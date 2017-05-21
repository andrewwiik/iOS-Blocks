//
//  FitnessPageControl.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "FitnessPageControl.h"

@implementation FitnessPageControl

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        float size = frame.size.height;
        
        float space = (frame.size.width - size * 4.0) / 3.0;
        
        white_dot = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, size, size)];
        
        white_dot.backgroundColor = white_Color;
        
        white_dot.layer.cornerRadius = white_dot.frame.size.height / 2.0;
        
        [self addSubview:white_dot];
        
        red_dot = [[UIView alloc] initWithFrame:CGRectMake(white_dot.frame.origin.x + white_dot.frame.size.width + space, 0.0, size, size)];
        
        red_dot.backgroundColor = gray_Color;
        
        red_dot.layer.cornerRadius = red_dot.frame.size.height / 2.0;
        
        [self addSubview:red_dot];
        
        green_dot = [[UIView alloc] initWithFrame:CGRectMake(red_dot.frame.origin.x + red_dot.frame.size.width + space, 0.0, size, size)];
        
        green_dot.backgroundColor = gray_Color;
        
        green_dot.layer.cornerRadius = green_dot.frame.size.height / 2.0;
        
        [self addSubview:green_dot];
        
        blue_dot = [[UIView alloc] initWithFrame:CGRectMake(green_dot.frame.origin.x + green_dot.frame.size.width + space, 0.0, size, size)];
        
        blue_dot.backgroundColor = gray_Color;
        
        blue_dot.layer.cornerRadius = blue_dot.frame.size.height / 2.0;
        
        [self addSubview:blue_dot];
    }
    
    return self;
}

-(void)layoutSubviews
{
    float size = self.frame.size.height;
    
    float space = (self.frame.size.width - size * 4.0) / 3.0;
    
    white_dot.frame = CGRectMake(0.0, 0.0, size, size);
    
    white_dot.layer.cornerRadius = white_dot.frame.size.height / 2.0;
    
    red_dot.frame = CGRectMake(white_dot.frame.origin.x + white_dot.frame.size.width + space, 0.0, size, size);
    
    red_dot.layer.cornerRadius = red_dot.frame.size.height / 2.0;
    
    green_dot.frame = CGRectMake(red_dot.frame.origin.x + red_dot.frame.size.width + space, 0.0, size, size);
    
    green_dot.layer.cornerRadius = green_dot.frame.size.height / 2.0;
    
    blue_dot.frame = CGRectMake(green_dot.frame.origin.x + green_dot.frame.size.width + space, 0.0, size, size);
    
    blue_dot.layer.cornerRadius = blue_dot.frame.size.height / 2.0;
}

-(void)selectPage:(int)index target:(FitnessIconView *)iconView
{
    switch (index) {
        case 0:
            
            white_dot.backgroundColor = white_Color;
            
            red_dot.backgroundColor = gray_Color;
            
            green_dot.backgroundColor = gray_Color;
            
            blue_dot.backgroundColor = gray_Color;
            
            [iconView setColor:white_dot.backgroundColor];
            
            break;
            
        case 1:
            
            white_dot.backgroundColor = gray_Color;
            
            red_dot.backgroundColor = red_Color;
            
            green_dot.backgroundColor = gray_Color;
            
            blue_dot.backgroundColor = gray_Color;
            
            [iconView setColor:red_dot.backgroundColor];
            
            break;
            
        case 2:
            
            white_dot.backgroundColor = gray_Color;
            
            red_dot.backgroundColor = gray_Color;
            
            green_dot.backgroundColor = green_Color;
            
            blue_dot.backgroundColor = gray_Color;
            
            [iconView setColor:green_dot.backgroundColor];
            
            break;
            
        case 3:
            
            white_dot.backgroundColor = gray_Color;
            
            red_dot.backgroundColor = gray_Color;
            
            green_dot.backgroundColor = gray_Color;
            
            blue_dot.backgroundColor = blue_Color;
            
            [iconView setColor:blue_dot.backgroundColor];
            
            break;
            
        default:
            
            white_dot.backgroundColor = gray_Color;
            
            red_dot.backgroundColor = gray_Color;
            
            green_dot.backgroundColor = gray_Color;
            
            blue_dot.backgroundColor = gray_Color;
            
            [iconView setColor:white_dot.backgroundColor];
            
            break;
    }
}

@end
