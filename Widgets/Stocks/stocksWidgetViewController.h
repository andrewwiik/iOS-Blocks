//
//  stocksWidgetViewController.h
//  stocks
//
//  Created by Pigi Galdi on 10/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "stocksContentView.h"

@interface stocksWidgetViewController : NSObject <IBKWidgetDelegate>

@property (nonatomic, strong) stocksContentView *contentView;

@end