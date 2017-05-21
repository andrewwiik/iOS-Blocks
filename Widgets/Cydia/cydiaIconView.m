//
//  cydiaIconView.m
//  Cydia
//
//  Created by gabriele filipponi on 18/08/15.
//
//

#import "cydiaIconView.h"

@implementation cydiaIconView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        show = NO;
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        banner = [[cydiaNewBanner alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 - 2.5, - 1, frame.size.width / 2.0 + 5.0, frame.size.height / 2.0 + 5.0)];
        banner.hidden = !show;
        [self addSubview:banner];
    }
    return self;
}

-(void)setNew:(BOOL)arg {
    show = !arg;
    banner.hidden = show;
    [banner setNeedsDisplay];
}

@end
