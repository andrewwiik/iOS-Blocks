#import "City.h"
#import "TWCUpdater.h"
#import <CoreLocation/CLGeocoder.h>


@interface TWCLocationUpdater : TWCCityUpdater

@property (nonatomic, retain) City *currentCity;
@property (nonatomic, retain) CLGeocoder *reverseGeocoder;

+ (id)sharedLocationUpdater;

- (void)_completeReverseGeocodeForLocation:(id)arg1 currentCity:(id)arg2 geocodeError:(id)arg3 completionHandler:(id)arg4;
- (void)_geocodeLocation:(id)arg1 currentCity:(id)arg2 completionHandler:(id)arg3;
- (void)_updateWeatherForLocation:(id)arg1 city:(id)arg2 completionHandler:(id)arg3;
- (id)currentCity;
- (void)enableProgressIndicator:(BOOL)arg1;
- (void)parsedResultCity:(id)arg1;
- (id)reverseGeocoder;
- (void)setCurrentCity:(id)arg1;
- (void)setReverseGeocoder:(id)arg1;
- (void)updateWeatherForCities:(id)arg1 withCompletionHandler:(id)arg2;
- (void)updateWeatherForCity:(id)arg1;
- (void)updateWeatherForLocation:(id)arg1 city:(id)arg2;
- (void)updateWeatherForLocation:(id)arg1 city:(id)arg2 withCompletionHandler:(id)arg3;

// iOS 7

+ (id)sharedLocationUpdater;
- (void)updateWeatherForLocation:(id)arg1 city:(id)arg2 withCompletionHandler:(id)arg3;

@end