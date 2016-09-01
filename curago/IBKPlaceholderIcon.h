
#import "../headers/SpringBoard/SBLeafIcon.h"
#import "../headers/SpringBoard/SBIconView.h"
#import "../headers/SpringBoard/SBIconImageView.h"

@interface IBKPlaceholderIcon : SBLeafIcon
- (id)initWithIdentifier:(NSString *)identifier;
- (id)initWithLeafIdentifier:(NSString *)identifier;
- (id)initWithLeafIdentifier:(NSString *)identifier applicationBundleID:(NSString *)applicationBundleID;
- (UIImage *)getGenericIconImage:(int)image;
- (UIImage *)generateIconImage:(int)image;
- (void)launchFromViewSwitcher;
- (void)launch;
- (void)launchFromLocation:(int)location;
- (BOOL)launchEnabled;
- (NSString *)displayName;
- (BOOL)canEllipsizeLabel;
- (NSString *)folderFallbackTitle;
- (NSString *)applicationBundleID;
- (Class)iconViewClassForLocation:(int)location;
- (Class)iconImageViewClassForLocation:(int)location;
@end

@interface IBKPlaceholderIconView : SBIconView
- (NSString *)accessibilityHint;
- (NSString *)accessibilityValue;
- (BOOL)userInteractionEnabled;

@end

@interface IBKPlaceholderIconImageView : SBIconImageView
- (BOOL)userInteractionEnabled;
@end