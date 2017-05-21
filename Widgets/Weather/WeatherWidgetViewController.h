//
//  WeatherWidgetViewController.h
//  Weather
//
//  Created by Matt Clarke on 23/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "WeatherContentView.h"
#import <Weather/Weather.h>

@interface WeatherWidgetViewController : NSObject <IBKWidgetDelegate, CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSTimer *updater;
}

@property (nonatomic, strong) WeatherContentView *contentView;
@property (nonatomic, strong) City *currentCity;

@end