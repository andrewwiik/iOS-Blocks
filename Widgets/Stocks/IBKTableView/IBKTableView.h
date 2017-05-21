//
//  IBKTableView.h
//  AlarmWidget
//
//  Created by Pigi Galdi on 10/08/15.
//
//
//  import framework.
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
//  import cell.
#import "IBKTableViewCell.h"

@interface IBKTableView : UITableView <UIScrollViewDelegate> {
    BOOL hasShadow;
    BOOL hasRefreshControl;
    UIRefreshControl *refreshControl;
}
@property (nonatomic, assign) BOOL hasShadow;
@property (nonatomic, assign) BOOL hasRefreshControl;
@property (nonatomic, retain) UIRefreshControl *refreshControl;
@end
