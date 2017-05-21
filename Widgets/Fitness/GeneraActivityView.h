//
//  GeneraActivityView.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import <UIKit/UIKit.h>

@interface GeneraActivityView : UIView
{
    float standLevel;
    
    float moveLevel;
    
    float exercizeLevel;
}

-(void)setCal:(NSString *)cal goal:(NSString *)goal exercise:(NSString *)exercise stand:(NSString *)stand;

@end
