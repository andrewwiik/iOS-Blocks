//
//  iDownloadBlogContentView.h
//  iDownloadBlog
//
//  Created by Matt Clarke on 12/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "iDownloadBlogFeedParser.h"
#import "Reachability.h"

@interface iDownloadBlogContentView : UIView <iCarouselDataSource, iCarouselDelegate, iDownloadBlogFeedParserDelegate> {
    NSTimer *switcherTimer;
}

@property (nonatomic, strong) iCarousel *carousel;
@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) iDownloadBlogFeedParser *feedParser;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSMutableDictionary *preloadedImages;
@property (nonatomic, strong) UIView *loadingView;

-(void)reloadForSettingsChangeOrNewUpdate:(id)sender;

@end