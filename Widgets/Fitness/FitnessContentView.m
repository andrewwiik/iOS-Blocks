//
//  FitnessContentView.m
//  Fitness
//
//  Created by gabriele filipponi on 08/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FitnessContentView.h"

float size = 8.0;

@implementation FitnessContentView

-(id)initWithFrame:(CGRect)frame target:(FitnessIconView *)arg
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        iconView = arg;
        
        NSDictionary *data = [FitnessDataLoader fetchFitnessData];
        
        NSString *goal = [data objectForKey:@"LatestCalorieBurnGoalMetCalories"];
        
        NSString *cal = [data objectForKey:@"CaloriesBurnedToday"];
        
        NSString *min = [data objectForKey:@"BriskMinutesToday"];
        
        NSString *hour = [data objectForKey:@"StandingHoursToday"];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.pagingEnabled = YES;
        
        [self setContentSize:CGSizeMake(frame.size.width * 4.0, 0.0)];
        
        self.delegate = self;
        
        self.showsHorizontalScrollIndicator = NO;
        
        self.showsVerticalScrollIndicator = NO;
        
        pageControl = [[FitnessPageControl alloc] initWithFrame:CGRectMake(frame.size.width / 3.0, [self contentViewHeight] + (frame.size.height - [self contentViewHeight] - size) / 2.0, frame.size.width / 3.0, size)];
        
        [self addSubview:pageControl];
        
        float size = [self contentViewHeight] * 8.5 / 10.0;
        
        general = [[GeneraActivityView alloc] initWithFrame:CGRectMake((frame.size.width - size) / 2.0, (frame.size.height - size) / 2.0 - 10.0, size, size)];
        
        [general setCal:cal goal:goal exercise:min stand:hour];
        
        [iconView setCal:cal goal:goal exercise:min stand:hour];
        
        [self addSubview:general];
        
        move = [[MoveView alloc] initWithFrame:CGRectMake((frame.size.width - size) / 2.0 + frame.size.width, (frame.size.height - size) / 2.0 - 10.0, size, size)];
        
        [move setLevel:cal goal:goal];
        
        [self addSubview:move];
        
        exercise = [[ExerciseView alloc] initWithFrame:CGRectMake((frame.size.width - size) / 2.0 + frame.size.width * 2.0, (frame.size.height - size) / 2.0 - 10.0, size, size)];
        
        [exercise setLevel:min];
        
        [self addSubview:exercise];
        
        stand = [[StandView alloc] initWithFrame:CGRectMake((frame.size.width - size) / 2.0 + frame.size.width * 3.0, (frame.size.height - size) / 2.0 - 10.0, size, size)];
        
        [stand setLevel:hour];
        
        [self addSubview:stand];
    }
    
    return self;
}

-(CGFloat)contentViewHeight
{
    return [NSClassFromString(@"IBKAPI") heightForContentViewWithIdentifier:@"com.apple.fitness"] - 5.0;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setContentSize:CGSizeMake(self.frame.size.width * 4.0, 0.0)];
    
    if (self.contentOffset.x <= (self.contentSize.width - self.frame.size.width))
    {
        pageControl.frame = CGRectMake(self.frame.size.width / 3.0 + self.contentOffset.x, [self contentViewHeight] + (self.frame.size.height - [self contentViewHeight] - size) / 2.0, self.frame.size.width / 3.0, size);
    }
    
    float size = [self contentViewHeight] * 8.5 / 10.0;
    
    general.frame = CGRectMake((self.frame.size.width - size) / 2.0, (self.frame.size.height - size) / 2.0 - 10.0, size, size);
    
    move.frame = CGRectMake((self.frame.size.width - size) / 2.0 + self.frame.size.width, (self.frame.size.height - size) / 2.0 - 10.0, size, size);
    
    exercise.frame = CGRectMake((self.frame.size.width - size) / 2.0 + self.frame.size.width * 2.0, (self.frame.size.height - size) / 2.0 - 10.0, size, size);
    
    stand.frame = CGRectMake((self.frame.size.width - size) / 2.0 + self.frame.size.width * 3.0, (self.frame.size.height - size) / 2.0 - 10.0, size, size);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = [[NSNumber numberWithDouble:fmax(floor(scrollView.contentOffset.x / self.frame.size.width), 0.0)] intValue];
    
    if (scrollView.contentOffset.x <= (scrollView.contentSize.width - scrollView.frame.size.width))
    {
        pageControl.frame = CGRectMake(self.frame.size.width / 3.0 + self.contentOffset.x, [self contentViewHeight] + (self.frame.size.height - [self contentViewHeight] - size) / 2.0, self.frame.size.width / 3.0, size);
    }
    
    [pageControl selectPage:index target:iconView];
}

@end