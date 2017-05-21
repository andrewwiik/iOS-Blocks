//
//  stocksContentView.m
//  stocks
//
//  Created by Pigi Galdi on 10/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "stocksContentView.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@implementation stocksContentView
@synthesize _tableView = _tableView;
@synthesize _cell = cell;
@synthesize _stockItem = stockItem;
@synthesize _valueString = valueString;
@synthesize _graphView = graphView;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // init content view.
        _tableView = [[IBKTableView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,[self contentViewHeight]) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithWhite:1.f alpha:0.6f];
        _tableView.hasShadow = NO;
        _tableView.hasRefreshControl = YES;
        _tableView.refreshControl.tintColor = [UIColor colorWithWhite:1.f alpha:0.8f];
        [self addSubview:_tableView];
        
        // create graph view.
        graphView = [[StockGraphView alloc] initWithFrame:CGRectMake(self.frame.size.width,0,self.frame.size.width,[self contentViewHeight])];
        [self addSubview:graphView];
    }
    
    return self;
}
- (float)contentViewHeight {
    return self.frame.size.height-(isPad ? 50.0 : 30.0)-7.0;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0,0,self.frame.size.width,[self contentViewHeight]);
}
- (void)slideAnimationFromView:(UIView *)firstView toView:(UIView *)secondView withDuration:(float)duration {
    [UIView animateWithDuration:duration animations:^{
        firstView.frame = CGRectMake(-self.frame.size.width,firstView.frame.origin.y,firstView.frame.size.width,firstView.frame.size.height);
        secondView.frame = CGRectMake(0,secondView.frame.origin.y,secondView.frame.size.width,secondView.frame.size.height);
    }];
}
// UITABLEVIEW DATA SOURCE && DELEGATE ========= //
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
    [objc_getClass("StockManager") clearSharedManager];
    return [[[objc_getClass("StockManager") sharedManager] stocksList] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // init identifier.
    static NSString *informationCellIdentifier = @"StocksWidgetCell";
    
    // remove everithing.
    cell = nil;
    stockItem = nil;
    valueString = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:informationCellIdentifier];
    // check for cell.
    if (cell == nil) {
        cell = [[IBKTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:informationCellIdentifier frame:tableView.frame];
//        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:[UIColor clearColor]];
        [[cell _separatorLine] setBackgroundColor:[UIColor whiteColor]];
        [[cell _ibkTitleLabel] setTextColor:[UIColor whiteColor]];
        [[cell _ibkTitleLabel] setFont:[UIFont systemFontOfSize:12]];
        [[cell _ibkTitleLabel] setLabelize:YES];
        [[cell _ibkSubtitleLabel] setTextColor:[UIColor whiteColor]];
        [[cell _ibkSubtitleLabel] setFont:[UIFont systemFontOfSize:11]];
        [[cell _ibkSubtitleLabel] setAlpha:0.4f];
        [[cell _ibkSubtitleLabel] setLabelize:YES];
        [[cell _ibkValueLabel] setTextColor:[UIColor whiteColor]];
        [[cell _ibkValueLabel] setFont:[UIFont systemFontOfSize:11]];
        [[cell _ibkValueLabel] setBackgroundColor:[UIColor darkGrayColor]];
        [[cell _ibkValueLabel].layer setCornerRadius:5.f];
        [[cell _ibkValueLabel] setLabelize:YES];
    }
    
    // get row stock item.
    [objc_getClass("StockManager") clearSharedManager];
    stockItem = [[[objc_getClass("StockManager") sharedManager] stocksList] objectAtIndex:indexPath.row];
    
    // set text.
    [[cell _ibkTitleLabel] setText:[stockItem listName]];
    [[cell _ibkSubtitleLabel] setText:[stockItem formattedPrice]];
    
    if ([stockItem changeIsNegative]){
        [[cell _ibkValueLabel] setBackgroundColor:[UIColor colorWithRed:255.f/255.f green:50.f/255.f blue:49.f/255.f alpha:1.f]];
        valueString = [NSString stringWithFormat:@"-%@",[stockItem formattedChangePercent:YES includePercentSign:YES]];
    }else if ([stockItem changeIsZero]){
        [[cell _ibkValueLabel] setBackgroundColor:[UIColor darkGrayColor]];
        valueString = [stockItem formattedChangePercent:YES includePercentSign:YES];
    }else {
        [[cell _ibkValueLabel] setBackgroundColor:[UIColor colorWithRed:76.f/255.f green:218.f/255.f blue:100.f/255.f alpha:1.f]];
        valueString = [NSString stringWithFormat:@"+%@",[stockItem formattedChangePercent:YES includePercentSign:YES]];
    }
    // set value text.
    [[cell _ibkValueLabel] setText:valueString];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
// END DATA SOURCE && DELEGATE ================= //
@end