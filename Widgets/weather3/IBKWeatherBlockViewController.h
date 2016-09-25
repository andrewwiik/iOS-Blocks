
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "./headers/Weather/City.h"
#import "./headers/Weather/TWCLocationUpdater.h"
#import "./headers/Weather/CityUpdaterDelegate-Protocol.h"

#import "IBKWidgetDelegate.h"

@interface IBKWeatherBlockViewController : NSObject <IBKWidgetDelegate, CityUpdaterDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSTimer *updater;
}

@property (nonatomic, strong) WeatherContentView *contentView;
@property (nonatomic, strong) City *currentCity;


@property (nonatomic, strong) UIView *view;

- (UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
- (BOOL)hasButtonArea;
- (BOOL)hasAlternativeIconView;

@end

