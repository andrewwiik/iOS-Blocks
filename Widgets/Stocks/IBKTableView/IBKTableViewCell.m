//
//  TableViewCell.m
//  TableViewCellDemo
//
//  Created by renxuan on 15/8/5.
//  Copyright (c) 2015年 renxuan. All rights reserved.
//

#import "IBKTableViewCell.h"

@interface IBKResources : NSObject
+(CGFloat)widthForWidgetWithIdentifier:(NSString *)identifier;
@end

@implementation IBKTableViewCell
@synthesize _separatorLine = separatorLine;
@synthesize _ibkContentView = ibkContentView;
@synthesize _ibkTitleLabel = ibkTitleLabel;
@synthesize _ibkSubtitleLabel = ibkSubtitleLabel;
@synthesize _ibkValueLabel = ibkValueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame {
    // super.
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    // if init.
    if (self) {
        // create separator line.
        separatorLine = [[UIView alloc] initWithFrame:CGRectMake(15,self.bounds.size.height,118,1)];
        separatorLine.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.35f];
        separatorLine.alpha = 0.3f;
        //[self addSubview:separatorLine];
        // create content view.
        ibkContentView = [[UIView alloc] initWithFrame:CGRectZero];
        ibkContentView.backgroundColor = [UIColor clearColor];
        ibkContentView.clipsToBounds = YES; // prevent to make child view visible outsite ibkContentView.
        [self addSubview:ibkContentView];
        ibkContentView.frame = CGRectMake(15,0,frame.size.width - 30, self.bounds.size.height);
        /*
        Create your UI objects here.
        Remember to add them to ibkContentView in order to respect table size for all widgets.
        */
        
        // create title label.
        ibkTitleLabel = [[IBKMarqueeLabel alloc] initWithFrame:CGRectMake(0,0,(ibkContentView.bounds.size.width/3)-5.f,self.frame.size.height-2)];
        ibkTitleLabel.fadeLength = 0.3f;
        [ibkContentView addSubview:ibkTitleLabel];
        
        // create price label.
        ibkSubtitleLabel = [[IBKMarqueeLabel alloc] initWithFrame:CGRectMake(ibkTitleLabel.frame.size.width+5.f,0,(ibkContentView.bounds.size.width/3)-5.f,self.frame.size.height-2)];
        ibkSubtitleLabel.fadeLength = 0.3f;
        [ibkContentView addSubview:ibkSubtitleLabel];
        
        // create value label.
        ibkValueLabel = [[IBKMarqueeLabel alloc] initWithFrame:CGRectMake(ibkSubtitleLabel.frame.origin.x+ibkSubtitleLabel.frame.size.width+5.f,10.5f,(ibkContentView.bounds.size.width/3),self.frame.size.height-25.f)];
        ibkValueLabel.layoutMargins = UIEdgeInsetsMake(0,5,0,5);
        ibkValueLabel.textAlignment = NSTextAlignmentCenter;
        ibkValueLabel.fadeLength = 0.3f;
        [ibkContentView addSubview:ibkValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    ibkContentView.frame = CGRectMake(15,0,self.bounds.size.width - 15, self.bounds.size.height);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
