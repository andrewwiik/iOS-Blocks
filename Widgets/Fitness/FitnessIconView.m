//
//  FitnessIconView.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "FitnessIconView.h"

@implementation FitnessIconView

-(id)initWithFrame:(CGRect)frame
{
    top = 0;
    
    mid = 0;
    
    bottom = 0;
    
    color = [UIColor whiteColor];
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setColor:(UIColor *)arg
{
    color = arg;
    
    [self setNeedsDisplay];
}

-(void)setCal:(NSString *)cal goal:(NSString *)arg exercise:(NSString *)exercise stand:(NSString *)stand
{
    goal = [arg floatValue];
    
    top = [cal floatValue];
    
    mid = [exercise floatValue];
    
    bottom = [stand floatValue];
}

-(void)drawRect:(CGRect)rect
{
    float d = rect.size.width - 8; //2
    
    float r = d / 2.0;
    
    float pezzetto = d * 22.09 / 80.0;
    
    float d1 = rect.size.width - 16; //12
    
    float r1 = d1 / 2.0;
    
    float pezzetto1 = d1 * 22.09 / 80.0;
    
    float d2 = rect.size.width - 24; //22
    
    float r2 = d2 / 2.0;
    
    float pezzetto2 = d2 * 22.09 / 80.0;
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// BackOval
    {
        //// topOval Drawing
        UIBezierPath* topOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(4, 4, d, d)];
        [[color colorWithAlphaComponent: 0.2] setStroke];
        topOvalPath.lineWidth = 2;
        [topOvalPath stroke];
        
        //// midOval Drawing
        UIBezierPath* midOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(8, 8, d1, d1)];
        [[color colorWithAlphaComponent: 0.2] setStroke];
        midOvalPath.lineWidth = 2;
        [midOvalPath stroke];
        
        //// bottomOval Drawing
        UIBezierPath* bottomOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(12, 12, d2, d2)];
        [[color colorWithAlphaComponent: 0.2] setStroke];
        bottomOvalPath.lineWidth = 2;
        [bottomOvalPath stroke];
    }
    
    
    //// MaskOval
    {
        //// top_maskOval Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rect.size.width / 2.0, rect.size.width / 2.0);
        CGContextRotateCTM(context, 90 * M_PI / 180);
        
        UIBezierPath* top_maskOvalPath = UIBezierPath.bezierPath;
        [top_maskOvalPath moveToPoint: CGPointMake(-r, 0)];
        [top_maskOvalPath addCurveToPoint: CGPointMake(0, -r) controlPoint1: CGPointMake(-r, -pezzetto) controlPoint2: CGPointMake(-pezzetto, -r)];
        [top_maskOvalPath addCurveToPoint: CGPointMake(r, 0) controlPoint1: CGPointMake(pezzetto, -r) controlPoint2: CGPointMake(r, -pezzetto)];
        [top_maskOvalPath addCurveToPoint: CGPointMake(-0, r) controlPoint1: CGPointMake(r, pezzetto) controlPoint2: CGPointMake(pezzetto, r)];
        [top_maskOvalPath addCurveToPoint: CGPointMake(-r, 0) controlPoint1: CGPointMake(-pezzetto, r) controlPoint2: CGPointMake(-r, pezzetto)];
        [top_maskOvalPath closePath];
        [color setStroke];
        top_maskOvalPath.lineWidth = 2;
        CGFloat top_maskOvalPattern[] = {top / goal * r * 2 * M_PI, r * 2 * M_PI};
        [top_maskOvalPath setLineDash: top_maskOvalPattern count: 2 phase: 0];
        [top_maskOvalPath stroke];
        
        CGContextRestoreGState(context);
        
        //// mid_maskOval Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rect.size.width / 2.0, rect.size.width / 2.0);
        CGContextRotateCTM(context, 90 * M_PI / 180);
        
        UIBezierPath* mid_maskOvalPath = UIBezierPath.bezierPath;
        [mid_maskOvalPath moveToPoint: CGPointMake(-r1, 0)];
        [mid_maskOvalPath addCurveToPoint: CGPointMake(0, -r1) controlPoint1: CGPointMake(-r1, -pezzetto1) controlPoint2: CGPointMake(-pezzetto1, -r1)];
        [mid_maskOvalPath addCurveToPoint: CGPointMake(r1, 0) controlPoint1: CGPointMake(pezzetto, -r1) controlPoint2: CGPointMake(r1, -pezzetto1)];
        [mid_maskOvalPath addCurveToPoint: CGPointMake(-0, r1) controlPoint1: CGPointMake(r1, pezzetto1) controlPoint2: CGPointMake(pezzetto1, r1)];
        [mid_maskOvalPath addCurveToPoint: CGPointMake(-r1, 0) controlPoint1: CGPointMake(-pezzetto1, r1) controlPoint2: CGPointMake(-r1, pezzetto1)];
        [mid_maskOvalPath closePath];
        [color setStroke];
        mid_maskOvalPath.lineWidth = 2;
        CGFloat mid_maskOvalPattern[] = {mid / 30.0 * r1 * 2 * M_PI, r1 * 2 * M_PI};
        [mid_maskOvalPath setLineDash: mid_maskOvalPattern count: 2 phase: 0];
        [mid_maskOvalPath stroke];
        
        CGContextRestoreGState(context);
        
        //// bottom_maskOval Drawing
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, rect.size.width / 2.0, rect.size.width / 2.0);
        CGContextRotateCTM(context, 90 * M_PI / 180);
        
        UIBezierPath* bottom_maskOvalPath = UIBezierPath.bezierPath;
        [bottom_maskOvalPath moveToPoint: CGPointMake(-r2, 0)];
        [bottom_maskOvalPath addCurveToPoint: CGPointMake(0, -r2) controlPoint1: CGPointMake(-r2, -pezzetto2) controlPoint2: CGPointMake(-pezzetto2, -r2)];
        [bottom_maskOvalPath addCurveToPoint: CGPointMake(r2, 0) controlPoint1: CGPointMake(pezzetto2, -r2) controlPoint2: CGPointMake(r2, -pezzetto2)];
        [bottom_maskOvalPath addCurveToPoint: CGPointMake(-0, r2) controlPoint1: CGPointMake(r2, pezzetto2) controlPoint2: CGPointMake(pezzetto2, r2)];
        [bottom_maskOvalPath addCurveToPoint: CGPointMake(-r2, 0) controlPoint1: CGPointMake(-pezzetto2, r2) controlPoint2: CGPointMake(-r2, pezzetto2)];
        [bottom_maskOvalPath closePath];
        [color setStroke];
        bottom_maskOvalPath.lineWidth = 2;
        CGFloat bottom_maskOvalPattern[] = {bottom / 12.0 * r2 * 2 * M_PI, r2 * 2 * M_PI};
        [bottom_maskOvalPath setLineDash: bottom_maskOvalPattern count: 2 phase: 0];
        [bottom_maskOvalPath stroke];
        
        CGContextRestoreGState(context);
    }
}

@end
