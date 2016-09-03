
#import <UIKit/UIView.h>

#import "SBUIPasscodeLockViewDelegate-Protocol.h"

@interface SBUIPasscodeLockViewBase : UIView
@property id<SBUIPasscodeLockViewDelegate> delegate;
@property bool shouldResetForFailedPasscodeAttempt;
@property bool showsEmergencyCallButton;
@property(readonly) NSString * passcode;
@property(retain, nonatomic) UIColor *customBackgroundColor;
@property double backgroundAlpha;
- (void)resetForFailedPasscode;
- (void)setBiometricMatchMode:(unsigned long long)arg1;
- (void)_resetForFailedMesaAttempt;
- (void)autofillForSuccessfulMesaAttemptWithCompletion:(id)arg1;
@end