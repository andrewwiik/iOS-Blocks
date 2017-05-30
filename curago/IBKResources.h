//
//  IBKResources.h
//  curago
//
//  Created by Matt Clarke on 04/06/2014.
//
//

#import <Foundation/Foundation.h>
#import "../headers/SpringBoard/SpringBoard.h"
#import <LocalAuthentication/LAContext.h>

#import "IBKFunctions.h"

@class IBKWidgetViewController;
@interface IBKResources : NSObject

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_6 (SCREEN_MAX_LENGTH == 667)
#define IS_IPHONE_6_PLUS (SCREEN_MAX_LENGTH == 736.0)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define orient [[UIApplication sharedApplication] statusBarOrientation]

+ (CGFloat)adjustedAnimationSpeed:(CGFloat)duration;
+ (BOOL)isRTL;

+ (NSSet*)widgetBundleIdentifiers;
+ (void)addNewIdentifier:(NSString*)arg1;
+ (void)removeIdentifier:(NSString*)arg1;
+ (NSArray*)generateWidgetIndexesForListView:(SBIconListView*)view;

+ (CGFloat)widthForWidgetWithIdentifier:(NSString *)identifier;
+ (CGFloat)heightForWidgetWithIdentifier:(NSString *)identifier;

+ (NSString*)getRedirectedIdentifierIfNeeded:(NSString*)identifier;

+ (NSString*)suffix;

// Settings.

+ (BOOL)bundleIdentiferWantsToBeLocked:(NSString*)bundleIdentifier;
+ (BOOL)shouldHideBadgeWhenWidgetExpanded;
+ (BOOL)shouldReturnIconsIfNotMoved;
+ (BOOL)transparentBackgroundForWidgets;
+ (BOOL)showBorderWhenTransparent;
+ (BOOL)debugLoggingEnabled;
+ (BOOL)hoverOnly;
+ (NSString*)passcodeHash;
+ (BOOL)allWidgetsLocked;
+ (BOOL)relockWidgets;
+ (BOOL)isWidgetLocked:(NSString*)identifier;
+ (void)reloadSettings;
+ (int)defaultColourType;
+ (void)setIndex:(unsigned long long)index forBundleID:(NSString *)bundleID forOrientation:(UIInterfaceOrientation)orientation;
+ (unsigned long long)indexForBundleID:(NSString *)bundleID forOrientation:(UIInterfaceOrientation)orientation;
+ (int)horiztonalWidgetSizeForBundleID:(NSString *)bundleID;
+ (int)verticalWidgetSizeForBundleID:(NSString *)bundleID;
+ (IBKWidgetViewController *)getWidgetViewControllerForIcon:(SBIcon *)icon orBundleID:(NSString*)bundleID;
+ (SBIconListView *)listViewForBundleID:(NSString *)bundleID;
+ (NSMutableDictionary *)widgetViewControllers;
+ (NSIndexPath *)indexPathForIcon:(SBIcon *)icon orBundleID:(NSString *)bundleID;
+ (SBIcon *)iconForBundleID:(NSString *)bundleID;
+ (SBIconView *)iconViewForBundleID:(NSString *)bundleID;

#pragma mark TouchID

+ (BOOL)isTouchIDEnabled;

@end
