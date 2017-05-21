//
//  libAnimatedWeatherUI.h
//  Weather
//
//  Created by Matt Clarke on 19/09/2015.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Retrieves an animated weather view for the provided condition.
UIView *viewForConditionInformation(int condition, BOOL isDay);

// Pulls the icon associated with the current condition.
UIImage *iconForConditionInformation(int condition, BOOL isDay, BOOL wantsLargerIcons);

// Pulls user-facing description of the provided condition
NSString *translatedNameForCondition(int condition);