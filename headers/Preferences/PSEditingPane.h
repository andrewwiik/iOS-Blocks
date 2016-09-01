#import "PSSpecifier.h"

@interface PSEditingPane : UIView {
    id _delegate;
    unsigned int _requiresKeyboard;
    PSSpecifier *_specifier;
    UIViewController *_viewController;
}

@property (nonatomic) UIViewController *viewController;

+ (id)defaultBackgroundColor;
+ (float)preferredHeight;

- (void)addNewValue;
- (BOOL)changed;
- (id)childViewControllerForHostingViewController;
- (struct CGRect)contentRect;
- (void)didRotateFromInterfaceOrientation:(int)arg1;
- (void)doneEditing;
- (void)editMode;
- (BOOL)handlesDoneButton;
- (id)initWithFrame:(struct CGRect)arg1;
- (void)insetContent;
- (void)layoutInsetContent:(struct CGRect)arg1;
- (id)preferenceSpecifier;
- (id)preferenceValue;
- (BOOL)requiresKeyboard;
- (id)scrollViewToBeInsetted;
- (void)setDelegate:(id)arg1;
- (void)setPreferenceSpecifier:(id)arg1;
- (void)setPreferenceValue:(id)arg1;
- (void)setViewController:(UIViewController *)arg1;
- (BOOL)shouldInsetContent;
- (id)specifierLabel;
- (UIViewController *)viewController;
- (void)viewDidBecomeVisible;
- (BOOL)wantsNewButton;
- (void)willAnimateRotationToInterfaceOrientation:(int)arg1 duration:(double)arg2;
- (void)willRotateToInterfaceOrientation:(int)arg1 duration:(double)arg2;

@end