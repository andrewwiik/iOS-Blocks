//
//  CydiaContentView.h
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "cydiaTableView.h"

@interface CydiaContentView : UIView {
    cydiaTableView *table;
}
@end

@interface IBKAPI : NSObject
+(CGFloat)heightForContentViewWithIdentifier:(NSString *)identifier;
@end