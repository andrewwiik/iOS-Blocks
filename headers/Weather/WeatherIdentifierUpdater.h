@interface WeatherIdentifierUpdater : NSObject {

	/*^block*/id _woeidWeatherHandler;
	NSArray* _requestedCities;
	NSMutableArray* _parsedCities;

}

@property (nonatomic,retain) NSArray * requestedCities;                  //@synthesize requestedCities=_requestedCities - In the implementation block
@property (nonatomic,retain) NSMutableArray * parsedCities;              //@synthesize parsedCities=_parsedCities - In the implementation block
+(id)sharedWeatherIdentifierUpdater;
+(void)clearSharedIdentifierUpdater;
-(void)dealloc;
-(void)updateWeatherForCity:(id)arg1 ;
-(id)aggregateDictionaryDomain;
-(void)handleCompletionForCity:(id)arg1 withUpdateDetail:(unsigned long long)arg2 ;
-(void)_failed:(unsigned long long)arg1 ;
-(void)updateWeatherForCities:(id)arg1 withCompletionHandler:(/*^block*/id)arg2 ;
-(NSArray *)requestedCities;
-(void)setRequestedCities:(NSArray *)arg1 ;
-(NSMutableArray *)parsedCities;
-(void)setParsedCities:(NSMutableArray *)arg1 ;
@end