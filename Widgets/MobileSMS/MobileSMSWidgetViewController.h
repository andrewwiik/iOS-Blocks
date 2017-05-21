//
//  MobileSMSWidgetViewController.h
//  MobileSMS
//
//  Created by gabriele on 10/04/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "MobileSMSContentView.h"

@interface MobileSMSWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) MobileSMSContentView *contentView;

@end