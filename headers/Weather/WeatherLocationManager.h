@interface WeatherLocationManager : NSObject <CLLocationManagerDelegate> {

	BOOL _locationTrackingIsReady;
	BOOL _locationUpdatesEnabled;
	BOOL _isInternalBuild;
	int _authorizationStatus;
	float _lastLocationAccuracy;
	NSString* _effectiveBundleIdentifier;
	id<CLLocationManagerDelegate> _delegate;
	CLLocationManager* _locationManager;
	unsigned long long _updateInterval;
	double _oldestAllowedUpdateTime;
	NSTimer* _delayedUpdateTimer;
	NSTimer* _accuracyFallbackTimer;
	WeatherPreferences* _preferences;
	NSDate* _lastLocationTimeStamp;
	double _lastLocationUpdateTime;
	double _nextPlannedUpdate;
	CLLocationCoordinate2D _lastLocationCoord;

}

@property (nonatomic,copy,readonly) NSString * effectiveBundleIdentifier;                //@synthesize effectiveBundleIdentifier=_effectiveBundleIdentifier - In the implementation block
@property (nonatomic,retain) CLLocationManager * locationManager;                        //@synthesize locationManager=_locationManager - In the implementation block
@property (assign,nonatomic) int authorizationStatus;                                    //@synthesize authorizationStatus=_authorizationStatus - In the implementation block
@property (assign,nonatomic) BOOL locationUpdatesEnabled;                                //@synthesize locationUpdatesEnabled=_locationUpdatesEnabled - In the implementation block
@property (assign,nonatomic) BOOL locationTrackingIsReady;                               //@synthesize locationTrackingIsReady=_locationTrackingIsReady - In the implementation block
@property (assign,nonatomic) unsigned long long updateInterval;                          //@synthesize updateInterval=_updateInterval - In the implementation block
@property (assign,nonatomic) double oldestAllowedUpdateTime;                             //@synthesize oldestAllowedUpdateTime=_oldestAllowedUpdateTime - In the implementation block
@property (nonatomic,retain) NSTimer * delayedUpdateTimer;                               //@synthesize delayedUpdateTimer=_delayedUpdateTimer - In the implementation block
@property (nonatomic,retain) NSTimer * accuracyFallbackTimer;                            //@synthesize accuracyFallbackTimer=_accuracyFallbackTimer - In the implementation block
@property (nonatomic,retain) WeatherPreferences * preferences;                           //@synthesize preferences=_preferences - In the implementation block
@property (assign,nonatomic) CLLocationCoordinate2D lastLocationCoord;                   //@synthesize lastLocationCoord=_lastLocationCoord - In the implementation block
@property (nonatomic,copy) NSDate * lastLocationTimeStamp;                               //@synthesize lastLocationTimeStamp=_lastLocationTimeStamp - In the implementation block
@property (assign,nonatomic) float lastLocationAccuracy;                                 //@synthesize lastLocationAccuracy=_lastLocationAccuracy - In the implementation block
@property (assign,nonatomic) double lastLocationUpdateTime;                              //@synthesize lastLocationUpdateTime=_lastLocationUpdateTime - In the implementation block
@property (assign,nonatomic) double nextPlannedUpdate;                                   //@synthesize nextPlannedUpdate=_nextPlannedUpdate - In the implementation block
@property (assign,nonatomic) BOOL isInternalBuild;                                       //@synthesize isInternalBuild=_isInternalBuild - In the implementation block
@property (assign,nonatomic) id<CLLocationManagerDelegate> delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (nonatomic,readonly) double distanceFilter; 
+(int)locationManagerAuthorizationWithEffectiveBundleId:(id)arg1 ;
+(id)sharedWeatherLocationManager;
+(void)clearSharedLocationManager;
-(BOOL)isInternalBuild;
-(id)init;
-(void)setDelegate:(id<CLLocationManagerDelegate>)arg1 ;
-(void)dealloc;
-(id<CLLocationManagerDelegate>)delegate;
-(void)setPreferences:(WeatherPreferences *)arg1 ;
-(unsigned long long)updateInterval;
-(void)setUpdateInterval:(unsigned long long)arg1 ;
-(WeatherPreferences *)preferences;
-(id)location;
-(int)authorizationStatus;
-(NSString *)effectiveBundleIdentifier;
-(double)distanceFilter;
-(CLLocationManager *)locationManager;
-(void)setLocationManager:(CLLocationManager *)arg1 ;
-(void)locationManager:(id)arg1 didFailWithError:(id)arg2 ;
-(void)locationManager:(id)arg1 didChangeAuthorizationStatus:(int)arg2 ;
-(void)locationManager:(id)arg1 didUpdateLocations:(id)arg2 ;
-(id)initWithPreferences:(id)arg1 effectiveBundleIdentifier:(id)arg2 ;
-(void)setLocationTrackingReady:(BOOL)arg1 activelyTracking:(BOOL)arg2 watchKitExtension:(BOOL)arg3 ;
-(void)clearLocalWeatherUpdateState;
-(BOOL)locationTrackingIsReady;
-(void)setLocationTrackingActive:(BOOL)arg1 ;
-(void)askForLocationManagerAuthorization;
-(BOOL)localWeatherAuthorized;
-(id)initWithPreferences:(id)arg1 ;
-(void)cancelAccuracyFallbackTimer;
-(void)cancelDelayedUpdateTimer;
-(int)forceLoadingAuthorizationStatus;
-(void)setLocationTrackingReady:(BOOL)arg1 activelyTracking:(BOOL)arg2 watchKitExtension:(BOOL)arg3 shouldRequestAuthorization:(BOOL)arg4 ;
-(void)clearLastLocationUpdateTime;
-(void)setLocationTrackingIsReady:(BOOL)arg1 ;
-(void)setLocationUpdatesEnabled:(BOOL)arg1 ;
-(void)scheduleDelayedUpdate:(double)arg1 ;
-(double)oldestAllowedUpdateTime;
-(void)setOldestAllowedUpdateTime:(double)arg1 ;
-(NSDate *)lastLocationTimeStamp;
-(void)setLastLocationTimeStamp:(NSDate *)arg1 ;
-(float)lastLocationAccuracy;
-(NSTimer *)delayedUpdateTimer;
-(void)setNextPlannedUpdate:(double)arg1 ;
-(void)delayedUpdateTimerDidFire:(id)arg1 ;
-(void)setDelayedUpdateTimer:(NSTimer *)arg1 ;
-(CLLocationCoordinate2D)lastLocationCoord;
-(void)accuracyFallbackTimerDidFire:(id)arg1 ;
-(void)setAccuracyFallbackTimer:(NSTimer *)arg1 ;
-(void)setLastLocationCoord:(CLLocationCoordinate2D)arg1 ;
-(void)setLastLocationAccuracy:(float)arg1 ;
-(BOOL)locationUpdatesEnabled;
-(NSTimer *)accuracyFallbackTimer;
-(void)monitorLocationAuthorization;
-(BOOL)isLocalStaleOrOutOfDate;
-(void)forceLocationUpdate;
-(double)nextPlannedUpdate;
-(void)setIsInternalBuild:(BOOL)arg1 ;
-(void)setAuthorizationStatus:(int)arg1 ;
-(double)lastLocationUpdateTime;
-(void)setLastLocationUpdateTime:(double)arg1 ;
-(void)updateLocation:(id)arg1 ;
@end