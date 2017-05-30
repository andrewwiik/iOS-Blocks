@protocol _SBUIBiometricKitInterfaceDelegate
@required
- (void)biometricKitInterface:(id)interface handleEvent:(unsigned long long)event;
@end

@interface _SBUIBiometricKitInterface : NSObject
@property (assign,nonatomic) id<_SBUIBiometricKitInterfaceDelegate> delegate;
- (void)cancel;
- (void)setDelegate:(id<_SBUIBiometricKitInterfaceDelegate>)arg1;
- (int)detectFingerWithOptions:(id)arg1 ;
- (int)matchWithMode:(unsigned long long)arg1 andCredentialSet:(id)arg2;
@end