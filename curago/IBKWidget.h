//
//  IBKWidget.h
//  curago
//
//  Created by Matt Clarke on 10/06/2014.
//
//

#import <Foundation/Foundation.h>

@protocol IBKWidget <NSObject>

@required
-(UIView*)view;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@optional
-(UIView*)buttonAreaView;
-(UIView*)alternativeIconView;
-(void)willRotateToInterfaceOrientation:(int)arg1;
-(void)didRotateToInterfaceOrientation:(int)arg1;

@end
