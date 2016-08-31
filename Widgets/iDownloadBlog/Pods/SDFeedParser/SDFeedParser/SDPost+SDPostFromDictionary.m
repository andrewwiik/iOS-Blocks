//
//  SDPost+SDPostFromDictionary.m
//  SDFeedParser-Demo
//
//  Created by Peter Foti on 9/4/14.
//  Copyright (c) 2014 Sebastian Dobrincu. All rights reserved.
//
#import "AFNetworking.h"
#import "SDPost+SDPostFromDictionary.h"
#import "NSString+StringByStrippingHTML.h"
#import "NSString+HTML.h"

@implementation SDPost (SDPostFromDictionary)

+ (SDPost *)SDPostFromDictionary:(NSDictionary *)dictionary
{
    SDPost *newPost = [SDPost new];
    newPost.ID = [dictionary[@"id"] integerValue];
    newPost.slug = dictionary[@"slug"];
    //    newPost.URL = dictionary[@"url"];
    newPost.title = [[dictionary valueForKeyPath:@"title.rendered"] stringByDecodingHTMLEntities];
    newPost.plainContent = [[dictionary valueForKeyPath:@"excerpt.rendered"] stringByConvertingHTMLToPlainText];
//    
//    newPost.thumbnailURL = dictionary[@"thumbnail"];
//    newPost.content = dictionary[@"content"];
//    newPost.plainContent = [NSString stringByStrippingHTML:dictionary[@"content"]];
//    NSArray *postsWords = [newPost.content componentsSeparatedByString:@" "];
//    NSInteger readingTime = postsWords.count/230;
//    newPost.contentReadingMinutes = readingTime;
//    newPost.excerpt = dictionary[@"excerpt"];
//    newPost.date = dictionary[@"date"];
//    newPost.lastModifiedDate = dictionary[@"modified"];
    
    return newPost;
}

@end
