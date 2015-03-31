//
//  IBKWeatherResources.h
//  Weather
//
//  Created by Matt Clarke on 31/03/2015.
//
//

#import <Foundation/Foundation.h>

@interface IBKWeatherResources : NSObject

+(BOOL)centeredMainUI;
+(BOOL)showFiveDayForecast;

+(void)reloadSettings;

@end
