//
//  FitnessDataLoader.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import "FitnessDataLoader.h"

@implementation FitnessDataLoader

+(NSDictionary *)fetchFitnessData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *path = @"/var/mobile/Library/Health/healthdb_secure.sqlite";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        const char *dbpath = [path UTF8String];
        
        sqlite3 *chats;
        
        if (sqlite3_open(dbpath, &chats) == SQLITE_OK)
        {
            NSLog(@"Database opened!");
            
            sqlite3_stmt *statement;
            
            NSString *query = [NSString stringWithFormat:@"SELECT * FROM key_value_secure WHERE key = 'LatestCalorieBurnGoalMetCalories' OR key = 'BriskMinutesToday' OR key = 'StandingHoursToday' OR key = 'CaloriesBurnedToday'"]; //
            
            if (sqlite3_prepare_v2(chats, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSString *key = ((char *)sqlite3_column_text(statement, 4)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] :
                    nil;
                    
                    NSString *value = ((char *)sqlite3_column_text(statement, 5)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] : nil;
                    
                    [dict setObject:value forKey:key];
                }
                
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(chats);
            
        } else
        {
            NSLog(@"Error while loading Fitness database!");
        }
    }else
    {
        NSLog(@"File not found!");
    }
    
    return dict;
}

@end
