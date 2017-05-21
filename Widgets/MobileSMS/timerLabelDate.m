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
        
        self.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
        
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
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval interval = [now timeIntervalSinceDate:data];
    
    if (interval < 60.0)
    {
        //Seconds
        
        self.text = [NSString stringWithFormat:@"%ds ago", [[NSNumber numberWithFloat:interval] intValue]];
        
        state = 0;
        
    }else if (interval / 60.0 < 60.0)
    {
        //Mitunes
        
        self.text = [NSString stringWithFormat:@"%dm ago", [[NSNumber numberWithFloat:interval / 60.0] intValue]];
        
        state = 1;
        
    }else if (interval / 3600.0 < 24.0)
    {
        //Hour
        
        self.text = [NSString stringWithFormat:@"%dh ago", [[NSNumber numberWithFloat:interval / 3600.0] intValue]];
        
        state = 2;
        
    }else if (interval / 3600.0 < 48.0)
    {
        //Yesterday
        
        self.text = @"Yesterday";
        
        state = 3;
    }else
    {
        //Else
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"dd/MM/yyyy"];
        
        self.text = [df stringFromDate:data];
        
        state = 4;
    }
    
    //self.frame = CGRectMake(15.0, 5.0, self.superview.frame.size.width - 30.0, self.superview.frame.size.height / 2.0 - 5.0);
}

@end
