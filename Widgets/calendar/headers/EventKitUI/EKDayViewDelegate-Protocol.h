
#import <Foundation/NSObject.h>

@protocol EKDayViewDelegate <NSObject>
@optional
-(void)dayViewDidFinishScrollingToOccurrence:(id)arg1;
-(void)dayView:(id)arg1 firstVisibleSecondChanged:(unsigned long long)arg2;
-(void)dayView:(id)arg1 didSelectEvent:(id)arg2;
-(void)dayView:(id)arg1 didCreateOccurrenceViews:(id)arg2;
-(void)dayViewDidTapEmptySpace:(id)arg1;

@end