#import <Foundation/NSObject.h>

@protocol EKDayViewDataSource <NSObject>
@required
-(id)dayView:(id)arg1 eventsForStartDate:(id)arg2 endDate:(id)arg3;

@end