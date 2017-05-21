//
//  FitnessDataLoader.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FitnessDataLoader : NSObject

+(NSDictionary *)fetchFitnessData;

@end
