
#import "IBKWeatherBlockViewController.h"

@implementation IBKWeatherBlockViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (self.view == nil) {
        
		self.view = [[UIView alloc] initWithFrame:frame];
		self.view.backgroundColor = [UIColor clearColor];

		self.weatherView = viewForConditionInformation(31,YES);
		self.weatherView.frame = self.view.frame;
		[self.view addSubview:self.weatherView];

	}
	
	return self.view;
}

-(BOOL)hasButtonArea {

    return NO;
}

-(BOOL)hasAlternativeIconView {

    return NO;
}

@end