//
//  MoveView.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//
//

#import <UIKit/UIKit.h>

@interface MoveView : UIView
{
    float moveLevel;
    
    int goal;
}

-(void)setLevel:(NSString *)level goal:(NSString *)arg;

@end
