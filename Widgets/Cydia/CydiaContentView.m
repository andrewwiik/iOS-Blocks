//
//  CydiaContentView.m
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CydiaContentView.h"

@implementation CydiaContentView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        table = [[cydiaTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, [self contentViewHeight])];
        [self addSubview:table];
    }

    return self;
}

-(float)contentViewHeight {
    return [NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.saurik.cydia"] - 5;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    table.frame = CGRectMake(0.0, 0.0, self.frame.size.width, [self contentViewHeight]);
}

@end
