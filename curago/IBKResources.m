//
//  IBKResources.m
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#import <objc/runtime.h>

@interface SBFAnimationFactory : NSObject
+ (id)factoryWithDuration:(double)arg1;
- (CGFloat)duration;
@end

#define plist @"/var/mobile/Library/Preferences/com.iosblocks.curago.plist"

static NSMutableSet *widgetIdentifiers;
static NSDictionary *settings;
static NSMutableDictionary *iconIndexes;
static NSMutableDictionary *widgetViewControllers;
static int isRTL = -1;
static int _touchIDEnabled = -1;
SBIconController *iconController;

static SBIconListView *thingy26;

@implementation IBKResources

+ (CGFloat)adjustedAnimationSpeed:(CGFloat)duration {
    if ([objc_getClass("SBFAnimationFactory") respondsToSelector:@selector(factoryWithDuration:)]) {
        return [(SBFAnimationFactory*)[objc_getClass("SBFAnimationFactory") factoryWithDuration:duration] duration];
    } else {
        return duration;
    }
}

+ (NSSet*)widgetBundleIdentifiers {
    if (!widgetIdentifiers) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plist];
        widgetIdentifiers = [NSMutableSet setWithArray:[[dict objectForKey:@"loadedWidgets"] mutableCopy]];
//        for (NSString *identifier in widgetIdentifiers) {
//            SBIconController *viewcont = [objc_getClass("SBIconController") sharedInstance];
//            SBIconModel *model = [viewcont model];
//            SBIcon *icon = [model expectedIconForDisplayIdentifier:identifier];
//            SBIconController *controller = [NSClassFromString(@"SBIconController") sharedInstance];
//            SBRootFolder *rootFolder = [controller valueForKeyPath:@"rootFolder"];
//            NSIndexPath *indexPath = [rootFolder indexPathForIcon:icon];
//            SBIconListView *listView = nil;
//            [controller getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:YES];
//            unsigned long long index2 = [(SBIconListModel*)[listView model] indexForLeafIconWithIdentifier:identifier];
//            if (![IBKResources indexForBundleID:identifier])
//            [IBKResources setIndex:index2 forBundleID:identifier];
//        
//        }
        if (!widgetIdentifiers)
            widgetIdentifiers = [NSMutableSet set];
    }
    
    return widgetIdentifiers;
}

+ (void)addNewIdentifier:(NSString*)arg1 {
    if (arg1) {
        [widgetIdentifiers addObject:arg1];
        
        if (!iconController) {
            if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
                iconController = [NSClassFromString(@"SBIconController") sharedInstance];
            }
        }
        SBIconModel *model = [iconController model];
        SBIcon *widgetIcon = [model expectedIconForDisplayIdentifier:arg1];
        SBRootFolder *rootFolder = [iconController valueForKeyPath:@"rootFolder"];
        NSIndexPath *indexPath = [rootFolder indexPathForIcon:widgetIcon];
        SBIconListView *listView = nil;
        [iconController getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:NO];
        
        if (listView) {
            SBIconIndexMutableList *list = [[listView model] valueForKey:@"_icons"];
            list.needsProcessing = YES;
        }
        
        [IBKResources saveIdentifiersToPlist];
        
        //NSLog(@"That should have saved...");
    }
}

+ (void)removeIdentifier:(NSString*)bundleID {
    if (bundleID) {
        [widgetIdentifiers removeObject:bundleID];

        if (!iconIndexes) {
            iconIndexes = [[NSMutableDictionary dictionaryWithContentsOfFile:plist] objectForKey:@"widgetIndexes"];
            if (!iconIndexes) iconIndexes = [NSMutableDictionary new];

            if (![iconIndexes objectForKey:@"Landscape"])
                [iconIndexes setObject:[NSMutableDictionary new] forKey:@"Landscape"];
            else {
                 [iconIndexes setObject:[(NSDictionary *)[iconIndexes objectForKey:@"Landscape"] mutableCopy] forKey:@"Landscape"];
            }
            if (![iconIndexes objectForKey:@"Portrait"])
                [iconIndexes setObject:[NSMutableDictionary new] forKey:@"Portrait"];
            else {
                 [iconIndexes setObject:[(NSDictionary *)[iconIndexes objectForKey:@"Portrait"] mutableCopy] forKey:@"Portrait"];
            }
        }

        [(NSMutableDictionary *)[iconIndexes objectForKey:@"Portrait"] removeObjectForKey:bundleID];
        [(NSMutableDictionary *)[iconIndexes objectForKey:@"Landscape"] removeObjectForKey:bundleID];
      //  NSLog(@"*** Attempted to remove %@", arg1);
        //NSLog(@"*** Loaded widget identifiers are now %@", widgetIdentifiers);
        if (!iconController) {
            if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
                iconController = [NSClassFromString(@"SBIconController") sharedInstance];
            }
        }

        SBIconModel *model = [iconController model];
        SBIcon *widgetIcon = [model expectedIconForDisplayIdentifier:bundleID];
        SBRootFolder *rootFolder = [iconController valueForKeyPath:@"rootFolder"];
        NSIndexPath *indexPath = [rootFolder indexPathForIcon:widgetIcon];
        SBIconListView *listView = nil;
        [iconController getListView:&listView folder:NULL relativePath:NULL forIndexPath:indexPath createIfNecessary:NO];
        
        if (listView) {
            SBIconIndexMutableList *list = [[listView model] valueForKey:@"_icons"];
            list.needsProcessing = YES;
        }
        
        [IBKResources saveIdentifiersToPlist];
    }
}

+ (void)saveIdentifiersToPlist {
    // Save to plist.
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plist];
    
    if (!dict)
        dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSString *string in widgetIdentifiers)
        [array addObject:string];
    
    [dict setObject:array forKey:@"loadedWidgets"];
    [dict setObject:iconIndexes forKey:@"widgetIndexes"];
    [dict writeToFile:plist atomically:YES];
}

+ (CGFloat)widthForWidgetWithIdentifier:(NSString *)identifier {
   // return 147; iOS 11 Hack

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        int widgetWidth = [IBKResources horiztonalWidgetSizeForBundleID:identifier];

        SBRootIconListView *listView;
        listView = [[NSClassFromString(@"SBIconController") sharedInstance] rootIconListAtIndex:0];
        if (!listView) {
            CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
            CGFloat statusBarWidth = statusBarSize.width > statusBarSize.height ? statusBarSize.width : statusBarSize.height;
            listView = [[NSClassFromString(@"SBRootIconListView") alloc] initWithFrame:CGRectMake(0,0,statusBarWidth,0)];
            listView.orientation = [[UIApplication sharedApplication] statusBarOrientation];
        }
        if ([NSClassFromString(@"IBKResources") isRTL]) {
          //  NSLog(@"called is RTL");
           // NSUInteger maxCols = [listView iconColumnsForCurrentOrientation];
            // NSLog(@"first coord: %@", NSStringFromCGPoint([listView originForIconAtCoordinate:SBIconCoordinateMake(1,1 + (widgetWidth -1))]));
            // NSLog(@"second coord: %@", NSStringFromCGPoint([listView originForIconAtCoordinate:SBIconCoordinateMake(1,maxCols - (widgetWidth - 1))]));
            return [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].x - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1 + (widgetWidth - 1))].x + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width;
        }
        return [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1 + (widgetWidth -1))].x - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].x + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width;
    } else {
        int widgetWidth = [IBKResources horiztonalWidgetSizeForBundleID:identifier];

        SBRootIconListView *listView;
        listView = [[NSClassFromString(@"SBIconController") sharedInstance] rootIconListAtIndex:0];
        if (!listView || listView) {
            CGFloat screenWidth = SCREEN_WIDTH;
            CGFloat screenHeight = SCREEN_HEIGHT;
            SBIconViewMap *map = nil;
            if ([[NSClassFromString(@"SBIconController") sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
                map = [[NSClassFromString(@"SBIconController") sharedInstance] homescreenIconViewMap];
            } else if ([NSClassFromString(@"SBIconViewMap") respondsToSelector:@selector(homescreenMap)]) {
                map = [NSClassFromString(@"SBIconViewMap") homescreenMap];
            } else {
                map = [[NSClassFromString(@"SBIconViewMap") alloc] initWithIconModel:nil screen:nil delegate:nil viewDelegate:nil];
            }
            NSLog(@"THE MAP: %@", map);
            SBRootFolderView *folderView = [[NSClassFromString(@"SBRootFolderView") alloc] initWithFolder:nil orientation:[[UIApplication sharedApplication] statusBarOrientation] viewMap:map forSnapshot:YES];
            folderView.frame = CGRectMake(0,0,screenWidth, screenHeight);
            // CGFloat dockHeight = [NSClassFromString(@"SBDockIconListView") defaultHeight];
            // if (statusBarWidth != screenWidth && statusBarWidth != screenHeight) {
            //     dockHeight = 0;
            // }
            // screenHeight = statusBarWidth <= (screenWidth + 10) ? screenHeight : screenWidth;
            // CGFloat listViewHeight = screenHeight - dockHeight - statusBarHeight - 16;
            // SB

            SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
            SBRootFolderController *rootFolder = [iconController valueForKeyPath:@"_rootFolderController"];
            NSUInteger dockEdge = rootFolder.dockEdge;

            listView = [[NSClassFromString(@"SBRootIconListView") alloc] initWithFrame:[folderView _scrollViewFrameForDockEdge:dockEdge]];
            listView.orientation = [[UIApplication sharedApplication] statusBarOrientation];

        }
        if ([NSClassFromString(@"IBKResources") isRTL]) {
          //  NSLog(@"called is RTL");
           // NSUInteger maxCols = [listView iconColumnsForCurrentOrientation];
            // NSLog(@"first coord: %@", NSStringFromCGPoint([listView originForIconAtCoordinate:SBIconCoordinateMake(1,1 + (widgetWidth -1))]));
            // NSLog(@"second coord: %@", NSStringFromCGPoint([listView originForIconAtCoordinate:SBIconCoordinateMake(1,maxCols - (widgetWidth - 1))]));
            return [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].x - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1 + (widgetWidth - 1))].x + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width;
        }
        return [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1 + (widgetWidth -1))].x - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].x + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width;
    }
}

// 310 Widget Final - 242 Height
// 306 Final - 79 Height

+ (CGFloat)heightForWidgetWithIdentifier:(NSString *)identifier {
   // return 148; iOS 11 Hack
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
        int widgetHeight = [IBKResources verticalWidgetSizeForBundleID:identifier];
    
        SBRootIconListView *listView;
        listView = [[NSClassFromString(@"SBIconController") sharedInstance] rootIconListAtIndex:0];
        if (!listView) {

            CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
            CGFloat statusBarWidth = statusBarSize.width > statusBarSize.height ? statusBarSize.width : statusBarSize.height;
            CGFloat statusBarHeight = statusBarSize.width < statusBarSize.height ? statusBarSize.width : statusBarSize.height;
            CGFloat screenWidth = SCREEN_WIDTH;
            CGFloat screenHeight = SCREEN_HEIGHT;
            CGFloat dockHeight = [NSClassFromString(@"SBDockIconListView") defaultHeight];
            if (statusBarWidth != screenWidth && statusBarWidth != screenHeight) {
                dockHeight = 0;
            }
            screenHeight = statusBarWidth <= (screenWidth + 10) ? screenHeight : screenWidth;
            CGFloat listViewHeight = screenHeight - dockHeight - statusBarHeight - 16;

            listView = [[NSClassFromString(@"SBRootIconListView") alloc] initWithFrame:CGRectMake(0,0,statusBarWidth,listViewHeight)];
            listView.orientation = [[UIApplication sharedApplication] statusBarOrientation];
        }
        return [listView originForIconAtCoordinate:SBIconCoordinateMake(1 + (widgetHeight -1),1)].y - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].y + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height;
    } else {
        int widgetHeight = [IBKResources verticalWidgetSizeForBundleID:identifier];
        
        SBRootIconListView *listView;
        listView = [[NSClassFromString(@"SBIconController") sharedInstance] rootIconListAtIndex:0];
        if (!listView || listView) {

            CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
            CGFloat statusBarHeight = statusBarSize.width < statusBarSize.height ? statusBarSize.width : statusBarSize.height;
            CGFloat screenWidth = SCREEN_WIDTH;
            CGFloat screenHeight = SCREEN_HEIGHT;
            SBIconViewMap *map = nil;
            if ([[NSClassFromString(@"SBIconController") sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
                map = [[NSClassFromString(@"SBIconController") sharedInstance] homescreenIconViewMap];
            } else if ([NSClassFromString(@"SBIconViewMap") respondsToSelector:@selector(homescreenMap)]) {
                map = [NSClassFromString(@"SBIconViewMap") homescreenMap];
            } else {
                map = [[NSClassFromString(@"SBIconViewMap") alloc] initWithIconModel:nil screen:nil delegate:nil viewDelegate:nil];
            }
            NSLog(@"THE MAP: %@", map);
            SBRootFolderView *folderView = [[NSClassFromString(@"SBRootFolderView") alloc] initWithFolder:nil orientation:[[UIApplication sharedApplication] statusBarOrientation] viewMap:map forSnapshot:YES];
            folderView.frame = CGRectMake(0,0,screenWidth, screenHeight);
            folderView.statusBarHeight = statusBarHeight;
            // CGFloat dockHeight = [NSClassFromString(@"SBDockIconListView") defaultHeight];
            // if (statusBarWidth != screenWidth && statusBarWidth != screenHeight) {
            //     dockHeight = 0;
            // }
            // screenHeight = statusBarWidth <= (screenWidth + 10) ? screenHeight : screenWidth;
            // CGFloat listViewHeight = screenHeight - dockHeight - statusBarHeight - 16;
            // SB

            SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
            SBRootFolderController *rootFolder = [iconController valueForKeyPath:@"_rootFolderController"];
            NSUInteger dockEdge = rootFolder.dockEdge;
            listView = [[NSClassFromString(@"SBRootIconListView") alloc] initWithFrame:[folderView _scrollViewFrameForDockEdge:dockEdge]];
            listView.orientation = [[UIApplication sharedApplication] statusBarOrientation];

           // NSLog(@"1: %f\n2.: %f\n3: %f\n4: %f\n5: %f\n6: %f\n7: %f", listViewHeight, statusBarWidth, statusBarHeight, screenWidth, screenHeight, dockHeight, screenHeight);
        }

        NSLog(@"listView: %@", listView);

        CGPoint topOrigin = [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)];
        CGPoint bottomOrigin = [listView originForIconAtCoordinate:SBIconCoordinateMake(1 + (widgetHeight - 1),1)];
        bottomOrigin.y += [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height;
        thingy26 = listView;
        return bottomOrigin.y - topOrigin.y;
        // CGFloat value = [listView originForIconAtCoordinate:SBIconCoordinateMake(1 + (widgetHeight -1),1)].y - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].y + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height;
        // NSLog(@"HEIGHT:::: %f", value);
        // return value;
    }

    //return [listView originForIconAtCoordinate:SBIconCoordinateMake(1 + (widgetHeight -1),1)].y - [listView originForIconAtCoordinate:SBIconCoordinateMake(1,1)].y + [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].height;
}

+ (id)listViewThing {
    return thingy26;
}

+ (NSArray *)generateWidgetIndexesForListView:(SBIconListView*)view {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *bundleID in [IBKResources widgetBundleIdentifiers]) {
        unsigned int index = [[view model] indexForLeafIconWithIdentifier:bundleID];
        if (index <= [objc_getClass("SBIconListModel") maxIcons])
            [array addObject:[NSNumber numberWithInt:index]];
    }
    
    return array;
}

+ (NSString *)getRedirectedIdentifierIfNeeded:(NSString*)identifier {
    if (!settings)
        [IBKResources reloadSettings];
    
    NSDictionary *dict = settings[@"redirectedIdentifiers"];
    
    if (dict && [dict objectForKey:identifier])
        return [dict objectForKey:identifier];
    else
        return identifier;
}

+ (NSString *)suffix {
    NSString *suffix = @"";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        suffix = @"~ipad";
    }
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0 && scale < 3.0) {
        suffix = [suffix stringByAppendingString:@"@2x.png"];
    } else if (scale >= 3.0) {
        suffix = [suffix stringByAppendingString:@"@3x.png"];
    } else if (scale < 2.0) {
        suffix = [suffix stringByAppendingString:@".png"];
    }
    
    return suffix;
}



+ (void)setIndex:(unsigned long long)index forBundleID:(NSString *)bundleID forOrientation:(UIInterfaceOrientation)orientation {

    if (!iconIndexes) {
        iconIndexes = [[NSMutableDictionary dictionaryWithContentsOfFile:plist] objectForKey:@"widgetIndexes"];
        if (!iconIndexes) iconIndexes = [NSMutableDictionary new];

        if (![iconIndexes objectForKey:@"Landscape"])
            [iconIndexes setObject:[NSMutableDictionary new] forKey:@"Landscape"];
        else {
             [iconIndexes setObject:[(NSDictionary *)[iconIndexes objectForKey:@"Landscape"] mutableCopy] forKey:@"Landscape"];
        }
        if (![iconIndexes objectForKey:@"Portrait"])
            [iconIndexes setObject:[NSMutableDictionary new] forKey:@"Portrait"];
        else {
             [iconIndexes setObject:[(NSDictionary *)[iconIndexes objectForKey:@"Portrait"] mutableCopy] forKey:@"Portrait"];
        }
    }
    if (bundleID) {

        SBRootIconListView *listView = [NSClassFromString(@"SBRootIconListView") alloc];
        int maxRows = 0;
        int maxCols = 0;

        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {

            int horiztonalWidgetSize = [IBKResources horiztonalWidgetSizeForBundleID:bundleID];

            if ([NSClassFromString(@"SBRootIconListView") respondsToSelector:@selector(iconColumnsForInterfaceOrientation:)]) {
                maxCols = [NSClassFromString(@"SBRootIconListView") iconColumnsForInterfaceOrientation:UIInterfaceOrientationPortrait];
                    
                if ([NSClassFromString(@"SBRootIconListView") respondsToSelector:@selector(iconRowsForInterfaceOrientation:)]) {
                    maxRows = [NSClassFromString(@"SBRootIconListView") iconRowsForInterfaceOrientation:UIInterfaceOrientationPortrait];
                }
            }

            int row = abs(((int)index % (int)maxCols) - (int)maxCols) - ((int)horiztonalWidgetSize - 1);
            int column = (int)index/(int)maxCols + 1;

            unsigned long long landscapeIndex = [listView indexForCoordinate:SBIconCoordinateMake(row,column) forOrientation:UIInterfaceOrientationLandscapeLeft];

            [(NSMutableDictionary *)[iconIndexes objectForKey:@"Landscape"] setObject:[NSNumber numberWithUnsignedLongLong:landscapeIndex] forKey:bundleID];
            [(NSMutableDictionary *)[iconIndexes objectForKey:@"Portrait"] setObject:[NSNumber numberWithUnsignedLongLong:index] forKey:bundleID];

        } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {

            int verticalWidgetSize = [IBKResources verticalWidgetSizeForBundleID:bundleID];

            if ([NSClassFromString(@"SBRootIconListView") respondsToSelector:@selector(iconColumnsForInterfaceOrientation:)]) {
                maxCols = [NSClassFromString(@"SBRootIconListView") iconColumnsForInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
                    
                if ([NSClassFromString(@"SBRootIconListView") respondsToSelector:@selector(iconRowsForInterfaceOrientation:)]) {
                    maxRows = [NSClassFromString(@"SBRootIconListView") iconRowsForInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
                }
            }

            int row = ((int)index % (int)maxCols) + 1;
            int column = abs(((int)index/(int)maxCols) - (int)maxRows) - ((int)verticalWidgetSize - 1);

            unsigned long long portraitIndex = [listView indexForCoordinate:SBIconCoordinateMake(row,column) forOrientation:UIInterfaceOrientationPortrait];

            [(NSMutableDictionary *)[iconIndexes objectForKey:@"Portrait"] setObject:[NSNumber numberWithUnsignedLongLong:portraitIndex] forKey:bundleID];
            [(NSMutableDictionary *)[iconIndexes objectForKey:@"Landscape"] setObject:[NSNumber numberWithUnsignedLongLong:index] forKey:bundleID];
        } else {
           // NSLog(@"A Error Occured");
        }
        // [iconIndexes setObject:[NSNumber numberWithUnsignedLongLong:index] forKey:bundleID];
        [IBKResources saveIdentifiersToPlist];
    }
    
}
+ (unsigned long long)indexForBundleID:(NSString *)bundleID forOrientation:(UIInterfaceOrientation)orientation {

    if (!iconIndexes) {
        iconIndexes = [[NSMutableDictionary dictionaryWithContentsOfFile:plist] objectForKey:@"widgetIndexes"];
        if (!iconIndexes) iconIndexes = [NSMutableDictionary new];

        if (![iconIndexes objectForKey:@"Landscape"])
            [iconIndexes setObject:[NSMutableDictionary new] forKey:@"Landscape"];
        else {
             [iconIndexes setObject:[(NSDictionary *)[iconIndexes objectForKey:@"Landscape"] mutableCopy] forKey:@"Landscape"];
        }
        if (![iconIndexes objectForKey:@"Portrait"])
            [iconIndexes setObject:[NSMutableDictionary new] forKey:@"Portrait"];
        else {
             [iconIndexes setObject:[(NSDictionary *)[iconIndexes objectForKey:@"Portrait"] mutableCopy] forKey:@"Portrait"];
        }
    }
    if (bundleID) {
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
            if ([(NSMutableDictionary *)[iconIndexes objectForKey:@"Portrait"] objectForKey:bundleID]) {
                return [(NSNumber *)[(NSMutableDictionary *)[iconIndexes objectForKey:@"Portrait"] objectForKey:bundleID] unsignedLongLongValue];
            }
            return 973;
        } else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
            if ([(NSMutableDictionary *)[iconIndexes objectForKey:@"Landscape"] objectForKey:bundleID]) {
                return [(NSNumber *)[(NSMutableDictionary *)[iconIndexes objectForKey:@"Landscape"] objectForKey:bundleID] unsignedLongLongValue];
            }
            return 973;
        } else {
            return 973;
        }
    }
    return 973;
}
//// BEGIN ACTUAL SETTINGS CHECKS.

+ (BOOL)shouldHideBadgeWhenWidgetExpanded {

    id temp = settings[@"shouldHideBadge"];
    return (temp ? [temp boolValue] : NO);
}

+ (BOOL)shouldReturnIconsIfNotMoved {

    id temp = settings[@"returnIcons"];
    return (temp ? [temp boolValue] : NO);
}

+ (BOOL)transparentBackgroundForWidgets {

    id temp = settings[@"transparentWidgets"];
    return (temp ? [temp boolValue] : NO);
}

+ (BOOL)showBorderWhenTransparent {

    id temp = settings[@"borderedWidgets"];
    return (temp ? [temp boolValue] : YES);
}

+ (BOOL)hoverOnly {

    id temp = settings[@"hoverOnly"];
    //return YES;
    return (temp ? [temp boolValue] : NO);
}

+ (BOOL)debugLoggingEnabled {

    id temp = settings[@"debug"];
    return (temp ? [temp boolValue] : NO);
}

+ (int)defaultColourType { // Used for switching which method to use for average colour of icon.

    id temp = settings[@"defaultColourType"];
    return (temp ? [temp intValue] : 0);
    // Enum:
    // 0 = average of 1px
    // 1 = dominant colour
}

+ (int)horiztonalWidgetSizeForBundleID:(NSString *)bundleID {
    
    // if ([bundleID isEqualToString:@"com.apple.Music"]) return 4;
    return 2;
}
+ (int)verticalWidgetSizeForBundleID:(NSString *)bundleID {

    return 2;
}

#pragma mark Widget locking

+ (BOOL)allWidgetsLocked {

    id temp = settings[@"allWidgetsLocked"];
    return (temp ? [temp boolValue] : NO);
}

+ (BOOL)relockWidgets {
    NSNumber *temp = settings[@"relockWidgets"];
    if (temp) {

        return ([temp intValue] == 0 ? NO : YES);
    } else {

        return NO;
    }
}

+ (NSString *)passcodeHash {
    id temp = settings[@"passcodeHash"];
    return (temp && ![temp isEqualToString:@""] ? temp : nil);
}

+ (BOOL)isWidgetLocked:(NSString*)identifier {

    if (![IBKResources passcodeHash]) {

        return NO;
    } else if ([IBKResources allWidgetsLocked]) {

        return YES;
    }
    
    NSArray *lockedBundleIdentifiers = settings[@"lockedBundleIdentifiers"];
    return [lockedBundleIdentifiers containsObject:identifier];
}

+ (void)reloadSettings {

    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.iosblocks.curago.plist"];
}

+ (id)iconIndexes {

    return iconIndexes;
}

+ (BOOL)bundleIdentiferWantsToBeLocked:(NSString*)bundleIdentifier {

    return NO;
}

+ (IBKWidgetViewController *)getWidgetViewControllerForIcon:(SBIcon *)arg1 orBundleID:(NSString*)arg2 {
    NSString *bundleIdentifier;
    if (arg1)
        bundleIdentifier = [arg1 applicationBundleID];
    else
        bundleIdentifier = arg2;
    return [widgetViewControllers objectForKey:bundleIdentifier];
}

+ (SBIcon *)iconForBundleID:(NSString *)bundleID {

    if (!iconController) {
        if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
            iconController = [NSClassFromString(@"SBIconController") sharedInstance];
        }
    }

    if ([iconController respondsToSelector:@selector(model)]) {

        SBIconModel *iconModel = [iconController model];
        if ([iconModel respondsToSelector:@selector(expectedIconForDisplayIdentifier:)]) {

            SBIcon *icon = [iconModel expectedIconForDisplayIdentifier:bundleID];
            if (icon && [icon isKindOfClass:NSClassFromString(@"SBIcon")]) {

                return icon;
            }
        }
    }

    return nil;
}

+ (NSIndexPath *)indexPathForIcon:(SBIcon *)icon orBundleID:(NSString *)bundleID {



    if ([iconController respondsToSelector:@selector(rootFolder)]) {

        SBRootFolder *rootFolder = [iconController rootFolder];
        if ([rootFolder respondsToSelector:@selector(indexPathForIcon:)]) {

            if (!icon && bundleID) {
                icon = [NSClassFromString(@"IBKResources") iconForBundleID:bundleID];
            }

            if (icon && [icon isKindOfClass:NSClassFromString(@"SBIcon")]) {

                NSIndexPath *indexPathForIcon = [rootFolder indexPathForIcon:icon];
                if (indexPathForIcon) {

                    return indexPathForIcon;
                }
            }
        }
    }

    return nil;
}

+ (SBIconListView *)listViewForBundleID:(NSString *)bundleID {
    NSLog(@"I'm gonna crash here");
        if (!iconController) {
            if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
                iconController = [NSClassFromString(@"SBIconController") sharedInstance];
            }
        }

        NSIndexPath *indexPathForIcon = [NSClassFromString(@"IBKResources") indexPathForIcon:nil orBundleID:bundleID];

        if ([iconController respondsToSelector:@selector(getListView:folder:relativePath:forIndexPath:createIfNecessary:)]) {

            SBIconListView *listView = nil;
            [iconController getListView:&listView folder:nil relativePath:nil forIndexPath:indexPathForIcon createIfNecessary:YES];

            if (listView) {
                return listView;
            }
        }
    return nil;
}

+ (SBIconView *)iconViewForBundleID:(NSString *)bundleID {
    NSLog(@"Maybe I can crash here");
    if (bundleID) {
        SBIconView *iconView = nil;
        if ([[NSClassFromString(@"SBIconController") sharedInstance] respondsToSelector:@selector(homescreenIconViewMap)]) {
            if ([[[NSClassFromString(@"SBIconController") sharedInstance] homescreenIconViewMap] respondsToSelector:@selector(mappedIconViewForIcon:)])
                iconView = [[[NSClassFromString(@"SBIconController") sharedInstance] homescreenIconViewMap] mappedIconViewForIcon:[IBKResources iconForBundleID:bundleID]];
        }
        else if ([NSClassFromString(@"SBIconViewMap") respondsToSelector:@selector(homescreenMap)]) {
            if ([[NSClassFromString(@"SBIconViewMap") homescreenMap] respondsToSelector:@selector(mappedIconViewForIcon:)])
                iconView = [[NSClassFromString(@"SBIconViewMap") homescreenMap] mappedIconViewForIcon:[IBKResources iconForBundleID:bundleID]];
        }
        if (iconView) 
            return iconView;
    }
    return nil;    
}

+ (NSMutableDictionary *)widgetViewControllers {
    if (!widgetViewControllers) {
        widgetViewControllers = [NSMutableDictionary new];
    }
    return widgetViewControllers;
}

+ (BOOL)isRTL {
    if (isRTL == -1) {
        if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
            isRTL = 1;
        }
        else {
            isRTL = 0;
        }
    }
    return (BOOL)isRTL;
}

// + (UIBezierPath *)roundedPathFromRect:(CGRect)frame
// {
//   UIBezierPath *path = [[UIBezierPath alloc] init];
//   CGFloat radius = [NSClassFromString(@"SBIconImageView") cornerRadius];

//   // Draw the path
//   [path moveToPoint:CGPointMake(radius, 0)];
//   [path addLineToPoint:CGPointMake(frame.size.width - radius, 0)];
//   [path addArcWithCenter:CGPointMake(frame.size.width - radius, radius)
//                   radius:radius
//               startAngle:- (M_PI / 2)
//                 endAngle:0
//                clockwise:YES];
//   [path addLineToPoint:CGPointMake(frame.size.width, frame.size.height - radius)];
//   [path addArcWithCenter:CGPointMake(frame.size.width - radius, frame.size.height - radius)
//                   radius:radius
//               startAngle:0
//                 endAngle:- ((M_PI * 3) / 2)
//                clockwise:YES];
//   [path addLineToPoint:CGPointMake(radius, frame.size.height)];
//   [path addArcWithCenter:CGPointMake(radius, frame.size.height - radius)
//                   radius:radius
//               startAngle:- ((M_PI * 3) / 2)
//                 endAngle:- M_PI
//                clockwise:YES];
//   [path addLineToPoint:CGPointMake(0, radius)];
//   [path addArcWithCenter:CGPointMake(radius, radius)
//                   radius:radius
//               startAngle:- M_PI
//                 endAngle:- (M_PI / 2)
//                clockwise:YES];

//   return path;
// }

#pragma mark TouchID

+ (BOOL)isTouchIDEnabled {
    if (_touchIDEnabled == -1) {
        if (NSClassFromString(@"SBUIBiometricEventMonitor")) {
            if ([[NSClassFromString(@"SBUIBiometricEventMonitor") sharedInstance] hasEnrolledIdentities]) {
                _touchIDEnabled = 1;
            } else {
                _touchIDEnabled = 0;
            }
        } else if (NSClassFromString(@"LAContext")) {
            LAContext *context = [NSClassFromString(@"LAContext") new];
            NSError *error = nil;
            if ([context canEvaluatePolicy:1 error:&error]) {
                _touchIDEnabled = 1;
            } else {
                _touchIDEnabled = 0;
            }
        } else {
            _touchIDEnabled = 0;
        }
    }

    return (BOOL)_touchIDEnabled;
}

@end
