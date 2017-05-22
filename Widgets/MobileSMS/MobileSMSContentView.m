//
//  IBKMusicButton.m
//  Music
//
//  Created by Matt Clarke on 05/02/2015.
//
//

#import "MobileSMSContentView.h"

@implementation MobileSMSContentView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.table = [[chatsTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 5.0 - (isPad ? 50.0 : 30.0)-7.0)];
        
        [self addSubview:self.table];
    }
    
    return self;
}

-(CGFloat)contentViewHeight
{
    return self.frame.size.height - 5.0 - (isPad ? 50.0 : 30.0)-7.0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.table.frame = CGRectMake(0, 0, self.frame.size.width, [self contentViewHeight]);
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
}

@end
