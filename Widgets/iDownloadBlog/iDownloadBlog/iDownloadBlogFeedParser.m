//
//  iDownloadBlogFeedParser.m
//  iDownloadBlog
//
//  Created by Matt Clarke on 13/03/2015.
//
//

#import "iDownloadBlogFeedParser.h"
#import "SDFeedParser.h"
@implementation iDownloadBlogFeedParser

-(instancetype)initWithUrlString:(NSString*)arg1 {
    self = [super init];
    
    if (self) {
        url = [NSURL URLWithString:arg1];
    }
    
    return self;
}

-(void)beginParsing {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.delegate feedParserDidStart:self];
        });
        SDFeedParser *feedParser = [[SDFeedParser alloc]init];
        [feedParser parseURL:@"http://www.idownloadblog.com/wp-json/wp/v2/posts/?orderby=date" success:^(NSArray *postsArray, NSInteger postsCount) {
            
            NSLog(@"Fetched %ld posts", postsCount);
            NSLog(@"Posts: %@", postsArray);
            
            for (SDPost *post in postsArray) {
                iDownloadBlogFeedItem *item = [[iDownloadBlogFeedItem alloc] init];
                item.title = post.title;
                item.imageUrl = post.thumbnailURL;
                item.identifier = [NSString stringWithFormat:@"%ld",(long)post.ID];
                item.content = post.plainContent;
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [self.delegate feedParser:self didParseFeedItem:item];
                });
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [self.delegate feedParserDidFinish:self];
            });
            
        }failure:^(NSError *error) {
            
            NSLog(@"Error: %@", error);
            
        }];
        
    });
}

@end
