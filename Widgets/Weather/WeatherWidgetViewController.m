//
//  WeatherWidgetViewController.m
//  Weather
//
//  Created by Matt Clarke on 23/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "WeatherWidgetViewController.h"
#import <CoreLocation/CLLocationManager.h>
#import <Weather/TWCCityUpdater.h>
#import <objc/runtime.h>
#import "Reachability.h"
#import "IBKWeatherResources.h"

@interface WeatherPreferences (iOS7)
- (id)loadSavedCityAtIndex:(int)arg1;
@end

@interface CLLocationManager (iOS8)
+ (void)setAuthorizationStatus:(bool)arg1 forBundleIdentifier:(id)arg2;
- (id)initWithEffectiveBundleIdentifier:(id)arg1;
-(void)requestAlwaysAuthorization;
@end

@interface WeatherLocationManager (iOS7)
@property(retain) CLLocationManager * locationManager;
- (CLLocation*)location;
- (void)setLocationTrackingReady:(bool)arg1 activelyTracking:(bool)arg2;
@end

@interface City (iOS7)
@property (assign, nonatomic) unsigned conditionCode;
@property (assign, nonatomic) BOOL isRequestedByFrameworkClient;

+(id)descriptionForWeatherUpdateDetail:(unsigned)arg1;
@end

@interface TWCLocationUpdater : TWCCityUpdater
+ (id)sharedLocationUpdater;
- (void)updateWeatherForLocation:(id)arg1 city:(id)arg2 withCompletionHandler:(id)arg3;
-(void)handleCompletionForCity:(id)arg1 withUpdateDetail:(unsigned long long)arg2 ;
-(void)_failed:(unsigned long long)arg1 ;
-(void)updateWeatherForLocation:(id)arg1 city:(id)arg2 ;
@end

// static __weak WeatherWidgetViewController *cont;

@implementation WeatherWidgetViewController

// static void significantTimeChange(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
//     [cont updateCurrentCity:nil];
// }

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
        [IBKWeatherResources reloadSettings];
        
		self.contentView = [[WeatherContentView alloc] initWithFrame:frame];
        
  //       [City initialize];

        if([[WeatherPreferences sharedPreferences] isLocalWeatherEnabled]) {
            self.currentCity = [[WeatherPreferences sharedPreferences] localWeatherCity];
        } else {
            if ([[WeatherPreferences sharedPreferences] loadSavedCities]) {
                if ([[[WeatherPreferences sharedPreferences] loadSavedCities] count] > 0) {
                    self.currentCity = [[WeatherPreferences sharedPreferences] loadSavedCities][0];
                }

            }
        }

        if(!self.currentCity) {
            if ([[WeatherPreferences sharedPreferences] _defaultCities]) {
                if ([[[WeatherPreferences sharedPreferences] _defaultCities] count] > 0) {
                    self.currentCity = [[WeatherPreferences sharedPreferences] _defaultCities][0];
                }
            }
        }

        if (self.currentCity) {
            [self.contentView updateForCity:self.currentCity];
        }
        
        /*self.currentCity = [[City alloc] init];
        [self.currentCity setAutoUpdate:YES];
        self.currentCity.isRequestedByFrameworkClient = YES;
        [self.currentCity associateWithDelegate:self];*/
        
       // updater = [NSTimer scheduledTimerWithTimeInterval:3600 target:self selector:@selector(updateCurrentCity:) userInfo:nil repeats:YES];
        
        // [self fullUpdate];
        
    
       // cont = self;
        //CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, significantTimeChange, CFSTR("SignificantTimeChangeNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return NO;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

#pragma mark City delegate

-(void)cityDidStartWeatherUpdate:(id)city {
    
}

-(void)cityDidFinishWeatherUpdate:(id)city {
    self.currentCity = city;
    
    /*if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([CLLocationManager locationServicesEnabled]) {
            [self.currentCity populateWithDataFromCity:[[WeatherPreferences sharedPreferences] localWeatherCity]];
        } else {
            [self.currentCity populateWithDataFromCity:[[WeatherPreferences sharedPreferences] loadSavedCityAtIndex:0]];
        }
    }*/
    
    [self.contentView updateForCity:self.currentCity];
}

-(void)updateCurrentCity:(id)sender {
    // If has connection, run full update, otherwise wait.
    // Wait until connection then retry.
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    if (reach.isReachable) {
       // [self fullUpdate];
        return;
    }
    
    reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (reach.isReachable) {
               // [self fullUpdate];
                [reach stopNotifier];
            }
        });
    };
    
    [reach startNotifier];
}

-(void)fullUpdate {
    if (!locationManager) {
        //locationManager = [[CLLocationManager alloc] init];
        
        //locationManager.delegate = self;
    }

    if([[WeatherPreferences sharedPreferences] isLocalWeatherEnabled]) {
        self.currentCity = [[WeatherPreferences sharedPreferences] localWeatherCity];
    } else {
        self.currentCity = [[WeatherPreferences sharedPreferences] loadSavedCities][0];
    }

    if(!self.currentCity) {
        self.currentCity = [[WeatherPreferences sharedPreferences] _defaultCities][0];
    }
    
    // if ([CLLocationManager locationServicesEnabled]) {
    //     //[CLLocationManager setAuthorizationStatus:3 forBundleIdentifier:@"com.apple.springboard"];
        
    //     self.currentCity = [[WeatherPreferences sharedPreferences] localWeatherCity];
    //     if ([self.currentCity respondsToSelector:@selector(associateWithDelegate:)])
    //         [self.currentCity associateWithDelegate:self];
        
    //     //[[WeatherLocationManager sharedWeatherLocationManager] setDelegate:locationManager];
    //     //if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    //       //  [[WeatherLocationManager sharedWeatherLocationManager] setLocationTrackingReady:YES activelyTracking:NO];
    //     [[WeatherLocationManager sharedWeatherLocationManager] setLocationTrackingActive:YES];
    //     [[WeatherPreferences sharedPreferences] setLocalWeatherEnabled:YES];
        
    //     // iOS 8
    //     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    //         if ([[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] respondsToSelector:@selector(updateWeatherForLocation:city:)]) {
    //             [[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] updateWeatherForLocation:[(WeatherLocationManager*)[WeatherLocationManager sharedWeatherLocationManager] location] city:self.currentCity];
    //             NSLog(@"Updating weather...");
    //             [[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] handleCompletionForCity:self.currentCity withUpdateDetail:0];
    //             NSLog(@"Handled completion.");
    //         } else {
    //             [[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] updateWeatherForLocation:[(WeatherLocationManager*)[WeatherLocationManager sharedWeatherLocationManager] location] city:self.currentCity withCompletionHandler:nil];
    //         }
    //     } else {
    //         [[NSClassFromString(@"LocationUpdater") sharedLocationUpdater] updateWeatherForLocation:[(WeatherLocationManager*)[WeatherLocationManager sharedWeatherLocationManager] location] city:self.currentCity];
    //         [[NSClassFromString(@"LocationUpdater") sharedLocationUpdater] handleCompletionForCity:self.currentCity withUpdateDetail:0];
    //     }
        
    //     NSLog(@"Loading this motherfucker: %@", self.currentCity);
    // } else {
    //     if([[WeatherPreferences sharedPreferences] isLocalWeatherEnabled]) {
    //         self.currentCity = [[WeatherPreferences sharedPreferences] localWeatherCity];
    //     } else {
    //         self.currentCity = [[WeatherPreferences sharedPreferences] loadSavedCities][0];
    //     }

    //     if(!self.currentCity) {
    //         self.currentCity = [[WeatherPreferences sharedPreferences] _defaultCities][0];
    //     }
    //     if ([self.currentCity respondsToSelector:@selector(associateWithDelegate:)])
    //         [self.currentCity associateWithDelegate:self];
        
    //     if (NSClassFromString(@"WeatherIdentifierUpdater")) {
    //         [[NSClassFromString(@"WeatherIdentifierUpdater") sharedWeatherIdentifierUpdater] updateWeatherForCity:self.currentCity];
    //         [[objc_getClass("TWCCityUpdater") sharedCityUpdater] updateWeatherForCity:self.currentCity];
    //     }
    // }
    
    @try {
        [self.currentCity update];
    } @catch (NSException *e) {
        NSLog(@"*** [iOS Blocks :: Weather] Avoided crash: %@", e);
    }
}

#pragma mark CLLocationManager delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self updateCurrentCity:nil];
}

/*-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //CLLocation *cur = locations[0];
    //[locationManager stopUpdatingLocation];
    
    // iOS 8
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] updateWeatherForLocation:cur city:self.currentCity];
        NSLog(@"Updating weather...");
        [[objc_getClass("TWCLocationUpdater") sharedLocationUpdater] handleCompletionForCity:self.currentCity withUpdateDetail:0];
        NSLog(@"Handled completion.");
    } else {
        [[LocationUpdater sharedLocationUpdater] updateWeatherForLocation:cur city:self.currentCity];
        [[LocationUpdater sharedLocationUpdater] handleCompletionForCity:self.currentCity withUpdateDetail:0];
    }
}*/

-(void)dealloc {
    if (self.contentView) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
    }
    
    if (self.currentCity) {
        if ([self.currentCity respondsToSelector:@selector(disassociateWithDelegate:)])
            [self.currentCity disassociateWithDelegate:self];
        self.currentCity = nil;
    }
    
    if (locationManager) {
        if ([locationManager respondsToSelector:@selector(stopUpdatingLocation)])
            [locationManager stopUpdatingLocation];
        locationManager.delegate = nil;
        locationManager = nil;
    }
    
    if (updater) {
        [updater invalidate];
        updater = nil;
    }
}

@end