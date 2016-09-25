//
//  IBKResources.m
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import "IBKResources.h"
#import "IBKFunctions.h"

#import <objc/runtime.h>

@interface SBFAnimationFactory : NSObject
+ (id)factoryWithDuration:(double)arg1;
- (CGFloat)duration;
@end

#define plist @"/var/mobile/Library/Preferences/com.matchstic.curago.plist"

static NSMutableSet *widgetIdentifiers;
static NSDictionary *settings;
static NSMutableDictionary *iconIndexes;
static NSMutableDictionary *widgetViewControllers;
SBIconController *iconController;

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

+ (void)removeIdentifier:(NSString*)arg1 {
    if (arg1) {
        [widgetIdentifiers removeObject:arg1];
        [iconIndexes removeObjectForKey:arg1];
        
      //  NSLog(@"*** Attempted to remove %@", arg1);
        //NSLog(@"*** Loaded widget identifiers are now %@", widgetIdentifiers);
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

// TODO: THIS ASSUMES IT'S ALWAYS 4 ICONS PER ROW!

+ (CGFloat)widthForWidgetWithIdentifier:(NSString *)identifier {

    if (!iconController) {
        if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
            iconController = [NSClassFromString(@"SBIconController") sharedInstance];
        }
    }
    
    SBIconListView *listView = [iconController rootIconListAtIndex:0];
    
    SBIconCoordinate widgetCoordinate = SBIconCoordinateMake(1, 1);
    
    SBIconCoordinate farIconCoordinate = SBIconCoordinateMake(1, [IBKResources horiztonalWidgetSizeForBundleID:identifier]);
    
    CGPoint farIconOrigin = [listView originForIconAtCoordinate:(struct SBIconCoordinate)farIconCoordinate];
    CGPoint farIconCenter = [listView centerForIconCoordinate:farIconCoordinate];
    CGPoint widgetIconOrigin = [listView originForIconAtCoordinate:widgetCoordinate];
    CGFloat spaceBetween = (farIconOrigin.x + ((farIconCenter.x - farIconOrigin.x) * 2)) - widgetIconOrigin.x;
    
    // NSLog(@"Space Between Height for Bundle Identifier: %@ \n is: %f", identifier, spaceBetween);
//    if (spaceBetween <  100) {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            return 252;
//        else if (IS_IPHONE_6)
//            return 147;
//        else if (IS_IPHONE_6_PLUS)
//            return 343.5;
//        else
//            return 136;
//    }
    return spaceBetween;
    
}

+ (CGFloat)heightForWidgetWithIdentifier:(NSString *)identifier {

    if (!iconController) {
        if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
            iconController = [NSClassFromString(@"SBIconController") sharedInstance];
        }
    }
    
    SBIconListView *listView = [iconController rootIconListAtIndex:0];
    
    SBIconCoordinate widgetCoordinate = SBIconCoordinateMake(1, 1);
    SBIconCoordinate farIconCoordinate = SBIconCoordinateMake([IBKResources verticalWidgetSizeForBundleID:identifier], 1);
    
    CGPoint farIconOrigin = [listView originForIconAtCoordinate:(struct SBIconCoordinate)farIconCoordinate];
    CGPoint farIconCenter = [listView centerForIconCoordinate:farIconCoordinate];
    CGPoint widgetIconOrigin = [listView originForIconAtCoordinate:widgetCoordinate];
    CGFloat spaceBetween = (farIconOrigin.y + ((farIconCenter.y - farIconOrigin.y) * 2)) - widgetIconOrigin.y;
    
    // NSLog(@"Space Between Width for Bundle Identifier: %@ \n is: %f", identifier, spaceBetween);
    
//    if (spaceBetween < 100) {
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            return 237;
//        else if (IS_IPHONE_6)
//            return 148;
//        else if (IS_IPHONE_6_PLUS)
//            return 158;
//        else
//            return 148;
//    }
    return spaceBetween;
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



+ (void)setIndex:(unsigned long long)index forBundleID:(NSString *)bundleID {
    if (!iconIndexes) {
        iconIndexes = [[[NSDictionary dictionaryWithContentsOfFile:plist] objectForKey:@"widgetIndexes"] mutableCopy];
        if (!iconIndexes) iconIndexes = [NSMutableDictionary new];
    }
    if (bundleID) {
        [iconIndexes setObject:[NSNumber numberWithUnsignedLongLong:index] forKey:bundleID];
        [IBKResources saveIdentifiersToPlist];
    }
    
}
+ (unsigned long long)indexForBundleID:(NSString *)bundleID {

    if (!iconIndexes) {
        iconIndexes = [[[NSDictionary dictionaryWithContentsOfFile:plist] objectForKey:@"widgetIndexes"] mutableCopy];
        if (!iconIndexes) iconIndexes = [NSMutableDictionary new];
    }
    if (bundleID) {
        if ([iconIndexes objectForKey:bundleID]) {
            return [(NSNumber*)[iconIndexes objectForKey:bundleID] unsignedLongLongValue];
        }
        return 973;
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
    
//    if ([bundleID isEqualToString:@"com.apple.Music"]) return 4;
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

    settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
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

        NSLog(@"GOT PAST ICON STAGE 1");

        SBIconModel *iconModel = [iconController model];

        if ([iconModel respondsToSelector:@selector(expectedIconForDisplayIdentifier:)]) {

            NSLog(@"GOT PAST ICON STAGE 2");

            SBIcon *icon = [iconModel expectedIconForDisplayIdentifier:bundleID];

            if (icon && [icon isKindOfClass:NSClassFromString(@"SBIcon")]) {

                NSLog(@"GOT PAST ICON STAGE 3");

                return icon;
            }
        }
    }

    return nil;
}

+ (NSIndexPath *)indexPathForIcon:(SBIcon *)icon orBundleID:(NSString *)bundleID {



    if ([iconController respondsToSelector:@selector(rootFolder)]) {

        NSLog(@"GOT PAST SUB-STAGE 2");

        SBRootFolder *rootFolder = [iconController rootFolder];

        if ([rootFolder respondsToSelector:@selector(indexPathForIcon:)]) {

            NSLog(@"GOT PAST SUB-STAGE 3");

            if (!icon && bundleID) {

                NSLog(@"GOT PAST SUB-STAGE 4");
                icon = [NSClassFromString(@"IBKResources") iconForBundleID:bundleID];
            }

            if (icon && [icon isKindOfClass:NSClassFromString(@"SBIcon")]) {

                NSLog(@"GOT PAST SUB-STAGE 5");

                NSIndexPath *indexPathForIcon = [rootFolder indexPathForIcon:icon];

                if (indexPathForIcon) {

                    NSLog(@"GOT PAST SUB-STAGE 6");
                    return indexPathForIcon;
                }
            }
        }
    }

    return nil;
}

+ (SBIconListView *)listViewForBundleID:(NSString *)bundleID {

        if (!iconController) {
            if ([NSClassFromString(@"SBIconController") respondsToSelector:@selector(sharedInstance)]) {
                iconController = [NSClassFromString(@"SBIconController") sharedInstance];
            }
        }

        NSIndexPath *indexPathForIcon = [NSClassFromString(@"IBKResources") indexPathForIcon:nil orBundleID:bundleID];

        if ([iconController respondsToSelector:@selector(getListView:folder:relativePath:forIndexPath:createIfNecessary:)]) {

            SBIconListView *listView = nil;

             NSLog(@"GOT PAST STAGE 2");

            [iconController getListView:&listView folder:nil relativePath:nil forIndexPath:indexPathForIcon createIfNecessary:YES];

            if (listView) {

                 NSLog(@"GOT PAST STAGE 3");
                return listView;
            }
        }

    return nil;
}

+ (NSMutableDictionary *)widgetViewControllers {

    if (!widgetViewControllers) {

        widgetViewControllers = [NSMutableDictionary new];
    }
    return widgetViewControllers;
}

@end
