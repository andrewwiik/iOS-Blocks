//
//  MoveView.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "MoveView.h"

@implementation MoveView

-(id)initWithFrame:(CGRect)frame
{
    moveLevel = 0.0;
    
    goal = 250.0;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setLevel:(NSString *)level goal:(NSString *)arg
{
    moveLevel = [level floatValue] / [arg floatValue];
    
    goal = [arg intValue];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* move1 = [UIColor colorWithRed: 0.976 green: 0 blue: 0.055 alpha: 1];
    UIColor* move2 = [UIColor colorWithRed: 1 green: 0 blue: 0.674 alpha: 1];
    
    //// Gradient Declarations
    CGFloat moveGradientLocations[] = {0, 1};
    CGGradientRef moveGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)move1.CGColor, (id)move2.CGColor], moveGradientLocations);
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow setShadowBlurRadius: 1];
    
    //// Variable Declarations
    CGFloat moveDash = moveLevel * 408 + 6;
    
    //// all
    {
        CGContextSaveGState(context);
        CGContextScaleCTM(context, rect.size.width / 148.0, rect.size.height / 148.0);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// MaskOval Drawing
        UIBezierPath* maskOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 148, 148)];
        CGContextSaveGState(context);
        [maskOvalPath addClip];
        CGContextDrawLinearGradient(context, moveGradient, CGPointMake(74, -0), CGPointMake(74, 148), 0);
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
            CGFloat moveMaskPattern[] = {moveDash, 408};
            [moveMaskPath setLineDash: moveMaskPattern count: 2 phase: 1];
            [moveMaskPath stroke];
            
            
            CGContextEndTransparencyLayer(context);
            
            CGContextRestoreGState(context);
        }
        
        
        //// MoveArrow
        {
            //// middleMoveLine Drawing
            UIBezierPath* middleMoveLinePath = UIBezierPath.bezierPath;
            [middleMoveLinePath moveToPoint: CGPointMake(70.5, 8.5)];
            [middleMoveLinePath addLineToPoint: CGPointMake(77.5, 8.5)];
            middleMoveLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            middleMoveLinePath.lineWidth = 2;
            [middleMoveLinePath stroke];
            
            
            //// bottomLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77.5, 8.5);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* bottomLinePath = UIBezierPath.bezierPath;
            [bottomLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [bottomLinePath addLineToPoint: CGPointMake(0, 0)];
            bottomLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            bottomLinePath.lineWidth = 2;
            [bottomLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77.5, 8.5);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topLinePath = UIBezierPath.bezierPath;
            [topLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topLinePath addLineToPoint: CGPointMake(0, 0)];
            topLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topLinePath.lineWidth = 2;
            [topLinePath stroke];
            
            CGContextRestoreGState(context);
        }
        
        
        //// moveText Drawing
        CGRect moveTextRect = CGRectMake(0, 33, 148, 52);
        {
            NSString* textContent = [NSString stringWithFormat:@"%d", [[NSNumber numberWithFloat:moveLevel * goal] intValue]];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* moveTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            moveTextStyle.alignment = NSTextAlignmentCenter;
            
            NSDictionary* moveTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: 50], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: moveTextStyle};
            
            CGFloat moveTextTextHeight = [textContent boundingRectWithSize: CGSizeMake(moveTextRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: moveTextFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, moveTextRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(moveTextRect), CGRectGetMinY(moveTextRect) + (CGRectGetHeight(moveTextRect) - moveTextTextHeight) / 2, CGRectGetWidth(moveTextRect), moveTextTextHeight) withAttributes: moveTextFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        //// goal Drawing
        CGRect goalRect = CGRectMake(2, 67, 148, 52);
        {
            NSString* textContent = [NSString stringWithFormat:@"OF %d CALS", goal];
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
    CGGradientRelease(moveGradient);
    CGColorSpaceRelease(colorSpace);
}


@end
