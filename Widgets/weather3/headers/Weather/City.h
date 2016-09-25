#import <Foundation/NSObject.h>
#import <CoreLocation/CLLocation.h>

@interface City : NSObject

@property (nonatomic, retain) NSTimer *autoUpdateTimer;
@property (nonatomic, retain) NSHashTable *cityUpdateObservers;
@property (nonatomic) unsigned int conditionCode;
@property (getter=isDataCelsius, nonatomic) BOOL dataCelsius;
@property (nonatomic, copy) NSString *deeplink;
@property (nonatomic) float dewPoint;
@property (nonatomic) float feelsLike;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic) float heatIndex;
@property (nonatomic) float humidity;
@property (nonatomic) BOOL isDay;
@property (nonatomic) BOOL isHourlyDataCelsius;
@property (nonatomic) BOOL isLocalWeatherCity;
@property (nonatomic) BOOL isRequestedByFrameworkClient;
@property (nonatomic) BOOL isUpdating;
@property (nonatomic) unsigned int lastUpdateDetail;
@property (nonatomic) int lastUpdateStatus;
@property (nonatomic) unsigned int lastUpdateWarning;
@property (nonatomic) double latitude;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, readonly) NSString *locationID;
@property (nonatomic) BOOL lockedForDemoMode;
@property (nonatomic) double longitude;
@property (nonatomic) unsigned int moonPhase;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) unsigned int observationTime;
@property (nonatomic) float precipitationPast24Hours;
@property (nonatomic) float pressure;
@property (nonatomic) int pressureRising;
@property (nonatomic) int secondsFromGMT;
@property (nonatomic, copy) NSString *state;
@property (nonatomic) unsigned int sunriseTime;
@property (nonatomic) unsigned int sunsetTime;
@property (nonatomic, copy) NSString *temperature;
@property (nonatomic, retain) NSTimeZone *timeZone;
@property (nonatomic, retain) NSDate *timeZoneUpdateDate;
@property (getter=isTransient, nonatomic) BOOL transient;
@property (nonatomic) int updateInterval;
@property (nonatomic, retain) NSDate *updateTime;
@property (getter=isUpdatingTimeZone, nonatomic) BOOL updatingTimeZone;
@property (readonly) NSDictionary *urlComponents;
@property (setter=setUVIndex:, nonatomic) unsigned int uvIndex;
@property (nonatomic) float visibility;
@property (nonatomic) float windChill;
@property (nonatomic) float windDirection;
@property (nonatomic) float windSpeed;
@property (nonatomic, copy) NSString *woeid;

// iOS 7

+(id)descriptionForWeatherUpdateDetail:(unsigned)arg1;

@end