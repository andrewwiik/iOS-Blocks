
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "./IBKWidgetDelegate.h"
#import "./libAnimatedWeatherUI.h"
#include <substrate.h>

@interface IBKWeatherBlockViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *weatherView;

-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@end

