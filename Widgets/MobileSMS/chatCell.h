//
//  chatCell.h
//  MobileSMS
//
//  Created by gabriele filipponi on 31/05/16.
//
//

#import <UIKit/UIKit.h>
#include "timerLabelDate.h"
#import "CBAutoScrollLabel.h"

@interface chatCell : UITableViewCell

@property (nonatomic, strong) timerLabelDate *date;
@property (nonatomic, strong) CBAutoScrollLabel *name;
@property (nonatomic, strong) UILabel *message;

@end

#define isIpadDevice (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
