@protocol WeatherUpdaterDelegate
-(void)didUpdateWeather;
-(void)failedUpdate:(id)update;
@end