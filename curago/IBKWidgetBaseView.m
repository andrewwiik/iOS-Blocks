#import "IBKWidgetBaseView.h"
#import <SpringBoard/SpringBoard.h>
#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_RTL [NSClassFromString(@"IBKResources") isRTL]

@implementation IBKWidgetBaseView
- (void)setFrame:(CGRect)frame {
	if (frame.origin.x == 0) {
		if (IS_RTL) {
			frame.origin.x = 0 - (frame.size.width - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width);
		}
		//[IBKResources widthForWidgetWithIdentifier:widget.applicationIdentifer] - [NSClassFromString(@"SBIconView") defaultVisibleIconImageSize].width)
	}
	[super setFrame:frame];
}
// - (CGRect)bounds {
// 	CGRect viewBounds = [super bounds];
// 	viewBounds.size = self.frame.size;
// 	return viewBounds;
// }
// 
@end