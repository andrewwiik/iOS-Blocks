@interface STKGroup : NSObject
@property (nonatomic, assign) BOOL empty;
@end


@interface STKGroupView : UIView
@property (nonatomic, assign) BOOL isOpen;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, retain) STKGroup *group;
@end