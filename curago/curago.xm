/*
//
// Curago (now iOS Blocks)
//
// This is a widget system blah blah blah. Build, install and you'll see.
//
// (c) Matt Clarke, 2014.
//
// curago.xm - 25/5/2014
//
*/
#import <QuartzCore/QuartzCore.h>
#include <SpringBoard/SpringBoard.h>
#include <BulletinBoard/BulletinBoard.h>

#include "IBKFunctions.m"

#import <objc/runtime.h>

#import "IBKResources.h"
#import "IBKWidgetViewController.h"
#import "IBKPlaceholderIcon.h"

#import <IBKKit/IBKWidgetDelegate-Protocol.h>



// struct SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
//     SBIconCoordinate coordinate;
//     coordinate.row = row;
//     coordinate.col = col;
//     return coordinate;
// }

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RTL_CHECK [NSClassFromString(@"IBKResources") isRTL]
#ifndef HBLogError
    #define HBLogError NSLog
#endif
@interface SBFAnimationSettings : NSObject
@property double duration;
+ (id)settingsControllerModule;
@end

static BOOL isPinching = NO;
// Class additions

// Globals

NSMutableDictionary *cachedIndexes;
NSMutableDictionary *cachedIndexesLandscape;
NSMutableSet *movedIndexPaths;

int icons = 0;
int currentOrientation = 1;
int touchesInAppWindowCount = 0;
int indexOfGrabbedIcon = -1;

id grabbedIcon;

BOOL animatingIn = NO;
BOOL rearrangingIcons = NO;
BOOL iWidgets = NO;
BOOL isRotating = NO;
BOOL inSwitcher = NO;
BOOL isLaunching = NO;
NSString *grabbedBundleID;

static BOOL isDropping = NO;
// static BOOL isRegular = NO;
// static BOOL isPausing = NO;
static unsigned long long previousPauseIndex = -1;

BOOL allWidgetsNeedLocking = NO;

static BBServer* __weak IBKBBServer;


@interface SBIcon (Testing)
- (id)referencedIcon;
@end

@interface SBIconView (iOS9)
@property(retain, nonatomic) UILongPressGestureRecognizer *shortcutMenuPeekGesture;
@end

void reloadAllWidgetsNow() {
    
    SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    SBRootFolderController *rootFolder = [iconController valueForKeyPath:@"_rootFolderController"];
    
    for (SBIconListView *listView in (NSArray *)[rootFolder valueForKey:@"iconListViews"]) {
        
        if ([listView isKindOfClass:NSClassFromString(@"SBRootIconListView")]) {
            SBIconIndexMutableList *list = [[listView model] valueForKey:@"_icons"];
            list.needsProcessing = YES;
        }
    }

    for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
        SBIconView *iconView = [NSClassFromString(@"IBKResources") iconViewForBundleID:key];
        if (iconView) {
            if (iconView.widgetView) {
                [iconView.widgetView removeFromSuperview];
            }
            if ([[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key]) {
                IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key];
                [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:key];
                [widgetController unloadWidgetInterface];
            }
            [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:key];
            iconView.widgetView = nil;
            [iconView loadWidget];
        }
    }

    NSLog(@"Reset All Widgets");
}

void displayAllWidgets() {
    
   // SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    //SBRootFolderController *rootFolder = [iconController valueForKeyPath:@"_rootFolderController"];
    
    // for (SBIconListView *listView in (NSArray *)[rootFolder valueForKey:@"iconListViews"]) {
        
    //     if ([listView isKindOfClass:NSClassFromString(@"SBRootIconListView")]) {
    //         SBIconIndexMutableList *list = [[listView model] valueForKey:@"_icons"];
    //         list.needsProcessing = YES;
    //     }
    // }
    for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key];
        if ([widgetController.view superview]) {
            if ([[widgetController.view superview] isKindOfClass:NSClassFromString(@"SBIconView")]){
                if ([key isEqualToString:[((SBIconView *)[widgetController.view superview]).icon applicationBundleID]]) {
                    widgetController.view.alpha = 1.0;
                    widgetController.view.hidden = NO;
                }
            }
        }
    }
    NSLog(@"Showed All Widgets");
}

void reloadLayout() {
    SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    SBRootFolderController *rootFolder = [iconController valueForKeyPath:@"_rootFolderController"];
    
    for (SBIconListView *listView in (NSArray *)[rootFolder valueForKey:@"iconListViews"]) {
        
        if ([listView isKindOfClass:NSClassFromString(@"SBRootIconListView")]) {
            SBIconIndexMutableList *list = [[listView model] valueForKey:@"_icons"];
            list.needsProcessing = YES;
        }
    }
}


// %hook SBMainWorkspace
// - (void)transactionDidComplete:(id)arg1 {
//     %orig;
//     displayAllWidgets();
// }
// %end

%hook SBWorkspaceTransaction
-(void)_transactionComplete {
    %orig;
    displayAllWidgets();
}
-(void)_didComplete {
    %orig;
    displayAllWidgets();
}
%end


// Hooks

%hook SBRootFolderController
-(void)didRotateFromInterfaceOrientation:(NSInteger)arg1 {
    %orig;
    NSLog(@"GOT ROT EVENT #1");
    //isRotating = NO;
    // reloadLayout();
    // reloadAllWidgetsNow();
    //reloadAllWidgetsNow();
}
%end

#pragma mark Icon co-ordinate placements

%hook SBIconListView

%property (nonatomic, retain) NSMutableDictionary *rotationHelper;

//- (_Bool)isFull {
//    int count = 1;
//
//    for (SBIcon *icon in [self icons]) {
//        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
//            count += 3;
//        }
//
//        count++;
//    }
//
//    return (count >= [objc_getClass("SBIconListView") maxIcons]);
//}

- (void)layoutIconsIfNeeded:(double)arg1 domino:(bool)arg2 {
    if (isDropping) {
        isDropping = NO;
        %orig(0.0,NO);
    }
    else {
        %orig;
    }
}

-(void)prepareToRotateToInterfaceOrientation:(int)interfaceOrientation {
    isRotating = YES;
    %orig;
}

-(void)performRotationWithDuration:(CGFloat)duration {
//    for (SBIcon *icon in [self icons]) {
//        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
//            IBKWidgetViewController *widgetViewController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]];
//            if (widgetViewController) {
//                [widgetViewController reloadWidgetForSettingsChange];
//            }
//        }
//    }
    %orig;
//    SBIconIndexMutableList *list = MSHookIvar<id>([self model],"_icons");
//    list.needsProcessing = YES;
    // reloadAllWidgetsNow();
    isRotating = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration+0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        reloadAllWidgetsNow();
    });
}
%end

#pragma mark App switcher detection

%hook SBAppSliderController

- (void)switcherWasDismissed:(BOOL)arg1 {
    %orig;
    inSwitcher = NO;
}

%end

%hook SBUIController

-(void)_activateSwitcher {
    inSwitcher = YES;
    
    // Oh bollocks. We need to ensure that all widgets are reset to showing again.
    for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key];
        widgetController.view.alpha = 1.0;
    }
    %orig;
}

- (void)transactionDidComplete:(id)arg1 {
    %orig;
    displayAllWidgets();
}
%end

// iOS 8

NSString *lastOpenedWidgetId;

%hook SBAppSwitcherController

- (void)switcherWasDismissed:(BOOL)arg1 {
    %orig;
    
    inSwitcher = NO;
}

%end

#pragma mark Opening/closing app animations

BOOL sup;
BOOL launchingWidget;


%hook SBUIAnimationZoomUpApp
- (void)_prepareAnimation {
    isLaunching = YES;
    %orig;
}
- (void)_noteZoomDidFinish {
    %orig;
    isLaunching = NO;
}
- (void)_noteContextHostCrossfadeDidFinish {
    %orig;
    isLaunching = NO;
}

%end

%hook SBAppExitedWorkspaceTransaction
- (void)_didComplete {
    %orig;
    displayAllWidgets();

}
%end

%hook SBApplication

- (void)willAnimateDeactivation:(_Bool)arg1 {
    isLaunching = YES;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 0.0;

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 1.0;
    }];

    sup = YES;
//    widgetController.view.alpha = 1.0;
    %orig;
}

-(void)didAnimateDeactivationOnStarkScreenController:(id)arg1 {
    %orig;
     IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
    
    sup = NO;
    isLaunching = NO;
}

- (void)deactivate {
     %orig;
     IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
    
    sup = NO;
    isLaunching = NO;
}

-(void)didDeactivateForEventsOnly:(BOOL)arg1 {
     %orig;
     IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
    
    sup = NO;
    isLaunching = NO;
}

- (void)didAnimateDeactivation {
    %orig;

//    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
//    [(UIImageView*)[widgetController.correspondingIconView _iconImageView] setAlpha:0.0];
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
    
    sup = NO;
    isLaunching = NO;
}

- (void)willActivateWithTransactionID:(unsigned long long)arg1 {
    isLaunching = YES;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    sup = YES;

    %orig;
}

- (void)didActivateWithTransactionID:(unsigned long long)arg1 {
    lastOpenedWidgetId = [self bundleIdentifier];

    %orig;

    sup = NO;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    isLaunching = NO;
}

// iOS 7

- (void)didAnimateActivation {
    %orig;
    isLaunching = NO;
    sup = NO;
//    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
//    widgetController.view.alpha = 1.0;
}

- (void)willAnimateActivation {
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];

    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.3] animations:^{
        widgetController.view.alpha = 0.0;
    }];

    sup = YES;

    %orig;
}

%end

#define isNSNull(value) [value isKindOfClass:[NSNull class]]

%hook SBIconIndexMutableList

// Add a property to keep the |SBIconListView| object pertaining to
// this |SBIconIndexMutableList| cached so it doesn't need to be
// found every single time we need it in our calculations to determine
// where icons should get placed if there is any "Blocks" that are
// expanded on the |SBIconListView| pertaining to this |SBIconIndexMutableList|
// instance.

%property (nonatomic, retain) SBIconListView *listView;
%property (nonatomic, retain) NSIndexPath *listViewIndexPath;
%property (nonatomic, retain) SBIconListView *nextPage;
%property (nonatomic, retain) NSMutableArray *nextPageIcons;
%property (nonatomic, assign) BOOL processing;
%property (nonatomic, assign) BOOL needsProcessing;

- (id)init {
    SBIconIndexMutableList *orig = %orig;
    orig.processing = NO;
    orig.needsProcessing = YES;
    return orig;
}

-(void)node:(id)node didRemoveContainedNodeIdentifiers:(id)identifiers {
    
    // In order to keep the icon coordinate calculations efficient it should only be calculating
    // when a a icon is moved, removed, or added. It also should not be calculating at the same time.
    
    if (!self.processing) {
        self.needsProcessing = YES;
        %orig;
    } else {
        %orig;
    }
}

-(void)node:(id)node didAddContainedNodeIdentifiers:(id)identifiers {
    
    if (!self.processing && !self.needsProcessing) {
        self.needsProcessing = YES;
        %orig;
    } else {
        %orig;
    }
}

- (id)nodes {
    
    if (self.processing || !self.needsProcessing) return %orig;
    
    if (self.listView) {
        if ([self.listView isKindOfClass:NSClassFromString(@"SBDockIconListView")] || [self.listView isKindOfClass:NSClassFromString(@"SBFolderIconListView")]) {
            self.needsProcessing = NO;
            return %orig;
        }
    }
    
    self.processing = YES;

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // Add code here to do background processing
    //
    //
    dispatch_async( dispatch_get_main_queue(), ^{
        // Add code here to update the UI/send notifications based on the
        // results of the background processing
    });
});
    
    BOOL hasWidgets = NO;


    
    if (!self.listView || self.listView) {
        
        // No point in grabbing the |SBIconListView| if there aren't any |SBIcon|(s).
        // This also prevents a "Out of Bounds" Exception from occurring.
        
        if ([[self valueForKey:@"_nodes"] count] > 0) {
            
            // Grab the |NSIndexPath| for the first |SBIcon| in this |SBIconIndexMutableList|.
            // The index path consists of two numbers, the first being the index of the |SBIconListView|
            // page where the |SBIcon| is located and the second number being the index of the
            // actual |SBIcon|in reference to the rest of the |SBIcon|(s) on the |SBIconListView|.
            
            NSIndexPath *iconIndexPath = [(SBRootFolder *)[[NSClassFromString(@"SBIconController") sharedInstance] valueForKeyPath:@"rootFolder"] indexPathForIcon:[[self valueForKey:@"_nodes"] objectAtIndex:0]];
            
            self.listViewIndexPath = iconIndexPath;
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:[iconIndexPath section] + 1];
            
            // Use the |NSIndexPath| that we grabbed for the first |SBIcon| in this |SBIconIndexMutableList|
            // to grab the |SBIconListView| pertaining to this |SBIconIndexMutableList| and cache it to the
            // [listView] property on this |SBIconIndexMutableList| instance.
            
            if ([[NSClassFromString(@"SBIconController") sharedInstance] respondsToSelector:@selector(getListView:folder:relativePath:forIndexPath:createIfNecessary:)]) {
                
                SBIconListView *listView = nil;
                SBIconListView *nextListView = nil;
                
                [[NSClassFromString(@"SBIconController") sharedInstance] getListView:&listView folder:NULL relativePath:NULL forIndexPath:iconIndexPath createIfNecessary:NO];
                
                [[NSClassFromString(@"SBIconController") sharedInstance] getListView:&nextListView folder:NULL relativePath:NULL forIndexPath:nextIndexPath createIfNecessary:NO];
                self.listView = listView;
                self.nextPage = nextListView;
            } else {
                self.processing = NO;
                return %orig;
            }
        }
    }
    
    // If an instance of |SBIconListView| exists on the [listView] property of
    // this |SBIconIndexMutableList| instance
    
//    if (!self.nextPage)
    
    if (self.listView != nil && ![self.listView isKindOfClass:NSClassFromString(@"SBDockIconListView")] && ![self.listView isKindOfClass:NSClassFromString(@"SBFolderIconListView")]) {
        
        // Grab the current |UIInterfaceOrientation| so it can be used later on.
        
        UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        
        // We need to copy the |NSMutableArray| that contains all of the |SBIcon| instances
        // which can found on the instance Variable [_nodes] on this |SBIconIndexMutableList| instance.
        // If a separate copy wasn't made the future operations below wouldn't be thread safe and
        // it becomes a possibility that SpringBoard could crash quite easily.
        
        NSMutableArray *nodes = [(NSMutableArray *)[self valueForKey:@"_nodes"] mutableCopy];
        if (!self.nextPageIcons)
        self.nextPageIcons = [NSMutableArray new];
        
        // We need to know the number of rows and columns the |SBIconListView| instance
        // on the [listView] property of this |SBIconIndexMutableList| can hold for the
        // device's current orientation in order to use the information later in this
        // method implementation for calculations.
        
        int maxNumberOfColumns = 0;
        int maxNumberOfRows = 0;
        
        if ([NSClassFromString(@"SBRootIconListView") respondsToSelector:@selector(iconColumnsForInterfaceOrientation:)]) {
            maxNumberOfColumns = [NSClassFromString(@"SBRootIconListView") iconColumnsForInterfaceOrientation:currentOrientation];
            
            if ([NSClassFromString(@"SBRootIconListView") respondsToSelector:@selector(iconRowsForInterfaceOrientation:)]) {
                maxNumberOfRows = [NSClassFromString(@"SBRootIconListView") iconRowsForInterfaceOrientation:currentOrientation];
            }
        }
        
        if (maxNumberOfColumns == 0 || maxNumberOfRows == 0)  {
            self.processing = NO;
            return %orig;
        }
        
        // Now we need to make a 2D array to store the icon Layout that is
        // calculated. The 2D |NSMutableArray| also needs to be filled with |NSNull|(s)
        // so that Objects can be set anywhere in the 2D array. The max rows
        // and columns that were grabbed above will be used to fix the 2D array
        // to the correct size
        
        NSMutableArray *grid = [NSMutableArray new];
        
        for (int r = 0; r < maxNumberOfRows; r++) {
            grid[r] = [NSMutableArray new];
            for (int c = 0; c < maxNumberOfColumns; c++) {
                grid[r][c] = [NSNull null];
            }
        }
        
        NSMutableArray *unfinishedNodes = [nodes mutableCopy];
        
        // Now the 2D array needs to be populated with the |SBIcon|(s), while accounting
        // for any |SBIcon|(s) that expanded into "Block" form. If a |SBIcon| is expanded
        // into "Block" form the rest of spaces in the grid that it consumes will be filled
        // with a pseudo placeholder icon |IBKPlaceholderIcon| which is a subclass of |SBIcon|
        // in order to keep the icons laid out properly on the |SBIconListView|. First all the
        // |SBIcon|(s) need to be looped over to check if any of them are expanded into "Block" form because
        // if a |SBIcon| is expanded into block form it has a higher priority of placement in the grid
        
        for (id icon in nodes) {
            
            // Every |SBIcon| or subclasses of it has the method "applicationBundleID"
            // that returns a |NSString| containing the unique identifier for that |SBIcon|.
            // We should always make sure of course that the object the method is being performed
            // on can actually respond to the message first. A class called |IBKResources| has the
            // selector "indexForBundleID:" that will return the saved index of any |SBIcon| that
            // is expanded into "Block" form. The method consumes the |SBIcon|'s unique identifier
            // as a |NSString| and returns a [int] for its corresponding index if one exists. If a
            // corresponding index does not exist it will return 'nil'.
            
            // If the icon is pseudo placeholder of the class |IBKPlaceholderIcon| it should be skipped
            // because all of the pseudo placeholders are getting recalculated in this method implementation.
            // Although early in this method implementation all of the |IBKPlaceholderIcon|(s) were supposedly
            // filter out of the "nodes" |NSMutableArray| it is always better to be safe than sorry.
            
            if (![icon isKindOfClass:NSClassFromString(@"IBKPlaceholderIcon")]) {
                
                // Every time a private method is accessed it should be checked in case the method name, signature
                // or implementation changes in a later version of iOS. Thank you to John Coates for this tip.
                
                if ([icon respondsToSelector:@selector(applicationBundleID)]) {
                    
                    hasWidgets = YES;
                    
                    // If the |SBIcon|'s identifier is saved to a variable it will reduce the number of method calls
                    // for this method implementation.
                    
                    NSString *iconIdentifier = [(SBIcon *)icon applicationBundleID];
                    
                    // If the |SBIcon|'s identifier is null the current iteration of this loop should be skipped because
                    // without a identifier the rest of the processing in this loop is useless.
                    
                    if (!iconIdentifier) continue;
                    
                    int index = [IBKResources indexForBundleID:iconIdentifier forOrientation:currentOrientation];
                    
                    if (index == 973) {
                        if ([[IBKResources widgetBundleIdentifiers] containsObject:iconIdentifier]) {
                            index = 0;
                        }
                        else {
                            continue;
                        }
                    }
                    
                    
                    // The index needs to be converted to |SBIconCoordinate| which is a struct that has
                    // a row and column field. the row field starts at 1 and the column field starts at 1.
                    // An function called "SBIconCoordinateMake" takes in a row and column both of type
                    // |long long| in that order and returns a |SBIconCoordinate|. The |SBIconListView|
                    // instance that is cached has the selector "iconCoordinateForIndex:forOrientation:" that
                    // consumes the index that needs to be converted to a |SBIconCoordinate| and the orientation
                    // that the |SBIconCoordinate| should be in reference to. The variable 'origCoord' is used
                    // later in this method implementation in order to check if the coordinate had to be moved due
                    // to the widget not being able to be placed in its original primary position.
                    
                    SBIconCoordinate coord;
                    SBIconCoordinate origCoord;
                    
                    if ([self.listView respondsToSelector:@selector(iconCoordinateForIndex:forOrientation:)]) {
                            coord = [self.listView iconCoordinateForIndex:index forOrientation:currentOrientation];
                            origCoord = coord;
                    } else {
                        
                        // If |SBIconListView| does not respond to the selector (iconCoordinateForIndex:forOrientation)
                        // it can safely be assumed that the rest of this method implementation will process incorrect
                        // results so the best route would be to return this method's original implementation in order
                        // to avoid unwanted side-effects due to incorrect calculations.
                        
                        self.processing = NO;
                        return %orig;
                    }
                    
                    // Every "Block" can consume a custom number of rows and columns that the user can set
                    // in the Prefereneces for that block. The default number of columns and rows consumed if no
                    // custom number is set in settings is 2 columns and 2 rows. The class |IBKResources| has
                    // two selectors, "horiztonalWidgetSizeForBundleID:" and "verticalWidgetSizeForBundleID:",
                    // they both consume the unique identifier return by the "applicationBundleID" selector
                    // which is found on all instances of |SBIcon| and any subclasses of |SBIcon|. The
                    // selector "horiztonalWidgetSizeForBundleID:" returns the number of columns the |SBIcon| in
                    // "Block" form should consume and the selector "verticalWidgetSizeForBundleID:" returns the
                    // number of rows the |SBIcon| in "Block" form should consume.
                    
                    int blockWidth = [IBKResources horiztonalWidgetSizeForBundleID:iconIdentifier];
                    
                    int blockHeight = [IBKResources verticalWidgetSizeForBundleID:iconIdentifier];
                    
                    // The |SBIconCoordinate|, "blockWidth" and "blockHeight" need to be used to calculate
                    // where the best fit for the "block" of this |SBIcon|. The "blockWidth" and "blockHeight" are
                    // used to check all coordinates the "block" would consume on the 2D grid "grid". If all the
                    // coordinates that the "block" would consume return |NSNull| It can safely be assumed that it is
                    // safe to place the "block" in this current position. If any of the coordinates that the "block" would
                    // return anything other than |NSNull| it has to assumed that there is something currently placed
                    // at that coordinate in the 2D grid so the "block" will be unable to placed in the position.
                    // In the event that the "block" cannot be placed in its original primary coordinate its primary
                    // coordinate will be moved over one and the above conditions will be tested again against the new
                    // primary coordinate. If it is decided that the "block" cannot be fit in any of the available
                    // coordinates on the 2D grid it will placed in |NSMutableArray| that will processed at the end
                    // of this method implementation to move all icons and or blocks to the next available spot on
                    // another |SBIconListView|
                    
                    // A while loop is used to loop over every possible coordinate the "block" can be placed until
                    // a position is found where the "block" can be placed while meeting all of the conditions outlined
                    // above.
                    
                    BOOL isPlaced = NO;
                    
                    while (!isPlaced) {
                        
                        // If the primary coordinate being checked has a row or column that would cause the "block"
                        // to overflow the page vertically or horizontally it should be iterated until the coordinate does not.
                        
//                        while (coord.row + blockHeight - 1 <= maxNumberOfRows || coord.col + blockWidth - 1 < maxNumberOfColumns) {
                        
                            if (coord.col + blockWidth - 1 > maxNumberOfColumns) {
                                
                                coord.row = coord.row + 1;
                                coord.col = 1;
                            }
                        
                            if (coord.row + blockHeight - 1 > maxNumberOfRows) {
                                
                                [self.nextPageIcons addObject:icon];
                                [unfinishedNodes removeObject: icon];
                                isPlaced = YES;
                                continue;
                            }
//                        }
                        
                        // The "blockWidth" and "blockHeight" are used to check every coordinate that the block would consume
                        // to check if they are empty. If they are all empty the "block" can be placed in that position.
                        
                        BOOL isValid = YES;
                        
                        for (int row = 0; row < blockHeight; row++) {
                            for (int col = 0; col < blockWidth; col++) {
                                
                                if (!isNSNull(grid[coord.row + row - 1][coord.col + col - 1])) {
                                    
                                    isValid = NO;
                                }
                            }
                        }
                        
                        // If all of the coordinates that the block would consume are empty we can place it in the 2D grid.
                        
                        if (isValid) {
                            
                            for (int row = 0; row < blockHeight; row++) {
                                for (int col = 0; col < blockWidth; col++) {
                                    
                                    if (row == 0 && col == 0) {
                                        
                                        grid[coord.row - 1][coord.col - 1] = icon;
                                    } else {
                                        
                                        IBKPlaceholderIcon *placeHolder = [[NSClassFromString(@"IBKPlaceholderIcon") alloc] initWithIdentifier:[NSString stringWithFormat:@"WIDUXPlaceHolder_%ld/%@", (long)row+col, iconIdentifier]];
                                        grid[coord.row + row - 1][coord.col + col - 1] = placeHolder;
                                    }
                                }
                            }
                            
                            
                            int newIndex = [self.listView indexForCoordinate:coord forOrientation:currentOrientation];
                            [IBKResources setIndex: newIndex forBundleID:iconIdentifier forOrientation:currentOrientation];
                            
                            [unfinishedNodes removeObject: icon];
                            isPlaced = YES;
                            
                        }
                        else {
                            
                            if (coord.col + blockWidth - 1 == maxNumberOfColumns) {
                                
                                coord.row = coord.row + 1;
                                coord.col = 1;
                            } else {
                                
                                coord.col = coord.col + 1;
                            }
                        }
                    }
                }
            }
            else {
                
                [unfinishedNodes removeObject: icon];
            }
        }
        
        
        NSMutableArray *unfinishedNodesCopy = [unfinishedNodes mutableCopy];
        int count = 0;
        
        for (int row = 0; row < maxNumberOfRows; row++) {
            for (int col = 0; col < maxNumberOfColumns; col++) {
                
                if (isNSNull(grid[row][col])) {
                    if (count < [unfinishedNodes count]) {
                        
                        grid[row][col] = [unfinishedNodes objectAtIndex:count];
                        [unfinishedNodesCopy removeObject:[unfinishedNodes objectAtIndex:count]];
                        count++;
                    } else {
                        if (hasWidgets) {
                            grid[row][col] = [[NSClassFromString(@"IBKPlaceholderIcon") alloc] initWithIdentifier:[NSString stringWithFormat:@"WIDUXPlaceHolder_%ld", (long)count]];
                            count++;
                        }
                    }
                }
            }
        }
        
        if ([unfinishedNodesCopy count] > 0) {
            for (id icon in unfinishedNodesCopy) {
//                [IBKResources removeIdentifier:[icon applicationBundleID]];
                [self.nextPageIcons addObject:icon];
            }
        }
        
      //  NSLog(@"Left Over Icons: %@", self.nextPageIcons);
        
        NSMutableArray *nextPageIcons = [self.nextPageIcons mutableCopy];
        for (id icon in nextPageIcons) {
//            [IBKResources removeIdentifier:[icon applicationBundleID]];
            [self moveToNextPage:icon];
        }
        
        NSMutableArray *finalGrid = [NSMutableArray new];
        
        for (int row = 0; row < maxNumberOfRows; row++) {
            for (int col = 0; col < maxNumberOfColumns; col++) {
                
                if (!isNSNull(grid[row][col])) {
                    
                    [finalGrid addObject:grid[row][col]];
                }
            }
        }
        
        // [self removeAllNodes];
        [self setValue:[NSMutableArray new] forKey:@"_nodes"];
        
        for (id icon in finalGrid) {
            
            [self addNode: icon];
        }
        
        self.processing = NO;
        self.needsProcessing = NO;
        
//        if ([self.nextPageIcons count] > 0) {
        
//            NSMutableArray *nextPageIcons = [self.nextPageIcons mutableCopy];
//            for (id icon in nextPageIcons) {
//                
//                [self moveToNextPage:icon];
//                [self.nextPageIcons removeObject:icon];
//            }
//            if (self.nextPage) {
//                [self.nextPage layoutIconsNow];
//            }
//        }
        
        
        return finalGrid;
    }
    else {
        
        self.processing = NO;
        return %orig;
    }
}

%new
- (void)moveToNextPage:(id)icon {
    if (!self.nextPage) {
        
        NSIndexPath *iconIndexPath = [(SBRootFolder *)[[NSClassFromString(@"SBIconController") sharedInstance] valueForKeyPath:@"rootFolder"] indexPathForIcon:[[self valueForKey:@"_nodes"] objectAtIndex:0]];
        
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:0 inSection:[iconIndexPath section] + 1];
        
        SBIconListView *nextListView = nil;
        
        [[NSClassFromString(@"SBIconController") sharedInstance] getListView:&nextListView folder:NULL relativePath:NULL forIndexPath:nextIndexPath createIfNecessary:NO];
        
        self.nextPage = nextListView;
        
    }
    [self removeNode:icon];
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
        [IBKResources removeIdentifier:[icon applicationBundleID]];
         [(SBIconIndexMutableList *)[[self.nextPage valueForKey:@"_model"] valueForKey:@"_icons"] insertNode:icon atIndex:0];
        [IBKResources addNewIdentifier:[icon applicationBundleID]];
        [IBKResources setIndex:0 forBundleID:[icon applicationBundleID] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    } else {
        [(SBIconIndexMutableList *)[[self.nextPage valueForKey:@"_model"] valueForKey:@"_icons"] insertNode:icon atIndex:0];
    }
    [self.nextPageIcons removeObject:icon];
    
    [self.nextPage layoutIconsNow];
}
%end

#pragma mark Injection into icon views

@interface SBIconView (T)
@property (nonatomic, retain) UIView *widgetView;
@end

%hook SBIconView

%property (nonatomic, retain) UIView *widgetView;

- (BOOL)isUserInteractionEnabled {
    if ([self.icon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) return NO;
    else return %orig;
}

- (CGFloat)alpha {
    if ([self.icon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) return 0;
    else return %orig;
}

//- (void)setAlpha:(CGFloat)alpha {
//    if ([self.icon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) %orig(0);
//    else %orig;
//}
//
//- (BOOL)hidden {
//    if ([self.icon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) return YES;
//    return %orig;
//}
//
//- (void)setHidden:(BOOL)arg1 {
//    if ([self.icon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) %orig(YES);
//        else %orig;
//}

- (BOOL)pointInside:(struct CGPoint)arg1 withEvent:(UIEvent*)arg2 {
    if ([self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) {
        return %orig;
    }
//    return NO;
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        // Check if point will be inside our thing.

        if ([IBKResources hoverOnly]) {
            UIView *view = [[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]] view];

            // Normalise point.
            arg1.x = arg1.x + ((view.frame.size.width - self.frame.size.width)/2);
            arg1.y = arg1.y + ((view.frame.size.width - self.frame.size.width)/2);
            //arg1 = [[[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]] view] convertPoint:arg1 fromView:self];
        }

//        NSLog(@"Checking if point %@ is inside.", NSStringFromCGPoint(arg1));

        return [[[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]] view] pointInside:arg1 withEvent:arg2];
    }

    BOOL orig = %orig;
    if ([[arg2 allTouches] count] > 1) return NO;

    // We need to check that if there are two or more touches, and only one is on the icon, then we MUST return NO.
    // Else, pinching will fail.

    return orig;
}

-(CGRect)bounds {

    if (inSwitcher || sup || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGRect frame = %orig;
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        // if (RTL_CHECK) {
        //     frame.origin.x = -frame.size.width + self.frame.size.width;
        // }
        return frame;
    }

    return %orig;
}

 - (CGSize)iconImageVisibleSize {
    if ([self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) {
        return %orig;
    }
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
//         CGRect frame = nil;
         IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
//         frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
         
         return CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
     }
     
     return %orig;
 }

- (void)layoutSubviews {
    %orig;
    if ([self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) {
        return;
    }
    if ([[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon]) {
        if ([[[self icon] applicationBundleID] isEqual:[[[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon] applicationBundleID]]) {
            return;
        }
    }
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon *)self.icon applicationBundleID]]) {
        [(UIImageView*)[self _iconImageView] setAlpha:0.0];
        if (self.widgetView) {
            if (![self.widgetView superview]) {
                if ([(IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[(SBIcon *)self.icon applicationBundleID]] view] == self.widgetView) {
                    [self addSubview:self.widgetView];
                    [self sendSubviewToBack:self.widgetView];
                    [self sendSubviewToBack: (UIView *)[self valueForKey:@"_iconImageView"]];
                    [(UIImageView*)[self _iconImageView] setAlpha:0.0];
                }
            }
        }
    }
}


%new
- (void)loadWidget {
    if ([self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) {
        return;
    }
//    NSLog(@"Layed out SubView for Icon");
    if (isRotating) return;
    if ([[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon]) {
        if ([[[self icon] applicationBundleID] isEqual:[[[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon] applicationBundleID]]) {
            return;
        }
    }
    if (isPinching == NO) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon *)self.icon applicationBundleID]]) {
            if ([(IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[(SBIcon *)self.icon applicationBundleID]] view] == self.widgetView) {
                if (self.widgetView) {
                    if (![self.widgetView superview]) {
                        [self addSubview:self.widgetView];
                        [self sendSubviewToBack:self.widgetView];
                        [self sendSubviewToBack: (UIView *)[self valueForKey:@"_iconImageView"]];
                        [(UIImageView*)[self _iconImageView] setAlpha:0.0];
                    }
                }
            }
        }
        
        if (self.widgetView) {
        
            [self.widgetView removeFromSuperview];
        }
        
        SBApplicationIcon *icon = nil;
    
        if (!icon) {
            icon = (SBApplicationIcon*)self.icon;
        }
    
        if (!inSwitcher) {
            if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
            
            // Widget view controllers will be deallocated when the icon is recycled.
                IBKWidgetViewController *widgetController;
                widgetController.view.alpha = 1.0;
                
                if (![[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]]) {
                    widgetController = [[IBKWidgetViewController alloc] init];
                    widgetController.applicationIdentifer = [icon applicationBundleID];
                    [widgetController layoutViewForPreExpandedWidget]; // No need to set center position
                } else {
                    widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]];
                    long long widgetOrientation = [widgetController usedOrientation];
                    if (widgetOrientation != 20 && widgetOrientation != [(SBIconController *)[NSClassFromString(@"SBIconController") sharedInstance] orientation]) {
                        //reloadAllWidgetsNow();
                    }

                   // [widgetController reloadWidgetForSettingsChange]; 
                }
            
            // Add the small UI onto the icon - we can be sure this will not be a folder icon
//            if ([self respondsToSelector:@selector(shortcutMenuPeekGesture)]) {
//                [self.shortcutMenuPeekGesture setEnabled:NO];
//            }
                [self addSubview:widgetController.view];
                [self sendSubviewToBack:widgetController.view];
                [self sendSubviewToBack: (UIView *)[self valueForKey:@"_iconImageView"]];
                self.widgetView = widgetController.view;
            
                if ([icon applicationBundleID] && ![[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]])
                    [[NSClassFromString(@"IBKResources") widgetViewControllers] setObject:widgetController forKey:[icon applicationBundleID]]; // Ensure that a pointer remains to that widget controller.
            
            // Hide original icon
                [(UIImageView*)[self _iconImageView] setAlpha:0.0];
                widgetController.correspondingIconView = self;
            
                widgetController.view.layer.shadowOpacity = 0.0;
                widgetController.shimIcon.alpha = 0.0f;
                widgetController.shimIcon.hidden = YES;
            
                if ([IBKResources hoverOnly]) {
                    widgetController.view.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
                    widgetController.view.layer.shadowOpacity = 0.3;
                }
            } else {
                [self.widgetView removeFromSuperview];
                self.widgetView = nil;
            }
        
        // Testing
        //NSLog(@"Resultant count == %lu", (unsigned long)[[NSClassFromString(@"IBKResources") widgetViewControllers] count]);
        }
    }
}

- (CGPoint)iconImageCenter {
    if ([IBKResources hoverOnly] || inSwitcher || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    
    CGPoint point = %orig;

    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    point = CGPointMake(widgetController.view.frame.size.width/2, widgetController.view.frame.size.height/2);

    return point;
}

- (CGRect)iconImageFrame {
    if (inSwitcher || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    
    CGRect frame = %orig;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

    return frame;
}

- (struct CGRect)_frameForLabel {

    if (inSwitcher || [IBKResources hoverOnly] || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    CGRect orig = %orig;
    
        
    CGRect widgetFrame = ((IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]]).view.frame;
        
    CGFloat widgetScale = ((IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]]).currentScale;
        
        
    CGFloat percentComplete = (widgetScale - 0.375)/0.625;
    if (percentComplete > 1)
        percentComplete = 1;
            
    else if (percentComplete < 0)
        percentComplete = 0;
            
    CGFloat extraPadding = (8 * percentComplete) + (orig.origin.x * (1 - percentComplete));
    if ([NSClassFromString(@"IBKResources") isRTL]) {
        orig.origin = CGPointMake(0 - extraPadding, widgetFrame.origin.y + widgetFrame.size.height);
    }
    else {
        orig.origin = CGPointMake(widgetFrame.origin.x + extraPadding, widgetFrame.origin.y + widgetFrame.size.height);
    }
    return orig;
}

-(CGRect)_frameForAccessoryView {
    
    if (inSwitcher || [IBKResources hoverOnly] || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    
    CGRect orig = %orig;
    CGRect widgetFrame = ((IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]]).view.frame;
        
    orig.origin = CGPointMake(widgetFrame.origin.x + widgetFrame.size.width - orig.size.width + 10, widgetFrame.origin.y - (orig.size.height/2));
    return orig;
}
    
-(void)prepareForRecycling {
    %orig;
    
    IBKWidgetViewController *widgetController = [NSClassFromString(@"IBKResources") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    [widgetController unloadWidgetInterface];
    [widgetController.view removeFromSuperview];
    
    if ([self.icon applicationBundleID]) {

        [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:[self.icon applicationBundleID]];
    }
}

-(void)prepareForReuse {
    %orig;
    
    IBKWidgetViewController *widgetController = [NSClassFromString(@"IBKResources") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    [widgetController unloadWidgetInterface];
    [widgetController.view removeFromSuperview];
    
    if ([self.icon applicationBundleID]) {

        [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:[self.icon applicationBundleID]];
    }
}
    
- (void)prepareToCrossfadeImageWithView:(id)arg1 maskCorners:(_Bool)arg2 trueCrossfade:(_Bool)arg3 anchorPoint:(struct CGPoint)arg4 {
    %orig;
}

- (id)iconImageSnapshot {
    if (inSwitcher || [IBKResources hoverOnly] || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
        
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    UIView *view = widgetController.view;

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}

// - (void)_setIcon:(id)arg1 animated:(BOOL)arg2 { // Deal with adding a widget view onto those icons that are already expanded
//     %orig;
//     [self loadWidget];
// }

- (void)setIcon:(id)arg1 {
    %orig;
    if (![[NSClassFromString(@"SBIconController") sharedInstance] isEditing])
        [self loadWidget];
}
- (void)setLocation:(int)arg1 {
    %orig;
    if ([self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")] || [[NSClassFromString(@"SBIconController") sharedInstance] isEditing]) {
        return;
    }
    if ([[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon]) {
        if ([[[self icon] applicationBundleID] isEqual:[[[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon] applicationBundleID]]) {
            return;
        }
    }
    [self loadWidget];
}
%end

CGSize defaultIconSizing;

#import "../headers/SpringBoard/SBIconImageCrossfadeView.h"

%hook SBIconImageView

- (CGRect)visibleBounds {
    if (inSwitcher || !sup || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;

    CGRect frame = %orig;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

    return frame;
}

//- (CGFloat)alpha {
//    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
//        
//        return 0;
//    }
//    
//    return %orig;
//}
//
//- (void)setAlpha:(CGFloat)alpha {
//    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
//        
//        alpha = 0;
//    }
//    
//    %orig(alpha);
//}

-(CGRect)frame {

    if (inSwitcher || !sup || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = %orig;
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

        return frame;
    }

    return %orig;
}

-(CGRect)bounds {
    if (inSwitcher || !sup || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    
    CGRect frame = %orig;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

    return frame;
}


//- (CGFloat)alpha {
//    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
//        
//        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
//        
//        CGFloat finalAlpha = %orig - widgetController.view.alpha;
//        return finalAlpha;
//
//    }
//    return %orig;
//}

%end

#pragma mark Handle de-caching indexes when in editing mode

%hook SBIconController

- (void)setIsEditing:(BOOL)arg1 {
    rearrangingIcons = arg1;

    %orig;

    if (arg1) {

        isLaunching = NO;
    }
}

-(Class)iconViewClassForIcon:(id)icon location:(int)arg2 {
    if ([icon isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]]) {
        return NSClassFromString(@"IBKPlaceholderIconView");
    }
    return %orig;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)sender {
    if ([sender isKindOfClass:NSClassFromString(@"SBUIForceTouchGestureRecognizer")] && [sender.view respondsToSelector:@selector(icon)]) {
        SBIconView *iconView = (SBIconView *)sender.view;
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[[iconView icon] applicationBundleID]]) {
            return NO;
        }
    }
    return %orig;
}

- (void)_launchIcon:(id)arg1 {
    isLaunching = YES;
    %orig;
}

-(BOOL)icon:(id)iconView canReceiveGrabbedIcon:(id)grabbedIconView {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[[(SBIconView*)grabbedIconView icon] applicationBundleID]] || [[IBKResources widgetBundleIdentifiers] containsObject:[[(SBIconView*)iconView icon] applicationBundleID]]) {
        return NO;
    }
    if ([[(SBIconView*)grabbedIconView icon] isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]] || [[(SBIconView*)iconView icon] isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]]) {
        return NO;
    }
    return %orig;
}
 - (BOOL)folderController:(SBFolderView *)controller draggedIconDidPauseAtLocation:(CGPoint)draggedIcon inListView:(SBIconListView *)listView {
     if ([self grabbedIcon]) {
         grabbedBundleID = [[self grabbedIcon] applicationBundleID];
         if (![[IBKResources widgetBundleIdentifiers] containsObject:grabbedBundleID]) {
             return %orig;
         }
     }
     unsigned int pauseIndex;
     int propose;
     BOOL isDraggedWidget = NO;
     [listView iconAtPoint:draggedIcon index:&pauseIndex proposedOrder:&propose grabbedIcon:[self grabbedIcon]];
     // if ([[IBIconHandler sharedHandler] containsBundleID:[[self grabbedIcon] applicationBundleID]]) {
     //	SBIconCoordinate coordinate = [listView iconCoordinateForIndex:pauseIndex forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
     //	if (coordinate.col + [[IBIconHandler sharedHandler] horiztonalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]] > [%c(SBIconListView) iconColumnsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]-1) {
     //		coordinate = SBIconCoordinateMake(coordinate.row, coordinate.col-1);
     //	}
     //	if (coordinate.row + [[IBIconHandler sharedHandler] verticalWidgetSizeForBundleID:[[self grabbedIcon] applicationBundleID]] > [%c(SBIconListView) iconRowsForInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]]) {
     //		coordinate = SBIconCoordinateMake(coordinate.row-1, coordinate.col);
     //	}
     //	pauseIndex = [listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
     // }
     if ([self grabbedIcon]) {
         grabbedBundleID = [[self grabbedIcon] applicationBundleID];
         if ([[IBKResources widgetBundleIdentifiers] containsObject:grabbedBundleID]) {
             isDraggedWidget = YES;
             struct SBIconCoordinate coordinate = [listView iconCoordinateForIndex:pauseIndex forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
             while (coordinate.col + [IBKResources horiztonalWidgetSizeForBundleID:grabbedBundleID] -1 > [listView iconColumnsForCurrentOrientation]) {
                 coordinate = SBIconCoordinateMake(coordinate.row, coordinate.col-1);
             }
             while (coordinate.row + [IBKResources verticalWidgetSizeForBundleID:grabbedBundleID] -1 > [listView iconRowsForCurrentOrientation]) {
                 coordinate = SBIconCoordinateMake(coordinate.row-1, coordinate.col);
             }
             pauseIndex = [listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
         }
     }
     if (!isDraggedWidget) return %orig;
     if (pauseIndex != previousPauseIndex) {
         if (isDraggedWidget) {
            SBIcon *icon = [[listView model] iconAtIndex:pauseIndex];
            if ([icon isPlaceholder]) {
                if (![icon isEmptyPlaceholder]) {
                    while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
                        [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
                    }
                }
            }
         }
     }

     previousPauseIndex = pauseIndex;

     // [self compactIconsInIconListsInFolder:[controller folder] moveNow:YES limitToIconList:listView];
     BOOL proposedReturn = %orig;
     if ([self grabbedIcon]) {
         if (proposedReturn == TRUE) {
             while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
                 [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
             }
             for (int y = 0; y < [IBKResources verticalWidgetSizeForBundleID:grabbedBundleID]; y++) {
                 for (int x = 0; x < [IBKResources horiztonalWidgetSizeForBundleID:grabbedBundleID]; x++) {
                     unsigned long long index = pauseIndex+([listView iconColumnsForCurrentOrientation] * y)+x;
                     [self insertIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] intoListView:listView iconIndex:index moveNow:NO];
                   //  NSLog(@"Inserted Shit");
                 }
             }
         }
     }  
     return proposedReturn;
 }


- (_Bool)folderController:(SBFolderView *)controller draggedIconDidMoveFromListView:(SBIconListView *)fromList toListView:(SBIconListView *)toList {
    
    BOOL proposedReturn = %orig;
    
    if ([toList isKindOfClass:NSClassFromString(@"SBFolderIconListView")]) {
        return proposedReturn;
    }
    
    if (proposedReturn == TRUE) {
        if ([self grabbedIcon]) {
            if ([[IBKResources widgetBundleIdentifiers] containsObject:[[self grabbedIcon] applicationBundleID]]) {
                while ([fromList containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
                    [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
                }
                while ([toList containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
                    [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
                }
            }
        }
        return TRUE;
    }
    else return FALSE;
}

- (void)_dropIcon:(SBIcon *)icon withInsertionPath:(id)insertionPath {
    SBIconListView *listView;
    [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:insertionPath createIfNecessary:YES];
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
        
        while ([listView containsIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder]]) {
            [self removeIcon:[%c(SBPlaceholderIcon) grabbedIconPlaceholder] compactFolder:YES];
        }
        
        if ([listView isKindOfClass:NSClassFromString(@"SBDockIconListView")] || [listView isKindOfClass:NSClassFromString(@"SBFolderIconListView")]) {
            [(IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]] closeWidgetAnimated];
            
            %orig(icon, insertionPath);
            return;
        }
        
        SBIconCoordinate coordinate = [listView iconCoordinateForIndex:[insertionPath indexAtPosition:[insertionPath length] - 1] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        
        if (coordinate.row == 1 && coordinate.col == 1) {
            insertionPath = [NSIndexPath indexPathForRow:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] inSection:[(NSIndexPath*)insertionPath section]];
            [IBKResources setIndex:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] forBundleID:[icon applicationBundleID] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
            isDropping = YES;
            %orig(icon, insertionPath);
            return;
            
        }
        while (coordinate.col + [IBKResources horiztonalWidgetSizeForBundleID:[icon applicationBundleID]] -1 > [listView iconColumnsForCurrentOrientation]) {
            coordinate = SBIconCoordinateMake(coordinate.row, coordinate.col-1);
        }
        while (coordinate.row + [IBKResources verticalWidgetSizeForBundleID:[icon applicationBundleID]] -1 > [listView iconRowsForCurrentOrientation]) {
            coordinate = SBIconCoordinateMake(coordinate.row-1, coordinate.col);
        }
        insertionPath = [NSIndexPath indexPathForRow:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] inSection:[(NSIndexPath*)insertionPath section]];
        [IBKResources setIndex:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] forBundleID:[icon applicationBundleID] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        isDropping = YES;
    }
    %orig(icon, insertionPath);
}


-(void)_handleShortcutMenuPeek:(UILongPressGestureRecognizer *)sender {
    if ([sender.view respondsToSelector:@selector(icon)]) {
        SBIconView *iconView = (SBIconView *)sender.view;
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[[iconView icon] applicationBundleID]]) {
            return;
        }
    }
    %orig;
}
%end

%hook SBIconViewMap
- (void)recycleViewForIcon:(SBIcon *)icon {
    %orig;
  //  NSLog(@"RECYCLED ICON: %@", icon);
}
%end


%hook SBFolderController
- (void)_resetDragPauseTimerForPoint:(struct CGPoint)point inIconListView:(SBIconListView *)listView {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon*)[self valueForKey:@"grabbedIcon"] applicationBundleID]]) { // If dragged icon is a widget
        SBIconView *draggedIconView;
        if ([[%c(SBIconController) sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
            draggedIconView = [[[%c(SBIconController) sharedInstance] homescreenIconViewMap] mappedIconViewForIcon:(SBIcon*)[self valueForKey:@"grabbedIcon"]];
        }
        else {
            draggedIconView = [[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:(SBIcon*)[self valueForKey:@"grabbedIcon"]];
        }
//         NSLog(@"DRAGGED ICON VIEW: %@", draggedIconView);
        CGPoint properPausePoint = CGPointMake(draggedIconView.frame.origin.x + [%c(SBIconView) defaultIconSize].width/2, draggedIconView.frame.origin.y + [%c(SBIconView) defaultIconSize].height/2);
        point = properPausePoint;
    }
    %orig;
}
%end

#pragma mark Handle pinching of icons

IBKWidgetViewController *widget;
SBIcon *widgetIcon;

// handle main scrolling icons

@interface UIGestureRecognizer (Test)
- (void)touchesBegan:(id)touches
           withEvent:(id)event;
- (void)touchesMoved:(id)touches
           withEvent:(id)event;
@end

UIPinchGestureRecognizer *pinch;
NSObject *panGesture;



%hook SBIconScrollView

-(UIScrollView*)initWithFrame:(CGRect)frame {
    UIScrollView *orig = %orig;

    //NSLog(@"*** [Curago] :: Adding pinch gesture onto SBIconScrollView");

    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [(UIView*)orig addGestureRecognizer:pinch];

    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
            panGesture = arg;
        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPinchGestureRecognizer") class]]) {
            [orig removeGestureRecognizer:arg];
        }
    }

    return orig;
}

- (void)_updatePagingGesture {
    %orig;

    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
            panGesture = arg;
        }
//        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPinchGestureRecognizer") class]]) {
//            [self removeGestureRecognizer:arg];
//        } else if ([[arg class] isEqual:[objc_getClass("UIScrollViewPagingSwipeGestureRecognizer") class]]) {
//            [arg requireGestureRecognizerToFail:pinch];
//        }
//        if (pinch)
//        if (![[arg class] isEqual:[objc_getClass("UIPinchGestureRecognizer") class]]) {
//            [arg requireGestureRecognizerToFail:pinch];
//        }
    }
}

-(void)layoutSubviews {
    %orig;

    // Now, layout the widgets for hover mode.

    if ([IBKResources hoverOnly]) {
        for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
            IBKWidgetViewController *contr = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key];
            UIView *view = contr.view;

            [[view superview] addSubview:view];
            [[view superview] sendSubviewToBack: view];
            [[view superview] sendSubviewToBack: (UIView *)[[view superview] valueForKey:@"_iconImageView"]];
        }
    }
}


// %new
// - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//     if ([gestureRecognizer isKindOfClass:[NSClassFromString(@"UIPinchGestureRecognizer") class]]) return YES;
//     else return FALSE;
// }
%new

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL isPan = [gestureRecognizer isEqual:panGesture];
    // if (isPan) {
    //     if (!(pinch.state == UIGestureRecognizerStatePossible)) return NO;
    // }
    if (isPan && gestureRecognizer.numberOfTouches > 1) {
        return NO;
    } else {
        return YES;
    }
}

%new

 -(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer*)recTwo {
     if ([recTwo isEqual:pinch] && gestureRecognizer.numberOfTouches > 1) {
         return YES;
     } else {
         return NO;
     }
 }
 %new
 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
 {
//     if (isPinching)return NO;
//     if ([otherGestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
//         return NO;
//     else return YES;
     return NO;
 }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches count] > 1) {
        for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
            if ([[arg class] isEqual:[objc_getClass("UIPinchGestureRecognizer") class]]) {
                [arg touchesBegan:touches withEvent:event];
            }
            // else {
            //     arg.enabled = NO;
            // }

        }
    }
//    else
//    %orig;

    // if ([touches count] > 1) {
    //     for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
    //         if ([[arg class] isEqual:[objc_getClass("UIPinchGestureRecognizer") class]]) {
    //         }
    //         // else {
    //         //     arg.enabled = YES;
    //         // }

    //     }
    // }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([touches count] > 1) {
        for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
            if ([[arg class] isEqual:[objc_getClass("UIPinchGestureRecognizer") class]]) {
                [arg touchesMoved:touches withEvent:event];
            }
            // else {
            //     arg.enabled = NO;
            // }

        }
    }
//    else
//    %orig;
    // if ([touches count] > 1) {
    //     for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
    //         if ([[arg class] isEqual:[objc_getClass("UIPinchGestureRecognizer") class]]) {
    //         }
    //         else {
    //             arg.enabled = NO;
    //         }

    //     }
    // }
    // %orig;

    // if ([touches count] > 1) {
    //     for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
    //         if ([[arg class] isEqual:[objc_getClass("UIPinchGestureRecognizer") class]]) {
    //         }
    //         else {
    //             arg.enabled = YES;
    //         }

    //     }
    // }
}
%new

int scale = 0;
static BOOL isClosing = NO;
NSInteger page = 0;
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch {
    // You must return if we're in a folder. for now
    if ([[objc_getClass("SBIconController") sharedInstance] hasOpenFolder]) return;

    if (pinch.state == UIGestureRecognizerStateBegan) {
         //NSLog(@"Pinching began");
        // Handle setting up the view.

        // calculate mid-point of pinch
        // CGFloat width = self.frame.size.width;
        // page = (self.contentOffset.x + (0.5f * width)) / width;
        // CGPoint rawMidpoint = [pinch locationInView:(UIView*)self];
        // CGPoint finalMidpoint = CGPointMake(rawMidpoint.x - (page * width), rawMidpoint.y);
//        NSLog(@"*** final midpoint == %@", NSStringFromCGPoint(finalMidpoint));

        // Get the icon at this point in the current list view
        SBIconListView *listView;
        listView = [[objc_getClass("SBIconController") sharedInstance] currentRootIconList];
        CGPoint finalMidpoint = [pinch locationInView:(UIView*)listView];
        //SBIconListView *listView = [self.subviews objectAtIndex:(page+1)]; // Spotlight is still page 0. WTF Apple.
        unsigned int index;
        widgetIcon = [listView iconAtPoint:finalMidpoint index:&index];
        //NSLog(@"Widget icon == %@", widgetIcon);

        // Extra check for folders

        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) {
            widget = nil;
            return;
        }
        
        if ([widgetIcon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) {
            
            NSArray* stringArray = [[widgetIcon applicationBundleID] componentsSeparatedByString: @"/"];
            if ([stringArray count] < 2) {
                widget = nil;
                return;
            }
            NSString *newWidgetBundleIdentifier = [stringArray objectAtIndex:[stringArray count]-1];
            SBIconController *controller = [%c(SBIconController) sharedInstance];
            SBIconModel *model = [controller model];
            widgetIcon = [model expectedIconForDisplayIdentifier:newWidgetBundleIdentifier];
           // NSLog(@"PInched ICon: %@", newWidgetBundleIdentifier);
            widget = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:newWidgetBundleIdentifier];
//            [widget handlePinchGesture:pinch];
//            isClosing = YES;
//            return;
            
//            widget = nil;
//            return;
            
        }

        // Ah shit. If this widget is already open, don't do anything!
        if ([[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[widgetIcon applicationBundleID]]) {
            widget = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[widgetIcon applicationBundleID]];
            [widget handlePinchGesture:pinch];
            isClosing = YES;
            isPinching = YES;
            return;
        }

        // We need to make this icon's view to be the highest subview. Oh shit. We can add in all our widget controllers here!
        isPinching = YES;
        widget = [[IBKWidgetViewController alloc] init];
        widget.applicationIdentifer = [widgetIcon applicationBundleID];
        [IBKResources addNewIdentifier:widget.applicationIdentifer];

        if ([widgetIcon applicationBundleID])
            [[NSClassFromString(@"IBKResources") widgetViewControllers] setObject:widget forKey:[widgetIcon applicationBundleID]];


        // Add widget view onto icon.
        SBIconView *view;
        if ([[%c(SBIconController) sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
            view = [[[%c(SBIconController) sharedInstance] homescreenIconViewMap] mappedIconViewForIcon:widgetIcon];
        }
        else {
            view = [[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:widgetIcon];
        }
        
        [view addSubview:widget.view];
        [view sendSubviewToBack: widget.view];
        [view sendSubviewToBack: (UIView *)[view valueForKey:@"_iconImageView"]];
        [(SBIconView *)view setWidgetView:widget.view];
        [view.superview addSubview:view]; // Move the view to be the top most subview

        widget.correspondingIconView = view;

        [[(SBIconView*)view _iconImageView] setAlpha:0.0];

        widget.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        widget.currentScale = 1;

        [widget loadWidgetInterface];

        widget.view.center = CGPointMake(([(UIView*)[view _iconImageView] frame].size.width/2)-1, ([(UIView*)[view _iconImageView] frame].size.height/2)-1);

        CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

       // NSLog(@"BEGINNING SCALE IS %f", iconScale);

        widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);widget.currentScale = iconScale;
        
    } else if (pinch.state == UIGestureRecognizerStateChanged && widget) {
        if (isClosing) {
        [widget handlePinchGesture:pinch];
        return;
        }
        // NSLog(@"Pinching changed");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;

        // Set scale of our widget view, using scale/velocity as our time duration for animation

        CGFloat duration = (pinch.scale/pinch.velocity);

        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            duration = (pinch.scale-1)/pinch.velocity;
            //NSLog(@"pinch.scale == %f, pinch.velocity == %f, duration == %f", pinch.scale, pinch.velocity, duration);
        }

        if (duration < 0)
            duration = -duration;

        scale = pinch.scale;

        [widget setScaleForView:pinch.scale withDuration:0.1];
    } else if (pinch.state == UIGestureRecognizerStateEnded && widget) {
        if (isClosing) {
            [widget handlePinchGesture:pinch];
            isClosing = NO;
            isPinching = NO;
            return;
        }
     //    NSLog(@"Pinching ended");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
         // Handle end of touch. If scale greater than a set value, drop down regardless of time spent held in place.
         // Also, we need to check whether we'll be overlapping another widget, and if so, don't drop /the bass/
         // We should add onto the homescreen now.

        if ((scale-1.0) > 0.75) { // Scale is 1.0 onwards, but we expect 0.0 onwards for our code
            [widget setScaleForView:8.0 withDuration:0.3];
            
            SBIconView *view;
            if ([[%c(SBIconController) sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
                view = [[[%c(SBIconController) sharedInstance] homescreenIconViewMap] mappedIconViewForIcon:widgetIcon];
            }
            else {
                view = [[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:widgetIcon];
            }
            
//            if ([view respondsToSelector:@selector(shortcutMenuPeekGesture)]) {
//                [[view shortcutMenuPeekGesture] setEnabled:NO];
//            }
            [IBKResources addNewIdentifier:[widgetIcon applicationBundleID]];
            SBIconListView *listView = [NSClassFromString(@"IBKResources") listViewForBundleID:widget.applicationIdentifer];
            unsigned long long index2 = [(SBIconListModel*)[listView model] indexForLeafIconWithIdentifier:[widgetIcon applicationBundleID]];
            [IBKResources setIndex:index2 forBundleID:[widgetIcon applicationBundleID] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];

            if ([IBKResources hoverOnly]) {
                return;
            }

            // Relayout icons.

            // Move icons to next page if needed.
            
            // TODO: This needs to be redone slightly so that if the next page is also full, it moves icons on again, etc

            SBIconListView *lst = [NSClassFromString(@"IBKResources") listViewForBundleID:widget.applicationIdentifer];

            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                //[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
                [lst setIconsNeedLayout];
                [lst layoutIconsIfNeeded:0.3 domino:NO];
            } else
                [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];

            // Move frame of widget into new position.
            reloadLayout();
            CGRect widgetViewFrame = widget.correspondingIconView.frame;
            widgetViewFrame.size = CGSizeMake([IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer], [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer]);
            [UIView animateWithDuration:0.3 animations:^{
                if ([NSClassFromString(@"IBKResources") isRTL]) {
                     widget.view.frame = CGRectMake(0 - ([IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer] - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width), 0, [IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer], [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer]);
                }
                else {
                    widget.view.frame = CGRectMake(0, 0, [IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer], [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer]);
                }
                widget.view.layer.shadowOpacity = 0.0;

                [(SBIconImageView*)[widget.correspondingIconView _iconImageView] setFrame:widgetViewFrame];

                // Icon's label?
            }];
        } else {
            CGFloat iconScale = (isPad ? 72 : 60) / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

            CGFloat red, green, blue;
            [widget.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
            widget.currentScale = iconScale;
            [UIView animateWithDuration:0.25 animations:^{
                widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
                widget.shimIcon.alpha = 1.0;
                widget.viw.alpha = 0.0;
                widget.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
            } completion:^(BOOL finished) {
                [widget unloadFromPinchGesture];
                [IBKResources removeIdentifier:widget.applicationIdentifer];
                if (widget && widget.applicationIdentifer) [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:widget.applicationIdentifer];
                [[(SBIconView*)widget.correspondingIconView _iconImageView] setAlpha:1.0];
            }];
        }
        isPinching = NO;
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
       // NSLog(@"PINCHING WAS CANCELLED");

        CGFloat scale = (isPad ? 72 : 60) / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

        widget.currentScale = scale;
        [UIView animateWithDuration:0.3 animations:^{
            widget.view.transform = CGAffineTransformMakeScale(scale, scale);
            widget.view.center = CGPointMake(([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.width/2)-1, ([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.height/2)-1);
            widget.shimIcon.alpha = 1.0;

            widget.iconImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[widget.correspondingIconView _iconImageView] setAlpha:1.0];
            widget.view.hidden = YES;
            [widget unloadFromPinchGesture];
            [IBKResources removeIdentifier:widget.applicationIdentifer];

            if (widget && widget.applicationIdentifer) [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:widget.applicationIdentifer];
        }];
        isPinching = NO;
    }
}

%end

%hook SBIconStateArchiver

+ (id)_representationForIcon:(SBIcon *)icon {
    if ([icon isPlaceholder]) {
        if (![icon isEmptyPlaceholder]) {
            if (![icon referencedIcon]) {
                return 0;
            }
        }
    }
    return %orig;
}
%end

#pragma mark Icon badge handling

@interface SBIconBadgeView (Curago)
@property (nonatomic, retain) SBIcon *icon;
@end

%hook SBIconBadgeView
%property (nonatomic, retain) SBIcon *icon;

static SBIcon *temp;

- (void)configureForIcon:(SBIcon*)arg1 location:(int)arg2 highlighted:(BOOL)arg3 {
    self.icon = arg1;

    %orig;

    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        // Calculate x for center
        [[self superview] addSubview:self]; // Bring to front.
    }

}

- (struct CGPoint)accessoryOriginForIconBounds:(CGRect)arg1 {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        // Calculate x for center
        IBKWidgetViewController *contr = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        arg1 = contr.view.bounds;

        // TODO: Fix for hover mode

        [[self superview] addSubview:self]; // Bring to front.
    }

    return %orig(arg1);
}

//-(void)layoutSubviews {
//    %orig;
//
//    [[self superview] addSubview:self]; // Bring to front.
//}

%end

#pragma mark Close button handling

@interface SBCloseBoxView : UIView
@end

%hook SBCloseBoxView

-(void)layoutSubviews {
    %orig;

    [[self superview] addSubview:self]; // Bring to front.
}

%end

#pragma mark Handle uninstallation of apps

%hook SBApplication

- (void)prepareForUninstallation {
    %orig;

    NSString *bundleId;
    if ([self respondsToSelector:@selector(bundleIdentifier)]) {
        bundleId = [self bundleIdentifier];
    } else {
        bundleId = [self displayIdentifier];
    }

    IBKWidgetViewController *contr = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:bundleId];
    [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:bundleId];
    [contr unloadWidgetInterface];
    contr = nil;

    [IBKResources removeIdentifier:bundleId];
}

%end

#pragma mark Handle re-locking widgets when locking

%hook SBLockScreenManager

-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 {
    %orig;

    if ([IBKResources relockWidgets] || allWidgetsNeedLocking) {
        for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
            IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key];
            [widgetController lockWidget];
        }

        allWidgetsNeedLocking = NO;
    }
}

%end

#pragma mark BBServer hooks for notification tables

%hook BBServer

-(id)init {
    BBServer *orig = %orig;
    IBKBBServer = orig;
    return orig;
}

- (void)_addBulletin:(BBBulletin*)arg1 {
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[arg1 sectionID]];
    if (widgetController)
        [widgetController addBulletin:arg1];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/notificationrecieved", [arg1 sectionID]] object:arg1];

    %orig;
}

- (void)_removeBulletin:(id)arg1 rescheduleTimerIfAffected:(BOOL)arg2 shouldSync:(BOOL)arg3 {
    for (NSString *key in [NSClassFromString(@"IBKResources") widgetViewControllers]) {
        if ([[(IBKWidgetViewController*)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key] applicationIdentifer] isEqual:[arg1 sectionID]])
            [(IBKWidgetViewController*)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key] removeBulletin:arg1];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:[NSString stringWithFormat:@"%@/notificationremoved", [arg1 sectionID]] object:arg1];

    %orig;
}

%new

+(id)sharedIBKBBServer {
    return IBKBBServer;
}

%end

#pragma mark Media data handling

%hook SBMediaController

-(void)_nowPlayingInfoChanged {
    %orig;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-UpdateMusic" object:nil];
}

%end

#pragma mark IOS 8 stuff

%group iOS8

%hook SBIconImageView

%new
-(id)alternateIconView {
    return nil; // Small fix for Auxo 3 of all things?!
}

%end

%end

#pragma mark iWidgets fixes

%group iWidgets

%hook IWWidgetsView

- (_Bool)pointInside:(struct CGPoint)arg1 withEvent:(id)arg2 {
    iWidgets = YES;
    BOOL original = %orig;
    iWidgets = NO;

    return original;
}

%end

%end

#pragma mark Settings callbacks

static void settingsChangedForWidget(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [IBKResources reloadSettings];

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];

    // Reload widget for this bundle identifier.
    IBKWidgetViewController *controller = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[dict objectForKey:@"changedBundleIdFromSettings"]];
    [controller reloadWidgetForSettingsChange];
}

static void reloadAllWidgets(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    // Reload widget for this bundle identifier.
    [IBKResources reloadSettings];

    for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
        [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:key];
    }
}

static void changedLockAll(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
   // NSLog(@"RECIEVED LOCK ALL");

    [IBKResources reloadSettings];

    for (NSString *key in [[NSClassFromString(@"IBKResources") widgetViewControllers] allKeys]) {
        IBKWidgetViewController *controller = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:key];
        [controller reloadWidgetForSettingsChange];
    }
}

static void reloadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [IBKResources reloadSettings];
}

#pragma mark Constructor and anti-piracy code

@interface ISIconSupport : NSObject
+(instancetype)sharedInstance;
-(void)addExtension:(NSString*)arg1;
@end


%ctor {

    // We're done. Load!
    %init;

    // dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
    // dlopen("/Library/MobileSubstrate/DynamicLibraries/iWidgets.dylib", RTLD_NOW);
    // [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"com.matchstic.curago"];

    // Load custom stuff for certain versions of iOS.

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        %init(iOS8);

    %init(iWidgets);

    [IBKResources reloadSettings];

    //dlopen("/Applications/News.app/Plugins/NewsToday.appex/NewsToday",RTLD_LAZY);

    // Handlers for widget settings.
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedForWidget, CFSTR("com.matchstic.ibk/settingschangeforwidget"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadAllWidgets, CFSTR("com.matchstic.ibk/reloadallwidgets"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadSettings, CFSTR("com.matchstic.ibk/reloadsettings"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, changedLockAll, CFSTR("com.matchstic.ibk/changedlockall"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
