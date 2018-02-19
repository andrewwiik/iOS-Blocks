//
//  chatsLoader.m
//  MobileSMS
//
//  Created by gabriele on 19/04/15.
//
//

#import "chatsLoader.h"

@implementation chatsLoader

//Get contact info by looking in the addressbook database
static int search_by_email = 18;
static int search_by_number = 17;
// (int)key -> 17 search by email/ 16 by number
 
+(NSString *)getPersonInfoByKey:(int)key value:(NSString *)value {
    NSString *path = @"/var/mobile/Library/AddressBook/AddressBook.sqlitedb"; //Databse path
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        const char *dbpath = [path UTF8String];
        sqlite3 *chats;
        if (sqlite3_open(dbpath, &chats) == SQLITE_OK) {
            NSLog(@"Database opened!");
            sqlite3_stmt *s;
            NSString *q = @"SELECT * FROM ABPERSONFULLTEXTSEARCH_CONTENT";
            if (sqlite3_prepare_v2(chats, [q UTF8String], -1, &s, NULL) == SQLITE_OK) {
                while (sqlite3_step(s) == SQLITE_ROW) {
                    NSString *obj = ((char *)sqlite3_column_text(s, key)) ? [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(s, key)] :
                    nil;
                    if (obj == nil) {
                        continue;
                    }
                    if ([obj isEqualToString:value] || [obj rangeOfString:value].location != NSNotFound) {
                        NSString *string = @"";
                        NSString *first = ((char *)sqlite3_column_text(s, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(s, 1)] :
                        nil;
                        if (first != nil) {
                            string = first;
                        }
                        NSString *last = ((char *)sqlite3_column_text(s, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(s, 2)] :
                        nil;
                        if (last != nil) {
                            if ([string length] != 0) {
                                string = [NSString stringWithFormat:@"%@ %@", string, last];
                            }else {
                                if ([last length] != 0) {
                                    string = last;
                                }else {
                                    string = value;
                                }
                            }
                        }
                        return string;
                    }
                }
                sqlite3_finalize(s);
            }
            sqlite3_close(chats);
            
        } else {
            NSLog(@"Error while loading messagges database!");
        }
    }else {
        NSLog(@"File not found!");
    }
    
    return value;
}

/*Grab all messages data from SMS database*/
+(NSDictionary *)getChatsDictionary {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0) {
        search_by_email = 17;
        search_by_number = 16;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *path = @"/var/mobile/Library/SMS/sms.db"; //SMS database path
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss Z"];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    NSDate *creationDate = [dateFormatter dateFromString:@"2001-01-01 00:00:00 +0000"];
    int i = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        const char *dbpath = [path UTF8String];
        sqlite3 *chats;
        if (sqlite3_open(dbpath, &chats) == SQLITE_OK) {
            NSLog(@"Database opened!");
            sqlite3_stmt *statement;
            //'Ôøº' represents a 0 lenght string so we don't want to display a null message
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM message WHERE TEXT <> 'Ôøº' GROUP BY HANDLE_ID ORDER BY ROWID DESC"]; //
            if (sqlite3_prepare_v2(chats, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    NSString *room_name = ((char *)sqlite3_column_text(statement, 35)) ? [NSString stringWithString:[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 35)]] :
                    nil;
                    
                    if (room_name != nil) {
                        if (![array containsObject:room_name]) {
                            [array addObject:room_name];
                        }else {
                            continue;
                        }
                    }
                    NSMutableDictionary *subdict = [NSMutableDictionary dictionary];
                    NSString *text = ((char *)sqlite3_column_text(statement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] : nil;
                    if (text == nil) {
                        text = @"";
                    }
                    NSString *q1 = [NSString stringWithFormat:@"%s",(const char *) sqlite3_column_text(statement, 0)];
                    NSString *q = [NSString stringWithFormat:@"SELECT ATTACHMENT_ID FROM MESSAGE_ATTACHMENT_JOIN WHERE MESSAGE_ID = %@", q1];
                    sqlite3_stmt *s;
                    /*Loop to get the latest attchament of the chat*/
                    if (sqlite3_prepare_v2(chats, [q UTF8String], -1, &s, NULL) == SQLITE_OK) {
                        while (sqlite3_step(s) == SQLITE_ROW) {
                            NSString *chat_id = [NSString stringWithFormat:@"%s",(const char *) sqlite3_column_text(s, 0)];
                            NSString *qu = [NSString stringWithFormat:@"SELECT * FROM ATTACHMENT WHERE ROWID = %@", chat_id];
                            sqlite3_stmt *st;
                            if (sqlite3_prepare_v2(chats, [qu UTF8String], -1, &st, NULL) == SQLITE_OK) {
                                while (sqlite3_step(st) == SQLITE_ROW) {
                                    NSString *file = [NSString stringWithFormat:@"%s",(const char *) sqlite3_column_text(st, 4)];
                                    //Get file
                                    file = [file stringByReplacingOccurrencesOfString:@"~" withString:@"/var/mobile"];
                                    
                                    if ([[file lowercaseString] hasSuffix:@"png"] || [[file lowercaseString] hasSuffix:@"jpg"] || [[file lowercaseString] hasSuffix:@"jpeg"]) {
                                        //Attachment is an image file
                                        [subdict setObject:file forKey:@"file"];
                                        text = @"";
                                    }else if ([[file lowercaseString] hasSuffix:@"amr"]) {
                                        //text = @"Audo / Video";
                                        text = @"";
                                        [subdict setObject:@"/Library/Curago/Widgets/filliponi.com.apple.MobileSMS/audio.png" forKey:@"file"];
                                        
                                    }else {
                                        //Other file type
                                        text = [NSString stringWithFormat:@"Attachment: %@", file];
                                    }
                                }
                            }
                        }
                    }
                    
                    NSDate *date = [NSDate dateWithTimeInterval:sqlite3_column_double(statement, 15) sinceDate:creationDate];
                    BOOL error = [[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 14)] boolValue]; //has the message been send or while sending an error as occured?
                    BOOL read = [[NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement, 26)] boolValue]; //has the messahe been read?
                    NSString *queryPart1 = [NSString stringWithFormat:@"%s",(const char *) sqlite3_column_text(statement, 0)];
                    NSString *query1 = [NSString stringWithFormat:@"SELECT CHAT_ID FROM CHAT_MESSAGE_JOIN WHERE MESSAGE_ID = %@", queryPart1];
                    //Loop chats to get identifier and it's display name (if the chat is a group)
                    sqlite3_stmt *statement1;
                    if (sqlite3_prepare_v2(chats, [query1 UTF8String], -1, &statement1, NULL) == SQLITE_OK) {
                        while (sqlite3_step(statement1) == SQLITE_ROW) {
                            NSString *chat_id = [NSString stringWithFormat:@"%s",(const char *) sqlite3_column_text(statement1, 0)];
                            NSString *query2 = [NSString stringWithFormat:@"SELECT * FROM CHAT WHERE ROWID = %@", chat_id];
                            sqlite3_stmt *statement2;
                            if (sqlite3_prepare_v2(chats, [query2 UTF8String], -1, &statement2, NULL) == SQLITE_OK) {
                                while (sqlite3_step(statement2) == SQLITE_ROW) {
                                    NSString *identifier = [NSString stringWithFormat:@"%s",(const char *) sqlite3_column_text(statement2, 6)];
                                    NSString *display_name = ((char *)sqlite3_column_text(statement2, 12)) ? [NSString stringWithFormat:@"%s",(char *)sqlite3_column_text(statement2, 12)] :
                                    nil;
                                    if (display_name == nil) {
                                        display_name = @"";
                                    }
                                    if ([display_name length] != 0)  {
                                        [subdict setObject:display_name forKey:@"identifier"];
                                        [subdict setObject:identifier ? [NSString stringWithFormat:@"//open?groupid=%@", identifier] : @"" forKey:@"open"];
                                    }else {
                                        [subdict setObject:identifier ? identifier : @"" forKey:@"open"];
                                        if (identifier == nil || [identifier length] == 0) {
                                            [subdict setObject:@"Unknow" forKey:@"identifier"];
                                        }else {
                                            if ([identifier rangeOfString:@"@"].location != NSNotFound) {
                                                [subdict setObject:[self getPersonInfoByKey:search_by_email value:identifier] forKey:@"identifier"];
                                            }else {
                                                [subdict setObject:[self getPersonInfoByKey:search_by_number value:[NSString stringWithFormat:@" %@ ", identifier]] forKey:@"identifier"];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    [subdict setObject:text forKey:@"text"];
                    [subdict setObject:date forKey:@"date"];
                    if (error) {
                        [subdict setObject:@YES forKey:@"error"];
                    }else {
                        [subdict setObject:@NO forKey:@"error"];
                    }
                    if (read) {
                        [subdict setObject:@YES forKey:@"read"];
                    }else {
                        [subdict setObject:@NO forKey:@"read"];
                    }
                    [dict setObject:subdict forKey:[[NSNumber numberWithInt:i] stringValue]];
                    i++;
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(chats);
            
        }else{
            NSLog(@"Error while loading messagges database!");
        }
    }else{
        NSLog(@"File not found!");
    }
    //Return our dictionary that contains everythin
    return dict;
}

/*
 To open a message the 'n' chat do this
 NSDictioanry *chats = [self getChatsDictionary];
 NSString *iden = [[chats objectForKey:[[NSNumber numberWithInteger:n] stringValue]] objectForKey:@"open"];
 if ([iden length] == 0) {
    return;
 }
 NSString *stringURL;
 stringURL = [NSString stringWithFormat:@"%@%@", @"sms:" , iden];
 NSURL *url = [NSURL URLWithString:stringURL];
 [[UIApplication sharedApplication] openURL:url];
 */

@end
