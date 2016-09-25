
#import <UIKit/UIView.h>

#import "EKDayViewDataSource-Protocol.h"
#import "EKDayViewDelegate-Protocol.h"

@protocol EKDayViewDelegate, EKDayViewDataSource;
@class UIImageView, UIView, NSArray, NSDate, EKDayAllDayView, EKDayViewContent, EKDayTimeView, UIScrollAnimation, UIScrollView, NSTimer, NSDateComponents, NSCalendar, UIColor, EKEvent;

@interface EKDayView : UIView 

@property (assign,nonatomic) id<EKDayViewDelegate> delegate;                  //@synthesize delegate=_delegate - In the implementation block
@property (assign,nonatomic) id<EKDayViewDataSource> dataSource;              //@synthesize dataSource=_dataSource - In the implementation block
@property (nonatomic,copy) NSDateComponents * displayDate;                           //@synthesize displayDate=_displayDate - In the implementation block
@property (nonatomic,copy) NSCalendar * calendar;                                    //@synthesize calendar=_calendar - In the implementation block
@property (nonatomic,readonly) double dayStart;                                      //@synthesize dayStart=_dayStart - In the implementation block
@property (nonatomic,readonly) double dayEnd;                                        //@synthesize dayEnd=_dayEnd - In the implementation block
@property (assign,nonatomic) int firstVisibleSecond; 
@property (assign,nonatomic) BOOL allowsOccurrenceSelection;                         //@synthesize allowsOccurrenceSelection=_allowsOccurrenceSelection - In the implementation block
@property (assign,nonatomic) BOOL alignsMidnightToTop;                               //@synthesize alignsMidnightToTop=_alignsMidnightToTop - In the implementation block
@property (nonatomic,readonly) double scrollBarOffset; 
@property (nonatomic,readonly) NSArray * occurrenceViews; 
@property (nonatomic,readonly) double leftContentInset; 
@property (assign,nonatomic) BOOL shouldEverShowTimeIndicators;                      //@synthesize shouldEverShowTimeIndicators=_shouldEverShowTimeIndicators - In the implementation block
@property (assign,nonatomic) BOOL showsTimeLine; 
@property (assign,nonatomic) BOOL showsTimeMarker; 
@property (assign,nonatomic) BOOL showsTimeLabel;                                    //@synthesize showsTimeLabel=_showsTimeLabel - In the implementation block
@property (assign,nonatomic) BOOL eventsFillGrid; 
@property (assign,nonatomic) BOOL showsLeftBorder; 
@property (assign,nonatomic) BOOL allowsScrolling; 
@property (assign,nonatomic) int outlineStyle;                                       //@synthesize outlineStyle=_outlineStyle - In the implementation block
@property (assign,nonatomic) int occurrenceBackgroundStyle; 
@property (assign,nonatomic) NSRange hoursToRender; 
@property (nonatomic,retain) UIColor * timeViewTextColor; 
@property (nonatomic,retain) UIColor * gridLineColor; 
@property (nonatomic,retain) UIColor * occurrenceTitleColor; 
@property (nonatomic,retain) UIColor * occurrenceLocationColor; 
@property (nonatomic,retain) UIColor * occurrenceTextBackgroundColor;                //@synthesize occurrenceTextBackgroundColor=_occurrenceTextBackgroundColor - In the implementation block
@property (assign,nonatomic) BOOL usesVibrantGridDrawing;                            //@synthesize usesVibrantGridDrawing=_usesVibrantGridDrawing - In the implementation block
@property (nonatomic,readonly) double scrollOffset; 
@property (assign,nonatomic) CGPoint normalizedContentOffset;
@property (nonatomic,readonly) UIView * dayContent;  
-(void)setAllowsOccurrenceSelection:(BOOL)arg1 ;
-(void)setEventsFillGrid:(BOOL)arg1 ;
-(NSArray *)occurrenceViews;
-(void)setShowsLeftBorder:(BOOL)arg1 ;
-(BOOL)showsLeftBorder;
-(void)dayViewContent:(id)arg1 didSelectEvent:(id)arg2 ;
-(UIColor *)occurrenceTitleColor;
-(UIColor *)occurrenceLocationColor;
-(UIColor *)occurrenceTextBackgroundColor;
-(int)occurrenceBackgroundStyle;
-(void)setOccurrenceBackgroundStyle:(int)arg1 ;
-(void)dayViewContent:(id)arg1 didTapPinnedOccurrence:(id)arg2 ;
-(void)dayViewContent:(id)arg1 didTapInEmptySpaceOnDay:(double)arg2 ;
-(id)selectedEvent;
-(void)selectEvent:(id)arg1 ;
-(void)setOccurrenceTitleColor:(UIColor *)arg1 ;
-(void)setOccurrenceLocationColor:(UIColor *)arg1 ;
-(void)setOccurrenceTextBackgroundColor:(UIColor *)arg1 ;
-(void)dayOccurrenceViewClicked:(id)arg1 atPoint:(CGPoint)arg2 ;
-(id)occurrenceViewForEvent:(id)arg1 ;
-(void)configureOccurrenceViewForGestureController:(id)arg1 ;
-(BOOL)allowsOccurrenceSelection;
-(BOOL)eventsFillGrid;
-(void)_localeChanged;
-(CGRect)_scrollerRect;
-(void)_timeViewTapped:(id)arg1 ;
-(void)setShowsTimeMarker:(BOOL)arg1 ;
-(void)_createAllDayView;
-(void)_adjustForDateOrCalendarChange;
-(void)setFirstVisibleSecond:(int)arg1 ;
-(BOOL)showsTimeLine;
-(void)_startMarkerTimer;
-(void)_invalidateMarkerTimer;
-(double)scrollBarOffset;
-(double)_verticalOffset;
-(void)updateMarkerPosition;
-(void)_disposeAllDayView;
-(void)_stopScrolling;
-(void)setShowsTimeLine:(BOOL)arg1 ;
-(BOOL)showsTimeMarker;
-(int)_secondAtPosition:(double)arg1 ;
-(int)firstVisibleSecond;
-(double)_positionOfSecond:(int)arg1 ;
-(void)firstVisibleSecondChanged;
-(NSRange)hoursToRender;
-(void)setHoursToRender:(NSRange)arg1 ;
-(void)setUsesVibrantGridDrawing:(BOOL)arg1 ;
-(void)_scrollToSecond:(int)arg1 animated:(BOOL)arg2 whenFinished:(id)arg3 ;
-(void)_finishedScrollToSecond;
-(BOOL)alignsMidnightToTop;
-(void)_clearVerticalGridExtensionImageCache;
-(id)_generateVerticalGridExtensionImage;
-(void)scrollEventsIntoViewAnimated:(BOOL)arg1 ;
-(void)scrollToEvent:(id)arg1 animated:(BOOL)arg2 ;
-(double)dateAtPoint:(CGPoint)arg1 isAllDay:(BOOL*)arg2 requireAllDayRegionInsistence:(BOOL)arg3 ;
-(BOOL)_showingAllDaySection;
-(double)_adjustSecondForwardForDSTHole:(double)arg1 ;
-(double)_adjustSecondBackwardForDSTHole:(double)arg1 ;
-(double)highlightedHour;
-(void)setAllDayLabelHighlighted:(BOOL)arg1 ;
-(BOOL)isAllDayLabelHighlighted;
-(void)allDayView:(id)arg1 didSelectEvent:(id)arg2 ;
-(void)allDayViewDidLayoutSubviews:(id)arg1 ;
-(void)dayViewContent:(id)arg1 didCreateOccurrenceViews:(id)arg2 ;
-(void)occurrencePressed:(id)arg1 onDay:(double)arg2 ;
-(CGRect)currentTimeRectInView:(id)arg1 ;
-(id)initWithFrame:(CGRect)arg1 orientation:(UIInterfaceOrientation)arg2 displayDate:(id)arg3 backgroundColor:(id)arg4 opaque:(BOOL)arg5 scrollbarShowsInside:(BOOL)arg6 ;
-(void)adjustFrameToSpanToMidnightFromStartDate:(id)arg1 ;
-(void)setDisplayDate:(NSDateComponents *)arg1 ;
-(void)setShouldEverShowTimeIndicators:(BOOL)arg1 ;
-(void)adjustForSignificantTimeChange;
-(void)setShowsTimeLabel:(BOOL)arg1 ;
-(BOOL)allowsScrolling;
-(UIColor *)timeViewTextColor;
-(void)setTimeViewTextColor:(UIColor *)arg1 ;
-(UIColor *)gridLineColor;
-(void)setGridLineColor:(UIColor *)arg1 ;
-(double)scrollOffset;
-(CGPoint)normalizedContentOffset;
-(void)setNormalizedContentOffset:(CGPoint)arg1 ;
-(void)scrollToDate:(id)arg1 animated:(BOOL)arg2 whenFinished:(id)arg3 ;
-(void)dayContentView:(id)arg1 atPoint:(CGPoint)arg2 ;
-(void)dayAllDayView:(id)arg1 occurrenceViewClicked:(id)arg2 ;
-(void)bringEventToFront:(id)arg1 ;
-(void)insertViewForEvent:(id)arg1 belowViewForOtherEvent:(id)arg2 ;
-(void)setAlignsMidnightToTop:(BOOL)arg1 ;
-(void)resetLastSelectedOccurrencePoint;
-(double)yPositionPerhapsMatchingAllDayOccurrence:(id)arg1 ;
-(CGRect)rectForEvent:(id)arg1 ;
-(void)_notifyDelegateOfFinishedScrollingToOccurrence;
-(void)setScrollerYInset:(double)arg1 keepingYPointVisible:(double)arg2 ;
-(void)relayoutExistingTimedOccurrences;
-(id)occurrenceViewAtPoint:(CGPoint)arg1 ;
-(double)dateAtPoint:(CGPoint)arg1 isAllDay:(BOOL*)arg2 ;
-(CGPoint)pointAtDate:(double)arg1 isAllDay:(BOOL)arg2 ;
-(BOOL)scrollTowardPoint:(CGPoint)arg1 ;
-(double)allDayRegionHeight;
-(void)highlightHour:(double)arg1 ;
-(void)addViewToScroller:(id)arg1 isAllDay:(BOOL)arg2 ;
-(double)dayStart;
-(double)dayEnd;
-(BOOL)shouldEverShowTimeIndicators;
-(BOOL)showsTimeLabel;
-(BOOL)usesVibrantGridDrawing;
-(void)dealloc;
-(void)setDataSource:(id<EKDayViewDataSource>)arg1 ;
-(void)setDelegate:(id<EKDayViewDelegate>)arg1 ;
-(void)reloadData;
-(void)layoutSubviews;
-(void)removeFromSuperview;
-(id)description;
-(void)scrollViewDidScroll:(id)arg1 ;
-(void)scrollViewWillBeginDragging:(id)arg1 ;
-(void)scrollViewDidEndDragging:(id)arg1 willDecelerate:(BOOL)arg2 ;
-(void)scrollViewDidEndDecelerating:(id)arg1 ;
-(void)scrollViewDidEndScrollingAnimation:(id)arg1 ;
-(void)setTimeZone:(id)arg1 ;
-(void)willMoveToSuperview:(id)arg1 ;
-(void)setAllowsScrolling:(BOOL)arg1 ;
-(void)setOrientation:(long long)arg1 ;
-(void)setCalendar:(NSCalendar *)arg1 ;
-(double)leftContentInset;
-(int)outlineStyle;
-(void)setOutlineStyle:(int)arg1 ;
- (void)setAllowPinchingHourHeights:(BOOL)arg1;
@end