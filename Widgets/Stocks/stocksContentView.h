//
//  stocksContentView.h
//  stocks
//
//  Created by Pigi Galdi on 10/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// import table.
#import "IBKTableView/IBKTableView.h"

@interface IBKAPI : NSObject
+ (CGFloat)heightForContentViewWithIdentifier:(NSString *)identifier;
@end

@interface Stock : NSObject
- (id)listName;
- (id)formattedPrice;
- (id)formattedChangePercent:(BOOL)percent includePercentSign:(BOOL)hasPercentSign;
- (BOOL)changeIsNegative;
- (BOOL)changeIsZero;
- (id)chartDataForInterval:(long long)interval;
@end
@interface StockManager : NSObject
+ (void)clearSharedManager;
+ (StockManager *)sharedManager;
- (NSMutableArray *)stocksList;
- (void)addStock:(id)stock;
- (void)removeStock:(id)stock;
@end
@interface StockGraphView : UIView
- (id)initWithFrame:(CGRect)frame;
- (void)loadStockChartData:(id)data;
- (void)clearData;
@end

@interface stocksContentView : UIView <UITableViewDataSource, UITableViewDelegate> {
    IBKTableView *_tableView;
    IBKTableViewCell *_cell;
    Stock *_stockItem;
    NSString *_valueString;
    StockGraphView *_graphView;
}
@property (nonatomic, retain) IBKTableView *_tableView;
@property (nonatomic, retain) IBKTableViewCell *_cell;
@property (nonatomic, retain) Stock *_stockItem;
@property (nonatomic, retain) NSString *_valueString;
@property (nonatomic, retain) StockGraphView *_graphView;
@end