//
//  IBKWeatherFiveView.m
//  Weather
//
//  Created by Matt Clarke on 31/03/2015.
//
//

#import "IBKWeatherFiveView.h"

@implementation IBKWeatherFiveView

- (id)initWithFrame:(CGRect)frame day:(NSString *)dayName condition:(int)condition high:(NSString *)high low:(NSString *)low {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // Day.
        self.dayName = [[IBKLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.dayName.text = dayName;
        self.dayName.textAlignment = NSTextAlignmentLeft;
        self.dayName.textColor = [UIColor whiteColor];
        self.dayName.backgroundColor = [UIColor clearColor];
        [self.dayName sizeToFit];
        [self.dayName setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.dayName];
        
        // Icon.
        
        // High
        
        self.high = [[IBKLabel alloc] initWithFrame:CGRectZero];
        self.high.text = high;
        self.high.textAlignment = NSTextAlignmentLeft;
        self.high.textColor = [UIColor whiteColor];
        self.high.backgroundColor = [UIColor clearColor];
        [self.high sizeToFit];
        [self.high setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.high];
        
        // Low
        
        self.low = [[IBKLabel alloc] initWithFrame:CGRectZero];
        self.low.text = low;
        self.low.textAlignment = NSTextAlignmentLeft;
        self.low.textColor = [UIColor whiteColor];
        self.low.backgroundColor = [UIColor clearColor];
        self.low.alpha = 0.5;
        [self.low sizeToFit];
        [self.low setLabelSize:kIBKLabelSizingSmall];
        
        [self addSubview:self.low];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.dayName.frame = CGRectMake(10, (self.frame.size.height/2) - (self.dayName.frame.size.height/2), self.dayName.frame.size.width, self.dayName.frame.size.height);
    
    self.icon.center = self.center;
    
    self.low.frame = CGRectMake(self.frame.size.width - 5 - self.low.frame.size.width, (self.frame.size.height/2) - (self.low.frame.size.height/2), self.low.frame.size.width, self.low.frame.size.height);
    self.high.frame = CGRectMake(self.low.frame.origin.x - self.high.frame.size.width, (self.frame.size.height/2) - (self.high.frame.size.height/2), self.high.frame.size.width, self.high.frame.size.height);
}

@end
