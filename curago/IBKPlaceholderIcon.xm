
#import "IBKPlaceholderIcon.h"

// (imageFromView) is a helper function that takes in a UIView and renders it
// out to a |UIImage| and then returns that |UIImage|. It used to generate 
// transparent icon images for |IBKPlaceholderIcon|

UIImage *imageFromView(UIView *view)
{
    CGRect rect = view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capturedImage;
}


@interface IBKPlaceholderIconViewLayer : CALayer
- (float)opacity;
@end

@implementation IBKPlaceholderIconViewLayer
- (id)init {
    self = [super init];
    if (self) {
		[self setOpacity:0];
		[self setNeedsDisplay];
    }
    return self;
}

- (id)initWithLayer:(id)layer {
	if (self = [super initWithLayer:layer]) {
		[self setOpacity:0];
	}
	return self;
}

- (float)opacity {
	return 0;
}

- (void)setOpacity:(float)arg1 {
	[super setOpacity:0];
}
@end

// |IBKPlaceholderIcon| is used to fill in the spaces that a "block" would consume. 
// |IBKPlaceholderIcon| cannot be interacted with and has no image or label. This makes 
// it so the end user assumes no icon is present there. 

%subclass IBKPlaceholderIcon : SBLeafIcon

// A new constructor is made using the method implimentations of |SBLeafIcon|.
// The method implimentations can differ between iOS Versions so in order to compensate
// a (respondsToSelector:) call must be made to determine which method is safe to call. 

%new
- (id)initWithIdentifier:(NSString *)identifier {

	if ([self respondsToSelector:@selector(initWithLeafIdentifier:applicationBundleID:)]) {
		self = [self initWithLeafIdentifier:identifier applicationBundleID:nil];
	} else {
		self = [self initWithLeafIdentifier:identifier];
	}
	return self;
}

// The methods providing the icon image for |SBLeafIcon| need to be overriden to return
// totally transparent images in order to give the illusion to the user that icon is 
// not there. This can be done by simply taking a snapshot of a blank |UIView| and 
// generating a |UIImage| from that snapshot. A helper function (imageFromView) is used
// to make the proccess easier.

- (UIImage *)getGenericIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 18.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor clearColor];
	UIImage *i = imageFromView(v);
	return i;
}

- (UIImage *)generateIconImage:(int)image {

	UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0,0,67,67)];
	v.layer.cornerRadius = 33.0;
	v.layer.masksToBounds = YES;
	v.backgroundColor = [UIColor clearColor];
	UIImage *i = imageFromView(v);
	//[gradient release];
	return i;
}

// In order to stop |IBKPlaceholderIcon| from doing anything when it is tapped the methods 
// (launchFromViewSwitcher), (launch), (launchFromLocation:), and (launchEnabled) need to overriden
// to not execute anything when they are called, or to return NO to prevent something from being
// executed.

- (void)launchFromViewSwitcher {

	// Prevent anything from happening.
}

- (void)launch {
	
	// Prevent anything from happening.
}

- (void)launchFromLocation:(int)location {
	
	// Prevent anything from happening.
}

- (BOOL)launchEnabled {

	// Disable icon launch for |IBKPlaceholderIcon| by returning NO.

	return NO;
}

// In order to give the illusion that a icon isn't present it also must not
// have a label. To achieve the goal of not displaying a label for |IBKPlaceholderIcon|
// all that needs to be done is to return a blank space for its label. This can be done
// by overriding the method (displayName). (canEllipsizeLabel) is also overriden just to be
// safe.

- (NSString *)displayName {

	return [NSString stringWithFormat:@" "];
}

- (BOOL)canEllipsizeLabel {
	return NO;
}

// Every subclass of |SBIcon| also has a preferred folder title. For |IBKPlaceholderIcon| a blank
// space is returned because the end user is not supposed to be aware of its exsistance. The 
// preferred folder title is determined by the method (folderFallbackTitle).

- (NSString *)folderFallbackTitle {

	return @" ";
}

// |IBKPlaceholderIcon| doesn't belong to any |SBApplication| so it does not have a 
// application bundle id by default. In order to make it seem like |IBKPlaceholderIcon|
// does have a application bundle id the leaf identifier can be returned it in it's place
// which a |IBKPlaceholderIcon| does have.

- (NSString *)applicationBundleID {

	return [self leafIdentifier];
}

// Every subclass of |SBIcon| must have a icon view class and a icon view image class. The
// two classes are used to build the view for the icon on the homescreen. These also need to
// be subclassed in order to get the illusion that the icon is not present.

- (Class)iconViewClassForLocation:(int)location {

	return NSClassFromString(@"IBKPlaceholderIconView");
}

- (Class)iconImageViewClassForLocation:(int)location {

	return NSClassFromString(@"IBKPlaceholderIconImageView");
}

%end

// |IBKPlaceholderIconView| is a subclass of |SBIconView| to be used with |IBKPlaceholderIcon|
// which is used to give the illusion that a icon doesn't exist wherever it is placed.

%subclass IBKPlaceholderIconView : SBIconView

// In order to support those who may use accessiblity features and devices with their iOS device
// We should return a blank space for the Accessbility values in order to give them the illusion
// that no icon is present when their device trys to read a |IBKPlaceholderIconView|.

- (NSString *)accessibilityValue {

	return @" ";
}

- (NSString *)accessibilityHint {

	return @" ";
}

- (BOOL)isHidden {
	return YES;
}

// To prevent interaction with |IBKPlaceholderIconView| (userInteractionEnabled) can simply be
// overriden to return NO always.

- (BOOL)userInteractionEnabled {
	return NO;
}

-(void)setIconLabelAlpha:(CGFloat)arg1 {
	%orig(0);
}

-(void)_applyIconLabelAlpha:(CGFloat)arg1 {
	%orig(0);
}

-(CGFloat)iconLabelAlpha {
	return 0;
}

+ (Class)layerClass {
	return NSClassFromString(@"IBKPlaceholderIconViewLayer");
}
%end

// |IBKPlaceholderIconImageView| is used as the image view for a |IBKPlaceholderIcon|.

%subclass IBKPlaceholderIconImageView : SBIconImageView

// |IBKPlaceholderIconImageView| should not be interacted with so (userInteractionEnabled)
// can be overriden to always return NO.

- (BOOL)userInteractionEnabled {

	return NO;
}

// |IBKPlaceholderIconImageView| should never be seen so its Alpha should
// always be 0.

- (CGFloat)alpha {
	return 0;
}

- (void)setAlpha:(CGFloat)alpha {
	%orig(0);
}

- (BOOL)isHidden {
	return YES;
}

- (void)setHidden:(BOOL)arg1 {
	%orig(YES);
}

- (void)layoutSubviews {
	
	%orig;
	self.alpha = 0;
	self.hidden = YES;
}
%end

// In order for |IBKPlaceholderIconView| to be used for a |IBKPlaceholderIcon| the method
// (viewMap:iconViewClassForIcon:) must be overriden to return the |IBKPlaceholderIconView|
// class for all |IBKPlaceholderIcon|(s)

%hook SBIconController

- (Class)viewMap:(id)map iconViewClassForIcon:(SBIcon *)icon {

	if ([icon isKindOfClass:NSClassFromString(@"IBKPlaceholderIcon")])
		return NSClassFromString(@"IBKPlaceholderIconView");
	else return %orig;
}

%end
