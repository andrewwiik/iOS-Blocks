//
//  IBKResources.h
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import <Foundation/Foundation.h>
#import <SpringBoard7.0/SBIconListView.h>

@interface IBKResources : NSObject

+(NSSet*)widgetBundleIdentifiers;
+(void)addNewIdentifier:(NSString*)arg1;
+(NSArray*)generateWidgetIndexesForListView:(SBIconListView*)view;

@end
