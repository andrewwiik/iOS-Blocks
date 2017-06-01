//
//  timerLabelDate.h
//  MobileSMS
//
//  Created by gabriele on 19/04/15.
//
//

#import <UIKit/UIKit.h>

@interface timerLabelDate : UILabel
{
    NSDate *data;
    
    int state;
}

-(id)initWithFrame:(CGRect)frame withDate:(NSDate *)date;
-(void)setDate:(NSDate *)date;
@property (nonatomic, retain) NSBundle *translations;

@end
