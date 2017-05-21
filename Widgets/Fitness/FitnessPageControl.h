//
//  FitnessPageControl.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import <UIKit/UIKit.h>

#import "FitnessIconView.h"

#define white_Color [UIColor whiteColor];

#define gray_Color [UIColor colorWithRed:128.0 / 255.0 green:128.0 / 255.0 blue:128.0 / 255.0 alpha:1.0];

#define red_Color [UIColor colorWithRed:251.0 / 255.0 green:22.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];

#define green_Color [UIColor colorWithRed:161.0 / 255.0 green:254.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];

#define blue_Color [UIColor colorWithRed:90.0 / 255.0 green:183.0 / 255.0 blue:252.0 / 255.0 alpha:1.0];

@interface FitnessPageControl : UIView
{
    UIView *white_dot;
    
    UIView *red_dot;
    
    UIView *green_dot;
    
    UIView *blue_dot;
}

-(void)selectPage:(int)index target:(FitnessIconView *)iconView;

@end
