//
//  MusicWidgetViewController.m
//  Music
//
//  Created by Matt Clarke on 04/11/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MusicWidgetViewController.h"
#import <SpringBoard7.0/SBMediaController.h>
#import "IBKMusicButton.h"
#import <objc/runtime.h>

@interface SBMediaController (iOS8)
-(NSString*)ibkNowPlayingArtist;
-(NSString*)ibkNowPlayingAlbum;
-(NSString*)ibkNowPlayingTitle;
-(UIImage*)ibkArtwork;
-(BOOL)ibkTrackSupports15SecondFF;
-(BOOL)ibkTrackSupports15SecondRewind;
@end

@interface IBKResources : NSObject

+(CGFloat)widthForWidget;

@end

#define IOS8_or_higher ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define path @"/var/mobile/Library/Curago/Widgets/com.apple.Music/"

@implementation MusicWidgetViewController

-(UIView *)viewWithFrame:(CGRect)frame isIpad:(BOOL)isIpad {
	if (self.view == nil) {
        self.isPad = isIpad;
        
		self.view = [[UIView alloc] initWithFrame:frame];
		self.view.backgroundColor = [UIColor clearColor];

		// Alright! If we're iPad, then render text too, else, just artwork.
        
        self.noMediaPlaying = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [objc_getClass("IBKResources") widthForWidget]-40, (isIpad ? 207 : 118)-(isIpad ? 50 : 30))];
        self.noMediaPlaying.numberOfLines = 0;
        self.noMediaPlaying.text = @"No media playing";
        self.noMediaPlaying.textAlignment = NSTextAlignmentCenter;
        self.noMediaPlaying.textColor = [UIColor whiteColor];
        self.noMediaPlaying.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        self.noMediaPlaying.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:self.noMediaPlaying];
        
        // Artwork.
        
        self.artwork = [[UIImageView alloc] initWithFrame:frame];
        self.artwork.backgroundColor = [UIColor clearColor];
        self.artwork.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.view addSubview:self.artwork];
        
        if (isIpad) {
            // Title and artist.
            
            // TODO.
        }
        
        // Notifications.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveUpdateToMusicData:) name:@"IBK-UpdateMusic" object:nil];
        
        // And if playing, update!
        
        if ([(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]) {
            [self didReceiveUpdateToMusicData:nil];
            
            self.noMediaPlaying.alpha = 0.0;
        }
	}

	return self.view;
}

-(void)didReceiveUpdateToMusicData:(id)sender {
    // I'd imagine we can pull data from SpringBoard now.
    NSLog(@"*** [Curago | com.apple.music] :: Pulling new data");
    
    if (IOS8_or_higher) {
        // Deal with that shit.
        [self performSelector:@selector(delayed8update) withObject:nil afterDelay:1.0];
    } else {
        self.artwork.image = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] _nowPlayingInfo] [@"artworkData"];
        self.songtitle.text = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] nowPlayingTitle];
        self.artist.text = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] nowPlayingArtist];
        
        // Update control buttons state.
        [self setPlayButtonState:[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]];
        
        if (![(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying] && ![(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] _nowPlayingInfo] [@"artworkData"])
            self.noMediaPlaying.alpha = 1.0;
        else
            self.noMediaPlaying.alpha = 0.0;
    }
}

-(void)delayed8update {
    self.artwork.image = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] ibkArtwork];
    self.songtitle.text = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] ibkNowPlayingTitle];
    self.artist.text = [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] ibkNowPlayingArtist];
    
    // Update control buttons state.
    [self setPlayButtonState:[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]];
    
    if (![(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying] && ![(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] ibkArtwork])
        self.noMediaPlaying.alpha = 1.0;
    else
        self.noMediaPlaying.alpha = 0.0;
}

-(void)setPlayButtonState:(BOOL)state {
    if (state) {
        self.play.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Pause%@", path, [self suffix]]];
    } else {
        self.play.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Play%@", path, [self suffix]]];
    }
}

-(BOOL)hasButtonArea {
    return YES;
}

-(BOOL)hasAlternativeIconView {
    return NO;
}

-(UIView*)buttonAreaViewWithFrame:(CGRect)frame {
    UIView *buttons = [[UIView alloc] initWithFrame:frame];
    buttons.backgroundColor = [UIColor clearColor];
    
    self.forward = [IBKMusicButton buttonWithType:UIButtonTypeCustom];
    self.forward.frame = CGRectMake(frame.size.width-25, (frame.size.height/2)-10, 20, 20);
    self.forward.backgroundColor = [UIColor clearColor];
    self.forward.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Forward%@", path, [self suffix]]];
    [self.forward addTarget:self action:@selector(forward:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addSubview:self.forward];
    
    self.play = [IBKMusicButton buttonWithType:UIButtonTypeCustom];
    self.play.frame = CGRectMake(frame.size.width-50, (frame.size.height/2)-10, 20, 20);
    self.play.backgroundColor = [UIColor clearColor];
    self.play.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Play%@", path, [self suffix]]];
    [self.play addTarget:self action:@selector(playPause:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addSubview:self.play];
    
    self.rewind = [IBKMusicButton buttonWithType:UIButtonTypeCustom];
    self.rewind.frame = CGRectMake(frame.size.width-75, (frame.size.height/2)-10, 20, 20);
    self.rewind.backgroundColor = [UIColor clearColor];
    self.rewind.display.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@Rewind%@", path, [self suffix]]];
    [self.rewind addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttons addSubview:self.rewind];
    
    [self setPlayButtonState:[(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]];
    
    return buttons;
}

-(NSString*)suffix {
    NSString *suffix = @"";
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (scale >= 2.0 && scale < 3.0) {
        suffix = [suffix stringByAppendingString:@"@2x.png"];
    } else if (scale >= 3.0) {
        suffix = [suffix stringByAppendingString:@"@3x.png"];
    } else if (scale < 2.0) {
        suffix = [suffix stringByAppendingString:@".png"];
    }
    
    return suffix;
}

-(void)forward:(id)sender {
    [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] changeTrack:1];
}

-(void)back:(id)sender {
    [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] changeTrack:-1];
}

-(void)playPause:(id)sender {
    if ([(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] isPlaying]) {
        [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] pause];
    } else {
        [(SBMediaController*)[objc_getClass("SBMediaController") sharedInstance] play];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.artwork removeFromSuperview];
    self.artwork = nil;
    
    [self.songtitle removeFromSuperview];
    self.songtitle = nil;
    
    [self.artist removeFromSuperview];
    self.artist = nil;
}

@end