//
//  FitnessIconView.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

@interface FitnessIconView : UIView
{
    float top, mid, bottom , goal;
    
    UIColor *color;
}

-(void)setColor:(UIColor *)arg;
-(void)setCal:(NSString *)cal goal:(NSString *)arg exercise:(NSString *)exercise stand:(NSString *)stand;

@end