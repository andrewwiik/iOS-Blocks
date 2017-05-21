//
//  chatCell.m
//  MobileSMS
//
//  Created by gabriele filipponi on 31/05/16.
//
//

#import "chatCell.h"

@implementation chatCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *selection = [[UIView alloc] init];
        selection.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3];
        self.selectedBackgroundView = selection;
        if ([self respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
            self.preservesSuperviewLayoutMargins = NO;
        }
        self.date = [[timerLabelDate alloc] initWithFrame:CGRectZero withDate:nil];
        [self addSubview:self.date];
        self.name = [[CBAutoScrollLabel alloc] init];
        self.name.textAlignment = NSTextAlignmentLeft;
        self.name.scrollDirection = CBAutoScrollDirectionRight;
        self.name.scrollSpeed = 10.0;
        self.name.pauseInterval = 2.0;
        self.name.labelSpacing = 20.0;
        self.name.textColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        self.name.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [self.name setFadeLength:2.0];
        [self addSubview:self.name];
        self.message = [[UILabel alloc] init];
        self.message.textAlignment = NSTextAlignmentLeft;
        self.message.textColor = [UIColor colorWithWhite:1.0 alpha:0.80];
        self.message.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        self.message.numberOfLines = 2;
        [self addSubview:self.message];
    }
    return self;
}

@end
