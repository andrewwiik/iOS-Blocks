#line 1 "/Users/Matt/iOS/Projects/Curago/Git/curago/curago.xm"













#import <SpringBoard7.0/SBIconController.h>
#import <SpringBoard7.0/SBFolder.h>
#import <SpringBoard7.0/SBRootFolder.h>
#import <SpringBoard7.0/SBIconListModel.h>
#import <SpringBoard7.0/SBIconModel.h>
#import <SpringBoard7.0/SBIconListView.h>
#import <SpringBoard7.0/SBIconImageView.h>
#import <SpringBoard7.0/SBIconView.h>
#import <SpringBoard7.0/SBApplicationIcon.h>
#import <SpringBoard7.0/SBFolderIcon.h>
#import <SpringBoard7.0/SBIconIndexMutableList.h>
#import <SpringBoard7.0/SBIconViewMap.h>
#import <SpringBoard7.0/SBIconScrollView.h>
#import <SpringBoard7.0/SBIconBadgeView.h>
#import <SpringBoard7.0/SBRootFolderController.h>
#import <SpringBoard7.0/SBRootFolderView.h>

#import <objc/runtime.h>

#import <QuartzCore/QuartzCore.h>
#import <BulletinBoard/BBServer.h>
#import <BulletinBoard/BBBulletin.h>

#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface SBFAnimationSettings : NSObject
@property double duration;
+ (id)settingsControllerModule;
@end



typedef struct SBIconCoordinate {
    NSUInteger row;
    NSUInteger col;
} SBIconCoordinate;



@interface SBIconListView (Additions)
-(SBIconCoordinate)coordinateForIconWithIndex:(unsigned int)index andOriginalCoordinate:(SBIconCoordinate)orig forOrientation:(int)arg3;
-(SBIcon*)modifiedIconForIcon:(SBIcon*)icon;
@end

@interface SBIconModel (iOS8)
- (void)saveIconStateIfNeeded;
@end

@interface IBKIconView : SBIconView

+(IBKWidgetViewController*)getWidgetViewControllerForIcon:(SBIcon*)arg1 orBundleID:(NSString*)arg2;
-(void)addPreExpandedWidgetIfNeeded:(id)arg1;

@end



NSMutableDictionary *cachedIndexes;
NSMutableDictionary *cachedIndexesLandscape;
NSMutableSet *movedIndexPaths;
NSMutableDictionary *widgetViewControllers;

int icons = 0;
int currentOrientation = 1;

BOOL animatingIn = NO;
BOOL rearrangingIcons = NO;
BOOL iWidgets = NO;
BOOL dontKillIcons = NO;
BOOL isRotating = NO;

static BBServer* __weak IBKBBServer;



#pragma mark Icon co-ordinate placements

#include <logos/logos.h>
#include <substrate.h>
@class SBAppSwitcherController; @class SBIconController; @class SBMediaController; @class SBIconView; @class SBIconImageCrossfadeView; @class IBKIconView; @class SBIconViewMap; @class MPUNowPlayingController; @class BBServer; @class SBIconBadgeView; @class SBAppSliderController; @class SBIconListView; @class SBLockScreenViewController; @class SBApplication; @class SBIconScrollView; @class SBIconImageView; @class IWWidgetsView; 
static _Bool (*_logos_orig$_ungrouped$SBIconListView$isFull)(SBIconListView*, SEL); static _Bool _logos_method$_ungrouped$SBIconListView$isFull(SBIconListView*, SEL); static void (*_logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$)(SBIconListView*, SEL, int); static void _logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(SBIconListView*, SEL, int); static void (*_logos_orig$_ungrouped$SBIconListView$cleanupAfterRotation)(SBIconListView*, SEL); static void _logos_method$_ungrouped$SBIconListView$cleanupAfterRotation(SBIconListView*, SEL); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$rowAtPoint$)(SBIconListView*, SEL, struct CGPoint); static unsigned int _logos_method$_ungrouped$SBIconListView$rowAtPoint$(SBIconListView*, SEL, struct CGPoint); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$columnAtPoint$)(SBIconListView*, SEL, struct CGPoint); static unsigned int _logos_method$_ungrouped$SBIconListView$columnAtPoint$(SBIconListView*, SEL, struct CGPoint); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$)(SBIconListView*, SEL, struct SBIconCoordinate, int); static unsigned int _logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(SBIconListView*, SEL, struct SBIconCoordinate, int); static struct SBIconCoordinate (*_logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$)(SBIconListView*, SEL, unsigned int, int); static struct SBIconCoordinate _logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(SBIconListView*, SEL, unsigned int, int); static SBIconCoordinate _logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$forOrientation$(SBIconListView*, SEL, unsigned int, SBIconCoordinate, int); static SBIcon* _logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$(SBIconListView*, SEL, SBIcon*); static void (*_logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$)(SBAppSliderController*, SEL, BOOL); static void _logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$(SBAppSliderController*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$)(SBAppSliderController*, SEL, id, id, int, id); static void _logos_method$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$(SBAppSliderController*, SEL, id, id, int, id); static void (*_logos_orig$_ungrouped$SBAppSwitcherController$switcherWasDismissed$)(SBAppSwitcherController*, SEL, BOOL); static void _logos_method$_ungrouped$SBAppSwitcherController$switcherWasDismissed$(SBAppSwitcherController*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBAppSwitcherController$animatePresentationFromDisplayLayout$withViews$withCompletion$)(SBAppSwitcherController*, SEL, id, id, id); static void _logos_method$_ungrouped$SBAppSwitcherController$animatePresentationFromDisplayLayout$withViews$withCompletion$(SBAppSwitcherController*, SEL, id, id, id); static void (*_logos_orig$_ungrouped$SBApplication$willAnimateDeactivation$)(SBApplication*, SEL, _Bool); static void _logos_method$_ungrouped$SBApplication$willAnimateDeactivation$(SBApplication*, SEL, _Bool); static void (*_logos_orig$_ungrouped$SBApplication$didAnimateDeactivation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$didAnimateDeactivation(SBApplication*, SEL); static void (*_logos_orig$_ungrouped$SBApplication$willActivateWithTransactionID$)(SBApplication*, SEL, unsigned long long); static void _logos_method$_ungrouped$SBApplication$willActivateWithTransactionID$(SBApplication*, SEL, unsigned long long); static void (*_logos_orig$_ungrouped$SBApplication$didActivateWithTransactionID$)(SBApplication*, SEL, unsigned long long); static void _logos_method$_ungrouped$SBApplication$didActivateWithTransactionID$(SBApplication*, SEL, unsigned long long); static void (*_logos_orig$_ungrouped$SBApplication$didAnimateActivation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$didAnimateActivation(SBApplication*, SEL); static void (*_logos_orig$_ungrouped$SBApplication$willAnimateActivation)(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$willAnimateActivation(SBApplication*, SEL); static void _logos_method$_ungrouped$SBApplication$finishedAnimatingActivationFully(SBApplication*, SEL); static id (*_logos_orig$_ungrouped$SBIconViewMap$mappedIconViewForIcon$)(SBIconViewMap*, SEL, id); static id _logos_method$_ungrouped$SBIconViewMap$mappedIconViewForIcon$(SBIconViewMap*, SEL, id); static id (*_logos_orig$_ungrouped$SBIconView$initWithDefaultSize)(SBIconView*, SEL); static id _logos_method$_ungrouped$SBIconView$initWithDefaultSize(SBIconView*, SEL); static CGRect (*_logos_orig$_ungrouped$SBIconImageView$visibleBounds)(SBIconImageView*, SEL); static CGRect _logos_method$_ungrouped$SBIconImageView$visibleBounds(SBIconImageView*, SEL); static CGRect (*_logos_orig$_ungrouped$SBIconImageView$frame)(SBIconImageView*, SEL); static CGRect _logos_method$_ungrouped$SBIconImageView$frame(SBIconImageView*, SEL); static CGRect (*_logos_orig$_ungrouped$SBIconImageView$bounds)(SBIconImageView*, SEL); static CGRect _logos_method$_ungrouped$SBIconImageView$bounds(SBIconImageView*, SEL); static CGPoint (*_logos_orig$_ungrouped$IBKIconView$iconImageCenter)(IBKIconView*, SEL); static CGPoint _logos_method$_ungrouped$IBKIconView$iconImageCenter(IBKIconView*, SEL); static CGRect (*_logos_orig$_ungrouped$IBKIconView$iconImageFrame)(IBKIconView*, SEL); static CGRect _logos_method$_ungrouped$IBKIconView$iconImageFrame(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$)(IBKIconView*, SEL, id, _Bool, _Bool, struct CGPoint); static void _logos_method$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$(IBKIconView*, SEL, id, _Bool, _Bool, struct CGPoint); static id (*_logos_orig$_ungrouped$IBKIconView$iconImageSnapshot)(IBKIconView*, SEL); static id _logos_method$_ungrouped$IBKIconView$iconImageSnapshot(IBKIconView*, SEL); static CGRect (*_logos_orig$_ungrouped$IBKIconView$frame)(IBKIconView*, SEL); static CGRect _logos_method$_ungrouped$IBKIconView$frame(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$_setIcon$animated$)(IBKIconView*, SEL, id, BOOL); static void _logos_method$_ungrouped$IBKIconView$_setIcon$animated$(IBKIconView*, SEL, id, BOOL); static struct CGRect (*_logos_orig$_ungrouped$IBKIconView$_frameForLabel)(IBKIconView*, SEL); static struct CGRect _logos_method$_ungrouped$IBKIconView$_frameForLabel(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$prepareForRecycling)(IBKIconView*, SEL); static void _logos_method$_ungrouped$IBKIconView$prepareForRecycling(IBKIconView*, SEL); static BOOL (*_logos_orig$_ungrouped$IBKIconView$pointInside$withEvent$)(IBKIconView*, SEL, struct CGPoint, UIEvent*); static BOOL _logos_method$_ungrouped$IBKIconView$pointInside$withEvent$(IBKIconView*, SEL, struct CGPoint, UIEvent*); static IBKWidgetViewController* _logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$(Class, SEL, SBIcon*, NSString*); static void _logos_method$_ungrouped$IBKIconView$addPreExpandedWidgetIfNeeded$(IBKIconView*, SEL, id); static void (*_logos_orig$_ungrouped$SBIconController$setIsEditing$)(SBIconController*, SEL, BOOL); static void _logos_method$_ungrouped$SBIconController$setIsEditing$(SBIconController*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBIconController$_prepareToResetRootIconLists)(SBIconController*, SEL); static void _logos_method$_ungrouped$SBIconController$_prepareToResetRootIconLists(SBIconController*, SEL); static BOOL _logos_method$_ungrouped$SBIconController$ibkIsInSwitcher(SBIconController*, SEL); static void _logos_method$_ungrouped$SBIconController$removeIdentifierFromWidgets$(SBIconController*, SEL, NSString*); static void _logos_method$_ungrouped$SBIconController$removeAllCachedIcons(SBIconController*, SEL); static void (*_logos_orig$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOff)(SBLockScreenViewController*, SEL); static void _logos_method$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOff(SBLockScreenViewController*, SEL); static UIScrollView* (*_logos_orig$_ungrouped$SBIconScrollView$initWithFrame$)(SBIconScrollView*, SEL, CGRect); static UIScrollView* _logos_method$_ungrouped$SBIconScrollView$initWithFrame$(SBIconScrollView*, SEL, CGRect); static BOOL _logos_method$_ungrouped$SBIconScrollView$gestureRecognizer$shouldRequireFailureOfGestureRecognizer$(SBIconScrollView*, SEL, UIGestureRecognizer*, UIGestureRecognizer*); static void _logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$(SBIconScrollView*, SEL, UIPinchGestureRecognizer*); static SBIconListView * _logos_method$_ungrouped$SBIconScrollView$IBKListViewForIdentifierTwo$(SBIconScrollView*, SEL, NSString*); static void (*_logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$)(SBIconBadgeView*, SEL, SBIcon*, int, BOOL); static void _logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(SBIconBadgeView*, SEL, SBIcon*, int, BOOL); static struct CGPoint (*_logos_orig$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$)(SBIconBadgeView*, SEL, CGRect); static struct CGPoint _logos_method$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$(SBIconBadgeView*, SEL, CGRect); static id (*_logos_orig$_ungrouped$BBServer$init)(BBServer*, SEL); static id _logos_method$_ungrouped$BBServer$init(BBServer*, SEL); static void (*_logos_orig$_ungrouped$BBServer$_addBulletin$)(BBServer*, SEL, BBBulletin*); static void _logos_method$_ungrouped$BBServer$_addBulletin$(BBServer*, SEL, BBBulletin*); static void (*_logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$)(BBServer*, SEL, id, BOOL, BOOL); static void _logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(BBServer*, SEL, id, BOOL, BOOL); static id _logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer(Class, SEL); static void (*_logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged)(SBMediaController*, SEL); static void _logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged(SBMediaController*, SEL); static void (*_logos_orig$_ungrouped$SBMediaController$setNowPlayingInfo$)(SBMediaController*, SEL, id); static void _logos_method$_ungrouped$SBMediaController$setNowPlayingInfo$(SBMediaController*, SEL, id); 

#line 94 "/Users/Matt/iOS/Projects/Curago/Git/curago/curago.xm"


static _Bool _logos_method$_ungrouped$SBIconListView$isFull(SBIconListView* self, SEL _cmd) {
    int count = 1;
    
    for (SBIcon *icon in [self icons]) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
            count += 3;
        }
        
        count++;
    }
    
    return (count >= [objc_getClass("SBIconListView") maxIcons]);
}

static void _logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(SBIconListView* self, SEL _cmd, int arg1) {
    currentOrientation = arg1;
    isRotating = YES;
    
    _logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBIconListView$cleanupAfterRotation(SBIconListView* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBIconListView$cleanupAfterRotation(self, _cmd);
    
    
    
    isRotating = NO;
    
    if (currentOrientation == 1 || currentOrientation == 2) {
        [cachedIndexes removeAllObjects];
    } else if (currentOrientation == 3 || currentOrientation == 4) {
        [cachedIndexesLandscape removeAllObjects];
    }
    
    [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.0 domino:NO forceRelayout:YES];
}



static unsigned int _logos_method$_ungrouped$SBIconListView$rowAtPoint$(SBIconListView* self, SEL _cmd, struct CGPoint arg1) {
    unsigned int orig = _logos_orig$_ungrouped$SBIconListView$rowAtPoint$(self, _cmd, arg1);
    NSLog(@"*** [Curago] :: designating row %d for point %@", orig, NSStringFromCGPoint(arg1));

    return orig;
}

static unsigned int _logos_method$_ungrouped$SBIconListView$columnAtPoint$(SBIconListView* self, SEL _cmd, struct CGPoint arg1) {
    unsigned int column = _logos_orig$_ungrouped$SBIconListView$columnAtPoint$(self, _cmd, arg1);
    NSLog(@"*** [Curago] :: designating column %d for point %@", column, NSStringFromCGPoint(arg1));
    
    return column;
}

static unsigned int _logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(SBIconListView* self, SEL _cmd, struct SBIconCoordinate arg1, int arg2) {
    unsigned int orig = _logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(self, _cmd, arg1, arg2);
    NSLog(@"Old index == %u", orig);
    
    
    
    
    
    
    unsigned int i = 0;
    
    for (NSString *bundleIdentifier in [IBKResources widgetBundleIdentifiers]) {
        if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
            
            int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
            SBIconCoordinate widget = [self iconCoordinateForIndex:a forOrientation:arg2];
            
            
        
            
            if ((widget.col+1) == arg1.col && widget.row == arg1.row) {
                NSLog(@"INVALID LOCATION");
                return -1;
            } else {
                if (widget.row < arg1.row)
                    i++;
                else if ((widget.col+1) < arg1.col && widget.row == arg1.row)
                    i++;
            }
            
            
            if (widget.col == arg1.col && (widget.row+1) == arg1.row) {
                NSLog(@"INVALID LOCATION");
                return -1;
            } else {
                if ((widget.row+1) < arg1.row)
                    i++;
                else if (widget.col < arg1.col && (widget.row+1) == arg1.row)
                    i++;
            }
            
            
            if ((widget.col+1) == arg1.col && (widget.row+1) == arg1.row) {
                NSLog(@"INVALID LOCATION");
                return -1;
            } else {
                if ((widget.row+1) < arg1.row)
                    i++;
                else if ((widget.col+1) < arg1.col && (widget.row+1) == arg1.row)
                    i++;
            }
            
        }
    }
    
    orig -= i;
    
    
    NSLog(@"Final index == %u", orig);
    
    return orig;
}



static struct SBIconCoordinate _logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(SBIconListView* self, SEL _cmd, unsigned int arg1, int arg2) {
    SBIconCoordinate orig = _logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(self, _cmd, arg1, arg2);
    
    if (![[self class] isEqual:[objc_getClass("SBDockIconListView") class]] && ![[self class] isEqual:[objc_getClass("SBFolderIconListView") class]]) {
        
        orig = [self coordinateForIconWithIndex:arg1 andOriginalCoordinate:orig forOrientation:arg2];
        
        
    }
    
    return orig;
}



static SBIconCoordinate _logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$forOrientation$(SBIconListView* self, SEL _cmd, unsigned int index, SBIconCoordinate orig, int orientation) {
   
    
    
















    
    if (!cachedIndexes)
        cachedIndexes = [NSMutableDictionary dictionary];
    if (!cachedIndexesLandscape)
        cachedIndexesLandscape = [NSMutableDictionary dictionary];
    
    SBApplicationIcon *icon = [[self model] iconAtIndex:index];
    NSString *bundleIdentifier = [icon leafIdentifier];
    
    if (!bundleIdentifier) {
        
        bundleIdentifier = [(SBFolderIcon*)icon nodeDescriptionWithPrefix:@"IBK"];
    }
        
    NSIndexPath *path;
    
    if (orientation == 1 || orientation == 2)
        path = [cachedIndexes objectForKey:bundleIdentifier];
    else if (orientation == 3 || orientation == 4)
        path = [cachedIndexesLandscape objectForKey:bundleIdentifier];
        
    if (path && !rearrangingIcons) {
        
        
        orig.row = (NSInteger)path.row;
        orig.col = (NSInteger)path.section;
        
        return orig;
    }
    
    NSLog(@"Getting icon co-ordinates");
    
    if (!movedIndexPaths) {
        
        movedIndexPaths = [NSMutableSet set];
    }
    
    BOOL invalid = YES;
    
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:bundleIdentifier]) {
        
        
        
        while (invalid) {
            
            
            
            NSIndexPath *testpath = [NSIndexPath indexPathForRow:orig.row inSection:orig.col];
            
            if (![movedIndexPaths containsObject:testpath]) {
                
                invalid = NO;
            } else {
                
                
                orig.col += 1;
                if (orig.col > [objc_getClass("SBIconListView") iconColumnsForInterfaceOrientation:currentOrientation]) {
                    orig.row += 1;
                    orig.col = 1;
                }
            }
        }
        
        NSUInteger widgetRow = orig.row;
        NSUInteger widgetCol = orig.col;
        
        
        NSIndexPath *path2 = [NSIndexPath indexPathForRow:widgetRow inSection:widgetCol+1];
        NSIndexPath *path3 = [NSIndexPath indexPathForRow:widgetRow+1 inSection:widgetCol];
        NSIndexPath *path4 = [NSIndexPath indexPathForRow:widgetRow+1 inSection:widgetCol+1];
        
        
        
        
        [movedIndexPaths addObject:path2];
        [movedIndexPaths addObject:path3];
        [movedIndexPaths addObject:path4];
    }
    
    while (invalid) {
        
        
        
        NSIndexPath *testpath = [NSIndexPath indexPathForRow:orig.row inSection:orig.col];
        
        if (![movedIndexPaths containsObject:testpath]) {
            
            invalid = NO;
        } else {
            
            
            orig.col += 1;
            if (orig.col > [objc_getClass("SBIconListView") iconColumnsForInterfaceOrientation:currentOrientation]) {
                
                
                orig.row += 1;
                orig.col = 1;
            }
        }
    }
    
    
    NSIndexPath *pathz = [NSIndexPath indexPathForRow:orig.row inSection:orig.col];
    [movedIndexPaths addObject:pathz];
    
    
    if (![[objc_getClass("SBIconController") sharedInstance] isEditing]) {
       
        if (orientation == 1 || orientation == 2)
            [cachedIndexes setObject:pathz forKey:bundleIdentifier];
        else if (orientation == 3 || orientation == 4)
            [cachedIndexesLandscape setObject:pathz forKey:bundleIdentifier];
    }
    
    
    if (index == [(NSArray*)[self icons] count]-1) {
        NSLog(@"Killing array");
        [movedIndexPaths removeAllObjects];
    }
    
    return orig;
}



static SBIcon* _logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$(SBIconListView* self, SEL _cmd, SBIcon* icon) {
    
    
    int index = 0;
    
    if ([[self icons] containsObject:icon]) {
        NSLog(@"We have the icon, and it's index is %lu", (unsigned long)[[self icons] indexOfObject:icon]);
        index = (int)[[self icons] indexOfObject:icon];
    } else {
        NSLog(@"Wtf. the icon is %@", icon);
    }
    
    NSLog(@"Old index == %d", index);
    
    int i = 0;
    int columns = [objc_getClass("SBIconListView") iconColumnsForInterfaceOrientation:currentOrientation];
     
     for (NSString *bundleIdentifier in [IBKResources widgetBundleIdentifiers]) {
     
         if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
             
             
             int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
             if (a < index)
                 i++;
             if (a+1 < index)
                 i++;
             
             int b = a + columns;
             if (b < index)
                 i++;
             if (b+1 < index)
                 i++;
         }
     }
     
    index -= (i == 0 ? 0 : i-1);
    
    NSLog(@"New index == %d", index);
     
    return [(SBIconListModel*)[self model] iconAtIndex:index];
    
    
    
    
    
}



#pragma mark App switcher detection

BOOL inSwitcher = NO;



static void _logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$(SBAppSliderController* self, SEL _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$(self, _cmd, arg1);
    inSwitcher = NO;
}
static void _logos_method$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$(SBAppSliderController* self, SEL _cmd, id arg1, id arg2, int arg3, id arg4) {
    inSwitcher = YES;
    _logos_orig$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$(self, _cmd, arg1, arg2, arg3, arg4);
}







static void _logos_method$_ungrouped$SBAppSwitcherController$switcherWasDismissed$(SBAppSwitcherController* self, SEL _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBAppSwitcherController$switcherWasDismissed$(self, _cmd, arg1);
    inSwitcher = NO;
}

static void _logos_method$_ungrouped$SBAppSwitcherController$animatePresentationFromDisplayLayout$withViews$withCompletion$(SBAppSwitcherController* self, SEL _cmd, id arg1, id arg2, id arg3) {
    inSwitcher = YES;
    _logos_orig$_ungrouped$SBAppSwitcherController$animatePresentationFromDisplayLayout$withViews$withCompletion$(self, _cmd, arg1, arg2, arg3);
}



#import <SpringBoard7.0/SBApplication.h>

BOOL sup;
BOOL launchingWidget;



static void _logos_method$_ungrouped$SBApplication$willAnimateDeactivation$(SBApplication* self, SEL _cmd, _Bool arg1) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 0.0;
    
    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 1.0;
    }];
    
    sup = YES;
    
    _logos_orig$_ungrouped$SBApplication$willAnimateDeactivation$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBApplication$didAnimateDeactivation(SBApplication* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBApplication$didAnimateDeactivation(self, _cmd);
    
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    [(UIImageView*)[widgetController.correspondingIconView _iconImageView] setAlpha:0.0];
    
    sup = NO;
}

static void _logos_method$_ungrouped$SBApplication$willActivateWithTransactionID$(SBApplication* self, SEL _cmd, unsigned long long arg1) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    
    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.25] animations:^{
        widgetController.view.alpha = 0.0;
    }];
    
    sup = YES;
    
    _logos_orig$_ungrouped$SBApplication$willActivateWithTransactionID$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$SBApplication$didActivateWithTransactionID$(SBApplication* self, SEL _cmd, unsigned long long arg1) {
    _logos_orig$_ungrouped$SBApplication$didActivateWithTransactionID$(self, _cmd, arg1);
    
    sup = NO;
    
    [self performSelector:@selector(finishedAnimatingActivationFully) withObject:nil afterDelay:1.0];
}



static void _logos_method$_ungrouped$SBApplication$didAnimateActivation(SBApplication* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBApplication$didAnimateActivation(self, _cmd);
    
    sup = NO;
    
    [self performSelector:@selector(finishedAnimatingActivationFully) withObject:nil afterDelay:1.0];
}

static void _logos_method$_ungrouped$SBApplication$willAnimateActivation(SBApplication* self, SEL _cmd) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    
    [UIView animateWithDuration:[IBKResources adjustedAnimationSpeed:0.3] animations:^{
        widgetController.view.alpha = 0.0;
    }];
    
    sup = YES;
    
    _logos_orig$_ungrouped$SBApplication$willAnimateActivation(self, _cmd);
}



static void _logos_method$_ungrouped$SBApplication$finishedAnimatingActivationFully(SBApplication* self, SEL _cmd) {
    IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self bundleIdentifier]];
    widgetController.view.alpha = 1.0;
}





static id _logos_method$_ungrouped$SBIconViewMap$mappedIconViewForIcon$(SBIconViewMap* self, SEL _cmd, id arg1) {
    id orig = _logos_orig$_ungrouped$SBIconViewMap$mappedIconViewForIcon$(self, _cmd, arg1);
    
    if ([[orig class] isEqual:[objc_getClass("IBKIconView") class]]) {
        if (!isRotating)
            [(IBKIconView*)orig addPreExpandedWidgetIfNeeded:arg1];
    }
    
    return orig;
}



#pragma mark Injection into icon views




static id _logos_method$_ungrouped$SBIconView$initWithDefaultSize(SBIconView* self, SEL _cmd) {
    SBIconView *original = _logos_orig$_ungrouped$SBIconView$initWithDefaultSize(self, _cmd);
    if (![[original class] isEqual:[objc_getClass("IBKIconView") class]] && ![[original class] isEqual:[objc_getClass("SBFolderIconView") class]])
        object_setClass(original, objc_getClass("IBKIconView"));
    return original;
}



CGSize defaultIconSizing;

#import <SpringBoard8.1/SBIconImageCrossfadeView.h>









static CGRect _logos_method$_ungrouped$SBIconImageView$visibleBounds(SBIconImageView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = _logos_orig$_ungrouped$SBIconImageView$visibleBounds(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
        
        return frame;
    }
    
    return _logos_orig$_ungrouped$SBIconImageView$visibleBounds(self, _cmd);
}

static CGRect _logos_method$_ungrouped$SBIconImageView$frame(SBIconImageView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = _logos_orig$_ungrouped$SBIconImageView$frame(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
        
        return frame;
    }
    
    return _logos_orig$_ungrouped$SBIconImageView$frame(self, _cmd);
}

static CGRect _logos_method$_ungrouped$SBIconImageView$bounds(SBIconImageView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && sup) {
        CGRect frame = _logos_orig$_ungrouped$SBIconImageView$bounds(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
        
        return frame;
    }
    
    return _logos_orig$_ungrouped$SBIconImageView$bounds(self, _cmd);
}





static CGPoint _logos_method$_ungrouped$IBKIconView$iconImageCenter(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGPoint point = _logos_orig$_ungrouped$IBKIconView$iconImageCenter(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        point = CGPointMake(widgetController.view.frame.size.width/2, widgetController.view.frame.size.height/2);
        
        return point;
    }
    
    return _logos_orig$_ungrouped$IBKIconView$iconImageCenter(self, _cmd);
}

static CGRect _logos_method$_ungrouped$IBKIconView$iconImageFrame(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        CGRect frame = _logos_orig$_ungrouped$IBKIconView$iconImageFrame(self, _cmd);
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height);
        
        return frame;
    }
    
    return _logos_orig$_ungrouped$IBKIconView$iconImageFrame(self, _cmd);
}

static void _logos_method$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$(IBKIconView* self, SEL _cmd, id arg1, _Bool arg2, _Bool arg3, struct CGPoint arg4) {
    _logos_orig$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$(self, _cmd, arg1, arg2, arg3, arg4);
}

static id _logos_method$_ungrouped$IBKIconView$iconImageSnapshot(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        UIView *view = widgetController.view;
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
        UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
        UIGraphicsEndImageContext();
    
        return img;
    } else {
        return _logos_orig$_ungrouped$IBKIconView$iconImageSnapshot(self, _cmd);
    }
}

static CGRect _logos_method$_ungrouped$IBKIconView$frame(IBKIconView* self, SEL _cmd) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher && !animatingIn && iWidgets) {
        CGRect frame = _logos_orig$_ungrouped$IBKIconView$frame(self, _cmd);
        defaultIconSizing = frame.size;
        IBKWidgetViewController *widgetController = [widgetViewControllers objectForKey:[self.icon applicationBundleID]];
        frame.size = CGSizeMake(widgetController.view.frame.size.width, widgetController.view.frame.size.height + [self _frameForLabel].size.height);
        
        return frame;
    }
    
    return _logos_orig$_ungrouped$IBKIconView$frame(self, _cmd);
}

static void _logos_method$_ungrouped$IBKIconView$_setIcon$animated$(IBKIconView* self, SEL _cmd, id arg1, BOOL arg2) { 
    _logos_orig$_ungrouped$IBKIconView$_setIcon$animated$(self, _cmd, arg1, arg2);
    
    [self addPreExpandedWidgetIfNeeded:arg1];
}

static struct CGRect _logos_method$_ungrouped$IBKIconView$_frameForLabel(IBKIconView* self, SEL _cmd) {
    CGRect orig = _logos_orig$_ungrouped$IBKIconView$_frameForLabel(self, _cmd);
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        orig.origin = CGPointMake(8, [IBKResources heightForWidget] + 2);
    }
    
    return orig;
}

static void _logos_method$_ungrouped$IBKIconView$prepareForRecycling(IBKIconView* self, SEL _cmd) {
    _logos_orig$_ungrouped$IBKIconView$prepareForRecycling(self, _cmd);
    
    IBKWidgetViewController *cont = [objc_getClass("IBKIconView") getWidgetViewControllerForIcon:self.icon orBundleID:nil];
    [cont unloadWidgetInterface];
    
    NSLog(@"**** [Curago] :: recycling view");
    
    if ([self.icon applicationBundleID])
        [widgetViewControllers removeObjectForKey:[self.icon applicationBundleID]];
}



static BOOL _logos_method$_ungrouped$IBKIconView$pointInside$withEvent$(IBKIconView* self, SEL _cmd, struct CGPoint arg1, UIEvent* arg2) {
    BOOL orig = _logos_orig$_ungrouped$IBKIconView$pointInside$withEvent$(self, _cmd, arg1, arg2);
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        
        orig = [[[widgetViewControllers objectForKey:[self.icon applicationBundleID]] view] pointInside:arg1 withEvent:arg2];
    }
    
    
    
    
    return orig;
}



static IBKWidgetViewController* _logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$(Class self, SEL _cmd, SBIcon* arg1, NSString* arg2) {
    NSString *bundleIdentifier;
    if (arg1)
        bundleIdentifier = [arg1 applicationBundleID];
    else
        bundleIdentifier = arg2;
        
    return [widgetViewControllers objectForKey:bundleIdentifier];
}



static void _logos_method$_ungrouped$IBKIconView$addPreExpandedWidgetIfNeeded$(IBKIconView* self, SEL _cmd, id arg1) {
    SBApplicationIcon *icon = (SBApplicationIcon*)arg1;
    
    if (!icon) {
        icon = (SBApplicationIcon*)self.icon;
    }
    
    if (!inSwitcher) {
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
            
            
            IBKWidgetViewController *widgetController;
            if (![widgetViewControllers objectForKey:[icon applicationBundleID]]) {
                widgetController = [[IBKWidgetViewController alloc] init];
                widgetController.applicationIdentifer = [icon applicationBundleID];
                [widgetController layoutViewForPreExpandedWidget]; 
            } else {
                widgetController = [widgetViewControllers objectForKey:[icon applicationBundleID]];
            }
            
            
            [self addSubview:widgetController.view];
            
            if (!widgetViewControllers)
                widgetViewControllers = [NSMutableDictionary dictionary];
                
                if ([icon applicationBundleID] && ![widgetViewControllers objectForKey:[icon applicationBundleID]])
                    [widgetViewControllers setObject:widgetController forKey:[icon applicationBundleID]]; 
            
            
            [(UIImageView*)[self _iconImageView] setAlpha:0.0];
            widgetController.correspondingIconView = self;
            
            widgetController.view.layer.shadowOpacity = 0.0;
            widgetController.shimIcon.alpha = 0.0;
            widgetController.shimIcon.hidden = YES;
        }
        
        
        
    }

}





#pragma mark Handle de-caching indexes when in editing mode, and switcher detection



static void _logos_method$_ungrouped$SBIconController$setIsEditing$(SBIconController* self, SEL _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBIconController$setIsEditing$(self, _cmd, arg1);
    
    if (arg1) {
        
            [cachedIndexes removeAllObjects];
        
            [cachedIndexesLandscape removeAllObjects];
    }
    
    rearrangingIcons = arg1;
}

static void _logos_method$_ungrouped$SBIconController$_prepareToResetRootIconLists(SBIconController* self, SEL _cmd) {
    if (dontKillIcons) {
        dontKillIcons = NO;
    } else {
        _logos_orig$_ungrouped$SBIconController$_prepareToResetRootIconLists(self, _cmd);
    }
}



static BOOL _logos_method$_ungrouped$SBIconController$ibkIsInSwitcher(SBIconController* self, SEL _cmd) {
    return inSwitcher;
}



static void _logos_method$_ungrouped$SBIconController$removeIdentifierFromWidgets$(SBIconController* self, SEL _cmd, NSString* identifier) {
    [widgetViewControllers removeObjectForKey:identifier];
}



static void _logos_method$_ungrouped$SBIconController$removeAllCachedIcons(SBIconController* self, SEL _cmd) {
    if (currentOrientation == 1 || currentOrientation == 2)
        [cachedIndexes removeAllObjects];
    else if (currentOrientation == 3 || currentOrientation == 4)
        [cachedIndexesLandscape removeAllObjects];
}



#pragma mark Handle pinching of icons

IBKWidgetViewController *widget;
SBIcon *widgetIcon;



@interface SBIconScrollView (Additions2)
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch;
@end

@interface SBIconScrollView (Additions)
-(SBIconListView *)IBKListViewForIdentifierTwo:(NSString*)identifier;
@end



static void _logos_method$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOff(SBLockScreenViewController* self, SEL _cmd) {
    dontKillIcons = YES;
    
    _logos_orig$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOff(self, _cmd);
}



UIPinchGestureRecognizer *pinch;



static UIScrollView* _logos_method$_ungrouped$SBIconScrollView$initWithFrame$(SBIconScrollView* self, SEL _cmd, CGRect frame) {
    UIScrollView *orig = _logos_orig$_ungrouped$SBIconScrollView$initWithFrame$(self, _cmd, frame);
    
    NSLog(@"*** [Curago] :: Adding pinch gesture onto SBIconScrollView");

    pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [(UIView*)orig addGestureRecognizer:pinch];
    
    for (UIGestureRecognizer *arg in [self gestureRecognizers]) {
        if ([[arg class] isEqual:[objc_getClass("UIScrollViewPanGestureRecognizer") class]]) {
            arg.delegate = self;
        }
    }
    
    return orig;
}



static BOOL _logos_method$_ungrouped$SBIconScrollView$gestureRecognizer$shouldRequireFailureOfGestureRecognizer$(SBIconScrollView* self, SEL _cmd, UIGestureRecognizer* gestureRecognizer, UIGestureRecognizer* recTwo) {
    if ([recTwo isEqual:pinch] && gestureRecognizer.numberOfTouches > 1) {
        return YES;
    } else {
        return NO;
    }
}



int scale = 0;
NSInteger page = 0;
static void _logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$(SBIconScrollView* self, SEL _cmd, UIPinchGestureRecognizer* pinch) {
    
    if ([[objc_getClass("SBIconController") sharedInstance] hasOpenFolder]) return;
    
    if (pinch.state == UIGestureRecognizerStateBegan) {
         NSLog(@"Pinching began");
        
        
        
        CGFloat width = self.frame.size.width;
        page = (self.contentOffset.x + (0.5f * width)) / width;
        CGPoint rawMidpoint = [pinch locationInView:(UIView*)self];
        CGPoint finalMidpoint = CGPointMake(rawMidpoint.x - (page * width), rawMidpoint.y);
        NSLog(@"*** final midpoint == %@", NSStringFromCGPoint(finalMidpoint));
        
        
        SBIconListView *listView;
        [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:[NSIndexPath indexPathForRow:1 inSection:page] createIfNecessary:NO];
        
        
        unsigned int index;
        widgetIcon = [listView iconAtPoint:finalMidpoint index:&index];
        NSLog(@"Widget icon == %@", widgetIcon);
        
        
        
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) {
            widget = nil;
            return;
        }
        
        
        if ([widgetViewControllers objectForKey:[widgetIcon applicationBundleID]]) {
            widget = nil;
            return;
        }
        
        
        widget = [[IBKWidgetViewController alloc] init];
        widget.applicationIdentifer = [widgetIcon applicationBundleID];
        
        if (!widgetViewControllers)
            widgetViewControllers = [NSMutableDictionary dictionary];
            
        if ([widgetIcon applicationBundleID])
            [widgetViewControllers setObject:widget forKey:[widgetIcon applicationBundleID]];
        
        
        IBKIconView *view = [[objc_getClass("SBIconViewMap") homescreenMap] iconViewForIcon:widgetIcon];
        [view addSubview:widget.view];
        [view.superview addSubview:view]; 
        
        widget.correspondingIconView = view;
        
        [[(SBIconView*)view _iconImageView] setAlpha:0.0];
     
        widget.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
        [widget loadWidgetInterface];
        
        widget.view.center = CGPointMake(([(UIView*)[view _iconImageView] frame].size.width/2)-1, ([(UIView*)[view _iconImageView] frame].size.height/2)-1);
        
        CGFloat widgetWidth = widget.view.bounds.size.width;
        CGFloat iconSize = (isPad ? 72 : 58);
        CGFloat scale = (iconSize/widgetWidth);
        
        widget.view.transform = CGAffineTransformMakeScale(scale, scale);
    } else if (pinch.state == UIGestureRecognizerStateChanged && widget) {
         NSLog(@"Pinching changed");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
        
        
        
        CGFloat duration = (pinch.scale/pinch.velocity);
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            duration = (pinch.scale-1)/pinch.velocity;
            
        }
        
        if (duration < 0)
            duration = -duration;
     
        scale = pinch.scale;
        
        [widget setScaleForView:pinch.scale withDuration:0.1];
    } else if (pinch.state == UIGestureRecognizerStateEnded && widget) {
         NSLog(@"Pinching ended");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
         
        
         
        
        if ((scale-1.0) > 0.75) { 
            [widget setScaleForView:8.0 withDuration:0.3];
            [IBKResources addNewIdentifier:[widgetIcon applicationBundleID]];
            
            
            if (currentOrientation == 1 || currentOrientation == 2)
                [cachedIndexes removeAllObjects];
            else if (currentOrientation == 3 || currentOrientation == 4)
                [cachedIndexesLandscape removeAllObjects];
            
            
            
            SBIconListView *lst = [self IBKListViewForIdentifierTwo:widget.applicationIdentifer];
            
            
            
            
            int count = 0;
            
            for (SBIcon *icon in [lst icons]) {
                if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]])
                    count += 3;
            }
            
            if ([lst icons].count + count > [objc_getClass("SBIconListView") maxIcons]) {
                
                
                count = ((int)[lst icons].count + count) - (int)[objc_getClass("SBIconListView") maxIcons];
                
                
                
                rearrangingIcons = YES;
                
                NSMutableArray *arr = [NSMutableArray array];
                
                for (int i = (int)[lst icons].count - 1; i > (int)[lst icons].count - 1 - count; --i) {
                    [arr addObject:[[lst icons] objectAtIndex:i]];
                }
                
                NSLog(@"Arr is %@", arr);
                
                
                
                SBIconListView *listView;
                [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:[NSIndexPath indexPathForRow:0 inSection:page + 1] createIfNecessary:YES];
                
                for (SBIcon *icon in arr) {
                    NSLog(@"Icon is %@", icon);
                    
                    [[lst model] removeIcon:icon];
                    
                    
                    [listView insertIcon:icon atIndex:0 moveNow:YES pop:YES];
                    
                    
                    
                    [listView setIconsNeedLayout];
                    [listView layoutIconsIfNeeded:0.0 domino:NO];
                    
                    
                    
                    
                }
                    
                if ([[[objc_getClass("SBIconController") sharedInstance] model] respondsToSelector:@selector(saveIconStateIfNeeded)])
                    [(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] saveIconStateIfNeeded];
                else
                    [(SBIconModel*)[[objc_getClass("SBIconController") sharedInstance] model] saveIconState];
                
                rearrangingIcons = NO;
            }
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                
                [lst setIconsNeedLayout];
                [lst layoutIconsIfNeeded:0.3 domino:NO];
            } else
                [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
            
            
            CGRect widgetViewFrame = widget.correspondingIconView.frame;
            widgetViewFrame.size = CGSizeMake([IBKResources widthForWidget], [IBKResources heightForWidget]);
            [UIView animateWithDuration:0.3 animations:^{
                widget.view.frame = CGRectMake(0, 0, [IBKResources widthForWidget], [IBKResources heightForWidget]);
                widget.view.layer.shadowOpacity = 0.0;
                
                [(SBIconImageView*)[widget.correspondingIconView _iconImageView] setFrame:widgetViewFrame];
                
                
            }];
        } else {
            CGFloat iconScale = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 72 : 58) / widget.shimIcon.frame.size.width;
            
            iconScale = 0.41;
            
            CGFloat red, green, blue;
            [widget.view.backgroundColor getRed:&red green:&green blue:&blue alpha:nil];
            
            [UIView animateWithDuration:0.25 animations:^{
                widget.view.transform = CGAffineTransformMakeScale(iconScale, iconScale);
                widget.shimIcon.alpha = 1.0;
                widget.viw.alpha = 0.0;
                widget.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.0];
            } completion:^(BOOL finished) {
                [widget unloadFromPinchGesture];
                if (widget && widget.applicationIdentifer) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
                [[(SBIconView*)widget.correspondingIconView _iconImageView] setAlpha:1.0];
            }];
        }
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
        CGFloat widgetWidth = widget.view.bounds.size.width;
        CGFloat iconSize = (isPad ? 72 : 58);
        CGFloat scale = (iconSize/widgetWidth);
        
        [UIView animateWithDuration:0.3 animations:^{
            widget.view.transform = CGAffineTransformMakeScale(scale, scale);
            widget.view.center = CGPointMake(([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.width/2)-1, ([(UIView*)[widget.correspondingIconView _iconImageView] frame].size.height/2)-1);
            widget.shimIcon.alpha = 1.0;
            
            widget.iconImageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[widget.correspondingIconView _iconImageView] setAlpha:1.0];
            widget.view.hidden = YES;
            [widget unloadFromPinchGesture];
            
            if (widget && widget.applicationIdentifer) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
        }];

    }
}



static SBIconListView * _logos_method$_ungrouped$SBIconScrollView$IBKListViewForIdentifierTwo$(SBIconScrollView* self, SEL _cmd, NSString* identifier) {
    SBIconController *viewcont = [objc_getClass("SBIconController") sharedInstance];
    SBIconModel *model = [viewcont model];
    SBIcon *icon = [model expectedIconForDisplayIdentifier:identifier];
    
    SBIconController *controller = [objc_getClass("SBIconController") sharedInstance];
    SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
    NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
    SBIconListView *listView = nil;
    [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
    return listView;
}





static SBIcon *temp;

static void _logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(SBIconBadgeView* self, SEL _cmd, SBIcon* arg1, int arg2, BOOL arg3) {
    temp = arg1;
    
    _logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(self, _cmd, arg1, arg2, arg3);
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[arg1 applicationBundleID]] && !inSwitcher) {
        
        [[self superview] addSubview:self]; 
    }
    
}

static struct CGPoint _logos_method$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$(SBIconBadgeView* self, SEL _cmd, CGRect arg1) {
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[temp applicationBundleID]] && !inSwitcher) {
        
        IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[temp applicationBundleID]];
        arg1 = contr.view.bounds;
        
        [[self superview] addSubview:self]; 
    }
    
    return _logos_orig$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$(self, _cmd, arg1);
}



#pragma mark BBServer hooks for notification tables



static id _logos_method$_ungrouped$BBServer$init(BBServer* self, SEL _cmd) {
    BBServer *orig = _logos_orig$_ungrouped$BBServer$init(self, _cmd);
    IBKBBServer = orig;
    return orig;
}

static void _logos_method$_ungrouped$BBServer$_addBulletin$(BBServer* self, SEL _cmd, BBBulletin* arg1) {
    IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[arg1 sectionID]];
    if (contr)
        [contr addBulletin:arg1];
    
    _logos_orig$_ungrouped$BBServer$_addBulletin$(self, _cmd, arg1);
}

static void _logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(BBServer* self, SEL _cmd, id arg1, BOOL arg2, BOOL arg3) {
    for (NSString *key in widgetViewControllers) {
        if ([[(IBKWidgetViewController*)[widgetViewControllers objectForKey:key] applicationIdentifer] isEqual:[arg1 sectionID]])
            [(IBKWidgetViewController*)[widgetViewControllers objectForKey:key] removeBulletin:arg1];
    }
    
    _logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(self, _cmd, arg1, arg2, arg3);
}



static id _logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer(Class self, SEL _cmd) {
    return IBKBBServer;
}





#include <MediaRemote/MediaRemote.h>

@interface MPUNowPlayingController : NSObject
@property(readonly) UIImage * currentNowPlayingArtwork;
@property(readonly) NSDictionary * currentNowPlayingInfo;

+(id)sharedMPU;
- (BOOL)isPlaying;
-(void)update;
@end

MPUNowPlayingController *sharedMPU;



static void _logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged(SBMediaController* self, SEL _cmd) {
    _logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged(self, _cmd);
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-UpdateMusic" object:nil];
}

static void _logos_method$_ungrouped$SBMediaController$setNowPlayingInfo$(SBMediaController* self, SEL _cmd, id arg1) {
    _logos_orig$_ungrouped$SBMediaController$setNowPlayingInfo$(self, _cmd, arg1);
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-UpdateMusic" object:nil];
}



static id _logos_method$iOS8$SBIconImageView$alternateIconView(SBIconImageView*, SEL); static id (*_logos_orig$iOS8$MPUNowPlayingController$init)(MPUNowPlayingController*, SEL); static id _logos_method$iOS8$MPUNowPlayingController$init(MPUNowPlayingController*, SEL); static id _logos_meta_method$iOS8$MPUNowPlayingController$ibksharedMPU(Class, SEL); static BOOL (*_logos_orig$iOS8$SBMediaController$isPlaying)(SBMediaController*, SEL); static BOOL _logos_method$iOS8$SBMediaController$isPlaying(SBMediaController*, SEL); static NSString* _logos_method$iOS8$SBMediaController$ibkNowPlayingArtist(SBMediaController*, SEL); static NSString* _logos_method$iOS8$SBMediaController$ibkNowPlayingAlbum(SBMediaController*, SEL); static NSString* _logos_method$iOS8$SBMediaController$ibkNowPlayingTitle(SBMediaController*, SEL); static UIImage* _logos_method$iOS8$SBMediaController$ibkArtwork(SBMediaController*, SEL); static BOOL _logos_method$iOS8$SBMediaController$ibkTrackSupports15SecondFF(SBMediaController*, SEL); static BOOL _logos_method$iOS8$SBMediaController$ibkTrackSupports15SecondRewind(SBMediaController*, SEL); 




static id _logos_method$iOS8$SBIconImageView$alternateIconView(SBIconImageView* self, SEL _cmd) {
    return nil; 
}





static id _logos_method$iOS8$MPUNowPlayingController$init(MPUNowPlayingController* self, SEL _cmd) {
    sharedMPU = _logos_orig$iOS8$MPUNowPlayingController$init(self, _cmd);
    
    return sharedMPU;
}



static id _logos_meta_method$iOS8$MPUNowPlayingController$ibksharedMPU(Class self, SEL _cmd) {
    return sharedMPU;
}





static BOOL _logos_method$iOS8$SBMediaController$isPlaying(SBMediaController* self, SEL _cmd) {
    return [sharedMPU isPlaying];
}



static NSString* _logos_method$iOS8$SBMediaController$ibkNowPlayingArtist(SBMediaController* self, SEL _cmd) {
    NSDictionary *dict = sharedMPU.currentNowPlayingInfo;
    return [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist];
}



static NSString* _logos_method$iOS8$SBMediaController$ibkNowPlayingAlbum(SBMediaController* self, SEL _cmd) {
    NSDictionary *dict = sharedMPU.currentNowPlayingInfo;
    return [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoAlbum];
}



static NSString* _logos_method$iOS8$SBMediaController$ibkNowPlayingTitle(SBMediaController* self, SEL _cmd) {
    NSDictionary *dict = sharedMPU.currentNowPlayingInfo;
    return [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle];
}



static UIImage* _logos_method$iOS8$SBMediaController$ibkArtwork(SBMediaController* self, SEL _cmd) {
    NSDictionary *dict = sharedMPU.currentNowPlayingInfo;
    NSData *data = [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData];
    return [UIImage imageWithData:data];
}



static BOOL _logos_method$iOS8$SBMediaController$ibkTrackSupports15SecondFF(SBMediaController* self, SEL _cmd) {
    NSDictionary *dict = sharedMPU.currentNowPlayingInfo;
    return [[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoSupportsFastForward15Seconds] boolValue];
}



static BOOL _logos_method$iOS8$SBMediaController$ibkTrackSupports15SecondRewind(SBMediaController* self, SEL _cmd) {
    NSDictionary *dict = sharedMPU.currentNowPlayingInfo;
    return [[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoSupportsRewind15Seconds] boolValue];
}





static _Bool (*_logos_orig$iWidgets$IWWidgetsView$pointInside$withEvent$)(IWWidgetsView*, SEL, struct CGPoint, id); static _Bool _logos_method$iWidgets$IWWidgetsView$pointInside$withEvent$(IWWidgetsView*, SEL, struct CGPoint, id); 



static _Bool _logos_method$iWidgets$IWWidgetsView$pointInside$withEvent$(IWWidgetsView* self, SEL _cmd, struct CGPoint arg1, id arg2) {
    iWidgets = YES;
    BOOL original = _logos_orig$iWidgets$IWWidgetsView$pointInside$withEvent$(self, _cmd, arg1, arg2);
    iWidgets = NO;
    
    return original;
}







#pragma mark Constructor and anti-piracy code

@interface ISIconSupport : NSObject
+(instancetype)sharedInstance;
-(void)addExtension:(NSString*)arg1;
@end

static __attribute__((constructor)) void _logosLocalCtor_e3a4cad1() {
    
    
    Class $IBKIconView = objc_allocateClassPair(objc_getClass("SBIconView"), "IBKIconView", 0);
    
    
    objc_registerClassPair($IBKIconView);
    
    
    {Class _logos_class$_ungrouped$SBIconListView = objc_getClass("SBIconListView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(isFull), (IMP)&_logos_method$_ungrouped$SBIconListView$isFull, (IMP*)&_logos_orig$_ungrouped$SBIconListView$isFull);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(prepareToRotateToInterfaceOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(cleanupAfterRotation), (IMP)&_logos_method$_ungrouped$SBIconListView$cleanupAfterRotation, (IMP*)&_logos_orig$_ungrouped$SBIconListView$cleanupAfterRotation);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(rowAtPoint:), (IMP)&_logos_method$_ungrouped$SBIconListView$rowAtPoint$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$rowAtPoint$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(columnAtPoint:), (IMP)&_logos_method$_ungrouped$SBIconListView$columnAtPoint$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$columnAtPoint$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(indexForCoordinate:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(iconCoordinateForIndex:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIconCoordinate), strlen(@encode(SBIconCoordinate))); i += strlen(@encode(SBIconCoordinate)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = 'I'; i += 1; memcpy(_typeEncoding + i, @encode(SBIconCoordinate), strlen(@encode(SBIconCoordinate))); i += strlen(@encode(SBIconCoordinate)); _typeEncoding[i] = 'i'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconListView, @selector(coordinateForIconWithIndex:andOriginalCoordinate:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$forOrientation$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconListView, @selector(modifiedIconForIcon:), (IMP)&_logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$, _typeEncoding); }Class _logos_class$_ungrouped$SBAppSliderController = objc_getClass("SBAppSliderController"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSliderController, @selector(switcherWasDismissed:), (IMP)&_logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$, (IMP*)&_logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$);MSHookMessageEx(_logos_class$_ungrouped$SBAppSliderController, @selector(animatePresentationFromDisplayIdentifier:withViews:fromSide:withCompletion:), (IMP)&_logos_method$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$, (IMP*)&_logos_orig$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$);Class _logos_class$_ungrouped$SBAppSwitcherController = objc_getClass("SBAppSwitcherController"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSwitcherController, @selector(switcherWasDismissed:), (IMP)&_logos_method$_ungrouped$SBAppSwitcherController$switcherWasDismissed$, (IMP*)&_logos_orig$_ungrouped$SBAppSwitcherController$switcherWasDismissed$);MSHookMessageEx(_logos_class$_ungrouped$SBAppSwitcherController, @selector(animatePresentationFromDisplayLayout:withViews:withCompletion:), (IMP)&_logos_method$_ungrouped$SBAppSwitcherController$animatePresentationFromDisplayLayout$withViews$withCompletion$, (IMP*)&_logos_orig$_ungrouped$SBAppSwitcherController$animatePresentationFromDisplayLayout$withViews$withCompletion$);Class _logos_class$_ungrouped$SBApplication = objc_getClass("SBApplication"); MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(willAnimateDeactivation:), (IMP)&_logos_method$_ungrouped$SBApplication$willAnimateDeactivation$, (IMP*)&_logos_orig$_ungrouped$SBApplication$willAnimateDeactivation$);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(didAnimateDeactivation), (IMP)&_logos_method$_ungrouped$SBApplication$didAnimateDeactivation, (IMP*)&_logos_orig$_ungrouped$SBApplication$didAnimateDeactivation);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(willActivateWithTransactionID:), (IMP)&_logos_method$_ungrouped$SBApplication$willActivateWithTransactionID$, (IMP*)&_logos_orig$_ungrouped$SBApplication$willActivateWithTransactionID$);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(didActivateWithTransactionID:), (IMP)&_logos_method$_ungrouped$SBApplication$didActivateWithTransactionID$, (IMP*)&_logos_orig$_ungrouped$SBApplication$didActivateWithTransactionID$);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(didAnimateActivation), (IMP)&_logos_method$_ungrouped$SBApplication$didAnimateActivation, (IMP*)&_logos_orig$_ungrouped$SBApplication$didAnimateActivation);MSHookMessageEx(_logos_class$_ungrouped$SBApplication, @selector(willAnimateActivation), (IMP)&_logos_method$_ungrouped$SBApplication$willAnimateActivation, (IMP*)&_logos_orig$_ungrouped$SBApplication$willAnimateActivation);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBApplication, @selector(finishedAnimatingActivationFully), (IMP)&_logos_method$_ungrouped$SBApplication$finishedAnimatingActivationFully, _typeEncoding); }Class _logos_class$_ungrouped$SBIconViewMap = objc_getClass("SBIconViewMap"); MSHookMessageEx(_logos_class$_ungrouped$SBIconViewMap, @selector(mappedIconViewForIcon:), (IMP)&_logos_method$_ungrouped$SBIconViewMap$mappedIconViewForIcon$, (IMP*)&_logos_orig$_ungrouped$SBIconViewMap$mappedIconViewForIcon$);Class _logos_class$_ungrouped$SBIconView = objc_getClass("SBIconView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconView, @selector(initWithDefaultSize), (IMP)&_logos_method$_ungrouped$SBIconView$initWithDefaultSize, (IMP*)&_logos_orig$_ungrouped$SBIconView$initWithDefaultSize);Class _logos_class$_ungrouped$SBIconImageView = objc_getClass("SBIconImageView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconImageView, @selector(visibleBounds), (IMP)&_logos_method$_ungrouped$SBIconImageView$visibleBounds, (IMP*)&_logos_orig$_ungrouped$SBIconImageView$visibleBounds);MSHookMessageEx(_logos_class$_ungrouped$SBIconImageView, @selector(frame), (IMP)&_logos_method$_ungrouped$SBIconImageView$frame, (IMP*)&_logos_orig$_ungrouped$SBIconImageView$frame);MSHookMessageEx(_logos_class$_ungrouped$SBIconImageView, @selector(bounds), (IMP)&_logos_method$_ungrouped$SBIconImageView$bounds, (IMP*)&_logos_orig$_ungrouped$SBIconImageView$bounds);Class _logos_class$_ungrouped$IBKIconView = objc_getClass("IBKIconView"); Class _logos_metaclass$_ungrouped$IBKIconView = object_getClass(_logos_class$_ungrouped$IBKIconView); MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(iconImageCenter), (IMP)&_logos_method$_ungrouped$IBKIconView$iconImageCenter, (IMP*)&_logos_orig$_ungrouped$IBKIconView$iconImageCenter);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(iconImageFrame), (IMP)&_logos_method$_ungrouped$IBKIconView$iconImageFrame, (IMP*)&_logos_orig$_ungrouped$IBKIconView$iconImageFrame);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(prepareToCrossfadeImageWithView:maskCorners:trueCrossfade:anchorPoint:), (IMP)&_logos_method$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$prepareToCrossfadeImageWithView$maskCorners$trueCrossfade$anchorPoint$);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(iconImageSnapshot), (IMP)&_logos_method$_ungrouped$IBKIconView$iconImageSnapshot, (IMP*)&_logos_orig$_ungrouped$IBKIconView$iconImageSnapshot);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(frame), (IMP)&_logos_method$_ungrouped$IBKIconView$frame, (IMP*)&_logos_orig$_ungrouped$IBKIconView$frame);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(_setIcon:animated:), (IMP)&_logos_method$_ungrouped$IBKIconView$_setIcon$animated$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$_setIcon$animated$);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(_frameForLabel), (IMP)&_logos_method$_ungrouped$IBKIconView$_frameForLabel, (IMP*)&_logos_orig$_ungrouped$IBKIconView$_frameForLabel);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(prepareForRecycling), (IMP)&_logos_method$_ungrouped$IBKIconView$prepareForRecycling, (IMP*)&_logos_orig$_ungrouped$IBKIconView$prepareForRecycling);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(pointInside:withEvent:), (IMP)&_logos_method$_ungrouped$IBKIconView$pointInside$withEvent$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$pointInside$withEvent$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(IBKWidgetViewController*), strlen(@encode(IBKWidgetViewController*))); i += strlen(@encode(IBKWidgetViewController*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$IBKIconView, @selector(getWidgetViewControllerForIcon:orBundleID:), (IMP)&_logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$IBKIconView, @selector(addPreExpandedWidgetIfNeeded:), (IMP)&_logos_method$_ungrouped$IBKIconView$addPreExpandedWidgetIfNeeded$, _typeEncoding); }Class _logos_class$_ungrouped$SBIconController = objc_getClass("SBIconController"); MSHookMessageEx(_logos_class$_ungrouped$SBIconController, @selector(setIsEditing:), (IMP)&_logos_method$_ungrouped$SBIconController$setIsEditing$, (IMP*)&_logos_orig$_ungrouped$SBIconController$setIsEditing$);MSHookMessageEx(_logos_class$_ungrouped$SBIconController, @selector(_prepareToResetRootIconLists), (IMP)&_logos_method$_ungrouped$SBIconController$_prepareToResetRootIconLists, (IMP*)&_logos_orig$_ungrouped$SBIconController$_prepareToResetRootIconLists);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(ibkIsInSwitcher), (IMP)&_logos_method$_ungrouped$SBIconController$ibkIsInSwitcher, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(removeIdentifierFromWidgets:), (IMP)&_logos_method$_ungrouped$SBIconController$removeIdentifierFromWidgets$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(removeAllCachedIcons), (IMP)&_logos_method$_ungrouped$SBIconController$removeAllCachedIcons, _typeEncoding); }Class _logos_class$_ungrouped$SBLockScreenViewController = objc_getClass("SBLockScreenViewController"); MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenViewController, @selector(_handleDisplayTurnedOff), (IMP)&_logos_method$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOff, (IMP*)&_logos_orig$_ungrouped$SBLockScreenViewController$_handleDisplayTurnedOff);Class _logos_class$_ungrouped$SBIconScrollView = objc_getClass("SBIconScrollView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$SBIconScrollView$initWithFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); memcpy(_typeEncoding + i, @encode(UIGestureRecognizer*), strlen(@encode(UIGestureRecognizer*))); i += strlen(@encode(UIGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(gestureRecognizer:shouldRequireFailureOfGestureRecognizer:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$gestureRecognizer$shouldRequireFailureOfGestureRecognizer$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPinchGestureRecognizer*), strlen(@encode(UIPinchGestureRecognizer*))); i += strlen(@encode(UIPinchGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(handlePinchGesture:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIconListView *), strlen(@encode(SBIconListView *))); i += strlen(@encode(SBIconListView *)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(IBKListViewForIdentifierTwo:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$IBKListViewForIdentifierTwo$, _typeEncoding); }Class _logos_class$_ungrouped$SBIconBadgeView = objc_getClass("SBIconBadgeView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconBadgeView, @selector(configureForIcon:location:highlighted:), (IMP)&_logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$, (IMP*)&_logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$);MSHookMessageEx(_logos_class$_ungrouped$SBIconBadgeView, @selector(accessoryOriginForIconBounds:), (IMP)&_logos_method$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$, (IMP*)&_logos_orig$_ungrouped$SBIconBadgeView$accessoryOriginForIconBounds$);Class _logos_class$_ungrouped$BBServer = objc_getClass("BBServer"); Class _logos_metaclass$_ungrouped$BBServer = object_getClass(_logos_class$_ungrouped$BBServer); MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(init), (IMP)&_logos_method$_ungrouped$BBServer$init, (IMP*)&_logos_orig$_ungrouped$BBServer$init);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(_addBulletin:), (IMP)&_logos_method$_ungrouped$BBServer$_addBulletin$, (IMP*)&_logos_orig$_ungrouped$BBServer$_addBulletin$);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(_removeBulletin:rescheduleTimerIfAffected:shouldSync:), (IMP)&_logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$, (IMP*)&_logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$BBServer, @selector(sharedIBKBBServer), (IMP)&_logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer, _typeEncoding); }Class _logos_class$_ungrouped$SBMediaController = objc_getClass("SBMediaController"); MSHookMessageEx(_logos_class$_ungrouped$SBMediaController, @selector(_nowPlayingInfoChanged), (IMP)&_logos_method$_ungrouped$SBMediaController$_nowPlayingInfoChanged, (IMP*)&_logos_orig$_ungrouped$SBMediaController$_nowPlayingInfoChanged);MSHookMessageEx(_logos_class$_ungrouped$SBMediaController, @selector(setNowPlayingInfo:), (IMP)&_logos_method$_ungrouped$SBMediaController$setNowPlayingInfo$, (IMP*)&_logos_orig$_ungrouped$SBMediaController$setNowPlayingInfo$);}
    
    dlopen("/Library/MobileSubstrate/DynamicLibraries/IconSupport.dylib", RTLD_NOW);
    dlopen("/Library/MobileSubstrate/DynamicLibraries/iWidgets.dylib", RTLD_NOW);
    [[objc_getClass("ISIconSupport") sharedInstance] addExtension:@"com.matchstic.curago"];
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {Class _logos_class$iOS8$SBIconImageView = objc_getClass("SBIconImageView"); { char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBIconImageView, @selector(alternateIconView), (IMP)&_logos_method$iOS8$SBIconImageView$alternateIconView, _typeEncoding); }Class _logos_class$iOS8$MPUNowPlayingController = objc_getClass("MPUNowPlayingController"); Class _logos_metaclass$iOS8$MPUNowPlayingController = object_getClass(_logos_class$iOS8$MPUNowPlayingController); MSHookMessageEx(_logos_class$iOS8$MPUNowPlayingController, @selector(init), (IMP)&_logos_method$iOS8$MPUNowPlayingController$init, (IMP*)&_logos_orig$iOS8$MPUNowPlayingController$init);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$iOS8$MPUNowPlayingController, @selector(ibksharedMPU), (IMP)&_logos_meta_method$iOS8$MPUNowPlayingController$ibksharedMPU, _typeEncoding); }Class _logos_class$iOS8$SBMediaController = objc_getClass("SBMediaController"); MSHookMessageEx(_logos_class$iOS8$SBMediaController, @selector(isPlaying), (IMP)&_logos_method$iOS8$SBMediaController$isPlaying, (IMP*)&_logos_orig$iOS8$SBMediaController$isPlaying);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBMediaController, @selector(ibkNowPlayingArtist), (IMP)&_logos_method$iOS8$SBMediaController$ibkNowPlayingArtist, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBMediaController, @selector(ibkNowPlayingAlbum), (IMP)&_logos_method$iOS8$SBMediaController$ibkNowPlayingAlbum, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBMediaController, @selector(ibkNowPlayingTitle), (IMP)&_logos_method$iOS8$SBMediaController$ibkNowPlayingTitle, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(UIImage*), strlen(@encode(UIImage*))); i += strlen(@encode(UIImage*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBMediaController, @selector(ibkArtwork), (IMP)&_logos_method$iOS8$SBMediaController$ibkArtwork, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBMediaController, @selector(ibkTrackSupports15SecondFF), (IMP)&_logos_method$iOS8$SBMediaController$ibkTrackSupports15SecondFF, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$iOS8$SBMediaController, @selector(ibkTrackSupports15SecondRewind), (IMP)&_logos_method$iOS8$SBMediaController$ibkTrackSupports15SecondRewind, _typeEncoding); }}
        
    {Class _logos_class$iWidgets$IWWidgetsView = objc_getClass("IWWidgetsView"); MSHookMessageEx(_logos_class$iWidgets$IWWidgetsView, @selector(pointInside:withEvent:), (IMP)&_logos_method$iWidgets$IWWidgetsView$pointInside$withEvent$, (IMP*)&_logos_orig$iWidgets$IWWidgetsView$pointInside$withEvent$);}
}

