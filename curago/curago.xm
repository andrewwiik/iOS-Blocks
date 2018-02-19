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
#import <Apex/STKGroupView.h>

#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "SBIconView+IBK.h"


@interface CALayer (IBK)
- (void)invalidateContents;
@end


// struct SBIconCoordinate SBIconCoordinateMake(long long row, long long col) {
//     SBIconCoordinate coordinate;
//     coordinate.row = row;
//     coordinate.col = col;
//     return coordinate;
// }

static int countyThingy = 0;

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_RTL [NSClassFromString(@"IBKResources") isRTL]
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
BOOL sup;
BOOL launchingWidget;

static BOOL isIOS11 = NO;

static BOOL isDropping = NO;
// static BOOL isRegular = NO;
// static BOOL isPausing = NO;
static unsigned long long previousPauseIndex = -1;

BOOL allWidgetsNeedLocking = NO;

static BBServer* __weak IBKBBServer;


#pragma mark UIView+additions

@interface UIView (IBK)
- (UIView *)ibk_superviewOfClass:(Class)class_name maxDepth:(NSInteger)depth;
@end

@implementation UIView (IBK)
- (UIView *)ibk_superviewOfClass:(Class)class_name maxDepth:(NSInteger)depth {
    UIView *s = self.superview;
    NSInteger currentDepth = 0;
    while (![s isKindOfClass:class_name] && currentDepth < depth) {
        if (s.superview) {
            s = s.superview;
        } else {
            return nil;
        }
        currentDepth++;
    }

    if (currentDepth >= depth) return nil;
    
    return s;
}
@end


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
    
   SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
    SBRootFolderController *rootFolder = [iconController valueForKeyPath:@"_rootFolderController"];
    
    for (SBIconListView *listView in (NSArray *)[rootFolder valueForKey:@"iconListViews"]) {
        
        if ([listView isKindOfClass:NSClassFromString(@"SBRootIconListView")]) {
            SBIconIndexMutableList *list = [[listView model] valueForKey:@"_icons"];
            list.needsProcessing = YES;
        }
    }
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


void openWidget(NSString *bundleID) {

    if ([[IBKResources widgetBundleIdentifiers] containsObject:bundleID]) {
        if ([[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:bundleID]) {
            isPinching = YES;

            IBKWidgetViewController *widget = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:bundleID];
            //widget.scalingDown = TRUE;
            CGFloat scale = [NSClassFromString(@"SBIconView") defaultIconImageSize].height / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

            widget.currentScale = scale;
           // widget.shimIcon.alpha = 1.0f;
          //  widget.shimIcon.hidden = NO;
           //((UIView *)[widget.correspondingIconView _iconImageView]).alpha = 1.0;
            widget.scalingDown = YES;
            widget.shimIcon.hidden = NO;
            
            // Add widget view onto icon.
            [widget.correspondingIconView.superview addSubview:widget.correspondingIconView];

            if (widget.applicationIdentifer) {
                [IBKResources removeIdentifier:widget.applicationIdentifer];
                [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:widget.applicationIdentifer];
            }

           // [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:widget.applicationIdentifer];

            SBIconListView *lst = [NSClassFromString(@"IBKResources") listViewForBundleID:widget.applicationIdentifer];

            [UIView animateWithDuration:0.3 animations:^{
                //widget.view.alpha = 0.0;
                widget.shimIcon.alpha = 1.0;
                widget.iconImageView.alpha = 0.0;
                [widget setScaleForView:1.0 withDuration:0.3];
               // widget.view.transform = CGAffineTransformMakeScale(scale, scale);
                widget.view.center = CGPointMake(([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.width/2)-1, ([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.height/2)-1);
                if ([widget.correspondingIconView valueForKey:@"_accessoryView"]) {
                    ((UIView *)[widget.correspondingIconView valueForKey:@"_accessoryView"]).frame = [widget.correspondingIconView _frameForAccessoryView];
                }
                
                if ([widget.correspondingIconView valueForKey:@"_labelView"]) {
                    ((UIView *)[widget.correspondingIconView valueForKey:@"labelView"]).frame = [widget.correspondingIconView _frameForLabel];
                }
                //widget.shimIcon.alpha = 1.0;

               // widget.iconImageView.alpha = 0.0;
              //  [[widget.correspondingIconView _iconImageView] setAlpha:1.0];
               // widget.view.alpha = 0.0;

                if (![IBKResources hoverOnly]) {
                    
//                    [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] removeAllCachedIcons];
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                        //[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
                        if (lst) {
                            [lst setIconsNeedLayout];
                            [lst layoutIconsIfNeeded:0.3 domino:NO];
                        }
                    } else
                        [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
//                    [[objc_getClass("SBIconController") sharedInstance] removeIdentifierFromWidgets:self.applicationIdentifer];
                }
            } completion:^(BOOL finished) {
                [[widget.correspondingIconView _iconImageView] setAlpha:1.0];
                widget.view.hidden = YES;
                [widget unloadFromPinchGesture];

                isPinching = NO;
                if (![IBKResources hoverOnly]) {
                    if (lst) {
                        [lst setIconsNeedLayout];
                        [lst layoutIconsIfNeeded:0.0 domino:NO];
                    }
                }


                //[IBKResources removeIdentifier:widget.applicationIdentifer];

               // if (widget && widget.applicationIdentifer) [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:widget.applicationIdentifer];
            }];
        }
    } else {

        isPinching = YES;
        SBIcon *widgetIcon = [NSClassFromString(@"IBKResources") iconForBundleID:bundleID];

        IBKWidgetViewController *widget = [[IBKWidgetViewController alloc] init];
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

        CGFloat iconScale = [NSClassFromString(@"SBIconView") defaultIconImageSize].height / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

        // NSLog(@"BEGINNING SCALE IS %f", iconScale);

        widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);widget.currentScale = iconScale;
      //  [widget setScaleForView:8.0 withDuration:0.3];

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


        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            //[(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
            [listView setIconsNeedLayout];
            [listView layoutIconsIfNeeded:0.3 domino:NO];
        } else
            [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];

        // Move frame of widget into new position.
        reloadLayout();
        CGRect widgetViewFrame = widget.correspondingIconView.frame;
        widgetViewFrame.size = CGSizeMake([IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer], [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer]);
        [UIView animateWithDuration:0.3 animations:^{
            [widget setScaleForView:8.0 withDuration:0.3];
            if ([NSClassFromString(@"IBKResources") isRTL]) {
                 widget.view.frame = CGRectMake(0 - ([IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer] - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width), 0, [IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer], [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer]);
            }
            else {
                widget.view.frame = CGRectMake(0, 0, [IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer], [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer]);
            }
            widget.view.layer.shadowOpacity = 0.0;

            [(SBIconImageView*)[widget.correspondingIconView _iconImageView] setFrame:widgetViewFrame];

            // Icon's label?

             if ([widget.correspondingIconView valueForKey:@"_accessoryView"]) {
                ((UIView *)[widget.correspondingIconView valueForKey:@"_accessoryView"]).frame = [widget.correspondingIconView _frameForAccessoryView];
            }
            
            if ([widget.correspondingIconView valueForKey:@"_labelView"]) {
                ((UIView *)[widget.correspondingIconView valueForKey:@"labelView"]).frame = [widget.correspondingIconView _frameForLabel];
            }
        }completion:^(BOOL finished) {
            isPinching = NO;
        }];
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
   // displayAllWidgets();
}
-(void)_didComplete {
    %orig;
   // displayAllWidgets();
}
%end

%hook SBUIAnimationController
-(void)_startAnimation {
    if (!isRotating) {
        isLaunching = YES;
        sup = YES;
    }
    %orig;
}
-(void)startInteractiveTransition:(id)arg1 {
    if (!isRotating) {
        isLaunching = YES;
        sup = YES;
    }
    %orig;
}
-(void)__startAnimation {
    if (!isRotating) {
        isLaunching = YES;
        sup = YES;
    }
    %orig;
}
// -(void)_cleanupAnimation {
//     %orig;
//     isLaunching = NO;
//     sup = NO;
// }
// -(void)__cleanupAnimation {
//     %orig;
//     isLaunching = NO;
//     sup = NO;
// }
-(void)_noteAnimationDidFinish {
    %orig;
    isLaunching = NO;
    sup = NO;
    displayAllWidgets();
}
-(void)__reportAnimationCompletion {
    %orig;
    isLaunching = NO;
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
    isLaunching = NO;
    sup = NO;
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


// %hook SBRootIconListView
// - (CGPoint)centerForIcon:(SBIcon *)icon {

//     if ([icon respondsToSelector:@selector(applicationBundleID)]) {
//         NSString *bundleID = [icon applicationBundleID];
//         if (![[IBKResources widgetBundleIdentifiers] containsObject:bundleID]) return %orig;
//         CGPoint point = %orig;
//         point.x = point.x - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width/2 + [IBKResources widthForWidgetWithIdentifier:bundleID]/2;
//         point.y = point.y - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height/2 + [IBKResources heightForWidgetWithIdentifier:bundleID]/2;
//         return point;
//     }
//     return %orig;
// }
// %end


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
    //displayAllWidgets();
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
    //displayAllWidgets();

}
%end

%hook SBApplication

- (void)willAnimateDeactivation:(_Bool)arg1 {
    isLaunching = YES;
    //IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    //widgetController.view.alpha = 0.0;

    // [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
    //     widgetController.view.alpha = 1.0;
    // }];

    // sup = YES;
//    widgetController.view.alpha = 1.0;
    %orig;
}

-(void)didAnimateDeactivationOnStarkScreenController:(id)arg1 {
    %orig;
    // IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    // widgetController.view.alpha = 1.0;
    
    // sup = NO;
    // isLaunching = NO;
}

- (void)deactivate {
     %orig;
   //  IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    // widgetController.view.alpha = 1.0;
    
    // sup = NO;
    // isLaunching = NO;
}

-(void)didDeactivateForEventsOnly:(BOOL)arg1 {
     %orig;
    // IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    // widgetController.view.alpha = 1.0;
    
    // sup = NO;
    // isLaunching = NO;
}

- (void)didAnimateDeactivation {
    %orig;

//    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
//    [(UIImageView*)[widgetController.correspondingIconView _iconImageView] setAlpha:0.0];
  //  IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    // widgetController.view.alpha = 1.0;
    
   // sup = NO;
   // isLaunching = NO;
}

- (void)willActivateWithTransactionID:(unsigned long long)arg1 {
    isLaunching = YES;
  //  IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];

    // [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
    //     widgetController.view.alpha = 0.0;
    // }];

  //  sup = YES;

    %orig;
}

- (void)didActivateWithTransactionID:(unsigned long long)arg1 {
    lastOpenedWidgetId = [self bundleIdentifier];

    %orig;

    // sup = NO;
    // isLaunching = NO;
   // IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
    // [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
    //     widgetController.view.alpha = 0.0;
    // }];
    // sup = NO;
    // isLaunching = NO;
}

// iOS 7

- (void)didAnimateActivation {
    %orig;
    //isLaunching = NO;
    //sup = NO;
//    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];
//    widgetController.view.alpha = 1.0;
}

- (void)willAnimateActivation {
   // IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self bundleIdentifier]];

    // [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.3] animations:^{
    //     widgetController.view.alpha = 0.0;
    // }];

 //  sup = YES;

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
                                        countyThingy++;
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
                            countyThingy++;
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

%hook KazeQuickSwitcherIconView
%new
- (BOOL)shouldHaveBlock {
    return NO;
}

%new
- (NSInteger)ibk_allowBlockState {
    return 1;
}
%end

%hook SBIconView
%property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
%property (nonatomic, retain) UIView *widgetViewHolder;
%property (nonatomic, assign) NSInteger ibk_allowBlockState;
%property (nonatomic, assign) BOOL isKazeIconView;
%property (nonatomic, assign) BOOL forceOriginalLabelFrame;

%new
- (void)checkRootListViewPlacement {
    if (self.ibk_allowBlockState == 0) {
        HBLogInfo(@"Calling Checks for Root List View Placement: %@", [(SBIcon *)self.icon applicationBundleID]);
        HBLogInfo(@"Bundle Identifiers Contains Identifer: %@", [[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon *)self.icon applicationBundleID]] ? @"YES" : @"NO");
        self.ibk_allowBlockState = 1;
        if (self.icon) {
            if (![[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon *)self.icon applicationBundleID]] && !isPinching) {

                return;
            }

            if (![[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon *)self.icon applicationBundleID]] && isPinching) {
                self.ibk_allowBlockState = 2;
            }

            if (![self isMemberOfClass:NSClassFromString(@"SBIconView")]) {
                HBLogInfo(@"WASN'T MEMBER OF CLASS");
                return;
            }

            if (rearrangingIcons) {
                if ([[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon]) {
                    if ([[[self icon] applicationBundleID] isEqual:[[[NSClassFromString(@"SBIconController") sharedInstance] grabbedIcon] applicationBundleID]]) {
                        self.ibk_allowBlockState = 1;
                        return;
                    }
                }
            }

            if ([self respondsToSelector:@selector(isDragging)]) {
                if ([self isGrabbed]) {
                    UIView *rootView = [self ibk_superviewOfClass:NSClassFromString(@"SBIconListView") maxDepth:10];
                    if (rootView) {
                        self.ibk_allowBlockState = 2;
                        return;
                    }
                }
            }

            if (NSClassFromString(@"SBMedusaPlatterDragPreview")) {
                UIView *rootView = [self ibk_superviewOfClass:NSClassFromString(@"SBMedusaPlatterDragPreview") maxDepth:3];
                if (rootView) {
                    self.ibk_allowBlockState = 2;
                    return;

                }
            }


            UIView *rootView = [self ibk_superviewOfClass:NSClassFromString(@"SBIconListView") maxDepth:10];
            HBLogInfo(@"ROOT VIEW: %@", rootView);
            if (rootView && !rearrangingIcons) {
                if ([rootView isMemberOfClass:NSClassFromString(@"SBRootIconListView")]) {
                    self.ibk_allowBlockState = 2;
                }
            }

            rootView = [self ibk_superviewOfClass:NSClassFromString(@"KazeQuickSwitcherIconView") maxDepth:10];
            if (rootView) {
                self.ibk_allowBlockState = 1;
                self.isKazeIconView = YES;
                return;
            }

            BOOL hasApexInstalled = NSClassFromString(@"STKGroupView") ? YES : NO;

            if (hasApexInstalled) {
                rootView = [self ibk_superviewOfClass:NSClassFromString(@"STKGroupView") maxDepth:5];
                if (rootView) {
                    self.ibk_allowBlockState = 1;
                    [self ibk_removeWidgetView];
                    return;
                }
            }

            for (UIView *subview in [self subviews]) {
                if (hasApexInstalled) {
                    if ([subview isMemberOfClass:NSClassFromString(@"STKGroupView")]) {
                        STKGroupView *stackView = (STKGroupView *)subview;
                        if (stackView.isOpen || stackView.isAnimating || !stackView.group.empty) {
                            self.ibk_allowBlockState = 1;
                            [self ibk_removeWidgetView];
                        }
                        break;
                    }
                }

                if ([subview isKindOfClass:NSClassFromString(@"IBKWidgetBaseView")]) {
                    self.ibk_allowBlockState = 2;
                }

                // if ([subview isKindOfClass:NSClassFromString(@"SBIconImageCrossfadeView")]) {
                //     self.ibk_allowBlockState = 2;
                //     break;
                // }
            }
        }
    }
}

%new
- (BOOL)shouldHaveBlock {
    // HBLogInfo(@"ALLOW BLOCK STATE: %d", (int)self.ibk_allowBlockState);
    if (self.ibk_allowBlockState == 0) {
        [self checkRootListViewPlacement];
    }
    return (BOOL)(self.ibk_allowBlockState-1);
}

%new
- (void)setShouldHaveBlock:(BOOL)shouldHaveBlock {
    if (shouldHaveBlock) {
        self.ibk_allowBlockState = 2;
    } else {
        self.ibk_allowBlockState = 1;
    }
}

%new
- (UIView *)widgetView {
    if (!self.widgetViewHolder && self.shouldHaveBlock) {
        SBIcon *icon = self.icon;
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]];
        if (widgetController) {
            self.widgetViewHolder = widgetController.view;
        }
    }

    return self.widgetViewHolder;
}

%new
- (void)setWidgetView:(UIView *)widgetView {
    self.widgetViewHolder = widgetView;
}

%new
- (void)ibk_loadWidgetView {
    [self checkRootListViewPlacement];
    if (self.shouldHaveBlock && !isPinching && !isRotating && (isIOS11 ? YES : (![self isGrabbed]))) {
        SBIcon *icon = self.icon;
        SBIconImageView *iconImageView = (SBIconImageView *)[self _iconImageView];

        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[icon applicationBundleID]];
        if (!widgetController) {
            IBKWidgetViewController *widgetController = [[IBKWidgetViewController alloc] init];
            widgetController.applicationIdentifer = [icon applicationBundleID];
            [widgetController layoutViewForPreExpandedWidget];
            [[NSClassFromString(@"IBKResources") widgetViewControllers] setObject:widgetController forKey:[icon applicationBundleID]];
        } else {
            [widgetController.view removeFromSuperview];
        }

        [self addSubview:widgetController.view];
        [self sendSubviewToBack:widgetController.view];
        [self sendSubviewToBack:iconImageView];
        self.widgetViewHolder = widgetController.view;

        [iconImageView setAlpha:0.0];
        widgetController.correspondingIconView = self;

        widgetController.view.layer.shadowOpacity = 0.0;
        widgetController.shimIcon.alpha = 0.0f;
        widgetController.shimIcon.hidden = YES;

        if ([IBKResources hoverOnly]) {
            widgetController.view.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
            widgetController.view.layer.shadowOpacity = 0.3;
        }
    }
}

%new
- (void)ibk_removeWidgetView {
    if (!self.shouldHaveBlock && self.widgetView) {
        [self.widgetView removeFromSuperview];
        self.widgetView = nil;
    }
}

- (void)didMoveToSuperview {
    %orig;
    self.ibk_allowBlockState = 0;
    // [self checkRootListViewPlacement];
    if (!self.widgetView) {
        if (self.shouldHaveBlock && !rearrangingIcons && ![[NSClassFromString(@"SBIconController") sharedInstance] isEditing]) {
            [self loadWidget];
        }
    }
}

- (BOOL)pointInside:(struct CGPoint)arg1 withEvent:(UIEvent*)arg2 {

    // if ([[arg2 allTouches] count] > 1) return %orig;
    BOOL shouldPoint = NO;
    for (UIView *view in [self subviews]) {
        if ([view isKindOfClass:NSClassFromString(@"IBKWidgetBaseView")]) {
            shouldPoint = YES;
            break;
        }
    }
    if ((shouldPoint && self.widgetView) || (self.shouldHaveBlock && self.widgetView)) {
        // Check if point will be inside our thing.

        if ([IBKResources hoverOnly]) {
            UIView *view = self.widgetView;

            // Normalise point.
            arg1.x += ((view.frame.size.width - self.frame.size.width)/2);
            arg1.y += ((view.frame.size.width - self.frame.size.width)/2);
            //arg1 = [[[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]] view] convertPoint:arg1 fromView:self];
        }

        if (IS_RTL) {
            //UIView *view = [[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]] view];
            arg1.x += fabs([self bounds].origin.x); 
        }

        NSLog(@"Checking if point %@ is inside.", NSStringFromCGPoint(arg1));

        return [self.widgetView pointInside:arg1 withEvent:arg2];
    }

    BOOL orig = %orig;
    if ([[arg2 allTouches] count] > 1) return NO;
    // We need to check that if there are two or more touches, and only one is on the icon, then we MUST return NO.
    // Else, pinching will fail.

    return orig;
}

// - (CGRect)frame {
//     if (isPinching || (!self.shouldHaveBlock && !rearrangingIcons) || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) return %orig;

//     CGRect frame = %orig;
//     frame.size = self.bounds.size;
//     return frame;
// }

-(CGRect)bounds {

    if (self.isKazeIconView) return %orig;
    UIView *widgetView = self.widgetView;
    if (!isPinching && ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
        if (!self.shouldHaveBlock && !widgetView) return %orig;
    }

    CGRect frame = %orig;
    //IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    frame.size = widgetView.bounds.size;

    if (IS_RTL) {
        if (!isLaunching) {
            frame.origin.x = 0 - (frame.size.width - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width);
        }
    }

    if (isLaunching) {
        frame.origin.x += 1;
        frame.origin.y += 1;
    }

    // if (IS_RTL) {
    //     frame.origin.x = -frame.size.width + self.frame.size.width;
    // }
    return frame;
}

-(void)cleanupAfterImageCrossfade {
    isLaunching = NO;
    %orig;
}

-(void)cleanupAfterCrossfade {
    isLaunching = NO;
    %orig;
}

- (void)layoutSubviews {
    %orig;
    if (self.isKazeIconView)
        return;
    // if (!self.swipeDown) {
    //     self.swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    //     self.swipeDown.direction = UISwipeGestureRecognizerDirectionUp;
    //     [self addGestureRecognizer:self.swipeDown];
    // }

    if (self.shouldHaveBlock) {
        UIImageView *iconImageView = [self _iconImageView];
        [iconImageView setAlpha:0.0];

        UIView *widgetView = self.widgetView;
        if (widgetView) {
            if (![widgetView superview]) {
                [self addSubview:widgetView];
                [self bringSubviewToFront:widgetView];
                [self sendSubviewToBack:iconImageView];
                //[iconImageView setAlpha:0.0];
            }
        }
    }
}

%new
- (void)didSwipe:(id)sender {
    if (self.shouldHaveBlock)
        openWidget([(SBIcon *)self.icon applicationBundleID]);
}


%new
- (void)loadWidget {
    HBLogInfo(@"Called Load Widget");
    if (isRotating || isPinching) return;

     HBLogInfo(@"Load Widget - Should Have Block: %@", self.shouldHaveBlock ? @"YES" : @"NO");

    if (self.shouldHaveBlock) {
        [self ibk_loadWidgetView];
    } else {
        [self ibk_removeWidgetView];
    }
}

#pragma mark Icon Opening and Closing Animations

// // Used for App Opening/Closing Animation -[SBCrossfadeIconZoomAnimator _zoomedIconCenter]
 - (CGSize)iconImageVisibleSize {
    if (self.isKazeIconView) return %orig;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    if (widgetController)
        return CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
    else return %orig;
 }

// Used for the Icon Open/Closing Animation -[SBScaleIconZoomAnimator _prepareAnimation]

- (CGPoint)iconImageCenter {
    if ((!self.shouldHaveBlock && !isLaunching) || [IBKResources hoverOnly]) return %orig;

    UIView *widgetView = ((IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]]).view;
    if (!widgetView) return %orig;

    CGPoint point = %orig;
    point = CGPointMake(widgetView.frame.size.width/2, widgetView.frame.size.height/2);

    if (IS_RTL) {
        point.x = point.x - (widgetView.frame.size.width - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width) ;
    }

    if (isLaunching) {
        point.y += 1;
        point.x += 1;
    }

    return point;
}

// - (CGRect)iconImageFrame {
//     if (isLaunching && self.icon) {
//         CGRect frame = %orig;
//         IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
//         frame.size = widgetController.view.frame.size;
//         return frame;
//     }
//     if (inSwitcher || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) return %orig;
    
//     CGRect frame = %orig;
//     IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
//     frame.size = widgetController.view.frame.size;

//     if (IS_RTL) {
//         frame.origin.x = frame.origin.x - (widgetController.view.frame.size.width - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width);
//     }
//     return frame;
// }

- (id)iconImageSnapshot {
    if (!self.shouldHaveBlock && !isLaunching) return %orig;
    if (self.isKazeIconView) return %orig;
        
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    UIView *view = widgetController.view;

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return img;
}

-(void)prepareToCrossfadeImageWithView:(id)arg1 maskCorners:(BOOL)arg2 trueCrossfade:(BOOL)arg3 {
    if (self.isKazeIconView) return %orig;
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
        UIView *iconImageView = (UIView *)[self valueForKey:@"_iconImageView"];
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;

        if (view) {
            [[iconImageView layer] invalidateContents];
            [[iconImageView layer] addSublayer:[view layer]];
            // CGRect frame = view.frame;
            // frame.origin.x =1;
            // frame.origin.y =1;
            // view.frame = frame;
            // [iconImageView addSubview:view];
        }
    }
    // if (self.widgetView) {
    //     UIView *iconImageView = (UIView *)[self valueForKey:@"_iconImageView"];
    //     if (iconImageView) {
    //         [iconImageView addSubview:self.widgetView];
    //     }
    // }
    %orig; 
}
-(void)prepareToCrossfadeImageWithView:(id)arg1 maskCorners:(BOOL)arg2 trueCrossfade:(BOOL)arg3 anchorPoint:(CGPoint)arg4 {
   // if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
   //      UIView *iconImageView = (UIView *)[self valueForKey:@"_iconImageView"];
   //      if (iconImageView) {
   //          UIImage *widgetSnapshot = [self iconImageSnapshot];
   //          UIImageView *widgetProxyView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
   //          widgetProxyView.image = widgetSnapshot;
   //          [iconImageView addSubview:widgetProxyView];
   //      }
   //  }
    if ([self isKindOfClass:NSClassFromString(@"KazeQuickSwitcherIconView")]) return %orig;
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
        UIView *iconImageView = (UIView *)[self valueForKey:@"_iconImageView"];
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;

        if (view) {
            [[iconImageView layer] invalidateContents];
            [[iconImageView layer] addSublayer:[view layer]];
            // CGRect frame = view.frame;
            // frame.origin.x =1;
            // frame.origin.y =1;
            // view.frame = frame;
            // [iconImageView addSubview:view];
        }
    }
    %orig;
}
-(void)prepareToCrossfadeImageWithView:(id)arg1 crossfadeType:(unsigned long long)arg2 maskCorners:(BOOL)arg3 trueCrossfade:(BOOL)arg4 anchorPoint:(CGPoint)arg5 {
    if ([self isKindOfClass:NSClassFromString(@"KazeQuickSwitcherIconView")]) return %orig;
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
        UIView *iconImageView = (UIView *)[self valueForKey:@"_iconImageView"];
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;

        if (view) {
             [[iconImageView layer] invalidateContents];
             [[iconImageView layer] addSublayer:[view layer]];
            // CGRect frame = view.frame;
            // frame.origin.x =1;
            // frame.origin.y =1;
            // view.frame = frame;
            // [iconImageView addSubview:view];
        }
    }

    %orig;
}
-(void)prepareToCrossfadeImageWithView:(id)arg1 crossfadeType:(unsigned long long)arg2 maskCorners:(BOOL)arg3 trueCrossfade:(BOOL)arg4 {
    if ([self isKindOfClass:NSClassFromString(@"KazeQuickSwitcherIconView")]) return %orig;
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
        UIView *iconImageView = (UIView *)[self valueForKey:@"_iconImageView"];
        IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;

        if (view) {
            [[iconImageView layer] invalidateContents];
            [[iconImageView layer] addSublayer:[view layer]];
            // CGRect frame = view.frame;
            // frame.origin.x =1;
            // frame.origin.y =1;
            // view.frame = frame;
            // [iconImageView addSubview:view];
        }
    }
    %orig;
}

#pragma mark Icon View Label Position

- (CGRect)_frameForLabel {
    if (self.forceOriginalLabelFrame) return %orig;
    if (isPinching && !self.shouldHaveBlock) return %orig;
    if (!isPinching && ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) {
        if (!self.shouldHaveBlock && ![self isGrabbed]) return %orig;
        if ([self isGrabbed] && ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]]) return %orig;
    }
    CGRect orig = %orig;
    
    IBKWidgetViewController *widgetController = (IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];   
    CGRect widgetFrame = widgetController.view.frame;
        
    CGFloat widgetScale = widgetController.currentScale;
        
        
    CGFloat percentComplete = (widgetScale - 0.375)/0.625;
    if (percentComplete > 1)
        percentComplete = 1;
            
    else if (percentComplete < 0)
        percentComplete = 0;

    CGFloat finalPosition = IS_RTL ? self.frame.size.width  - orig.size.width - 8 : 8;
    if (IS_RTL) {
        CGPoint labelFramePoint = CGPointMake(widgetController.view.bounds.size.width - orig.size.width-8 ,0);
        CGPoint labelPoint = [widgetController.view convertPoint:labelFramePoint toView:self];
        finalPosition = labelPoint.x;


    }
            
    CGFloat extraPadding = (finalPosition * percentComplete) + (orig.origin.x * (1 - percentComplete));
    if ([NSClassFromString(@"IBKResources") isRTL]) {
       // CGFloat startingPosition = [widgetController.view convertPoint:CGPointMake(0,0) toView:self].x;
        orig.origin = CGPointMake(extraPadding, widgetFrame.origin.y + widgetFrame.size.height);
    }
    else {
        orig.origin = CGPointMake(widgetFrame.origin.x + extraPadding, widgetFrame.origin.y + widgetFrame.size.height);
    }

    if (orig.origin.y == 0 && widgetFrame.size.height == 0) return %orig;
    return orig;
}

#pragma mark Icon View Badge Position for Icon Views

-(CGRect)_frameForAccessoryView {
    
    if ((!self.shouldHaveBlock && !rearrangingIcons && !isLaunching) || [IBKResources hoverOnly] || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [self isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    
    CGRect orig = %orig;
    CGRect widgetFrame = ((IBKWidgetViewController *)[[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]]).view.frame;
    CGFloat xValue = widgetFrame.origin.x + (IS_RTL ? 0 : widgetFrame.size.width) - (IS_RTL ? 0 : orig.size.width) + (IS_RTL ? -10 : 10);

    // if (IS_RTL) {
    //     xValue = 
    // }
    orig.origin = CGPointMake(xValue, widgetFrame.origin.y - (orig.size.height/2));
    return orig;
}
    
// -(void)prepareForRecycling {
//     %orig;
    
//     IBKWidgetViewController *widgetController = [NSClassFromString(@"IBKResources") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
//     if (widgetController) {
//         [widgetController unloadWidgetInterface];
//         [widgetController.view removeFromSuperview];
        
//         if ([self.icon applicationBundleID]) {

//             [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:[self.icon applicationBundleID]];
//             [self checkRootListViewPlacement];
//         }
//     }
// }

// -(void)prepareForReuse {
//     %orig;
    
//     IBKWidgetViewController *widgetController = [NSClassFromString(@"IBKResources") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
//     if (widgetController) {
//         [widgetController unloadWidgetInterface];
//         [widgetController.view removeFromSuperview];
        
//         if ([self.icon applicationBundleID]) {

//             [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:[self.icon applicationBundleID]];
//         }
//     }
// }
    
// - (void)prepareToCrossfadeImageWithView:(id)arg1 maskCorners:(_Bool)arg2 trueCrossfade:(_Bool)arg3 anchorPoint:(struct CGPoint)arg4 {
//     %orig;
// }

// - (void)_setIcon:(id)arg1 animated:(BOOL)arg2 { // Deal with adding a widget view onto those icons that are already expanded
//     %orig;
//     [self loadWidget];
// }

- (void)setIcon:(SBIcon *)icon {
    %orig;
    self.ibk_allowBlockState = 0;
    if (icon) {
        if (![[NSClassFromString(@"SBIconController") sharedInstance] isEditing])
            [self loadWidget];
    }
}
- (void)setLocation:(int)location {
    %orig;
    self.ibk_allowBlockState = 0;
    // BOOL shouldHaveBlock = self.shouldHaveBlock;
    // HBLogInfo(@"Set Location - Should Have Block: %@", shouldHaveBlock ? @"YES" : @"NO");
    if (!rearrangingIcons) {
        [self loadWidget];
    }
}
%end

CGSize defaultIconSizing;

#import "../headers/SpringBoard/SBIconImageCrossfadeView.h"

@interface SBIconImageView (IBK)
@property (nonatomic, assign, readonly) BOOL shouldHaveBlock;
- (void)checkRootListViewPlacement;
@end

%hook SBIconImageView

%new
- (void)checkRootListViewPlacement {
    SBIconView *iconView = (SBIconView *)[self ibk_superviewOfClass:NSClassFromString(@"SBIconView") maxDepth:10];
    if (iconView) {
       [iconView checkRootListViewPlacement];
    }
}

%new
- (BOOL)shouldHaveBlock {
    SBIconView *iconView = (SBIconView *)[self ibk_superviewOfClass:NSClassFromString(@"SBIconView") maxDepth:10];
    if (iconView) {
        HBLogInfo(@"Have Block - IconView: %@", iconView);
        return iconView.shouldHaveBlock;
    } else return NO;
}

- (CGRect)visibleBounds {
    if (!isPinching) {
        if (!self.shouldHaveBlock && (!isLaunching || !rearrangingIcons) && (self.icon && ![[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon *)self.icon applicationBundleID]])) return %orig;
    }
    // if ([[self superview] isKindOfClass:NSClassFromString(@"SBIconView")]) {
    //     return [self superview].bounds;
    // }
    CGRect frame = %orig;
    IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
    if (widgetController && ((isPinching && self.shouldHaveBlock) || (!isPinching && (self.shouldHaveBlock || !self.shouldHaveBlock)))) {
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);


        if (IS_RTL) {
            frame.origin.x = 0 - (widgetController.view.frame.size.width - [NSClassFromString(@"SBIconView") defaultIconImageSize].width) - 1;
        } else {
            // frame.origin.x += 1;
            // frame.origin.y += 1;
        }
    }

    if (isLaunching) {
        frame.origin.x -= 1;
        frame.origin.y -= 1;
    }
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

// -(CGRect)frame {

//     if ((!self.shouldHaveBlock && !rearrangingIcons) || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;

//     if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
//         CGRect frame = %orig;
//         IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
//         frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

//         return frame;
//     }

//     return %orig;
// }

// -(CGRect)bounds {
//     if ((!self.shouldHaveBlock && !rearrangingIcons) || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
    
//     CGRect frame = %orig;
//     IBKWidgetViewController *widgetController = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[self.icon applicationBundleID]];
//     frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);

//     return frame;
// }


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

// - (void)setAlpha:(CGFloat)alpha {
//     if ((!self.shouldHaveBlock && isLaunching) || inSwitcher || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
//     %orig(0);
// }

// - (CGFloat)alpha {
//      if ((!self.shouldHaveBlock && !isLaunching) || inSwitcher  || ![[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] || [[self superview] isKindOfClass:NSClassFromString(@"SBAppSwitcherIconView")]) return %orig;
//     return 0;;
// }

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
    if ([grabbedIconView isKindOfClass:NSClassFromString(@"SBIconView")]) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[[(SBIconView*)grabbedIconView icon] applicationBundleID]] || [[IBKResources widgetBundleIdentifiers] containsObject:[[(SBIconView*)iconView icon] applicationBundleID]]) {
            return NO;
        }
        if ([[(SBIconView*)grabbedIconView icon] isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]] || [[(SBIconView*)iconView icon] isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]]) {
            return NO;
        }
    } else if ([grabbedIconView isKindOfClass:NSClassFromString(@"SBIcon")]) {
         if ([[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon*)grabbedIconView applicationBundleID]] || [[IBKResources widgetBundleIdentifiers] containsObject:[(SBIcon*)grabbedIconView applicationBundleID]]) {
            return NO;
        }
        if ([grabbedIconView isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]] || [grabbedIconView isKindOfClass:[NSClassFromString(@"IBKPlaceholderIcon") class]]) {
            return NO;
        }
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
            
            return %orig(icon, insertionPath);
        }
        
        SBIconCoordinate coordinate = [listView iconCoordinateForIndex:[insertionPath indexAtPosition:[insertionPath length] - 1] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        
        if (coordinate.row == 1 && coordinate.col == 1) {
            insertionPath = [NSIndexPath indexPathForRow:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] inSection:[(NSIndexPath*)insertionPath section]];
            [IBKResources setIndex:[listView indexForCoordinate:coordinate forOrientation:[[UIApplication sharedApplication] statusBarOrientation]] forBundleID:[icon applicationBundleID] forOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
            isDropping = YES;
            return %orig(icon, insertionPath);
            
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
        if (![[IBKResources widgetBundleIdentifiers] containsObject:[[iconView icon] applicationBundleID]]) {
            %orig;
        }
    } else {
        %orig;
    }
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
        CGFloat xMidpointValue = ([%c(SBIconView) defaultIconSize].width/2) * (IS_RTL ? 2 : 1);
        CGPoint properPausePoint = CGPointMake(draggedIconView.frame.origin.x + xMidpointValue, draggedIconView.frame.origin.y + [%c(SBIconView) defaultIconSize].height/2);
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

    // UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:orig action:@selector(handleTapGesture:)];
    // tapGesture.numberOfTapsRequired = 2;
    // [(UIView *)orig addGestureRecognizer:tapGesture];

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

%new
- (void)handleTapGesture:(id)sender {
    openWidget([NSString stringWithFormat:@"com.apple.Music"]);
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
        isPinching = YES;
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
            isPinching = NO;
            return;
        }

        SBIconView *view;
        if ([[%c(SBIconController) sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
            view = [[[%c(SBIconController) sharedInstance] homescreenIconViewMap] mappedIconViewForIcon:widgetIcon];
        }
        else {
            view = [[%c(SBIconViewMap) homescreenMap] mappedIconViewForIcon:widgetIcon];
        }

        view.ibk_allowBlockState = 0;

        if ([widgetIcon isKindOfClass:[%c(IBKPlaceholderIcon) class]]) {
            
            NSArray* stringArray = [[widgetIcon applicationBundleID] componentsSeparatedByString: @"/"];
            if ([stringArray count] < 2) {
                widget = nil;
                isPinching = NO;
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
            
        } else {
            if (!view.shouldHaveBlock) {
                widget = nil;
                isPinching = NO;
                return;
            }
        }

        // Ah shit. If this widget is already open, don't do anything!
        if ([[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[widgetIcon applicationBundleID]]) {
            widget = [[NSClassFromString(@"IBKResources") widgetViewControllers] objectForKey:[widgetIcon applicationBundleID]];
            widget.correspondingIconView.ibk_allowBlockState = 2;
            isClosing = YES;
            isPinching = YES;
            [widget handlePinchGesture:pinch];
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

        CGFloat iconScale = [NSClassFromString(@"SBIconView") defaultIconImageSize].height / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

       // NSLog(@"BEGINNING SCALE IS %f", iconScale);

        widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);widget.currentScale = iconScale;
        
    } else if (pinch.state == UIGestureRecognizerStateChanged && widget) {
        if (isClosing) {
            isPinching = YES;
            widget.correspondingIconView.ibk_allowBlockState = 2;
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
            widget.correspondingIconView.ibk_allowBlockState = 1;
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

                if ([widget.correspondingIconView valueForKey:@"_accessoryView"]) {
                    ((UIView *)[widget.correspondingIconView valueForKey:@"_accessoryView"]).frame = [widget.correspondingIconView _frameForAccessoryView];
                }
                
                if ([widget.correspondingIconView valueForKey:@"_labelView"]) {
                    ((UIView *)[widget.correspondingIconView valueForKey:@"labelView"]).frame = [widget.correspondingIconView _frameForLabel];
                }
                widget.view.layer.shadowOpacity = 0.0;

                [(SBIconImageView*)[widget.correspondingIconView _iconImageView] setFrame:widgetViewFrame];

                // Icon's label?
            }];
        } else {
            widget.correspondingIconView.ibk_allowBlockState = 1;
            CGFloat iconScale = [NSClassFromString(@"SBIconView") defaultIconImageSize].height / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

            CGFloat red, green, blue;
            [widget.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
            widget.currentScale = iconScale;
            [UIView animateWithDuration:0.25 animations:^{
                // widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
                // widget.shimIcon.alpha = 1.0;
                // widget.viw.alpha = 0.0;
                widget.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
                [widget setScaleForView:1.0 withDuration:0.25];
            } completion:^(BOOL finished) {
                [[(SBIconView*)widget.correspondingIconView _iconImageView] setAlpha:1.0];
                [widget unloadFromPinchGesture];
                [IBKResources removeIdentifier:widget.applicationIdentifer];
                if (widget && widget.applicationIdentifer) [[NSClassFromString(@"IBKResources") widgetViewControllers] removeObjectForKey:widget.applicationIdentifer];
                //[[(SBIconView*)widget.correspondingIconView _iconImageView] setAlpha:1.0];
            }];
        }
        isPinching = NO;
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
       // NSLog(@"PINCHING WAS CANCELLED");
        widget.correspondingIconView.ibk_allowBlockState = 1;
        CGFloat scale = [NSClassFromString(@"SBIconView") defaultIconImageSize].height / [IBKResources heightForWidgetWithIdentifier:widget.applicationIdentifer];

        CGFloat red, green, blue;
        [widget.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];

        widget.currentScale = scale;
        [UIView animateWithDuration:0.3 animations:^{
            widget.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
            [widget setScaleForView:1.0 withDuration:0.3];
        } completion:^(BOOL finished) {
            widget.correspondingIconView.widgetView = nil;
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

    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.iosblocks.curago.plist"];

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


%group iOSThing

@interface SBIconListModel (iOSEleven)
- (SBIcon *)directlyContainedIconWithIdentifier:(NSString *)identifier;
@end
%hook SBIconListModel
%new
-(NSUInteger)indexForLeafIconWithIdentifier:(NSString *)identifier {
    return [self indexForIcon:[self directlyContainedIconWithIdentifier:identifier]];
}
%end

%hook SBIconController
%new
- (id)grabbedIcon {
    return nil;
}
%end

%hook SBApplication
%new
- (BOOL)hasGameCenterData {
    return NO;
}
%end
%end

%hook SBDockIconListView
- (id)initWithModel:(id)model orientation:(NSInteger)orientation viewMap:(id)map {
    if (!map) {
        NSLog(@"I DIDN'T HAVE A VIEW MAP");
    }
    return %orig;
}
%end


@interface SBMedusaPlatterDragPreview : UIView
@property (nonatomic,readonly) SBIconView * iconView;
-(NSUInteger)platterViewState; 
+ (CGFloat)iconLiftAlpha; 
@end

@interface UITargetedDragPreviewSpecial : NSObject
@property (nonatomic, retain) NSValue *forcedSize;
@end

@interface UITargetedDragPreview (NSObject)
@property (nonatomic, retain) NSValue *forcedSize;
@end

%group iOS11

static CGSize temporarySize = CGSizeZero;
static BOOL useTempSize = NO;


%hook SBMedusaPlatterDragPreview
-(void)setPlatterViewState:(NSUInteger)state andSize:(CGSize)size {
    BOOL shouldRelocateWidgetView = NO;
    if (self.iconView && self.iconView.shouldHaveBlock && self.iconView.widgetView) {
        if (state > 1) {
            shouldRelocateWidgetView = TRUE;
            // useTempSize = YES;
            // temporarySize = self.iconView.widgetView.bounds.size;
        }

        if (state < 2) {
            useTempSize = YES;
            // temporarySize = self.iconView.widgetView.bounds.size;
            //  CGPoint center = self.center;
            // CGRect widgetFrame = self.iconView.widgetView.bounds;
            // frame.size = widgetFrame.size;
            // self.frame = frame;
            // center.x += [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width;
            // center.y += [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height*2;
           // self.center = center;
        }
        // useTempSize = YES;
        // temporarySize = self.iconView.widgetView.bounds.size;
    }
    %orig(state,size);
    UIView *widgetView = self.iconView.widgetView;
    if (shouldRelocateWidgetView && [widgetView superview] != self.iconView) {
        if ([widgetView superview]) {
            [widgetView removeFromSuperview];
        }

        [self.iconView addSubview:widgetView];
    }
    useTempSize = NO;

}

- (void)setIcon:(SBIcon *)icon {
    %orig;
    if (self.iconView && self.iconView.widgetView) {
        // CGRect frame = self.frame;
        // CGPoint center = self.center;
        // CGRect widgetFrame = self.iconView.widgetView.bounds;
        // frame.size = widgetFrame.size;
        // self.frame = frame;
        useTempSize = YES;
       //  center.x += [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width;
       //  center.y += [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height*2;
       //  useTempSize = NO;
       // self.center = center;
    }
    useTempSize = NO;
}
%end
%hook SBIconListView
%new
-(void)layoutIconsIfNeeded:(CGFloat)duration domino:(BOOL)domino {
    [self layoutIconsIfNeeded:duration animationType:domino ? 1 : 0];
}
%end

%hook SBIconDragManager
- (BOOL)shouldUseGhostIconForIconView:(SBIconView *)iconView {
    return NO;
}
%end

%hook _DUIPreview
-(BOOL)hidesSourceView {
    return NO;
}
- (void)setHidesSourceView:(BOOL)hides {
    %orig(NO);
}
%end

%hook SBIconImageView
- (CGRect)bounds {
    if (useTempSize) return CGRectMake(0,0,temporarySize.width*0.5, temporarySize.height*0.5);
    else return %orig;
}
%end

%hook SBIconView

+ (CGSize)defaultVisibleIconImageSize {
    if (useTempSize) return CGSizeMake(temporarySize.width, temporarySize.height);
    else return %orig;
}

- (CGRect)frame {
    CGRect frame = %orig;
    if (self.widgetView && useTempSize) frame.size = self.bounds.size;
    return frame;
}

- (UITargetedDragPreviewSpecial *)dragPreviewForItem:(id)item session:(id)session {
    if (self.widgetView) {
        temporarySize = self.widgetView.bounds.size;
        useTempSize = YES;
    }
    UITargetedDragPreviewSpecial *orig = %orig;
    if (self.widgetView) {
        orig.forcedSize = [NSValue valueWithCGSize:self.widgetView.bounds.size];
    }
    useTempSize = NO;

    // CGPoint center = orig.center;
    // center.x += temporarySize.width;
    // center.y += temporarySize.height;
    // orig.center = center;
    return orig;
}

-(void)setDragging:(BOOL)dragging {
    if (!dragging && [self isDragging]) {
        UIView *widgetView = self.widgetView;
        if (widgetView) {
            [widgetView removeFromSuperview];
        }

        [self addSubview:self.widgetView];
    }
    %orig;
}

-(void)_applyIconContentScale:(CGFloat)scale {
    UIView *scalingContainer = [self valueForKey:@"_scalingContainer"];
    if (scalingContainer && self.widgetView) {
        UIView *widgetView = self.widgetView;
        BOOL shouldRelocate = YES;
        SBMedusaPlatterDragPreview *rootView = (SBMedusaPlatterDragPreview  *)[widgetView ibk_superviewOfClass:NSClassFromString(@"SBMedusaPlatterDragPreview") maxDepth:3];
        if (rootView) {
            if ([rootView platterViewState] > 1.0) shouldRelocate = NO;

        }
        if (widgetView && shouldRelocate) {
            if (![widgetView superview]) {
                [widgetView removeFromSuperview];
            }
            scalingContainer.alpha = [NSClassFromString(@"SBMedusaPlatterDragPreview") iconLiftAlpha];
            [scalingContainer addSubview:widgetView];
        } else {
            //scalingContainer.alpha = 1.0;
        }
    }
    %orig;
}

- (void)setIconContentScalingEnabled:(BOOL)enabled {
    if (enabled) {
        if (self.widgetView) {
            ((UIImageView *)[self _iconImageView]).hidden = YES;
        }
        UIView *scalingContainer = [self valueForKey:@"_scalingContainer"];
        if (scalingContainer) {
            scalingContainer.alpha = [NSClassFromString(@"SBMedusaPlatterDragPreview") iconLiftAlpha];
        }
    } else {
        if (self.widgetView) {
            ((UIImageView *)[self _iconImageView]).hidden = NO;
        }

        UIView *scalingContainer = [self valueForKey:@"_scalingContainer"];
        if (scalingContainer) {
            scalingContainer.alpha = 1.0;
        }
    }
    %orig;
}
%end

// %hook SBSAppDragLocalContext
// -(void)setPortaledPreview:(UIView *)view {
//     view.backgroundColor = [UIColor redColor];
//     %orig(view);
// }
// %end

%hook UITargetedDragPreviewSpecial
%property (nonatomic, retain) NSValue *forcedSize;

- (CGSize)size {
    return %orig;
    UITargetedDragPreviewSpecial *orig = (UITargetedDragPreviewSpecial *)self;
    if (orig.forcedSize) return [orig.forcedSize CGSizeValue];
    else return %orig;
}
%end

// %hook SBMedusaPlatterDragPreview
// %end

%end

%ctor {

    // We're done. Load!
    %init;
    %init(iOSThing); // For iOS 11

   // dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
   // dlopen("/Library/MobileSubstrate/DynamicLibraries/iWidgets.dylib", RTLD_NOW);
    //dlopen("/Library/MobileSubstrate/DynamicLibraries/Kaze.dylib", RTLD_NOW);
    // [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"com.iosblocks.curago"];

    // Load custom stuff for certain versions of iOS.

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        %init(iOS8);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
        //%init(iOS11);
        %init(iOS11, UITargetedDragPreviewSpecial=NSClassFromString(@"UITargetedDragPreview"));
        isIOS11 = YES;
    }

    %init(iWidgets);

    [IBKResources reloadSettings];

    //dlopen("/Applications/News.app/Plugins/NewsToday.appex/NewsToday",RTLD_LAZY);

    // Handlers for widget settings.
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, settingsChangedForWidget, CFSTR("com.matchstic.ibk/settingschangeforwidget"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadAllWidgets, CFSTR("com.matchstic.ibk/reloadallwidgets"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, reloadSettings, CFSTR("com.matchstic.ibk/reloadsettings"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, changedLockAll, CFSTR("com.matchstic.ibk/changedlockall"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
