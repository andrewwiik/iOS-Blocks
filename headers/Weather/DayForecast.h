
#import <WeatherFoundation/WFTemperature.h>

@interface DayForecast : NSObject {

	WFTemperature* _high;
	WFTemperature* _low;
	unsigned long long _icon;
	unsigned long long _dayOfWeek;
	unsigned long long _dayNumber;

}

@property (nonatomic,copy) WFTemperature * high;                             //@synthesize high=_high - In the implementation block
@property (nonatomic,copy) WFTemperature * low;                              //@synthesize low=_low - In the implementation block
@property (assign,nonatomic) unsigned long long icon;                   //@synthesize icon=_icon - In the implementation block
@property (assign,nonatomic) unsigned long long dayOfWeek;              //@synthesize dayOfWeek=_dayOfWeek - In the implementation block
@property (assign,nonatomic) unsigned long long dayNumber;              //@synthesize dayNumber=_dayNumber - In the implementation block
-(unsigned long long)dayOfWeek;
-(void)dealloc;
-(id)description;
-(void)setIcon:(unsigned long long)arg1 ;
-(void)setDayOfWeek:(unsigned long long)arg1 ;
-(unsigned long long)icon;
-(unsigned long long)dayNumber;
-(long long)compareDayNumberToDayForecast:(id)arg1 ;
-(void)setDayNumber:(unsigned long long)arg1 ;
@end