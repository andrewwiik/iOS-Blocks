//
//  StandView.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "StandView.h"

@implementation StandView

-(id)initWithFrame:(CGRect)frame
{
    standLevel = 0.2;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setLevel:(NSString *)level
{
    standLevel = [level floatValue] / 12.0;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* stand1 = [UIColor colorWithRed: 0 green: 0.851 blue: 0.831 alpha: 1];
    UIColor* stand2 = [UIColor colorWithRed: 0 green: 1 blue: 0.906 alpha: 1];
    
    //// Gradient Declarations
    CGFloat exerciseGradientLocations[] = {0, 1};
    CGGradientRef exerciseGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)stand1.CGColor, (id)stand2.CGColor], exerciseGradientLocations);
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow setShadowBlurRadius: 1];
    
    //// Variable Declarations
    CGFloat standDash = standLevel * 408 + 6;
    
    //// all
    {
        CGContextSaveGState(context);
        CGContextScaleCTM(context, rect.size.width / 148.0, rect.size.height / 148.0);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// StandOval Drawing
        UIBezierPath* standOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 148, 148)];
        CGContextSaveGState(context);
        [standOvalPath addClip];
        CGContextDrawLinearGradient(context, exerciseGradient, CGPointMake(74, -0), CGPointMake(74, 148), 0);
        CGContextRestoreGState(context);
        
        
        //// MaskGroup
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 74, 74);
            CGContextRotateCTM(context, 90 * M_PI / 180);
            
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// StandMask Drawing
            UIBezierPath* standMaskPath = UIBezierPath.bezierPath;
            [standMaskPath moveToPoint: CGPointMake(-65, 0)];
            [standMaskPath addCurveToPoint: CGPointMake(0, -65) controlPoint1: CGPointMake(-65, -35.9) controlPoint2: CGPointMake(-35.9, -65)];
            [standMaskPath addCurveToPoint: CGPointMake(65, 0) controlPoint1: CGPointMake(35.9, -65) controlPoint2: CGPointMake(65, -35.9)];
            [standMaskPath addCurveToPoint: CGPointMake(-0, 65) controlPoint1: CGPointMake(65, 35.9) controlPoint2: CGPointMake(35.9, 65)];
            [standMaskPath addCurveToPoint: CGPointMake(-65, 0) controlPoint1: CGPointMake(-35.9, 65) controlPoint2: CGPointMake(-65, 35.9)];
            [standMaskPath closePath];
            standMaskPath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            standMaskPath.lineWidth = 17;
            CGFloat standMaskPattern[] = {standDash, 408};
            [standMaskPath setLineDash: standMaskPattern count: 2 phase: 1];
            [standMaskPath stroke];
            
            
            CGContextEndTransparencyLayer(context);
            
            CGContextRestoreGState(context);
        }
        
        
        //// standText Drawing
        CGRect standTextRect = CGRectMake(0, 33, 148, 52);
        {
            NSString* textContent = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:standLevel * 12] intValue]];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* standTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            standTextStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* standTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 50], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: standTextStyle};
            
            CGFloat standTextTextHeight = [textContent boundingRectWithSize: CGSizeMake(standTextRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: standTextFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, standTextRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(standTextRect), CGRectGetMinY(standTextRect) + (CGRectGetHeight(standTextRect) - standTextTextHeight) / 2, CGRectGetWidth(standTextRect), standTextTextHeight) withAttributes: standTextFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        //// goal Drawing
        CGRect goalRect = CGRectMake(2, 67, 148, 52);
        {
            NSString* textContent = @"OF 12 HRS";
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* goalStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            goalStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* goalFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 15], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: goalStyle};
            
            CGFloat goalTextHeight = [textContent boundingRectWithSize: CGSizeMake(goalRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: goalFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, goalRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(goalRect), CGRectGetMinY(goalRect) + (CGRectGetHeight(goalRect) - goalTextHeight) / 2, CGRectGetWidth(goalRect), goalTextHeight) withAttributes: goalFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        //// StandArrow
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 75, 9);
            CGContextRotateCTM(context, -90 * M_PI / 180);
            
            
            
            //// middleLine Drawing
            UIBezierPath* middleLinePath = UIBezierPath.bezierPath;
            [middleLinePath moveToPoint: CGPointMake(-3.5, 0)];
            [middleLinePath addLineToPoint: CGPointMake(3.5, 0)];
            middleLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            middleLinePath.lineWidth = 2;
            [middleLinePath stroke];
            
            
            //// toRightLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 3.5, 0);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* toRightLinePath = UIBezierPath.bezierPath;
            [toRightLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [toRightLinePath addLineToPoint: CGPointMake(0, 0)];
            toRightLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            toRightLinePath.lineWidth = 2;
            [toRightLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topLeftLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 3.5, 0);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topLeftLinePath = UIBezierPath.bezierPath;
            [topLeftLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topLeftLinePath addLineToPoint: CGPointMake(0, 0)];
            topLeftLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topLeftLinePath.lineWidth = 2;
            [topLeftLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            
            CGContextRestoreGState(context);
        }
        
        
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
    }
    
    
    //// Cleanup
    CGGradientRelease(exerciseGradient);
    CGColorSpaceRelease(colorSpace);
}

@end
