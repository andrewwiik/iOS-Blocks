
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "./libAnimatedWeatherUI.h"
#include <substrate.h>

@interface IBKWeatherBlockViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIView *weatherView;
@property (nonatomic, strong) NSArray *filePaths;

-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@end

