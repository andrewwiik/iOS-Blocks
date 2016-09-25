#import <Foundation/NSObject.h>

@interface WeatherHTTPRequest : NSObject

+ (void)appendDebugString:(id)arg1;
+ (void)saveDebugString;

- (id)aggregateDictionaryDomain;
- (void)cancel;
- (id)connection;
- (void)connection:(id)arg1 didFailWithError:(id)arg2;
- (void)connection:(id)arg1 didReceiveData:(id)arg2;
- (void)connection:(id)arg1 didReceiveResponse:(id)arg2;
- (void)connectionDidFinishLoading:(id)arg1;
- (void)failWithError:(id)arg1;
- (id)init;
- (BOOL)isLoading;
- (void)loadRequest:(id)arg1;
- (void)request:(id)arg1 receivedResponseData:(id)arg2;

@end