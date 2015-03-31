//
//  WeatherContentView.h
//  Weather
//
//  Created by Matt Clarke on 23/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Weather/Weather.h>
#import "IBKLabel.h"

@interface WeatherContentView : UIView {
    IBKLabel *degreeSymbol;
}

@property (nonatomic, strong) UIView *animatedView;
@property (nonatomic, strong) CALayer *conditionLayer;
@property (nonatomic, strong) CALayer *gradientLayer;
@property (nonatomic, strong) IBKLabel *cityName;
@property (nonatomic, strong) IBKLabel *weatherDetail;
@property (nonatomic, strong) IBKLabel *temperature;
@property (nonatomic, strong) UIImageView *conditionImage;

-(void)updateForCity:(City*)city;

@end