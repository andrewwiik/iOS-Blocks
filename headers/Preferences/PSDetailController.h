#import "PSViewController.h"

@class PSEditingPane;

@interface PSDetailController : PSViewController {
    PSEditingPane *_pane;
}

@property (nonatomic) PSEditingPane *pane;

- (void)didRotateFromInterfaceOrientation:(int)arg1;
- (void)loadPane;
- (void)loadView;
- (PSEditingPane *)pane;
- (struct CGRect)paneFrame;
- (void)saveChanges;
- (void)setPane:(PSEditingPane *)arg1;
- (void)statusBarWillAnimateByHeight:(float)arg1;
- (void)suspend;
- (id)title;
- (void)viewDidAppear:(BOOL)arg1;
- (void)viewDidLayoutSubviews;
- (void)viewDidUnload;
- (void)viewWillAppear:(BOOL)arg1;
- (void)viewWillDisappear:(BOOL)arg1;
- (void)willAnimateRotationToInterfaceOrientation:(int)arg1 duration:(double)arg2;
- (void)willRotateToInterfaceOrientation:(int)arg1 duration:(double)arg2;

@end