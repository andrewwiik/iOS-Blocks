//
//  cydiaCell.m
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//
//

#import "cydiaCell.h"

@implementation cydiaCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier inTable:(UITableView *)table height:(float)height{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //Image
        image = [[cydiaIconView alloc] initWithFrame:CGRectMake(10.0, 6.5, height - 13.0, height - 13.0)];
        [self addSubview:image];
        //Title
        title = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 5.0, image.frame.origin.y, table.frame.size.width - (image.frame.origin.x + image.frame.size.width + 5.0 + 15.0), height / 2.0 - image.frame.origin.y)];
        [title setShadowColor:[UIColor.blackColor colorWithAlphaComponent: 0.2]];
        [title setShadowOffset: CGSizeMake(0.0, -0.3)];
        title.textAlignment = NSTextAlignmentLeft;
        title.scrollDirection = CBAutoScrollDirectionLeft;
        title.scrollSpeed = 10.0;
        title.pauseInterval = 2.0;
        title.labelSpacing = 20.0;
        title.textColor = [UIColor whiteColor];
        title.font = [UIFont fontWithName:@"HelveticaNeue" size:13];//14
        [title setFadeLength:2.0];
        [self addSubview:title];
        //Description
        description = [[CBAutoScrollLabel alloc] initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 5.0, height / 2.0, table.frame.size.width - (image.frame.origin.x + image.frame.size.width + 5.0 + 15.0), height / 2.0 - image.frame.origin.y)];
        [description setShadowColor:[UIColor.blackColor colorWithAlphaComponent: 0.2]];
        [description setShadowOffset: CGSizeMake(0.0, -0.3)];
        description.textAlignment = NSTextAlignmentLeft;
        description.scrollDirection = CBAutoScrollDirectionLeft;
        description.scrollSpeed = 10.0;
        description.pauseInterval = 2.0;
        description.labelSpacing = 20.0;
        description.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        description.font = [UIFont fontWithName:@"HelveticaNeue" size:9];//11
        [description setFadeLength:2.0];
        [self addSubview:description];
    }
    return self;
}

-(void)setTitle:(NSString *)arg {
    title.text = arg;
    [title scrollLabelIfNeeded];
}

-(void)setDescription:(NSString *)arg {
    description.text = arg;
    [description scrollLabelIfNeeded];
}

-(void)setImagePackage:(UIImage *)arg {
    image.image = arg;
}

-(void)setNewPackage:(BOOL)arg {
    [image setNew:arg];
}

@end
