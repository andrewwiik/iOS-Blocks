
#import <Foundation/NSObject.h>

#import "SBUIPasscodeLockViewBase.h"

@interface SBUIPasscodeLockViewFactory : NSObject
+(SBUIPasscodeLockViewBase*)_passcodeLockViewForStyle:(int)arg1 withLightStyle:(bool)arg2;
+(SBUIPasscodeLockViewBase*)passcodeLockViewForStyle:(int)arg1;
@end