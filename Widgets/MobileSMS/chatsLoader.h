//
//  chatsLoader.h
//  MobileSMS
//
//  Created by gabriele on 19/04/15.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

// #define search_by_email 17
// #define search_by_number 16

@interface chatsLoader : NSObject

+(NSDictionary *)getChatsDictionary;

@end
