//
//  cydiaNews.h
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "M13ProgressViewRing.h"

@interface cydiaNews : NSObject<NSXMLParserDelegate> {
    NSMutableDictionary *dictionary;
    NSXMLParser *parser;
    UITableView *table;
    NSString *element;
    NSArray *sections;
    int i;
}

-(void)fetchUpdateWithTable:(UITableView *)arg;

@end

@interface cydiaTableView : UITableView<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate> {
    cydiaNews *news;
    UIRefreshControl *refresh;
    M13ProgressViewRing *loading;
    NSDictionary *dict;
}

-(void)setDictionary:(NSDictionary *)arg;
-(M13ProgressViewRing *)getLoading;
@end
