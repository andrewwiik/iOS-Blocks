@interface TWCCityUpdater : NSObject
                   //@synthesize delegate=_delegate - In the implementation block
@property (nonatomic,retain) NSLocale * locale;                                                //@synthesize locale=_locale - In the implementation block
@property (nonatomic,retain) NSString * trackingParameter; 
+(id)sharedCityUpdater;
-(id)init;
-(void)cancel;
-(void)setLocale:(NSLocale *)arg1 ;
-(NSLocale *)locale;
-(BOOL)isUpdatingCity:(id)arg1 ;
-(void)updateWeatherForCity:(id)arg1 ;
-(NSString *)trackingParameter;
-(void)setTrackingParameter:(NSString *)arg1 ;
-(void)updateWeatherForCities:(id)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
-(void)updateWeatherForCities:(id)arg1 ;
@end