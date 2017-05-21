//
//  FitnessWidgetViewController.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FitnessWidgetViewController.h"

@implementation FitnessWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad
{
	if (!self.contentView)
    {
        if (!self.iconView)
        {
            self.iconView = [[FitnessIconView alloc] initWithFrame:frame];
        }
        
		self.contentView = [[FitnessContentView alloc] initWithFrame:frame target:self.iconView];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea
{
    return NO;
}

-(BOOL)hasAlternativeIconView
{
    return YES;
}

-(UIView*)alternativeIconViewWithFrame:(CGRect)frame
{
    if (!self.iconView)
    {
        self.iconView = [[FitnessIconView alloc] initWithFrame:frame];
    }else
    {
        self.iconView.frame = frame;
    }
    
    return self.iconView;
}

-(NSArray *)gradientBackgroundColors
{
    return [NSArray arrayWithObjects:@"000000", @"000000", nil];
}

// YES to use a gradient instead of one colour as per customHexColor
-(BOOL)wantsGradientBackground
{
    return YES;
}

@end