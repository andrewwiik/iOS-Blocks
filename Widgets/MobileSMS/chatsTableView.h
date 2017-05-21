//
//  chatsTableView.h
//  MobileSMS
//
//  Created by gabriele on 19/04/15.
//
//

#import <UIKit/UIKit.h>
#import "chatsLoader.h"
#import "timerLabelDate.h"
#import "CBAutoScrollLabel.h"
#import "chatCell.h"

@interface chatsTableView : UITableView<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSDictionary *chats;
}

@end

@interface UIApplication (Messagges)

-(void)launchApplicationWithIdentifier:(NSString *)identifier suspended:(BOOL)arg;

@end
