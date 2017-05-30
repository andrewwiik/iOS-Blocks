//
//  IBKWidgetLockView.h
//  curago
//
//  Created by Matt Clarke on 13/04/2015.
//
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"

#import "../headers/SpringBoard/SpringBoard.h"
#import "../headers/BiometricKit/BiometricKit.h"
#import "../headers/UIKit/UIKit-Private.h"

#import "IBKResources.h"

#define TouchIDFingerDown  1
#define TouchIDFingerUp    0
#define TouchIDFingerHeld  2
#define TouchIDMatched     3
#define TouchIDMaybeMatched 4
#define TouchIDNotMatched  9
#define TouchIDNotMatched2 10

@interface IBKWidgetLockView : UIView <SBUIPasscodeLockViewDelegate, SBUIBiometricEventMonitorDelegate, _SBUIBiometricKitInterfaceDelegate> {
	id _oldDelegate;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MarqueeLabel *buttonLabel;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) NSString *passcodeHash;
@property (nonatomic, strong) UIView *backdropView;
@property (nonatomic, strong) SBUIPasscodeLockViewBase *passcodeView;
@property (nonatomic, strong) UIWindow *ipadWindow;
@property (nonatomic, assign) BOOL isMonitoring;
 

- (id)initWithFrame:(CGRect)frame passcodeHash:(NSString*)hash isLight:(BOOL)isLight;
- (void)biometricKitInterface:(id)interface handleEvent:(unsigned long long)event;
- (void)matchResult:(id)result withDetails:(id)details;
- (void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event;
- (void)startMonitoring;
- (void)stopMonitoring;

@end
