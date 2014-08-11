//
//  IBKNotificationsTableCell.h
//  curago
//
//  Created by Matt Clarke on 30/07/2014.
//
//

#import <UIKit/UIKit.h>
#import <BulletinBoard/BBBulletin.h>

@interface IBKNotificationsTableCell : UITableViewCell

@property (nonatomic, strong) NSTimer *dateTimer;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIColor *superviewColouration;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *attachment;
@property (nonatomic, strong) UIView *separatorLine;

-(void)initialiseForBulletin:(BBBulletin*)bulletin andRowWidth:(CGFloat)width;

@end
