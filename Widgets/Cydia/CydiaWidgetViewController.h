//
//  CydiaWidgetViewController.h
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "CydiaContentView.h"

@interface CydiaWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) CydiaContentView *contentView;

@end