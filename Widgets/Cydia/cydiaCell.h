//
//  cydiaCell.h
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//
//

#import <UIKit/UIKit.h>

#import "CBAutoScrollLabel.h"
#import "cydiaIconView.h"

@interface cydiaCell : UITableViewCell {
    cydiaIconView *image;
    CBAutoScrollLabel *title, *description;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTable:(UITableView *)table height:(float)height;
-(void)setTitle:(NSString *)arg;
-(void)setDescription:(NSString *)arg;
-(void)setImagePackage:(UIImage *)arg;
-(void)setNewPackage:(BOOL)arg;
@end
