//
//  main.m
//  ParseWeatherShit
//
//  Created by Matt Clarke on 26/03/2015.
//  Copyright (c) 2015 Matt Clarke. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSArray *sortedKeys = [[NSString stringWithContentsOfFile:@"/Users/Matt/iOS/Projects/Curago/Git/Widgets/Weather/Working/Names.txt" encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
        printf("NSString *filename = @""\n");
        printf("switch (condition) {\n");
        
        int count = 0;
        
        for (NSString *key in sortedKeys) {
            
            printf("\tcase %d:\n", count);
            
            NSString *color1 = [NSString stringWithFormat:@"\t\tfilename = @\"%@\";", key];
                
            printf("%s\n\t\tbreak;\n", [color1 cStringUsingEncoding:NSUTF8StringEncoding]);
            
            count++;
        }
        
        printf("}\n");
    }
    return 0;
}

