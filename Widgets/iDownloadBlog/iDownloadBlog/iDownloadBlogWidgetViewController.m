//
//  iDownloadBlogWidgetViewController.m
//  iDownloadBlog
//
//  Created by Matt Clarke on 12/03/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//
#import "SDFeedParser.h"
#import "iDownloadBlogWidgetViewController.h"
#import "IBKLabel.h"

@implementation iDownloadBlogWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (!self.contentView) {
		self.contentView = [[iDownloadBlogContentView alloc] initWithFrame:frame];
	}

	return self.contentView;
}

-(BOOL)hasButtonArea {
    return YES;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

-(BOOL)wantsNoContentViewFadeWithButtons {
    return YES;
}

-(UIView*)buttonAreaViewWithFrame:(CGRect)frame {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    IBKLabel *label = [[IBKLabel alloc] initWithFrame:view.bounds];
    label.text = @"New Posts";
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.alpha = 0.5;
    
    [label setLabelSize:kIBKLabelSizingButtonView];
    
    [view addSubview:label];
    
    return view;
}

-(BOOL)wantsGradientBackground {
    return YES;
}

-(NSArray*)gradientBackgroundColors {
    return [NSArray arrayWithObjects:@"4898c8", @"3c0099", nil];
}

- (void)testShit {
    SDFeedParser *feedParser = [[SDFeedParser alloc]init];
    [feedParser parseURL:@"http://www.idownloadblog.com/wp-json/wp/v2/posts/?orderby=date" success:^(NSArray *postsArray, NSInteger postsCount) {
        
        NSLog(@"Fetched %ld posts", postsCount);
        NSLog(@"Posts: %@", postsArray);
        
        for (SDPost *post in postsArray) {
            NSLog(@"Post: \n Title: %@ \n Image URl: %@", post.title, post.thumbnailURL);
        }
        
    }failure:^(NSError *error) {
        
        NSLog(@"Error: %@", error);
        
    }];
}

@end