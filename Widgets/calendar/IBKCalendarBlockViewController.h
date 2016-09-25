
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "./headers/EventKitUI/CalendarModel.h"
#import "./headers/EventKitUI/EKCalendarDate.h"
#import "./headers/EventKitUI/EKDayView.h"
#import "./headers/EventKitUI/EKDayViewDataSource-Protocol.h"
#import "./headers/EventKitUI/EKDayViewDelegate-Protocol.h"

#import "./IBKWidgetDelegate.h"

@interface IBKAPI : NSObject
+ (CGFloat)heightForContentViewWithIdentifier:(NSString *)identifier;
@end

@interface IBKCalendarBlockViewController : NSObject <IBKWidgetDelegate, EKDayViewDataSource, EKDayViewDelegate>

@property (nonatomic, strong) EKDayView *dayView;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) NSTimer *reloadTimer;
@property (nonatomic, strong) NSTimer *stopTimer;
@property (nonatomic, strong) CalendarModel *calendarModel;
@property (nonatomic, strong) EKCalendarDate *currentCalendarDate;

- (UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
- (BOOL)hasButtonArea;
- (BOOL)hasAlternativeIconView;
- (BOOL)wantsNoContentViewFadeWithButtons;
- (UIView *)alternativeIconViewWithFrame:(CGRect)frame;
- (id)dayView:(id)arg1 eventsForStartDate:(id)arg2 endDate:(id)arg3;

@end

