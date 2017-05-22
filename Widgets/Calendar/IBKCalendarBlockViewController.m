
#import "IBKCalendarBlockViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation IBKCalendarBlockViewController

- (BOOL)wantsNoContentViewFadeWithButtons {
	return NO;
	
}

- (UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (self.view == nil) {

		if (!self.calendarModel) {
			self.calendarModel = [NSClassFromString(@"CalendarModel") new];
			NSMutableArray *visibleCalendars = [(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"] mutableCopy];
			NSMutableSet *selectedCalendars = [NSMutableSet new];
			for (id obj in visibleCalendars) {
				[selectedCalendars addObject:obj];
			}
			self.calendarModel.selectedCalendars = [selectedCalendars copy];
			[self.calendarModel setMaxCachedDays:3];
			self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
		[self.calendarModel setMaxCachedDays:3];
		}

		if (!self.currentCalendarDate)
		self.currentCalendarDate = [NSClassFromString(@"EKCalendarDate") calendarDateWithDate:[NSDate date] 
																					 timeZone:[NSTimeZone defaultTimeZone]];

		self.view = [[UIView alloc] initWithFrame:frame];

		self.dayView = [[NSClassFromString(@"EKDayView") alloc] initWithFrame:CGRectMake(frame.origin.x - 8, frame.origin.y, (frame.size.width + 8)*1.2, ([NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.apple.mobilecal"])*1.2)
															   orientation:[[UIApplication sharedApplication] statusBarOrientation] 
														   	   displayDate:[self.currentCalendarDate componentsWithoutTime]
														   backgroundColor:[UIColor whiteColor]
														   			opaque:NO
													  scrollbarShowsInside:YES];
		self.dayView.showsTimeMarker = NO;
		[self.dayView setAllowPinchingHourHeights:NO];
		self.dayView.gridLineColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];

		[self.view addSubview:self.dayView];
        self.dayView.dataSource = self;
        self.dayView.delegate = self;
        self.dayView.layer.mask = nil;
        self.dayView.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.dayView.frame = CGRectMake(-5, 0,self.dayView.frame.size.width + 5,self.dayView.frame.size.height);
	}
	self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
	[self.calendarModel setMaxCachedDays:3];
	self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
	[self.calendarModel setMaxCachedDays:3];


	NSDate *today = [NSDate date];
	NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
	[weekdayFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"

	NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
	[dayFormatter setDateFormat:@"dd"]; // day, like "Saturday"

	self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,frame.size.height - [NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.apple.mobilecal"], frame.size.width/3*2, frame.size.height - [NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.apple.mobilecal"])];
	self.dayLabel.text = [weekdayFormatter stringFromDate:today];
	self.dayLabel.textColor = [UIColor colorWithRed:1 green:0.231 blue:0.188 alpha:1];
	self.dayLabel.adjustsFontSizeToFitWidth = YES;
	self.dayLabel.font = [self.dayLabel.font fontWithSize:isPad ? 17 : 12];
	[self.dayLabel sizeToFit];
	self.dayLabel.frame = CGRectMake(10,frame.size.height - 7.5 - self.dayLabel.frame.size.height, self.dayLabel.frame.size.width, self.dayLabel.frame.size.height);

	self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,frame.size.height - [NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.apple.mobilecal"], frame.size.width/3*1, frame.size.height - [NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.apple.mobilecal"])];
	self.numberLabel.text = [dayFormatter stringFromDate:today];
	self.numberLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
	self.numberLabel.adjustsFontSizeToFitWidth = YES;
	self.numberLabel.font = [UIFont fontWithName:@".SFUIText-Light" size:isPad ? 42 : 35];
	[self.numberLabel sizeToFit];
	self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
							    target:self.dayView
							    selector:@selector(reloadData)
							    userInfo:nil
							    repeats:YES];
	self.stopTimer = [NSTimer scheduledTimerWithTimeInterval:2.0
							    target:self
							    selector:@selector(stopReloading)
							    userInfo:nil
							    repeats:NO];
	self.numberLabel.frame = CGRectMake(frame.size.width-self.numberLabel.frame.size.width-7.5,frame.size.height - self.numberLabel.frame.size.height, self.numberLabel.frame.size.width, self.numberLabel.frame.size.height);
	return self.view;
}

- (BOOL)hasButtonArea {

    return YES;
}

- (BOOL)hasAlternativeIconView {

    return YES;
}
- (void)loadView {
	if (self.dayView) {
		[self.dayView reloadData];
	}
}
- (void)layoutSubviews {
	if (self.dayView) {
		[self.dayView reloadData];
	}
}
- (id)testingDataStuffLOL {
	self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
	[self.calendarModel setMaxCachedDays:3];
	return [self.calendarModel occurrencesForDay:[self.calendarModel.selectedDay componentsWithoutTime] waitForLoad:YES];
}
- (id)dayView:(id)dayView eventsForStartDate:(id)startDate endDate:(id)endDate {
	if (!self.calendarModel) {
		self.calendarModel = [NSClassFromString(@"CalendarModel") new];
		self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
	}
	if (self.calendarModel) {
		self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
		[self.calendarModel setMaxCachedDays:3];
		self.calendarModel.selectedCalendars = [NSSet setWithArray:(NSArray *)[self.calendarModel valueForKey:@"_visibleCalendars"]];
		return [self.calendarModel occurrencesForStartDate:[(EKCalendarDate *)startDate date] endDate:[(EKCalendarDate *)endDate date] preSorted:YES waitForLoad:YES];
	}
	return nil;
}

- (UIView *)alternativeIconViewWithFrame:(CGRect)frame {
	UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
	[[self.view superview] addSubview:self.dayLabel];
	[[self.view superview] addSubview:self.numberLabel];
	[[self.view superview] superview].backgroundColor = [UIColor whiteColor];
	if (self.dayView) {
		[self.dayView reloadData];
	}
	return view;
}

- (void)stopReloading {
	[self.reloadTimer invalidate];
	[self.stopTimer invalidate];
	self.stopTimer = nil;
	self.reloadTimer = nil;
}

-(UIView*)buttonAreaViewWithFrame:(CGRect)frame {
	return nil;
}

@end

@interface EKCurrentTimeMarkerView : NSObject
+ (CGFloat)_spacingAdjustmentFontSize;
@end


