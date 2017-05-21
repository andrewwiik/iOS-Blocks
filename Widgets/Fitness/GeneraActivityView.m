//
//  GeneraActivityView.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "GeneraActivityView.h"

@implementation GeneraActivityView

-(id)initWithFrame:(CGRect)frame
{
    standLevel = 0.0;
    
    moveLevel = 0.0;
    
    exercizeLevel = 0.0;
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

-(void)setCal:(NSString *)cal goal:(NSString *)goal exercise:(NSString *)exercise stand:(NSString *)stand
{
    moveLevel = [cal floatValue] / [goal floatValue];
    
    exercizeLevel = [exercise floatValue] / 30.0;
    
    standLevel = [stand floatValue] / 12.0;
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* stand2 = [UIColor colorWithRed: 0 green: 1 blue: 0.904 alpha: 1];
    UIColor* stand1 = [UIColor colorWithRed: 0 green: 0.851 blue: 0.83 alpha: 1];
    UIColor* move1 = [UIColor colorWithRed: 0.976 green: 0 blue: 0.055 alpha: 1];
    UIColor* exercise1 = [UIColor colorWithRed: 0.513 green: 0.927 blue: 0 alpha: 1];
    UIColor* exercise2 = [UIColor colorWithRed: 0.706 green: 1 blue: 0 alpha: 1];
    UIColor* move2 = [UIColor colorWithRed: 1 green: 0 blue: 0.674 alpha: 1];
    
    //// Gradient Declarations
    CGFloat standGradientLocations[] = {0, 1};
    CGGradientRef standGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)stand1.CGColor, (id)stand2.CGColor], standGradientLocations);
    CGFloat moveGradientLocations[] = {0, 1};
    CGGradientRef moveGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)move1.CGColor, (id)move2.CGColor], moveGradientLocations);
    CGFloat exerciseGradientLocations[] = {0, 1};
    CGGradientRef exerciseGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)@[(id)exercise1.CGColor, (id)exercise2.CGColor], exerciseGradientLocations);
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(0.1, -0.1)];
    [shadow setShadowBlurRadius: 1];
    
    //// Variable Declarations
    CGFloat standDash = standLevel * 182 + 6;
    CGFloat moveDash = moveLevel * 408 + 6;
    CGFloat exersizeDash = exercizeLevel * 295 + 6;
    
    //// All
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, -1);
        CGContextScaleCTM(context, rect.size.width / 148.0, rect.size.height / 148.0);
        
        CGContextBeginTransparencyLayer(context, NULL);
        
        
        //// ColorGroup
        {
            //// MaskOval Drawing
            UIBezierPath* maskOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 1, 148, 148)];
            CGContextSaveGState(context);
            [maskOvalPath addClip];
            CGContextDrawLinearGradient(context, moveGradient, CGPointMake(74, 1), CGPointMake(74, 149), 0);
            CGContextRestoreGState(context);
            
            
            //// ExerciseOval Drawing
            UIBezierPath* exerciseOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(18, 19, 112, 112)];
            CGContextSaveGState(context);
            [exerciseOvalPath addClip];
            CGContextDrawLinearGradient(context, exerciseGradient, CGPointMake(74, 19), CGPointMake(74, 131), 0);
            CGContextRestoreGState(context);
            [UIColor.blackColor setStroke];
            exerciseOvalPath.lineWidth = 1;
            [exerciseOvalPath stroke];
            
            
            //// StandOval Drawing
            UIBezierPath* standOvalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(36, 37, 76, 76)];
            CGContextSaveGState(context);
            [standOvalPath addClip];
            CGContextDrawLinearGradient(context, standGradient, CGPointMake(74, 37), CGPointMake(74, 113), 0);
            CGContextRestoreGState(context);
            [UIColor.blackColor setStroke];
            standOvalPath.lineWidth = 1;
            [standOvalPath stroke];
        }
        
        
        //// MaskGroup
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 74, 75);
            CGContextRotateCTM(context, 90 * M_PI / 180);
            
            CGContextSetBlendMode(context, kCGBlendModeDestinationIn);
            CGContextBeginTransparencyLayer(context, NULL);
            
            
            //// MoveMask Drawing
            UIBezierPath* moveMaskPath = [UIBezierPath bezierPath];
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
            
            
            //// ExerciseMask Drawing
            UIBezierPath* exerciseMaskPath = [UIBezierPath bezierPath];
            [exerciseMaskPath moveToPoint: CGPointMake(-47, 0)];
            [exerciseMaskPath addCurveToPoint: CGPointMake(0, -47) controlPoint1: CGPointMake(-47, -25.96) controlPoint2: CGPointMake(-25.96, -47)];
            [exerciseMaskPath addCurveToPoint: CGPointMake(47, 0) controlPoint1: CGPointMake(25.96, -47) controlPoint2: CGPointMake(47, -25.96)];
            [exerciseMaskPath addCurveToPoint: CGPointMake(-0, 47) controlPoint1: CGPointMake(47, 25.96) controlPoint2: CGPointMake(25.96, 47)];
            [exerciseMaskPath addCurveToPoint: CGPointMake(-47, 0) controlPoint1: CGPointMake(-25.96, 47) controlPoint2: CGPointMake(-47, 25.96)];
            [exerciseMaskPath closePath];
            exerciseMaskPath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            exerciseMaskPath.lineWidth = 17;
            CGFloat exerciseMaskPattern[] = {exersizeDash, 295};
            [exerciseMaskPath setLineDash: exerciseMaskPattern count: 2 phase: 1];
            [exerciseMaskPath stroke];
            
            
            //// StandMask Drawing
            UIBezierPath* standMaskPath = [UIBezierPath bezierPath];
            [standMaskPath moveToPoint: CGPointMake(-29, 0)];
            [standMaskPath addCurveToPoint: CGPointMake(0, -29) controlPoint1: CGPointMake(-29, -16.02) controlPoint2: CGPointMake(-16.02, -29)];
            [standMaskPath addCurveToPoint: CGPointMake(29, 0) controlPoint1: CGPointMake(16.02, -29) controlPoint2: CGPointMake(29, -16.02)];
            [standMaskPath addCurveToPoint: CGPointMake(-0, 29) controlPoint1: CGPointMake(29, 16.02) controlPoint2: CGPointMake(16.02, 29)];
            [standMaskPath addCurveToPoint: CGPointMake(-29, 0) controlPoint1: CGPointMake(-16.02, 29) controlPoint2: CGPointMake(-29, 16.02)];
            [standMaskPath closePath];
            standMaskPath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            standMaskPath.lineWidth = 17;
            CGFloat standMaskPattern[] = {standDash, 182};
            [standMaskPath setLineDash: standMaskPattern count: 2 phase: 1];
            [standMaskPath stroke];
            
            
            CGContextEndTransparencyLayer(context);
            
            CGContextRestoreGState(context);
        }
        
        
        //// MoveArrow
        {
            //// middleMoveLine Drawing
            UIBezierPath* middleMoveLinePath = [UIBezierPath bezierPath];
            [middleMoveLinePath moveToPoint: CGPointMake(70.5, 9.5)];
            [middleMoveLinePath addLineToPoint: CGPointMake(77.5, 9.5)];
            middleMoveLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            middleMoveLinePath.lineWidth = 2;
            [middleMoveLinePath stroke];
            
            
            //// bottomLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77.5, 9.5);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* bottomLinePath = [UIBezierPath bezierPath];
            [bottomLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [bottomLinePath addLineToPoint: CGPointMake(0, 0)];
            bottomLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            bottomLinePath.lineWidth = 2;
            [bottomLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77.5, 9.5);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topLinePath = [UIBezierPath bezierPath];
            [topLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topLinePath addLineToPoint: CGPointMake(0, 0)];
            topLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topLinePath.lineWidth = 2;
            [topLinePath stroke];
            
            CGContextRestoreGState(context);
        }
        
        
        //// ExerciseArrow
        {
            //// middleOrizontalLine Drawing
            UIBezierPath* middleOrizontalLinePath = [UIBezierPath bezierPath];
            [middleOrizontalLinePath moveToPoint: CGPointMake(70.5, 27.5)];
            [middleOrizontalLinePath addLineToPoint: CGPointMake(77.5, 27.5)];
            middleOrizontalLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            middleOrizontalLinePath.lineWidth = 2;
            [middleOrizontalLinePath stroke];
            
            
            //// bottomFirstLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77.5, 27.5);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* bottomFirstLinePath = [UIBezierPath bezierPath];
            [bottomFirstLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [bottomFirstLinePath addLineToPoint: CGPointMake(0, 0)];
            bottomFirstLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            bottomFirstLinePath.lineWidth = 2;
            [bottomFirstLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topFirstLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 77.5, 27.5);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topFirstLinePath = [UIBezierPath bezierPath];
            [topFirstLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topFirstLinePath addLineToPoint: CGPointMake(0, 0)];
            topFirstLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topFirstLinePath.lineWidth = 2;
            [topFirstLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// bottomSecondLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 81.5, 27.5);
            CGContextRotateCTM(context, -45 * M_PI / 180);
            
            UIBezierPath* bottomSecondLinePath = [UIBezierPath bezierPath];
            [bottomSecondLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [bottomSecondLinePath addLineToPoint: CGPointMake(0, 0)];
            bottomSecondLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            bottomSecondLinePath.lineWidth = 2;
            [bottomSecondLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            //// topSecondLine Drawing
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 81.5, 27.5);
            CGContextRotateCTM(context, 45 * M_PI / 180);
            
            UIBezierPath* topSecondLinePath = [UIBezierPath bezierPath];
            [topSecondLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topSecondLinePath addLineToPoint: CGPointMake(0, 0)];
            topSecondLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topSecondLinePath.lineWidth = 2;
            [topSecondLinePath stroke];
            
            CGContextRestoreGState(context);
        }
        
        
        //// StandArrow
        {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, 74, 45.5);
            CGContextRotateCTM(context, -90 * M_PI / 180);
            
            
            
            //// middleLine Drawing
            UIBezierPath* middleLinePath = [UIBezierPath bezierPath];
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
            
            UIBezierPath* toRightLinePath = [UIBezierPath bezierPath];
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
            
            UIBezierPath* topLeftLinePath = [UIBezierPath bezierPath];
            [topLeftLinePath moveToPoint: CGPointMake(-5.5, -0)];
            [topLeftLinePath addLineToPoint: CGPointMake(0, 0)];
            topLeftLinePath.lineCapStyle = kCGLineCapRound;
            
            [UIColor.blackColor setStroke];
            topLeftLinePath.lineWidth = 2;
            [topLeftLinePath stroke];
            
            CGContextRestoreGState(context);
            
            
            
            CGContextRestoreGState(context);
        }
        
        
        //// moveText Drawing
        CGRect moveTextRect = CGRectMake(6, 0, 58, 19);
        {
            NSString* textContent = @"MOVE";
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* moveTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            moveTextStyle.alignment = NSTextAlignmentRight;
            
            NSDictionary* moveTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 13], NSForegroundColorAttributeName: move1, NSParagraphStyleAttributeName: moveTextStyle};
            
            CGFloat moveTextTextHeight = [textContent boundingRectWithSize: CGSizeMake(moveTextRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: moveTextFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, moveTextRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(moveTextRect), CGRectGetMinY(moveTextRect) + (CGRectGetHeight(moveTextRect) - moveTextTextHeight) / 2, CGRectGetWidth(moveTextRect), moveTextTextHeight) withAttributes: moveTextFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        //// exerciseText Drawing
        CGRect exerciseTextRect = CGRectMake(0, 18, 64, 19);
        {
            NSString* textContent = @"EXERCISE";
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* exerciseTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            exerciseTextStyle.alignment = NSTextAlignmentRight;
            
            NSDictionary* exerciseTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 13], NSForegroundColorAttributeName: exercise1, NSParagraphStyleAttributeName: exerciseTextStyle};
            
            CGFloat exerciseTextTextHeight = [textContent boundingRectWithSize: CGSizeMake(exerciseTextRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: exerciseTextFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, exerciseTextRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(exerciseTextRect), CGRectGetMinY(exerciseTextRect) + (CGRectGetHeight(exerciseTextRect) - exerciseTextTextHeight) / 2, CGRectGetWidth(exerciseTextRect), exerciseTextTextHeight) withAttributes: exerciseTextFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        //// standText Drawing
        CGRect standTextRect = CGRectMake(6, 36, 58, 19);
        {
            NSString* textContent = @"STAND";
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
            NSMutableParagraphStyle* standTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
            standTextStyle.alignment = NSTextAlignmentRight;
            
            NSDictionary* standTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 13], NSForegroundColorAttributeName: stand1, NSParagraphStyleAttributeName: standTextStyle};
            
            CGFloat standTextTextHeight = [textContent boundingRectWithSize: CGSizeMake(standTextRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: standTextFontAttributes context: nil].size.height;
            CGContextSaveGState(context);
            CGContextClipToRect(context, standTextRect);
            [textContent drawInRect: CGRectMake(CGRectGetMinX(standTextRect), CGRectGetMinY(standTextRect) + (CGRectGetHeight(standTextRect) - standTextTextHeight) / 2, CGRectGetWidth(standTextRect), standTextTextHeight) withAttributes: standTextFontAttributes];
            CGContextRestoreGState(context);
            CGContextRestoreGState(context);
            
        }
        
        
        CGContextEndTransparencyLayer(context);
        
        CGContextRestoreGState(context);
    }
    
    
    //// Cleanup
    CGGradientRelease(standGradient);
    CGGradientRelease(moveGradient);
    CGGradientRelease(exerciseGradient);
    CGColorSpaceRelease(colorSpace);
}

@end
