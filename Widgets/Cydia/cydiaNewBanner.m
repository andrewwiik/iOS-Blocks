//
//  cydiaNewBanner.m
//  Cydia
//
//  Created by gabriele filipponi on 18/08/15.
//
//

#import "cydiaNewBanner.h"

@implementation cydiaNewBanner

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        banner = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        banner.layer.masksToBounds = YES;
        banner.backgroundColor = [UIColor clearColor];
        banner.image = [UIImage imageWithContentsOfFile:@"/Library/Curago/Widgets/com.saurik.Cydia/Sections/new.png"];
        [self addSubview:banner];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    return;
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Shadow Declarations
    NSShadow* shadow = [[NSShadow alloc] init];
    [shadow setShadowColor: UIColor.blackColor];
    [shadow setShadowOffset: CGSizeMake(0.1, 1.1)];
    [shadow setShadowBlurRadius: 3];
    
    //// Text Drawing
    CGContextSaveGState(context);
    CGContextRotateCTM(context, 45 * M_PI / 180);
    
    float height = 14.85 * rect.size.height / 42.0;
    CGRect textRect = CGRectMake(0.0, -height, rect.size.width * 1.41 /*pow(2, 0.5)*/, height);
    {
        NSString* textContent = @"New";
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadow.shadowOffset, shadow.shadowBlurRadius, [shadow.shadowColor CGColor]);
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: 13], NSForegroundColorAttributeName: UIColor.whiteColor, NSParagraphStyleAttributeName: textStyle};
        
        CGFloat textTextHeight = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: textFontAttributes context: nil].size.height;
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textTextHeight) / 2, CGRectGetWidth(textRect), textTextHeight) withAttributes: textFontAttributes];
        CGContextRestoreGState(context);
        CGContextRestoreGState(context);
        
    }
    
    CGContextRestoreGState(context);
}

@end
