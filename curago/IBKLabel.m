/*
 * IBKLabel.m
 * iOS BLocks
 *
 * Utilises code from ShadowLabel.m - completely
 * public code so no need to worry about license.
 *
 */

#import "IBKLabel.h"

#define isIpadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation IBKLabel

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {;
        self.layer.masksToBounds = NO;
        _blurRadius = 1.0;
        _shadowAlpha = 0.25;
        self.alpha = 0.9;
        self.shadowingEnabled = YES;
    }
    
    return self;
}

// Ensure we have a slightly translucent text coluration
-(void)setAlpha:(CGFloat)alpha {
    if (alpha == 1.0) {
        [super setAlpha:0.9];
    } else {
        [super setAlpha:alpha];
    }
}

-(void)setLabelSize:(int)size {
    switch (size) {
        case kIBKLabelSizingTiny:
            self.font = [UIFont fontWithName:@"HelveticaNeue" size:(isIpadDevice ? 12 : 10)];
            _blurRadius = 1.5;
            _shadowAlpha = 0.15;
            break;
        case kIBKLabelSizingSmall:
            self.font = [UIFont fontWithName:@"HelveticaNeue" size:(isIpadDevice ? 13 : 11)];
            _blurRadius = 2.5;
            _shadowAlpha = 0.25;
            break;
        case kIBKLabelSizingSmallBold:
            self.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:(isIpadDevice ? 14 : 12.5)];
            _blurRadius = 2.5;
            _shadowAlpha = 0.25;
            break;
        case kIBKLabelSizingButtonView:
            self.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:(isIpadDevice ? 16 : 13)];
            _blurRadius = 2.5;
            _shadowAlpha = 0.25;
            break;
        case kIBKLabelSizingMedium:
            break;
        case kIBKLabelSizingLarge:
            self.font = [UIFont fontWithName:@"HelveticaNeue" size:(isIpadDevice ? 18 : 16)];
            _blurRadius = 7.5;
            _shadowAlpha = 0.3;
            break;
        case kIBKLabelSizingGiant:
            break;
        default:
            break;
    }
}

/*
 * Override -drawTextInRect to allow creating a nice soft shadow
 * behind the text of the label.
 */

@end
