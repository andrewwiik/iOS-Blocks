//
//  IBKGameCenterTableView.h
//  curago
//
//  Created by Matt Clarke on 10/02/2015.
//
//

#import <UIKit/UIKit.h>
#import "IBKNotificationsTableCell.h"
#import "IBKLabel.h"

@interface IBKGameCenterTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UIColor *superviewColoration;
@property (nonatomic, strong) IBKLabel *loading;

-(id)initWithIdentifier:(NSString*)identifier andFrame:(CGRect)frame andColouration:(UIColor*)color;

@end
