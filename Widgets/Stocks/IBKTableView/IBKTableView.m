//
//  IBKTableView.m
//  AlarmWidget
//
//  Created by Pigi Galdi on 10/08/15.
//
//

#import "IBKTableView.h"

@implementation IBKTableView
@synthesize hasShadow = hasShadow;
@synthesize hasRefreshControl = hasRefreshControl;
@synthesize refreshControl = refreshControl;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    // super.
    self = [super initWithFrame:frame style:style];
    // if self.
    if (self){
        // create view.
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.separatorInset = UIEdgeInsetsMake(0,15,0,15);
    }
    return self;
}
- (void)setHasRefreshControl:(BOOL)__hasRefreshControl {
    hasRefreshControl = __hasRefreshControl;
    if (__hasRefreshControl){
        [self createRefreshControl];
    }else {
        if (refreshControl){
            [refreshControl removeFromSuperview];
            refreshControl = nil;
        }
    }
}
- (void)createRefreshControl {
    // init refresh control.
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefreshControl:) forControlEvents:UIControlEventValueChanged];
    [refreshControl setTransform:CGAffineTransformMakeScale(0.75f,0.75f)];
    [self addSubview:refreshControl];
}
- (void)handleRefreshControl:(UIRefreshControl *)control {
    // stop spinning.
    [control endRefreshing];
    // reload table view data.
    [self reloadData];
}

- (void)setHasShadow:(BOOL)__hasShadow {
    hasShadow = __hasShadow;
    if (__hasShadow){
        [self createShadow];
    }else {
        [self removeShadow];
    }
}
- (void)createShadow {
    // add bottom shadow.
    CAGradientLayer *maskLayer = maskLayer = [CAGradientLayer layer];
    maskLayer.shouldRasterize = YES;
    maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
    id outerColor = (id)[UIColor clearColor].CGColor;
    id innerColor = (id)[UIColor blackColor].CGColor;
    maskLayer.colors = @[(id)outerColor,
                         (id)innerColor, (id)innerColor, (id)outerColor];
    maskLayer.locations = @[[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.0],[NSNumber numberWithFloat:0.95],[NSNumber numberWithFloat:1.0]];
    maskLayer.bounds = self.layer.bounds;
    maskLayer.anchorPoint = CGPointZero;
    maskLayer.zPosition = 1000;
    self.layer.mask = maskLayer;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [CATransaction commit];
}
/*
**  TO FIX: SHADOW REMAINS ON BOTTOM.
**
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    scrollView.layer.mask.position = CGPointMake(0, scrollView.contentOffset.y);
    [CATransaction commit];
}
**
**/

- (void)removeShadow {
    if (self.layer.mask){
        self.layer.mask = nil;
    }
}
@end
