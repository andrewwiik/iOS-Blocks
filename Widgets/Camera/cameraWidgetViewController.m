//
//  cameraWidgetViewController.m
//  camera
//
//  Created by Pigi Galdi on 11/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "cameraWidgetViewController.h"

@implementation cameraWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
        self.contentView = [[cameraContentView alloc] initWithFrame:frame];
        [self.contentView setIsIpad:isIpad];
	}

	return self.contentView;
}

- (BOOL)hasButtonArea {
    return NO;
}
- (BOOL)hasAlternativeIconView {
    return NO;
}
- (BOOL)wantsGradientBackground {
    return YES;
}
- (NSArray *)gradientBackgroundColors {
    return @[@"898C90", @"D8DDDE"];
}
@end