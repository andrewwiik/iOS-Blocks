//
//  MobileSMSWidgetViewController.m
//  MobileSMS
//
//  Created by gabriele on 10/04/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "MobileSMSWidgetViewController.h"

@implementation MobileSMSWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[MobileSMSContentView alloc] initWithFrame:frame];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return NO;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

-(BOOL)wantsGradientBackground
{
    return YES;
}

-(NSArray *)gradientBackgroundColors
{
    return [NSArray arrayWithObjects:@"38c33b", @"60c359", nil];
}

@end