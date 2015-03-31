//
//  IBKWeatherLayerFactory.h
//  Weather
//
//  Created by Matt Clarke on 24/03/2015.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface IBKWeatherLayerFactory : NSObject

@property(strong, nonatomic) NSBundle *weatherFrameworkBundle;

+(instancetype)sharedInstance;
- (id)layerForCondition:(int)arg1 isDay:(_Bool)arg2;
-(CALayer*)colourBackingLayerForCondition:(int)condition isDay:(BOOL)isDay;
-(NSString*)nameForCondition:(int)condition;

@end
