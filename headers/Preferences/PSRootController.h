@class PSListController;

@interface PSRootController : UINavigationController

- (instancetype)initWithTitle:(NSString *)title identifier:(NSString *)identifier;

- (void)pushController:(PSListController *)controller; // < 3.2
- (void)pushController:(id)arg1 animate:(bool)arg2;
- (void)pushViewController:(id)arg1 animated:(BOOL)animated;
- (id)popViewControllerAnimated:(bool)arg1;
- (void)suspend;


@end
