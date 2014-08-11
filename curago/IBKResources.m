//
//  IBKResources.m
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import "IBKResources.h"
#import <SpringBoard7.0/SBIconListModel.h>
#import <objc/runtime.h>

static NSMutableSet *widgetIdentifiers;

@implementation IBKResources

+(NSSet*)widgetBundleIdentifiers {
    if (!widgetIdentifiers)
        //testingAdditionalIdentifiers = [NSMutableArray arrayWithObjects:@"com.apple.Maps", @"com.appe.mobilenotes", @"com.everyme.Everyme", nil];
        widgetIdentifiers = [NSMutableSet set]; // Load this from the plist next time.
    
    return widgetIdentifiers;
}

+(void)addNewIdentifier:(NSString*)arg1 {
    if (arg1)
        [widgetIdentifiers addObject:arg1];
}

+(NSArray*)generateWidgetIndexesForListView:(SBIconListView*)view {
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *bundleID in [IBKResources widgetBundleIdentifiers]) {
        unsigned int index = [[view model] indexForLeafIconWithIdentifier:bundleID];
        if (index <= [objc_getClass("SBIconListModel") maxIcons])
            [array addObject:[NSNumber numberWithInt:index]];
    }
    
    return array;
}

@end
