//
//  TableViewCell.h
//  TableViewCellDemo
//
//  Created by renxuan on 15/8/5.
//  Copyright (c) 2015年 renxuan. All rights reserved.
//

#import <UIKit/UIKit.h>
// IBKObjects
#import "IBKLabel.h"
#import "IBKMarqueeLabel.h"

@interface IBKTableViewCell : UITableViewCell {
    UIView *_ibkContentView;
    UIView *_separatorLine;
    IBKMarqueeLabel *_ibkTitleLabel;
    IBKMarqueeLabel *_ibkSubtitleLabel;
    
    // for stocks widget.
    IBKMarqueeLabel *_ibkValueLabel;
}
@property (nonatomic, retain) UIView *_separatorLine;
@property (nonatomic, retain) UIView *_ibkContentView;
@property (nonatomic, retain) IBKMarqueeLabel *_ibkTitleLabel;
@property (nonatomic, retain) IBKMarqueeLabel *_ibkSubtitleLabel;

// stocks widget
@property (nonatomic, retain) IBKMarqueeLabel *_ibkValueLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier frame:(CGRect)frame;
@end
