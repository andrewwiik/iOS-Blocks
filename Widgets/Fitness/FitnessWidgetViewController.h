//
//  FitnessWidgetViewController.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "FitnessContentView.h"

@interface FitnessWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) FitnessContentView *contentView;
@property (nonatomic, strong) FitnessIconView *iconView;

@end