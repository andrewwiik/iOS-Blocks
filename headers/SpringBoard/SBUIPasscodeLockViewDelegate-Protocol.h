
#import <Foundation/NSObject.h>

@protocol SBUIPasscodeLockViewDelegate <NSObject>
@optional
-(void)passcodeLockViewEmergencyCallButtonPressed:(id)pressed;
-(void)passcodeLockViewCancelButtonPressed:(id)pressed;
-(void)passcodeLockViewPasscodeEntered:(id)entered;
-(void)passcodeLockViewPasscodeDidChange:(id)passcodeLockViewPasscode;
@end