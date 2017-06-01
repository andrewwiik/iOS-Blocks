//
//  timerLabelDate.m
//  MobileSMS
//
//  Created by gabriele on 19/04/15.
//
//

#import "timerLabelDate.h"

@implementation timerLabelDate

- (id)initWithFrame:(CGRect)frame withDate:(NSDate *)date
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        data = date;
        
        state = -1;
        
        self.textAlignment = NSTextAlignmentRight;
        
        self.textColor = [UIColor colorWithWhite:1.0 alpha:0.80];
        
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTextDate:) userInfo:nil repeats:YES];//[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTextDate:) userInfo:nil repeats:YES];
        
        [timer fire];
    }
    
    return self;
}

-(void)setDate:(NSDate *)date
{
    data = date;
    
    state = 0;
    
    [self updateTextDate:nil];
    
    if (state != 4)
    {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTextDate:) userInfo:nil repeats:YES];//[NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTextDate:) userInfo:nil repeats:YES];
        
        [timer fire];
    }
}

-(void)updateTextDate:(NSTimer *)timer
{
    if (!self || state == 4)
    {
        [timer invalidate];
        
        NSLog(@"Interrupt Label Timer!");
        
        timer = nil;
        
        return;
    }

    if (!self.translations) {
        self.translations = [NSBundle bundleWithPath:@"/System/Library/CoreServices/SpringBoard.app"];
    }
    
    NSDate *now = [NSDate date];
    
    int seconds = (int)fabs([now timeIntervalSinceDate:data]);

    NSString *string;
    seconds = floorf(seconds);
    int minutes = seconds / 60.0f;
    int hours = minutes / 60.0f;
    int days = hours / 24.0f;
    
    if (seconds < 10) {
        // Display "now"
        state = 0;
        string = [self.translations localizedStringForKey:@"RELATIVE_DATE_NOW" value:@"now" table:@"SpringBoard"];
    } else if (seconds < 60) {
        // Display "%@s ago"
        state = 0;
        string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_SEC" value:@"%@s ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", seconds]];
    } else if (minutes < 60) {
        // Display "%@m ago"
        state = 1;
        string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_MIN" value:@"%@m ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", minutes]];
    } else if (hours < 24) {
        // Display "%@h ago"
        state = 2;
        string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_HOUR" value:@"%@h ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", hours]];
    } else {
        // Display "%@d ago"
        state = 3;
        string = [NSString stringWithFormat:[self.translations localizedStringForKey:@"RELATIVE_DATE_PAST_DAY" value:@"%@d ago" table:@"SpringBoard"], [NSString stringWithFormat:@"%d", days]];
    }
    
    self.text = string;
    
    
    //self.frame = CGRectMake(15.0, 5.0, self.superview.frame.size.width - 30.0, self.superview.frame.size.height / 2.0 - 5.0);
}

@end
