//
//  IBKWidgetViewController.h
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//
//

#import <UIKit/UIKit.h>

#import "IBKWidget.h"
#import "IBKGameCenterTableView.h"
#import "IBKWidgetTopBase.h"
#import "IBKWidgetLockView.h"
#import "IBKLabel.h"
#import "IBKWidgetBaseView.h"
#import "SBIconView+IBK.h"

#import "../headers/SpringBoard/SpringBoard.h"
#import "../headers/BulletinBoard/BBObserver.h"
// #import <SpringBoard/SBIconController.h>

@interface IBKWidgetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBKWidgetTopBase *topBase;
    NSMutableArray *_notificationsDataSource;
    NSDictionary *_infoPlist;
    long long _usedOrientation;
}

@property (nonatomic,strong) IBKWidgetBaseView *view;
@property (nonatomic, strong) NSObject<IBKWidget> *widget;
@property (nonatomic, retain) NSBundle *bundle;
@property (nonatomic, strong) UIView *viw;
@property (nonatomic, strong) UIView *buttons;
@property (nonatomic, strong) UIView *alternateIcon;
@property (nonatomic, strong) UIImageView *otherIcon;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, copy) NSString *applicationIdentifer;
@property (nonatomic, strong) UIView *iconImageView; // This may be set as a UIImageView or SBIconImageView
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, weak) SBIconView *correspondingIconView;
@property (nonatomic, strong) NSBundle *widgetBundle;
@property (nonatomic, strong) BBObserver *notificationObserver;
@property (nonatomic, strong) UITableView *notificationsTableView;
@property (nonatomic, strong) IBKGameCenterTableView *gcTableView;
@property (nonatomic, strong) IBKLabel *noNotifsLabel;
@property (nonatomic, strong) UIView *shimIcon;
@property (nonatomic, strong) NSMutableArray *notificationsDataSource; // This is full of BBBulletins.

@property (nonatomic) CGFloat currentScale;
@property (readwrite) BOOL fallbackToNotificationList;
@property (readwrite) BOOL isWidgetLoaded;
@property (readwrite) BOOL scalingDown;
@property (readwrite) BOOL isLight;
@property (readwrite) BOOL isLocked;

@property (nonatomic, strong) IBKWidgetLockView *lockView;

- (IBKWidgetBaseView *)view;
- (void)setView:(IBKWidgetBaseView *)view;

-(void)setScaleForView:(CGFloat)scale withDuration:(CGFloat)duration;
-(void)layoutViewForPreExpandedWidget;
-(void)loadWidgetInterface; // Call when pinch out recognised
-(void)unloadWidgetInterface; // Call when recycling view
-(void)unloadFromPinchGesture;
-(void)handlePinchGesture:(UIPinchGestureRecognizer*)pinch;
-(void)performRotationWithDuration:(CGFloat)duration;
-(void)closeWidgetAnimated;

-(void)addBulletin:(id)arg2;
-(void)removeBulletin:(id)arg2;

-(NSString*)getPathForMainBundle;
-(void)reloadWidgetForSettingsChange;

-(UIView*)topBase;

-(long long)usedOrientation;

-(void)lockWidget;
-(void)unlockWidget;

@end
