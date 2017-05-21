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
        self.table = [[chatsTableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, [self contentViewHeight])];
        
        [self addSubview:self.table];
    }
    
    return self;
}

-(float)contentViewHeight
{
    return [objc_getClass("IBKAPI") heightForContentViewWithIdentifier:@"com.apple.MobileSMS"] - 5.0;
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
