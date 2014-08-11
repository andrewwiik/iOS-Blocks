//
//  IBKWidgetViewController.h
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//
//

#import <UIKit/UIKit.h>
#import <SpringBoard7.0/SBIconImageView.h>
#import "IBKWidget.h"
#import <BulletinBoard/BBObserver.h>
#import <SpringBoard7.0/SBIconView.h>

@interface IBKWidgetViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id<IBKWidget> widget;
@property (nonatomic, copy) NSString *applicationIdentifer;
@property (nonatomic, strong) UIView *iconImageView; // This may be set as a UIImageView or SBIconImageView
@property (nonatomic, weak) SBIconView *correspondingIconView;
@property (nonatomic, strong) NSBundle *widgetBundle;
@property (nonatomic, strong) BBObserver *notificationObserver;
@property (nonatomic, strong) UITableView *notificationsTableView;
@property (nonatomic, strong) NSMutableArray *notificationsDataSource; // This is full of BBBulletins.
@property (readwrite) BOOL fallbackToNotificationList;
@property (readwrite) BOOL isWidgetLoaded;

-(void)setScaleForView:(CGFloat)scale withDuration:(CGFloat)duration;
-(void)layoutViewForPreExpandedWidget;
-(void)loadWidgetInterface; // Call when pinch out recognised
-(void)unloadWidgetInterface; // Call when recycling view
-(void)unloadFromPinchGesture;

-(void)addBulletin:(id)arg2;
-(void)removeBulletin:(id)arg2;

-(NSString*)getPathForMainBundle;

@end
