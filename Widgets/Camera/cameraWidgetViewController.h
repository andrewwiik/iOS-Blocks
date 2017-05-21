//
//  cameraWidgetViewController.h
//  camera
//
//  Created by Pigi Galdi on 11/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "cameraContentView.h"

@interface cameraWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) cameraContentView *contentView;

@end