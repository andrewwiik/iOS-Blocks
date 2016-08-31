//
//  iDownloadBlogFeedParser.h
//  iDownloadBlog
//
//  Created by Matt Clarke on 13/03/2015.
//
//

#import <Foundation/Foundation.h>
#import "iDownloadBlogFeedItem.h"

@class iDownloadBlogFeedParser;

// Delegate
@protocol iDownloadBlogFeedParserDelegate <NSObject>
@optional
- (void)feedParserDidStart:(iDownloadBlogFeedParser*)parser;
- (void)feedParser:(iDownloadBlogFeedParser*)parser didParseFeedItem:(iDownloadBlogFeedItem*)item;
- (void)feedParserDidFinish:(iDownloadBlogFeedParser*)parser;
- (void)feedParser:(iDownloadBlogFeedParser*)parser didFailWithError:(NSError *)error;
@end

@interface iDownloadBlogFeedParser : NSObject {
    NSURL *url;
}

@property (nonatomic, weak) id<iDownloadBlogFeedParserDelegate> delegate;

-(instancetype)initWithUrlString:(NSString*)arg1;
-(void)beginParsing;

@end