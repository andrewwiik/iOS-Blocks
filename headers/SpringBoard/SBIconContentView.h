#import <UIKit/UIView.h>

@interface SBIconContentView : UIView
@property(assign, nonatomic) int orientation;
-(void)layoutSubviews;
-(void)didAddSubview:(id)subview;
-(void)clearAllFolderContentViews;
-(void)popFolderContentView:(id)view;
-(void)pushFolderContentView:(id)view;
-(void)updateLayoutWithDuration:(double)duration;
-(id)initWithOrientation:(int)orientation;
@end