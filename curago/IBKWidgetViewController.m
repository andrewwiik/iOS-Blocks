//
//  IBKWidgetViewController.m
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//
//

/*
 TODO:
 
 - Add in listener to settings changes so we can adjust as necessary
 - Implement loading from binary and error handling.
 - Implement Hooke's Law if the scaling gesture wil have use go too large
 - Finish rotation handling
 
*/

#import "IBKWidgetViewController.h"
#import "IBKResources.h"

#import <SpringBoard7.0/SBIconController.h>
#import <SpringBoard7.0/SBIconModel.h>
#import <objc/runtime.h>
#import "UIImageAverageColorAddition.h"
#import "CKBlurView.h"
#import "IBKNotificationsTableCell.h"
#import <BulletinBoard/BBBulletin.h>
#import <BulletinBoard/BBServer.h>

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define is_IOS7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.10)

@interface IBKWidgetViewController ()

@end

@interface SBIconImageView (iOS7_1)
- (void)setIcon:(id)arg1 location:(int)arg2 animated:(BOOL)arg3;
@end

@interface BBServer (Additions)
+(id)sharedIBKBBServer;
- (id)_bulletinsForSectionID:(id)arg1 inFeeds:(unsigned int)arg2;
@end

@implementation IBKWidgetViewController

-(void)loadView {
    // Begin building our base widget view
    
    CGRect initialFrame = CGRectMake(0, 0, isPad ? 252 : 136, isPad ? 237 : 148);
    
    UIView *baseView = [[UIView alloc] initWithFrame:initialFrame];
    baseView.alpha = 0.0;
    baseView.userInteractionEnabled = YES;
    baseView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    baseView.layer.cornerRadius = 12;
    baseView.layer.masksToBounds = NO;
    baseView.layer.shadowOffset = CGSizeZero;
    baseView.layer.shadowOpacity = 0.3;
    baseView.hidden = YES;
    // Center is configured by IBKIconView
    
    self.view = baseView;
}

-(void)loadWidgetInterface {
    if (!self.view) {
        [self loadView];
    }
    
    NSLog(@"Loading widget interface...");
    
    self.view.hidden = NO;
    
    // We need our icon image view here - the widget may define it's own icon
    self.iconImageView = [[objc_getClass("SBIconImageView") alloc] initWithFrame:CGRectMake(10, (isPad ? 237 : 148)-(isPad ? 60 : 40), (isPad ? 60 : 40), (isPad ? 60 : 40))];
    
    NSLog(@"version == %f", [[[UIDevice currentDevice] systemVersion] floatValue]);
    
    if ([[self iconImageView] respondsToSelector:@selector(setIcon:animated:)])
        [(SBIconImageView*)[self iconImageView] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:self.applicationIdentifer] animated:NO];
    else
        [(SBIconImageView*)[self iconImageView] setIcon:[(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] applicationIconForDisplayIdentifier:self.applicationIdentifer] location:2 animated:NO];
    self.iconImageView.frame = CGRectMake(7, (isPad ? 237 : 148)-(isPad ? 50 : 30)-7, (isPad ? 50 : 30), (isPad ? 50 : 30));
    self.iconImageView.alpha = 0.0;
    self.iconImageView.layer.shadowOpacity = 0.15;
    self.iconImageView.layer.shadowOffset = CGSizeZero;
    self.iconImageView.layer.shadowRadius = 5.0;
    
    [self.view addSubview:self.iconImageView];
    
    // Fix up animations for the icon's badge.
    
    
    
    NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Info.plist", [self getPathForMainBundle]]];
    
    if (!infoPlist) {
        // Fallback to showing notifications table.
        
        // Create table view.
        
        CGRect frame = self.view.frame;
        frame.origin = CGPointZero;
        
        self.notificationsDataSource = [NSMutableArray array];
        
        // Fill the array with notifications
        
        BBServer *server = [objc_getClass("BBServer") sharedIBKBBServer];
        NSLog(@"Server is %@", server);
        NSLog(@"Could try %@", [server _bulletinsForSectionID:self.applicationIdentifer inFeeds:1]);
        for (BBBulletin *bulletin in [server _allBulletinsForSectionID:self.applicationIdentifer])
            [self.notificationsDataSource addObject:bulletin];
        
        NSLog(@"Bulletins array == %@", self.notificationsDataSource);
        
        CGRect initialFrame = CGRectMake(10, 7, (isPad ? 252 : 136)-14, self.iconImageView.frame.origin.y-9);
        
        self.notificationsTableView = [[UITableView alloc] initWithFrame:initialFrame style:UITableViewStylePlain];
        
        self.notificationsTableView.delegate = self;
        self.notificationsTableView.dataSource = self;
        self.notificationsTableView.backgroundColor = [UIColor clearColor];
        self.notificationsTableView.showsVerticalScrollIndicator = YES;
        self.notificationsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.notificationsTableView registerClass:[IBKNotificationsTableCell class] forCellReuseIdentifier:@"notificationTableCell"];
        
        [self.view addSubview:self.notificationsTableView];
        
        // What would be really cool is to have a CKBlurView under the icon view.
        
        /*CKBlurView *blurView = [[CKBlurView alloc] initWithFrame:CGRectMake(0, self.iconImageView.frame.origin.y-4, self.view.frame.size.width, (isPad ? 64 : 44))];
        blurView.blurRadius = 7.5;
        blurView.blurCroppingRect = CGRectMake(0, 0, blurView.frame.size.width, blurView.frame.size.height);
        
        [self.view addSubview:blurView];*/
        
        // Set our background colour to the average of the app's icon.
        self.view.backgroundColor = [(UIImage*)[(SBIconImageView*)self.iconImageView squareContentsImage] mergedColor];
        
        NSMutableArray *indexPaths = [NSMutableArray array];
        for (BBBulletin *bulletin in self.notificationsDataSource) {
            [indexPaths addObject:[NSIndexPath indexPathForRow:[self.notificationsDataSource indexOfObject:bulletin] inSection:0]];
        }
        [self.notificationsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        // Bring icon back up to top view
        
        [self.view addSubview:self.iconImageView];
    } else {
        // Load up widget UI from NSBundle.
    }
    
    self.isWidgetLoaded = YES;
}

-(void)unloadWidgetInterface {
    // Unload the widget UI.
    self.view.hidden = YES;
    
    
    // testing
}

-(void)layoutViewForPreExpandedWidget {
    // Layout view as this widget is already expanded.
    if (!self.isWidgetLoaded)
        [self loadWidgetInterface];
    
    // Set scaling of baseView
    self.view.alpha = 1.0;
    self.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    self.view.layer.shadowOpacity = 0.0;
    //self.view.userInteractionEnabled = YES; // This will be enabled once we can launch from the new icon view.
    
    // Set alpha of icon image view
    self.iconImageView.alpha = 1.0;
}

-(void)setScaleForView:(CGFloat)scale withDuration:(CGFloat)duration {
    // This scale value should have Hooke's Law applied if it is greater than 1.0
    
    scale -= 1.0;
    
    if (scale > 1.0) {
        CGFloat force = log(scale)/(2.0*scale);
        
        scale = 1.0+force;
    }
    
    NSLog(@"Scale is %f", scale);
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeScale(scale, scale);
        self.view.alpha = scale;
        
        [(UIView*)[self.correspondingIconView _iconImageView] setAlpha:1.0-scale];
    
        // Depending on how far we've scaled, adjust the icon image view at a much faster rate.
        self.iconImageView.alpha = scale*1.5;
    }];
}

-(void)unloadFromPinchGesture {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        self.view.alpha = 0.0;
        self.iconImageView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self unloadWidgetInterface];
    }];
}

-(NSString*)getPathForMainBundle {
    return @"zzzzz";
    
    // TODO: Implement finding the path for the widget on disk, and handle theme support.
}

#pragma mark Rotation handling

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    // Alright. Let's rotate.
    CGRect baseViewFrame;
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == 0) {
        if (isPad) {
            baseViewFrame = CGRectMake(0, 0, 252, 237);
        } else {
            baseViewFrame = CGRectMake(0, 0, 136, 148);
        }
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        if (isPad) {
            baseViewFrame = CGRectMake(0, 0, 272, 217);
        } else {
            baseViewFrame = CGRectMake(0, 0, 148, 136);
        }
    }
    
    // Also, adjust icon frame.
    CGRect iconViewFrame = CGRectMake(10, baseViewFrame.size.height-(isPad ? 60 : 40), (isPad ? 60 : 40), (isPad ? 60 : 40));
    
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = baseViewFrame;
        self.iconImageView.frame = iconViewFrame;
    }];
}

#pragma mark End rotation handling.

#pragma mark UITableView delegate methods. (for notifications fallback)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Handle stuff like QR tweaks etc.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Each has it's own height I think. Two visible at all times for iPhone
    
    return 52.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // THIS IS IMPORTANT
    
    NSLog(@"Asking for a new cell");
    
    IBKNotificationsTableCell *cell = [self.notificationsTableView dequeueReusableCellWithIdentifier:@"notificationTableCell"];
    if (!cell) {
        cell = [[IBKNotificationsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"notificationTableCell"];
    }
    
    BBBulletin *bulletin = (self.notificationsDataSource)[indexPath.row];
    
    cell.superviewColouration = self.view.backgroundColor;
    [cell initialiseForBulletin:bulletin andRowWidth:(isPad ? 252 : 136)-20];
    
    NSLog(@"Finished creating new cell");
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.notificationsDataSource count];
}

#pragma mark End UITableView delegate methods

#pragma mark BBBulletin methods

-(void)addBulletin:(id)arg2 {
    NSLog(@"Recieved bulletin");
    
    [self.notificationsDataSource insertObject:arg2 atIndex:0];
    
    NSLog(@"self.noticationsDataSource == %@", self.notificationsDataSource);
    
    //[self.notificationsTableView reloadData];
    
    //[self.notificationsTableView reloadSections:0 withRowAnimation:UITableViewRowAnimationTop];
    
    NSMutableArray *indexPaths = [NSMutableArray array];
    [indexPaths addObject:[NSIndexPath indexPathForRow:[self.notificationsDataSource indexOfObject:arg2] inSection:0]];
    [self.notificationsTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];

}

-(void)removeBulletin:(id)arg2 {
    // TODO: Check whether we need to use the bulletin ID for removal
    [self.notificationsDataSource removeObject:arg2];
    
    [self.notificationsTableView reloadData];
}

- (void)observer:(id)observer modifyBulletin:(id)bulletin {
    
}

-(void)observer:(id)observer noteInvalidatedBulletinIDs:(id)ids {
    
}

#pragma mark End BBObserverDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
