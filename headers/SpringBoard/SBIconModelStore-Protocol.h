#import <Foundation/NSObject.h>

@protocol SBIconModelStore <NSObject>
@required
-(id)loadDesiredIconState:(id*)arg1;
-(id)loadCurrentIconState:(id*)arg1;
-(BOOL)deleteDesiredIconState:(id*)arg1;
-(BOOL)deleteCurrentIconState:(id*)arg1;
-(BOOL)saveDesiredIconState:(id)arg1 error:(id*)arg2;
-(BOOL)saveCurrentIconState:(id)arg1 error:(id*)arg2;

@end