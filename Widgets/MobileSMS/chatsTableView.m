//
//  chatsTableView.m
//  MobileSMS
//
//  Created by gabriele on 19/04/15.
//
//

#import "chatsTableView.h"

@implementation chatsTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self registerClass:[chatCell class] forCellReuseIdentifier:@"chatCell"];
        
        chats = [[NSDictionary alloc] initWithDictionary:[chatsLoader getChatsDictionary]];
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
        self.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.60];
        
        self.backgroundColor = [UIColor clearColor];
        
        CAGradientLayer *maskLayer = maskLayer = [CAGradientLayer layer];
        
        maskLayer.shouldRasterize = YES;
        
        maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
        
        id outerColor = (id)[UIColor clearColor].CGColor;
        
        id innerColor = (id)[UIColor blackColor].CGColor;
        
        maskLayer.colors = [NSArray arrayWithObjects:(id)outerColor,
                            (id)innerColor, (id)innerColor, (id)outerColor, nil];
        
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.95], [NSNumber numberWithFloat:1.0], nil];
        
        maskLayer.bounds = self.layer.bounds;
        
        maskLayer.anchorPoint = CGPointZero;
        
        maskLayer.zPosition = 1000;
        
        self.layer.mask = maskLayer;
        
        [CATransaction begin];
        
        [CATransaction setDisableActions:YES];
        
        //maskLayer.position = CGPointMake(5, 5);
        
        [CATransaction commit];
        
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        if ([[chats allKeys] count] == 0)
        {
            self.alpha = 1.0;
            
            [self setScrollEnabled:NO];
            
            self.separatorColor = [UIColor clearColor];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.6];
            
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            
            label.textAlignment = NSTextAlignmentCenter;
            
            label.numberOfLines = 4;
            
            [label setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(open)];
            
            [label addGestureRecognizer:tap];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"No message\nTap to open the Messages app"];
            
            [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue" size:18] range:NSMakeRange(0, 10)];
            
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 10)];
            
            [label setAttributedText:string];
            
            [self addSubview:label];
        }else
        {
            self.dataSource = self;
            
            self.delegate = self;
        }
    }
    
    return self;
}

-(void)open
{
    [[UIApplication sharedApplication] launchApplicationWithIdentifier:@"com.apple.MobileSMS" suspended:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    
    [CATransaction commit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [chats count];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    chatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    [cell.date setDate:[[chats objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] objectForKey:@"date"]];
    cell.date.frame = CGRectMake(10.0, 5.0, tableView.frame.size.width - 20.0, [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2.0 - 5.0);
    cell.name.frame = CGRectMake(10.0, 5.0, (tableView.frame.size.width - 20.0) / 2.0, [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2.0 - 5.0);
    cell.name.text = [[chats objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] objectForKey:@"identifier"];
    [cell.name scrollLabelIfNeeded];
    cell.message.frame = CGRectMake(10.0, [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2.0, tableView.frame.size.width - 20.0, [self tableView:tableView heightForRowAtIndexPath:indexPath] / 2.0 - 5.0);
    NSString *text = [[chats objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] objectForKey:@"text"];
    if ([[[chats objectForKey:[[NSNumber numberWithInteger:indexPath.row] stringValue]] objectForKey:@"file"] length] != 0) {
       text = @"Imagine";
    }
    cell.message.text = text;
    
    return cell;
}

-(NSInteger)getNumberOfLinesInLabel:(NSString *)text
{
    NSInteger lineCount = 0;

    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:10];

    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByClipping;

    NSDictionary * attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};

    CGSize requiredSize = [text boundingRectWithSize:CGSizeMake(self.frame.size.width - 20.0, 40.0)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
    
    int charSize = [UIFont fontWithName:@"HelveticaNeue" size:10].leading;
    
    int rHeight = requiredSize.height;
    
    lineCount = rHeight/charSize;
    
    return lineCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self getNumberOfLinesInLabel:[[chats objectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]] objectForKey:@"text"]] >= 2)
    {
        return 60.0;
    }else
    {
        return 40.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *iden = [[chats objectForKey:[[NSNumber numberWithInteger:indexPath.row] stringValue]] objectForKey:@"open"];
    
    if ([iden length] == 0)
    {
        return;
    }
    
    NSString *stringURL;
    
    stringURL = [NSString stringWithFormat:@"%@%@", @"sms:" , iden];
    
    NSURL *url = [NSURL URLWithString:stringURL];
    
    [[UIApplication sharedApplication] openURL:url];

}

@end
