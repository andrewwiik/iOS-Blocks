#line 1 "/Users/Matt/iOS/Projects/Curago/curago/curago/curago.xm"













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
#import <objc/runtime.h>

#import <QuartzCore/QuartzCore.h>
#import <BulletinBoard/BBServer.h>
#import <BulletinBoard/BBBulletin.h>

#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)



typedef struct SBIconCoordinate {
    int row;
    int col;
} SBIconCoordinate;



@interface SBIconListView (Additions)
-(SBIconCoordinate)coordinateForIconWithIndex:(unsigned int)index andOriginalCoordinate:(SBIconCoordinate)orig;
-(SBIcon*)modifiedIconForIcon:(SBIcon*)icon;
@end

@interface IBKIconView : SBIconView

+(IBKWidgetViewController*)getWidgetViewControllerForIcon:(SBIcon*)arg1 orBundleID:(NSString*)arg2;

@end



NSMutableDictionary *cachedIndexes;
NSMutableSet *movedIndexPaths;
NSMutableDictionary *widgetViewControllers;

int icons = 0;
int currentOrientation = 1;

static BBServer* __weak IBKBBServer;



#pragma mark Icon co-ordinate placements

#include <logos/logos.h>
#include <substrate.h>
@class SBIconListView; @class BBServer; @class IBKIconView; @class SBAppSliderController; @class SBIconView; @class SBIconScrollView; @class SBIconController; @class SBIconBadgeView; 
static void (*_logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$)(SBIconListView*, SEL, int); static void _logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(SBIconListView*, SEL, int); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$rowAtPoint$)(SBIconListView*, SEL, struct CGPoint); static unsigned int _logos_method$_ungrouped$SBIconListView$rowAtPoint$(SBIconListView*, SEL, struct CGPoint); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$columnAtPoint$)(SBIconListView*, SEL, struct CGPoint); static unsigned int _logos_method$_ungrouped$SBIconListView$columnAtPoint$(SBIconListView*, SEL, struct CGPoint); static unsigned int (*_logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$)(SBIconListView*, SEL, struct SBIconCoordinate, int); static unsigned int _logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$(SBIconListView*, SEL, struct SBIconCoordinate, int); static struct SBIconCoordinate (*_logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$)(SBIconListView*, SEL, unsigned int, int); static struct SBIconCoordinate _logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(SBIconListView*, SEL, unsigned int, int); static SBIconCoordinate _logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$(SBIconListView*, SEL, unsigned int, SBIconCoordinate); static SBIcon* _logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$(SBIconListView*, SEL, SBIcon*); static void (*_logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$)(SBAppSliderController*, SEL, BOOL); static void _logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$(SBAppSliderController*, SEL, BOOL); static void (*_logos_orig$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$)(SBAppSliderController*, SEL, id, id, int, id); static void _logos_method$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$(SBAppSliderController*, SEL, id, id, int, id); static id (*_logos_orig$_ungrouped$SBIconView$initWithDefaultSize)(SBIconView*, SEL); static id _logos_method$_ungrouped$SBIconView$initWithDefaultSize(SBIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$_setIcon$animated$)(IBKIconView*, SEL, id, BOOL); static void _logos_method$_ungrouped$IBKIconView$_setIcon$animated$(IBKIconView*, SEL, id, BOOL); static struct CGRect (*_logos_orig$_ungrouped$IBKIconView$_frameForLabel)(IBKIconView*, SEL); static struct CGRect _logos_method$_ungrouped$IBKIconView$_frameForLabel(IBKIconView*, SEL); static void (*_logos_orig$_ungrouped$IBKIconView$prepareForRecycling)(IBKIconView*, SEL); static void _logos_method$_ungrouped$IBKIconView$prepareForRecycling(IBKIconView*, SEL); static IBKWidgetViewController* _logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$(Class, SEL, SBIcon*, NSString*); static void (*_logos_orig$_ungrouped$SBIconController$setIsEditing$)(SBIconController*, SEL, BOOL); static void _logos_method$_ungrouped$SBIconController$setIsEditing$(SBIconController*, SEL, BOOL); static BOOL _logos_method$_ungrouped$SBIconController$ibkIsInSwitcher(SBIconController*, SEL); static UIScrollView* (*_logos_orig$_ungrouped$SBIconScrollView$initWithFrame$)(SBIconScrollView*, SEL, CGRect); static UIScrollView* _logos_method$_ungrouped$SBIconScrollView$initWithFrame$(SBIconScrollView*, SEL, CGRect); static void _logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$(SBIconScrollView*, SEL, UIPinchGestureRecognizer*); static void (*_logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$)(SBIconBadgeView*, SEL, SBIcon*, int, BOOL); static void _logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(SBIconBadgeView*, SEL, SBIcon*, int, BOOL); static id (*_logos_orig$_ungrouped$BBServer$init)(BBServer*, SEL); static id _logos_method$_ungrouped$BBServer$init(BBServer*, SEL); static void (*_logos_orig$_ungrouped$BBServer$_addBulletin$)(BBServer*, SEL, BBBulletin*); static void _logos_method$_ungrouped$BBServer$_addBulletin$(BBServer*, SEL, BBBulletin*); static void (*_logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$)(BBServer*, SEL, id, BOOL, BOOL); static void _logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$(BBServer*, SEL, id, BOOL, BOOL); static id _logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer(Class, SEL); 

#line 74 "/Users/Matt/iOS/Projects/Curago/curago/curago/curago.xm"


static void _logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(SBIconListView* self, SEL _cmd, int arg1) {
    
    [cachedIndexes removeAllObjects];
    currentOrientation = arg1;
    NSLog(@"******** Cached icons removed to prepare for orientation change, and current or == %d", currentOrientation);
    
    _logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$(self, _cmd, arg1);
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
    
    NSLog(@"arg1 == {col: %d, row: %d}", arg1.col, arg1.row);
    
    
    
    
    unsigned int i = 0;
    
    for (NSString *bundleIdentifier in [IBKResources widgetBundleIdentifiers]) {
        if ([(SBIconListModel*)[self model] containsLeafIconWithIdentifier:bundleIdentifier]) {
            
            int a = (int)[[self model] indexForLeafIconWithIdentifier:bundleIdentifier];
            SBIconCoordinate widget = [self iconCoordinateForIndex:a forOrientation:arg2];
            
            NSLog(@"Widget's co-ordinate == {col: %d, row: %d}", widget.col, widget.row);
        
            
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
    
    NSLog(@"i ended up being == %u", i);
    NSLog(@"Final index == %u", orig);
    
    return orig;
}



static struct SBIconCoordinate _logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(SBIconListView* self, SEL _cmd, unsigned int arg1, int arg2) {
    SBIconCoordinate orig = _logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$(self, _cmd, arg1, arg2);
    
    if (![[self class] isEqual:[objc_getClass("SBDockIconListView") class]] && ![[self class] isEqual:[objc_getClass("SBFolderIconListView") class]]) {
        
        orig = [self coordinateForIconWithIndex:arg1 andOriginalCoordinate:orig];
        
       
    }
    
    return orig;
}



static SBIconCoordinate _logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$(SBIconListView* self, SEL _cmd, unsigned int index, SBIconCoordinate orig) {
   
    
    
















    
    if (!cachedIndexes)
        cachedIndexes = [NSMutableDictionary dictionary];
    
    SBApplicationIcon *icon = [[self model] iconAtIndex:index];
    NSString *bundleIdentifier = [icon leafIdentifier];
        
    if (!bundleIdentifier) {
        
        bundleIdentifier = [(SBFolderIcon*)icon nodeDescriptionWithPrefix:@"IBK"];
    }
        
    NSIndexPath *path = [cachedIndexes objectForKey:bundleIdentifier];
    if (path) {
        
        
        orig.row = (int)path.row;
        orig.col = (int)path.section;
        
        return orig;
    }
    
    NSLog(@"Getting icon co-ordinates");
    
    if (!movedIndexPaths) {
        NSLog(@"Creating an NSSet for temporary index holding");
        movedIndexPaths = [NSMutableSet set];
    }
    
    BOOL invalid = YES;
    
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:bundleIdentifier]) {
        
        NSLog(@"That one is a widget");
        
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
        
        int widgetRow = orig.row;
        int widgetCol = orig.col;
        
       
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
       
        [cachedIndexes setObject:pathz forKey:bundleIdentifier];
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



#pragma mark Injection into icon views




static id _logos_method$_ungrouped$SBIconView$initWithDefaultSize(SBIconView* self, SEL _cmd) {
    SBIconView *original = _logos_orig$_ungrouped$SBIconView$initWithDefaultSize(self, _cmd);
    if (![[original class] isEqual:[objc_getClass("IBKIconView") class]] && ![[original class] isEqual:[objc_getClass("SBFolderIconView") class]])
        object_setClass(original, objc_getClass("IBKIconView"));
    return original;
}





static void _logos_method$_ungrouped$IBKIconView$_setIcon$animated$(IBKIconView* self, SEL _cmd, id arg1, BOOL arg2) { 
    _logos_orig$_ungrouped$IBKIconView$_setIcon$animated$(self, _cmd, arg1, arg2);
    
    if (!inSwitcher) {
        SBApplicationIcon *icon = (SBApplicationIcon*)arg1;
        
        if ([[IBKResources widgetBundleIdentifiers] containsObject:[icon applicationBundleID]]) {
            NSLog(@"It's a widget! Inserting our UI");
        
            
            IBKWidgetViewController *widgetController;
            if (![widgetViewControllers objectForKey:[icon applicationBundleID]])
                widgetController = [[IBKWidgetViewController alloc] init];
            else
                widgetController = [widgetViewControllers objectForKey:[icon applicationBundleID]];
            widgetController.applicationIdentifer = [icon applicationBundleID];
            
            
            [self addSubview:widgetController.view];
            
            [widgetController layoutViewForPreExpandedWidget]; 
            
            if (!widgetViewControllers)
                widgetViewControllers = [NSMutableDictionary dictionary];
                
            if ([icon applicationBundleID])
                [widgetViewControllers setObject:widgetController forKey:[icon applicationBundleID]]; 
            
            
            [(UIImageView*)[self _iconImageView] setHidden:YES];
        }
        
        
        
        
    }
}

static struct CGRect _logos_method$_ungrouped$IBKIconView$_frameForLabel(IBKIconView* self, SEL _cmd) {
    CGRect orig = _logos_orig$_ungrouped$IBKIconView$_frameForLabel(self, _cmd);
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[self.icon applicationBundleID]] && !inSwitcher) {
        orig.origin = CGPointMake(8, (isPad ? 200 : 151)); 
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



static IBKWidgetViewController* _logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$(Class self, SEL _cmd, SBIcon* arg1, NSString* arg2) {
    NSString *bundleIdentifier;
    if (arg1)
        bundleIdentifier = [arg1 applicationBundleID];
    else
        bundleIdentifier = arg2;
        
    return [widgetViewControllers objectForKey:bundleIdentifier];
}






#pragma mark Handle de-caching indexes when in editing mode, and switcher detection



static void _logos_method$_ungrouped$SBIconController$setIsEditing$(SBIconController* self, SEL _cmd, BOOL arg1) {
    _logos_orig$_ungrouped$SBIconController$setIsEditing$(self, _cmd, arg1);
    
    if (arg1)
        [cachedIndexes removeAllObjects];
}



static BOOL _logos_method$_ungrouped$SBIconController$ibkIsInSwitcher(SBIconController* self, SEL _cmd) {
    return inSwitcher;
}




#pragma mark Handle pinching of icons

IBKWidgetViewController *widget;
SBIcon *widgetIcon;





static UIScrollView* _logos_method$_ungrouped$SBIconScrollView$initWithFrame$(SBIconScrollView* self, SEL _cmd, CGRect frame) {
    UIScrollView *orig = _logos_orig$_ungrouped$SBIconScrollView$initWithFrame$(self, _cmd, frame);

    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [(UIView*)orig addGestureRecognizer:pinch];
    
    return orig;
}



int scale = 0;
static void _logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$(SBIconScrollView* self, SEL _cmd, UIPinchGestureRecognizer* pinch) {
    
    if ([[objc_getClass("SBIconController") sharedInstance] hasOpenFolder]) return;
    
    if (pinch.state == UIGestureRecognizerStateBegan) {
         NSLog(@"Pinching began");
        
        
        
        CGFloat width = self.frame.size.width;
        NSInteger page = (self.contentOffset.x + (0.5f * width)) / width;
        CGPoint rawMidpoint = [pinch locationInView:(UIView*)self];
        CGPoint finalMidpoint = CGPointMake(rawMidpoint.x - (page * width), rawMidpoint.y);
        NSLog(@"*** final midpoint == %@", NSStringFromCGPoint(finalMidpoint));
        
        
        SBIconListView *listView;
        [[objc_getClass("SBIconController") sharedInstance] getListView:&listView folder:nil relativePath:nil forIndexPath:[NSIndexPath indexPathForRow:1 inSection:page] createIfNecessary:NO];
        
        
        unsigned int index;
        widgetIcon = [listView iconAtPoint:finalMidpoint index:&index];
        NSLog(@"Widget icon == %@", widgetIcon);
        
        
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
     
        [widget loadWidgetInterface];
        
        widget.view.center = CGPointMake([(UIView*)[view _iconImageView] frame].size.width/2, [(UIView*)[view _iconImageView] frame].size.height/2);
    } else if (pinch.state == UIGestureRecognizerStateChanged && widget) {
         NSLog(@"Pinching changed");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
        
        
        CGFloat duration = (pinch.scale/pinch.velocity);
        if (duration < 0)
            duration = -duration;
     
        scale = pinch.scale;
        
        [widget setScaleForView:pinch.scale withDuration:duration];
    } else if (pinch.state == UIGestureRecognizerStateEnded && widget) {
         NSLog(@"Pinching ended");
        if ([[widgetIcon class] isEqual:[objc_getClass("SBFolderIcon") class]]) return;
         
        
         
        
        if ((scale-1.0) > 0.75) { 
            [widget setScaleForView:2.0 withDuration:0.3];
            [IBKResources addNewIdentifier:[widgetIcon applicationBundleID]];
            
            
            [cachedIndexes removeAllObjects];
            [(SBIconController*)[objc_getClass("SBIconController") sharedInstance] layoutIconLists:0.3 domino:NO forceRelayout:YES];
            
            
            CGRect widgetViewFrame = widget.correspondingIconView.frame;
            widgetViewFrame.size = CGSizeMake(isPad ? 252 : 136, isPad ? 237 : 148);
            [UIView animateWithDuration:0.3 animations:^{
                widget.view.frame = CGRectMake(0, 0, isPad ? 252 : 136, isPad ? 237 : 148);
                widget.view.layer.shadowOpacity = 0.0;
                
                [(SBIconImageView*)[widget.correspondingIconView _iconImageView] setFrame:widgetViewFrame];
                
                
            }];
        } else {
            [widget unloadFromPinchGesture];
            if (widget) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
        }
    } else if (pinch.state == UIGestureRecognizerStateCancelled) {
        [widget unloadFromPinchGesture];
        if (widget) [widgetViewControllers removeObjectForKey:widget.applicationIdentifer];
    }
}





static void _logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(SBIconBadgeView* self, SEL _cmd, SBIcon* arg1, int arg2, BOOL arg3) {
    _logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$(self, _cmd, arg1, arg2, arg3);
    
    if ([[IBKResources widgetBundleIdentifiers] containsObject:[arg1 applicationBundleID]] && !inSwitcher) {
        
        
        IBKWidgetViewController *contr = [widgetViewControllers objectForKey:[arg1 applicationBundleID]];
        self.center = CGPointMake(0, contr.view.frame.size.width);
    }
    
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



#pragma mark Constructor and anti-piracy code

static __attribute__((constructor)) void _logosLocalCtor_08e8c1bc() {
    
    
    Class $IBKIconView = objc_allocateClassPair(objc_getClass("SBIconView"), "IBKIconView", 0);
    
    
    objc_registerClassPair($IBKIconView);
    
    
    {Class _logos_class$_ungrouped$SBIconListView = objc_getClass("SBIconListView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(prepareToRotateToInterfaceOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$prepareToRotateToInterfaceOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(rowAtPoint:), (IMP)&_logos_method$_ungrouped$SBIconListView$rowAtPoint$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$rowAtPoint$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(columnAtPoint:), (IMP)&_logos_method$_ungrouped$SBIconListView$columnAtPoint$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$columnAtPoint$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(indexForCoordinate:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$indexForCoordinate$forOrientation$);MSHookMessageEx(_logos_class$_ungrouped$SBIconListView, @selector(iconCoordinateForIndex:forOrientation:), (IMP)&_logos_method$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$, (IMP*)&_logos_orig$_ungrouped$SBIconListView$iconCoordinateForIndex$forOrientation$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIconCoordinate), strlen(@encode(SBIconCoordinate))); i += strlen(@encode(SBIconCoordinate)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = 'I'; i += 1; memcpy(_typeEncoding + i, @encode(SBIconCoordinate), strlen(@encode(SBIconCoordinate))); i += strlen(@encode(SBIconCoordinate)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconListView, @selector(coordinateForIconWithIndex:andOriginalCoordinate:), (IMP)&_logos_method$_ungrouped$SBIconListView$coordinateForIconWithIndex$andOriginalCoordinate$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconListView, @selector(modifiedIconForIcon:), (IMP)&_logos_method$_ungrouped$SBIconListView$modifiedIconForIcon$, _typeEncoding); }Class _logos_class$_ungrouped$SBAppSliderController = objc_getClass("SBAppSliderController"); MSHookMessageEx(_logos_class$_ungrouped$SBAppSliderController, @selector(switcherWasDismissed:), (IMP)&_logos_method$_ungrouped$SBAppSliderController$switcherWasDismissed$, (IMP*)&_logos_orig$_ungrouped$SBAppSliderController$switcherWasDismissed$);MSHookMessageEx(_logos_class$_ungrouped$SBAppSliderController, @selector(animatePresentationFromDisplayIdentifier:withViews:fromSide:withCompletion:), (IMP)&_logos_method$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$, (IMP*)&_logos_orig$_ungrouped$SBAppSliderController$animatePresentationFromDisplayIdentifier$withViews$fromSide$withCompletion$);Class _logos_class$_ungrouped$SBIconView = objc_getClass("SBIconView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconView, @selector(initWithDefaultSize), (IMP)&_logos_method$_ungrouped$SBIconView$initWithDefaultSize, (IMP*)&_logos_orig$_ungrouped$SBIconView$initWithDefaultSize);Class _logos_class$_ungrouped$IBKIconView = objc_getClass("IBKIconView"); Class _logos_metaclass$_ungrouped$IBKIconView = object_getClass(_logos_class$_ungrouped$IBKIconView); MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(_setIcon:animated:), (IMP)&_logos_method$_ungrouped$IBKIconView$_setIcon$animated$, (IMP*)&_logos_orig$_ungrouped$IBKIconView$_setIcon$animated$);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(_frameForLabel), (IMP)&_logos_method$_ungrouped$IBKIconView$_frameForLabel, (IMP*)&_logos_orig$_ungrouped$IBKIconView$_frameForLabel);MSHookMessageEx(_logos_class$_ungrouped$IBKIconView, @selector(prepareForRecycling), (IMP)&_logos_method$_ungrouped$IBKIconView$prepareForRecycling, (IMP*)&_logos_orig$_ungrouped$IBKIconView$prepareForRecycling);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(IBKWidgetViewController*), strlen(@encode(IBKWidgetViewController*))); i += strlen(@encode(IBKWidgetViewController*)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(SBIcon*), strlen(@encode(SBIcon*))); i += strlen(@encode(SBIcon*)); memcpy(_typeEncoding + i, @encode(NSString*), strlen(@encode(NSString*))); i += strlen(@encode(NSString*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$IBKIconView, @selector(getWidgetViewControllerForIcon:orBundleID:), (IMP)&_logos_meta_method$_ungrouped$IBKIconView$getWidgetViewControllerForIcon$orBundleID$, _typeEncoding); }Class _logos_class$_ungrouped$SBIconController = objc_getClass("SBIconController"); MSHookMessageEx(_logos_class$_ungrouped$SBIconController, @selector(setIsEditing:), (IMP)&_logos_method$_ungrouped$SBIconController$setIsEditing$, (IMP*)&_logos_orig$_ungrouped$SBIconController$setIsEditing$);{ char _typeEncoding[1024]; unsigned int i = 0; memcpy(_typeEncoding + i, @encode(BOOL), strlen(@encode(BOOL))); i += strlen(@encode(BOOL)); _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconController, @selector(ibkIsInSwitcher), (IMP)&_logos_method$_ungrouped$SBIconController$ibkIsInSwitcher, _typeEncoding); }Class _logos_class$_ungrouped$SBIconScrollView = objc_getClass("SBIconScrollView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconScrollView, @selector(initWithFrame:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$initWithFrame$, (IMP*)&_logos_orig$_ungrouped$SBIconScrollView$initWithFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(UIPinchGestureRecognizer*), strlen(@encode(UIPinchGestureRecognizer*))); i += strlen(@encode(UIPinchGestureRecognizer*)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBIconScrollView, @selector(handlePinchGesture:), (IMP)&_logos_method$_ungrouped$SBIconScrollView$handlePinchGesture$, _typeEncoding); }Class _logos_class$_ungrouped$SBIconBadgeView = objc_getClass("SBIconBadgeView"); MSHookMessageEx(_logos_class$_ungrouped$SBIconBadgeView, @selector(configureForIcon:location:highlighted:), (IMP)&_logos_method$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$, (IMP*)&_logos_orig$_ungrouped$SBIconBadgeView$configureForIcon$location$highlighted$);Class _logos_class$_ungrouped$BBServer = objc_getClass("BBServer"); Class _logos_metaclass$_ungrouped$BBServer = object_getClass(_logos_class$_ungrouped$BBServer); MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(init), (IMP)&_logos_method$_ungrouped$BBServer$init, (IMP*)&_logos_orig$_ungrouped$BBServer$init);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(_addBulletin:), (IMP)&_logos_method$_ungrouped$BBServer$_addBulletin$, (IMP*)&_logos_orig$_ungrouped$BBServer$_addBulletin$);MSHookMessageEx(_logos_class$_ungrouped$BBServer, @selector(_removeBulletin:rescheduleTimerIfAffected:shouldSync:), (IMP)&_logos_method$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$, (IMP*)&_logos_orig$_ungrouped$BBServer$_removeBulletin$rescheduleTimerIfAffected$shouldSync$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_metaclass$_ungrouped$BBServer, @selector(sharedIBKBBServer), (IMP)&_logos_meta_method$_ungrouped$BBServer$sharedIBKBBServer, _typeEncoding); }}
}

