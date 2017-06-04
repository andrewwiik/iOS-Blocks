//
//  MusicWidgetViewController.h
//  Music
//
//  Created by Matt Clarke on 04/11/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import <IBKKit/IBKWidgetDelegate-Protocol.h>
#import "IBKMusicButton.h"


@interface MusicWidgetViewController : NSObject <IBKWidgetDelegate> {
	UIImage *_playImage;
	UIImage *_pauseImage;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, readwrite) BOOL isPad;
@property (nonatomic, strong) UILabel *songtitle;
@property (nonatomic, strong) UILabel *artist;
@property (nonatomic, strong) UIImageView *artwork;
@property (nonatomic, strong) UILabel *noMediaPlaying;
@property (nonatomic, strong) IBKMusicButton *forward;
@property (nonatomic, strong) IBKMusicButton *rewind;
@property (nonatomic, strong) IBKMusicButton *play;

-(UIView*)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad;
-(BOOL)hasButtonArea;
-(BOOL)hasAlternativeIconView;

@end