//
//  curagoController.h
//  curago
//
//  Created by Matt Clarke on 21/02/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Preferences/Preferences.h>
#import "IBKHeaderView.h"

@interface curagoController : PSListController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBKHeaderView *headerview;

+(instancetype)sharedInstance;
-(void)loadInPrefsForIndex:(int)index animated:(BOOL)animated;

@end