//
//  IBKNotificationsTableCell.m
//  curago
//
//  Created by Matt Clarke on 30/07/2014.
//
//

#import "IBKNotificationsTableCell.h"
#import <BulletinBoard/BBAttachments.h>

@implementation IBKNotificationsTableCell

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(BOOL)isSuperviewColourationBright {
    BOOL isLight = NO;
    
    CGDataProviderRef provider = CGImageGetDataProvider([IBKNotificationsTableCell imageWithColor:self.superviewColouration].CGImage);
    NSData* data = (id)CFBridgingRelease(CGDataProviderCopyData(provider));
    
    if ([data length] > 0) {
        const UInt8 *pixelBytes = [data bytes];
        
        // Whether or not the image format is opaque, the first byte is always the alpha component, followed by RGB.
        UInt8 pixelR = pixelBytes[1];
        UInt8 pixelG = pixelBytes[2];
        UInt8 pixelB = pixelBytes[3];
        
        // Calculate the perceived luminance of the pixel; the human eye favors green, followed by red, then blue.
        double percievedLuminance = 1 - (((0.299 * pixelR) + (0.587 * pixelG) + (0.114 * pixelB)) / 255);
        
        pixelBytes = nil;
        
        isLight = percievedLuminance < 0.3;
    }
    
    data = nil;
    
    return isLight;
}

-(void)initialiseForBulletin:(BBBulletin*)bulletin andRowWidth:(CGFloat)width {
    NSLog(@"initing for bulletin");
    // Initialiation: title, date label and content
    // content may be the count of -(id)attachments
    // date label: minutes (1m ago), hours (2h ago), days (up to 3d ago), actual date.
    // attachment image - just take the first one
    
    // We have a height of 52.0 per cell.
    
    if (!self.title) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(4, 3, width-8, 14)];
        self.title.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12.5];
        self.title.numberOfLines = 1;
        self.title.backgroundColor = [UIColor clearColor];
        
        if ([self isSuperviewColourationBright])
            self.title.textColor = [UIColor darkTextColor];
        else
            self.title.textColor = [UIColor whiteColor];
        
        [self addSubview:self.title];
    }
    
    self.title.text = [bulletin title];
    
    [self.title sizeToFit];
    
    CGRect titleFrameCleanUp = self.title.frame;
    if (titleFrameCleanUp.size.width > width-46) {
        titleFrameCleanUp.size = CGSizeMake(width-46, titleFrameCleanUp.size.height);
        self.title.frame = titleFrameCleanUp;
    }
    
    NSLog(@"dateLabel");
    
    if (!self.dateLabel) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, width-2, 12)];
        self.dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        self.dateLabel.numberOfLines = 1;
        self.dateLabel.backgroundColor = [UIColor clearColor];
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        
        if ([self isSuperviewColourationBright])
            self.dateLabel.textColor = [UIColor darkTextColor];
        else
            self.dateLabel.textColor = [UIColor whiteColor];
        
        self.dateLabel.alpha = 0.5;
        
        [self addSubview:self.dateLabel];
    }
    
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    // TODO: Do we need to set the dateLabel's text here?
    // TODO: Add NSTimer for date label refresh
    
    self.dateLabel.text = @"2m ago";
    
    NSLog(@"Content");
    
    if (!self.content) {
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(4, 19, width-8, 26)];
        self.content.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        self.content.numberOfLines = 0;
        self.content.backgroundColor = [UIColor clearColor];
        
        if ([self isSuperviewColourationBright])
            self.content.textColor = [UIColor darkTextColor];
        else
            self.content.textColor = [UIColor whiteColor];
        
        [self addSubview:self.content];
    }
    
    NSLog(@"Attachments");
    
    self.content.text = bulletin.message;
    
    if ([bulletin attachments]) {
        // Deal with attachment image
        // TODO: Finish attachment image handling
        
        NSLog(@"clientComposedImageInfos == %@", bulletin.attachments.clientSideComposedImageInfos);
        NSLog(@"Additinoal attachments == %@", bulletin.attachments.additionalAttachments);
        
        NSLog(@"ComposedAttachmentImage == %@", bulletin.composedAttachmentImage);
        
        if (!self.attachment) {
            self.attachment = [[UIImageView alloc] initWithImage:bulletin.composedAttachmentImage];
            
            // Recalculate image size based on height to sit it in.
            CGFloat percentage = 26/bulletin.composedAttachmentImageSize.height;
            CGFloat newWidth = bulletin.composedAttachmentImageSize.width/percentage;
            
            NSLog(@"Newwidth == %f", newWidth);
            
            self.attachment.frame = CGRectMake(4, 19, newWidth, 26);
            
            self.attachment.backgroundColor = [UIColor blueColor];
            self.attachment.alpha = 0.5;
            
            [self addSubview:self.attachment];
        }
        
        
    }
    
    if (!self.separatorLine) {
        self.separatorLine = [[UIView alloc] initWithFrame:CGRectMake(10, 50, width-20, 1)];
        self.separatorLine.backgroundColor = [UIColor whiteColor];
        self.separatorLine.alpha = 0.25;
        
        [self addSubview:self.separatorLine];
    }
}

-(void)updateTime:(NSTimer*)timer {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)prepareForReuse {
    // Take everything out - title, time, timer and content
    
    self.title.text = @"";
    self.dateLabel.text = @"";
    self.content.text = @"";
    self.attachment.image = nil;
    [self.dateTimer invalidate];
}

@end
