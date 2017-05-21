//
//  ExerciseView.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "ExerciseView.h"

@implementation ExerciseView

-(id)initWithFrame:(CGRect)frame
{
    exerciseLevel = 0.6;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setLevel:(NSString *)level
{
    exerciseLevel = [level floatValue] / 30.0;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* exercise1 = [UIColor colorWithRed: 0.513 green: 0.927 blue: 0 alpha: 1];
    UIColor* exercise2 = [UIColor colorWithRed: 0.706 green: 1 blue: 0 alpha: 1];
    
    //// Gradient Declarations
    CGFloat exerciseGradientLocations[] = {0, 1};
    CGGradientRef exerciseGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)exercise1.CGColor, (id)exercise2.CGColor], exerciseGradientLocations);
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow setShadowBlurRadius: 1];
    
    //// Variable Declarations
    CGFloat exerciseDash = exerciseLevel * 408 + 6;
    
    //// all
    {
        CGContextSaveGState(context);
        CGContextScaleCTM(context, rect.size.width / 148.0, rect.size.height / 148.0);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// MaskOval Drawing
        UIBezierPath* maskOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 148, 148)];
        CGContextSaveGState(context);
        [maskOvalPath addClip];
        CGContextDrawLinearGradient(context, exerciseGradient, CGPointMake(74, -0), CGPointMake(74, 148), 0);
        CGContextRestoreGState(context);
        
        
        //// MaskGroup
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 74, 74);
            CGContextRotateCTM(context, 90 * M_PI / 180);
            
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// MoveMask Drawing
            UIBezierPath* moveMaskPath = UIBezierPath.bezierPath;
            [moveMaskPath moveToPoint: CGPointMake(-65, 0)];
            [moveMaskPath addCurveToPoint: CGPointMake(0, -65) controlPoint1: CGPointMake(-65, -35.9) controlPoint2: CGPointMake(-35.9, -65)];
            [moveMaskPath addCurveToPoint: CGPointMake(65, 0) controlPoint1: CGPointMake(35.9, -65) controlPoint2: CGPointMake(65, -35.9)];
            [moveMaskPath addCurveToPoint: CGPointMake(-0, 65) controlPoint1: CGPointMake(65, 35.9) controlPoint2: CGPointMake(35.9, 65)];
            [moveMaskPath addCurveToPoint: CGPointMake(-65, 0) controlPoint1: CGPointMake(-35.9, 65) controlPoint2: CGPointMake(-65, 35.9)];
            [moveMaskPath closePath];
            moveMaskPath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            moveMaskPath.lineWidth = 17;
            CGFloat moveMaskPattern[] = {exerciseDash, 408};
            [moveMaskPath setLineDash: moveMaskPattern count: 2 phase: 1];
            [moveMaskPath stroke];
            
            
            CGContextEndTransparencyLayer(context);
            
            CGContextRestoreGState(context);
        }
        
        //// ExerciseArrow
        {
            //// middleOrizontalLine Drawing
            UIBezierPath* middleOrizontalLinePath = UIBezierPath.bezierPath;
            [middleOrizontalLinePath moveToPoint: CGPointMake(70, 8.89)];
            [middleOrizontalLinePath addLineToPoint: CGPointMake(77, 8.89)];
            middleOrizontalLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            middleOrizontalLinePath.lineWidth = 2;
            [middleOrizontalLinePath stroke];
            
            
            //// bottomFirstLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77, 8.89);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* bottomFirstLinePath = UIBezierPath.bezierPath;
            [bottomFirstLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [bottomFirstLinePath addLineToPoint: CGPointMake(0, 0)];
            bottomFirstLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            bottomFirstLinePath.lineWidth = 2;
            [bottomFirstLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topFirstLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77, 8.89);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topFirstLinePath = UIBezierPath.bezierPath;
            [topFirstLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topFirstLinePath addLineToPoint: CGPointMake(0, 0)];
            topFirstLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topFirstLinePath.lineWidth = 2;
            [topFirstLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// bottomSecondLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 81, 8.89);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* bottomSecondLinePath = UIBezierPath.bezierPath;
            [bottomSecondLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [bottomSecondLinePath addLineToPoint: CGPointMake(0, 0)];
            bottomSecondLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            bottomSecondLinePath.lineWidth = 2;
            [bottomSecondLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topSecondLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 81, 8.89);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topSecondLinePath = UIBezierPath.bezierPath;
            [topSecondLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topSecondLinePath addLineToPoint: CGPointMake(0, 0)];
            topSecondLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topSecondLinePath.lineWidth = 2;
            [topSecondLinePath stroke];
            
            CGContextRestoreGState(context);
        }
        
        //// exerciseText Drawing
        CGRect exerciseTextRect = CGRectMake(0, 33, 148, 52);
        {
            NSString* textContent = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:exerciseLevel * 30] intValue]];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* exerciseTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            exerciseTextStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* exerciseTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 50], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: exerciseTextStyle};
            
            CGFloat exerciseTextTextHeight = [textContent boundingRectWithSize: CGSizeMake(exerciseTextRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: exerciseTextFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, exerciseTextRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(exerciseTextRect), CGRectGetMinY(exerciseTextRect) + (CGRectGetHeight(exerciseTextRect) - exerciseTextTextHeight) / 2, CGRectGetWidth(exerciseTextRect), exerciseTextTextHeight) withAttributes: exerciseTextFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        //// goal Drawing
        CGRect goalRect = CGRectMake(2, 67, 148, 52);
        {
            NSString* textContent = @"OF 30 MINS";
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
        
        
        CGContextEndTransparencyLayer(context);
        
        CGContextRestoreGState(context);
    }
    
    
    //// Cleanup
    CGGradientRelease(exerciseGradient);
    CGColorSpaceRelease(colorSpace);
}

@end
