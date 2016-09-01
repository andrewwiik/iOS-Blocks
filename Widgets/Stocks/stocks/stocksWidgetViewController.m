//
//  stocksWidgetViewController.m
//  stocks
//
//  Created by Pigi Galdi on 10/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "stocksWidgetViewController.h"

@implementation stocksWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[stocksContentView alloc] initWithFrame:frame];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return YES;
}
-(BOOL)hasAlternativeIconView {
    return NO;
}
-(BOOL)wantsGradientBackground {
    return YES;
}
-(NSArray *)gradientBackgroundColors {
    return @[@"2B2B2B", @"4A4A4A"];
}
@end