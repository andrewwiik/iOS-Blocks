//
//  IBKResources.h
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import <Foundation/Foundation.h>
#import "../headers/SpringBoard/SBIconListView.h"
#import "../headers/SpringBoard/SBIconController.h"
#import "../headers/SpringBoard/SBFolder.h"
#import "../headers/SpringBoard/SBRootFolder.h"
#import "../headers/SpringBoard/SBIconListModel.h"
#import "../headers/SpringBoard/SBIconModel.h"
#import "../headers/SpringBoard/SBIconImageView.h"
#import "../headers/SpringBoard/SBIconView.h"
#import "../headers/SpringBoard/SBApplicationIcon.h"
#import "../headers/SpringBoard/SBFolderIcon.h"
#import "../headers/SpringBoard/SBIconIndexMutableList.h"
#import "../headers/SpringBoard/SBIconViewMap.h"
#import "../headers/SpringBoard/SBIconScrollView.h"
#import "../headers/SpringBoard/SBIconBadgeView.h"
#import "../headers/SpringBoard/SBRootFolderController.h"
#import "../headers/SpringBoard/SBRootFolderView.h"

@interface IBKResources : NSObject

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667)
#define IS_IPHONE_6_PLUS (SCREEN_MAX_LENGTH == 736.0)

#define orient [[UIApplication sharedApplication] statusBarOrientation]

+(CGFloat)adjustedAnimationSpeed:(CGFloat)duration;

+(NSSet*)widgetBundleIdentifiers;
+(void)addNewIdentifier:(NSString*)arg1;
+(void)removeIdentifier:(NSString*)arg1;
+(NSArray*)generateWidgetIndexesForListView:(SBIconListView*)view;

+(CGFloat)widthForWidgetWithIdentifier:(NSString *)identifier;
+(CGFloat)heightForWidgetWithIdentifier:(NSString *)identifier;

+(NSString*)getRedirectedIdentifierIfNeeded:(NSString*)identifier;

+(NSString*)suffix;

// Settings.

+(BOOL)bundleIdentiferWantsToBeLocked:(NSString*)bundleIdentifier;
+(BOOL)shouldHideBadgeWhenWidgetExpanded;
+(BOOL)shouldReturnIconsIfNotMoved;
+(BOOL)transparentBackgroundForWidgets;
+(BOOL)showBorderWhenTransparent;
+(BOOL)debugLoggingEnabled;
+(BOOL)hoverOnly;
+(NSString*)passcodeHash;
+(BOOL)allWidgetsLocked;
+(BOOL)relockWidgets;
+(BOOL)isWidgetLocked:(NSString*)identifier;
+(void)reloadSettings;
+(int)defaultColourType;
+ (void)setIndex:(unsigned long long)index forBundleID:(NSString *)bundleID;
+ (unsigned long long)indexForBundleID:(NSString *)bundleID;
+ (int)horiztonalWidgetSizeForBundleID:(NSString *)bundleID;
+ (int)verticalWidgetSizeForBundleID:(NSString *)bundleID;
@end
