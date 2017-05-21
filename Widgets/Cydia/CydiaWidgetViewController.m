//
//  CydiaWidgetViewController.m
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "CydiaWidgetViewController.h"

@implementation CydiaWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[CydiaContentView alloc] initWithFrame:frame];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return NO;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

-(NSArray*)gradientBackgroundColors{
    return [NSArray arrayWithObjects:@"623526", @"da9c6e", nil];
}

-(BOOL)wantsGradientBackground
{
    return YES;
}

@end