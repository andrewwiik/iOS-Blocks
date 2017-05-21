@interface LocationUpdater : NSObject {

	BOOL _isGeoCoding;
	CLGeocoder* _geoCoder;
	/*^block*/id _localWeatherHandler;
	City* _currentCity;

}

@property (nonatomic,retain) City * currentCity;              //@synthesize currentCity=_currentCity - In the implementation block
+(id)sharedLocationUpdater;
+(void)clearSharedLocationUpdater;
-(void)dealloc;
-(void)cancel;
-(id)aggregateDictionaryDomain;
-(void)didProcessDocument;
-(void)handleCompletionForCity:(id)arg1 withUpdateDetail:(unsigned long long)arg2 ;
-(void)failCity:(id)arg1 ;
-(void)_failed:(unsigned long long)arg1 ;
-(void)handleNilCity;
-(BOOL)isDataValid:(id)arg1 ;
-(void)parsedResultCity:(id)arg1 ;
-(void)updateWeatherForLocation:(id)arg1 city:(id)arg2 withCompletionHandler:(/*^block*/id)arg3 ;
-(void)updateWeatherForLocation:(id)arg1 city:(id)arg2 ;
-(void)enableProgressIndicator:(BOOL)arg1 ;
-(void)setCurrentCity:(City *)arg1 ;
-(City *)currentCity;
@end