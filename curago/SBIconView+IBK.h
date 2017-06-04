
@interface SBIconView (IBK)
@property (nonatomic, retain) UIView *widgetView;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeDown;
@property (nonatomic, assign) BOOL shouldHaveBlock;
@property (nonatomic, retain) UIView *widgetViewHolder;
@property (nonatomic, assign) NSInteger ibk_allowBlockState;
@property (nonatomic, assign) BOOL isKazeIconView;
@property (nonatomic, assign) BOOL forceOriginalLabelFrame;
- (void)checkRootListViewPlacement;
- (void)ibk_removeWidgetView;
- (void)ibk_loadWidgetView;
@end