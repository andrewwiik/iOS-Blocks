
#import <Foundation/NSObject.h>

@protocol SBUIBiometricEventMonitorDelegate <NSObject>
@required
-(void)biometricEventMonitor:(id)monitor handleBiometricEvent:(unsigned)event;
@end
