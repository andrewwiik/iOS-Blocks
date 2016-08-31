//
//  SDFeedParser.m
//  SDFeedParser
//
//  Created by Sebastian Dobrincu on 17/07/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//

#import "SDFeedParser.h"
#import "AFNetworking.h"
#import "SDPost+SDPostFromDictionary.h"
#import "SDCategory+SDCategoryFromDictionary.h"
#import "SDComment+SDCommentFromDictionary.h"
#import "SDTag+SDTagFromDictionary.h"
#import "AFNetworking.h"
#import "NSString+StringByStrippingHTML.h"
#import "NSString+HTML.h"

@implementation SDFeedParser

- (void)parseURL:(NSString*)urlString success:(void (^)(NSArray *postsArray, NSInteger postsCount))successBlock failure:(void (^)(NSError *error))failureBlock{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            //Get posts count
            _postsCount = [responseObject count];
            
            //Get pages count
            _pagesCount = 1;
            
            //Fetch posts
            NSMutableArray *allPosts = [[NSMutableArray alloc]initWithCapacity:[responseObject count]];
            NSArray *fetchedPostsArray = [responseObject copy];
            for (NSDictionary *eachPost in fetchedPostsArray) {
                
                SDPost *currentPost = [SDPost SDPostFromDictionary:eachPost];
                NSArray *thumbJSONArray = [eachPost valueForKeyPath:@"_links.wp:featuredmedia"];
                NSString *thumbJSONURL = [(NSDictionary*)[thumbJSONArray objectAtIndex:0] objectForKey:@"href"];
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                //NSLog(@"THUMB URL: %@", thumbJSONURL);
                [manager GET:thumbJSONURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //        NSLog(@"Response Object: %@", responseObject);
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        //Get posts count
                        //NSString *thumbString = [responseObject valueForKeyPath:@"media_details.sizes.featured-thumbnail.source_url"];
                        //NSLog(@"Thumb String: %@",thumbString);
                        currentPost.thumbnailURL = [responseObject valueForKeyPath:@"media_details.sizes.featured-thumbnail.source_url"];
                        
                    }
                    else {
                        //NSLog(@"Not a Dict");
                    }
                    
                    [allPosts addObject:currentPost];
                    _postsArray = [allPosts copy];
                    successBlock(self.postsArray, self.postsArray.count);
                    //Trigger success block
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"Failed Getting Thumb");
                    
                    
                }];

                
                //Fetch posts category
//                NSMutableArray *allCategories = [[NSMutableArray alloc]init];
//                NSArray *fetchedCategoriesArray = eachPost[@"categories"];
//                for (NSDictionary *eachCategory in fetchedCategoriesArray) {
//                    
//                    SDCategory *currentCategory = [SDCategory SDCategoryFromDictionary:eachCategory];
//                    [allCategories addObject:currentCategory];
//                }
//                currentPost.categoriesArray = [allCategories copy];
//                
//                //Fetch posts tags
//                NSMutableArray *allTags = [[NSMutableArray alloc]init];
//                NSArray *fetchedTagsArray = eachPost[@"tags"];
//                for (NSDictionary *eachTag in fetchedTagsArray) {
//                    
//                    SDTag *currentTag = [SDTag SDTagFromDictionary:eachTag];
//                    [allTags addObject:currentTag];
//                }
//                currentPost.tagsArray = [allTags copy];
//                currentPost.authorInfo = eachPost[@"author"];
//                
//                //Fetch posts comments
//                NSMutableArray *allComments = [[NSMutableArray alloc]initWithCapacity:[eachPost[@"comment_count"] integerValue]];
//                NSArray *fetchedCommentsArray = eachPost[@"comments"];
//                for (NSDictionary *eachComment in fetchedCommentsArray) {
//                    
//                    SDComment *currentComment = [SDComment SDCommentFromDictionary:eachComment];
//                    [allComments addObject:currentComment];
//                }
//                currentPost.commentsArray = [allComments copy];
//                currentPost.commentsCount = [eachPost[@"comment_count"] integerValue];
//                currentPost.status = responseObject[@"comment_status"];
                
            }
            _postsArray = [allPosts copy];
        }
        
        //Trigger success block
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //Trigger failure block
        failureBlock(error);
        
    }];
    
}



@end
