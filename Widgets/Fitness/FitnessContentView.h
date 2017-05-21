//
//  FitnessContentView.h
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FitnessPageControl.h"
#import "GeneraActivityView.h"
#import "MoveView.h"
#import "ExerciseView.h"
#import "StandView.h"
#import "FitnessDataLoader.h"

@interface FitnessContentView : UIScrollView<UIScrollViewDelegate>
{
    FitnessPageControl *pageControl;
    
    FitnessIconView *iconView;
    
    GeneraActivityView *general;
    
    MoveView *move;
    
    ExerciseView *exercise;
    
    StandView *stand;
}

-(id)initWithFrame:(CGRect)frame target:(FitnessIconView *)arg;

@end

@interface IBKAPI : NSObject

+(CGFloat)heightForContentViewWithIdentifier:(NSString *)identifier;

@end