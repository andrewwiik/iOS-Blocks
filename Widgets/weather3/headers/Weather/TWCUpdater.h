#import "WeatherJSONHTTPRequest.h"
#import "WeatherUpdaterDelegate-Protocol.h"

@interface TWCUpdater : WeatherJSONHTTPRequest 

@property (nonatomic,copy) id weatherCompletionUpdaterHandler;                        
@property (assign,nonatomic) id<WeatherUpdaterDelegate> delegate;
-(void)failWithError:(id)arg1;
-(void)setDelegate:(id<WeatherUpdaterDelegate>)arg1;
-(id)init;
-(id<WeatherUpdaterDelegate>)delegate;
-(id)aggregateDictionaryDomain;
-(void)processJSONObject:(id)arg1;
-(void)didProcessJSONObject;
-(void)runAndClearWeatherCompletionWithDetail:(unsigned long long)arg1;
-(void)handleCompletionForCity:(id)arg1 withUpdateDetail:(unsigned long long)arg2;
-(void)failCity:(id)arg1;
-(id)_ISO8601Calendar;
-(id)_GMTOffsetRegularExpression;
-(id)_ISO8601DateFormatter;
-(void)_failed:(unsigned long long)arg1;
-(void)_processHourlyForecasts:(id)arg1;
-(void)_processDailyForecasts:(id)arg1;
-(void)_processCurrentConditions:(id)arg1;
-(void)_processLinks:(id)arg1;
-(void)parsedResultCity:(id)arg1;
-(void)_updateNextPendingCity;
-(BOOL)isDataValid:(id)arg1;
-(void)addCityToPendingQueue:(id)arg1;
-(void)handleNilCity;
-(void)loadRequestForURLPortion:(id)arg1;
-(BOOL)isUpdatingCity:(id)arg1;
-(id)weatherCompletionUpdaterHandler;
-(void)setWeatherCompletionUpdaterHandler:(id)arg1;
@end