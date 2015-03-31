//
//  WeatherContentView.m
//  Weather
//
//  Created by Matt Clarke on 23/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManager.h>
#import "IBKWeatherLayerFactory.h"
#import "WeatherContentView.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))

@interface City (iOS7)
@property (assign,nonatomic) unsigned conditionCode;
@property (assign,nonatomic) BOOL isRequestedByFrameworkClient;

+(id)descriptionForWeatherUpdateDetail:(unsigned)arg1;
- (id)naturalLanguageDescription;

@end

@implementation WeatherContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Custom initialisation
        self.gradientLayer = [[IBKWeatherLayerFactory sharedInstance] colourBackingLayerForCondition:0 isDay:YES];
        self.gradientLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.gradientLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self.layer addSublayer:self.gradientLayer];
        
        self.conditionLayer = [[IBKWeatherLayerFactory sharedInstance] layerForCondition:0 isDay:YES];
        self.conditionLayer.opacity = 1.0;
        self.conditionLayer.hidden = NO;
        self.conditionLayer.geometryFlipped = YES;
        
        self.animatedView = [[UIView alloc] initWithFrame:self.conditionLayer.frame];
        self.animatedView.backgroundColor = [UIColor clearColor];
        
        [self.animatedView.layer addSublayer:self.conditionLayer];
        
        self.animatedView.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.animatedView.frame = CGRectMake(0, 0, self.animatedView.frame.size.width, self.animatedView.frame.size.height);
        
        [self addSubview:self.animatedView];
        
        // Data display
        
        self.cityName = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, 20)];
        self.cityName.text = @"Location";
        self.cityName.textAlignment = NSTextAlignmentLeft;
        self.cityName.textColor = [UIColor whiteColor];
        self.cityName.backgroundColor = [UIColor clearColor];
        self.cityName.layer.masksToBounds = NO;
        
        [self.cityName setLabelSize:kIBKLabelSizingLarge];
        
        [self addSubview:self.cityName];
        
        self.weatherDetail = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 16)];
        self.weatherDetail.text = @"Condition";
        self.weatherDetail.textAlignment = NSTextAlignmentLeft;
        self.weatherDetail.textColor = [UIColor whiteColor];
        self.weatherDetail.backgroundColor = [UIColor clearColor];
        
        [self.weatherDetail setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.weatherDetail];
        
        self.temperature = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-40, 30)];
        self.temperature.text = @"--";
        self.temperature.textAlignment = NSTextAlignmentLeft;
        self.temperature.textColor = [UIColor whiteColor];
        self.temperature.backgroundColor = [UIColor clearColor];
        
        [self.temperature setLabelSize:kIBKLabelSizingGiant];
        
        [self addSubview:self.temperature];
        
        degreeSymbol = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, 11, 11)];
        degreeSymbol.text = @"°";
        degreeSymbol.textAlignment = NSTextAlignmentLeft;
        degreeSymbol.textColor = [UIColor whiteColor];
        degreeSymbol.backgroundColor = [UIColor clearColor];
        [degreeSymbol setLabelSize:kIBKLabelSizingLarge];
        
        [self addSubview:degreeSymbol];
    }
    
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    /*
     * This method will be called every time your widget rotates.
     * Therefore, it is highly recommended to set your frames here
     * in relation to the size of this content view.
    */
    
    // Relayout colour area.
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:self.gradientLayer];
    [self addSubview:self.animatedView];
    [self addSubview:self.cityName];
    [self addSubview:self.weatherDetail];
    [self addSubview:self.temperature];
    [self addSubview:degreeSymbol];
    
    [self.cityName sizeToFit];
    self.cityName.frame = CGRectMake(10, self.frame.size.height*0.125, self.cityName.frame.size.width, self.cityName.frame.size.height);
    
    [self.weatherDetail sizeToFit];
    self.weatherDetail.frame = CGRectMake(10, self.cityName.frame.origin.y + self.cityName.frame.size.height + 2, self.weatherDetail.frame.size.width, self.weatherDetail.frame.size.height);
    
    [self.temperature sizeToFit];
    self.temperature.frame = CGRectMake(10, self.weatherDetail.frame.origin.y + self.weatherDetail.frame.size.height + 3, self.temperature.frame.size.width, self.temperature.frame.size.height);
    
    [degreeSymbol sizeToFit];
    degreeSymbol.frame = CGRectMake(self.temperature.frame.origin.x + self.temperature.frame.size.width + 2, self.temperature.frame.origin.y + 5, degreeSymbol.frame.size.width, degreeSymbol.frame.size.height);
}

-(void)updateForCity:(City *)city {
    [self.gradientLayer removeFromSuperlayer];
    [self.conditionLayer removeFromSuperlayer];
    
    self.gradientLayer = nil;
    self.conditionLayer = nil;
    
    self.gradientLayer = [[IBKWeatherLayerFactory sharedInstance] colourBackingLayerForCondition:(int)city.conditionCode isDay:city.isDay];
    self.gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.gradientLayer.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self.layer addSublayer:self.gradientLayer];
    
    self.conditionLayer = [[IBKWeatherLayerFactory sharedInstance] layerForCondition:(int)city.conditionCode isDay:city.isDay];
    self.conditionLayer.opacity = 1.0;
    self.conditionLayer.hidden = NO;
    self.conditionLayer.geometryFlipped = YES;
    
    self.animatedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    [self.animatedView.layer addSublayer:self.conditionLayer];
    
    self.animatedView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.animatedView.frame = CGRectMake(0, 0, self.animatedView.frame.size.width, self.animatedView.frame.size.height);
    
    [self addSubview:self.animatedView];
    [self addSubview:self.cityName];
    [self addSubview:self.weatherDetail];
    [self addSubview:self.temperature];
    [self addSubview:degreeSymbol];
    
    // Now handle displayed data.
    self.cityName.text = city.name;
    self.weatherDetail.text = [[IBKWeatherLayerFactory sharedInstance] nameForCondition:(int)city.conditionCode];
    self.temperature.text = city.temperature;
}

-(UIImage*)iconForCondition:(int)condition isDay:(BOOL)isDay {
    
    
    return nil;
}

-(void)dealloc {
    [self.conditionLayer removeFromSuperlayer];
    self.conditionLayer = nil;
    
    [self.gradientLayer removeFromSuperlayer];
    self.gradientLayer = nil;
    
    [self.animatedView removeFromSuperview];
    self.animatedView = nil;
    
    [self.cityName removeFromSuperview];
    self.cityName = nil;
    
    [self.weatherDetail removeFromSuperview];
    self.weatherDetail = nil;
    
    [self.temperature removeFromSuperview];
    self.temperature = nil;
    
    [degreeSymbol removeFromSuperview];
    degreeSymbol = nil;
}

@end