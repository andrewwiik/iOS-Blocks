//
//  cydiaNews.m
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//
//

#import "cydiaNews.h"

@implementation cydiaNews

-(id)init {
    self = [super init];
    if (self) {
        dictionary = [[NSMutableDictionary alloc] init];
        NSString *path = @"/Library/Curago/Widgets/com.iosblocks.cydia.block/Sections";
        NSError *error = nil;
        sections = [[NSArray alloc] initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error]];
    }
    return self;
}

-(void)fetchUpdateWithTable:(UITableView *)arg {
    [UIView animateWithDuration:0.2 animations:^
     {
         [((cydiaTableView *)arg) getLoading].alpha = 1.0;
     }];
    i = -1;
    table = arg;
    [dictionary removeAllObjects];
    NSURL *url = [NSURL URLWithString:@"http://feeds.cydiaupdates.com/CydiaupdatesAllSections"];
    parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    element = elementName;
    if ([element isEqualToString:@"item"]) {
        i++;
        NSDictionary *dict = [NSDictionary dictionary];
        [dictionary setObject:dict forKey:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (i == -1) {
        return;
    }
    NSString *key = [NSString stringWithFormat:@"%d", i];
    if ([element isEqualToString:@"title"]) {
        if ([[[dictionary objectForKey:key] objectForKey:@"title"] length] == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict addEntriesFromDictionary:[dictionary objectForKey:key]];
            [dict setObject:[self getFileImage:string] forKey:@"image"];
            [dict setObject:@([string rangeOfString:@"New"].location != NSNotFound) forKey:@"new"];
            if ([string rangeOfString:@"("].location != NSNotFound) {
                NSInteger loc = [string length] - 1;
                NSInteger k;
                BOOL found = NO, found_par = NO;
                for (k = loc; k >= 0; k--) {
                    NSString *ch = [string substringWithRange:NSMakeRange(k, 1)];
                    if ([ch isEqualToString:@"."] && found_par) {
                        found = YES;
                    }else if ([ch isEqualToString:@" "] && found && found_par) {
                        string = [string substringToIndex:k];
                        break;
                    }else if ([ch isEqualToString:@"("]) {
                        found_par = YES;
                    }
                }
            }
            [dict setObject:string forKey:@"title"];
            [dictionary setObject:dict forKey:key];
        }
    } else if ([element isEqualToString:@"description"]) {
        if ([[[dictionary objectForKey:key] objectForKey:@"description"] length] == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict addEntriesFromDictionary:[dictionary objectForKey:key]];
            [dict setObject:string forKey:@"description"];
            [dictionary setObject:dict forKey:key];
        }
    } else if ([element isEqualToString:@"feedburner:origLink"]) {
        if ([[[dictionary objectForKey:key] objectForKey:@"package"] length] == 0)
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict addEntriesFromDictionary:[dictionary objectForKey:key]];
            [dict setObject:[string stringByReplacingOccurrencesOfString:@"http://cydiaupdates.com/pkg/" withString:@""] forKey:@"package"];
            [dictionary setObject:dict forKey:key];
        }
    }
}

-(NSString *)getFileImage:(NSString *)str{
    if (sections) {
        for (NSString *file in sections) {
            NSString *icon = [file lowercaseString];
            icon = [icon stringByReplacingOccurrencesOfString:@"@2x.png" withString:@""];
            if ([str.lowercaseString rangeOfString:icon].location != NSNotFound) {
                return [NSString stringWithFormat:@"/Library/Curago/Widgets/com.iosblocks.cydia.block/Sections/%@", file];
            }
        }
    }
    return @"";
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [UIView animateWithDuration:0.2 animations:^
    {
        [((cydiaTableView *)table) getLoading].alpha = 0.0;
    }];
    [((cydiaTableView *)table) setDictionary:dictionary];
}

@end
