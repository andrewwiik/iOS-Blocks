//
//  cameraContentView.m
//  camera
//
//  Created by Pigi Galdi on 11/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "cameraContentView.h"

@implementation cameraContentView
@synthesize _cameraViewManager = __cameraViewManager;
@synthesize _blurredView = blurredView;
@synthesize _captureButton = captureButton;
@synthesize _inactiveTimer = inactiveTimer;
@synthesize _spinner = spinner;
@synthesize _savingVideoLabel = savingVideoLabel;

#define kPath @"/bootstrap/Library/Curago/Widgets/com.iosblocks.camera.block"
#define kImageBig [self isIpad] ? @"PhotoBig.png" : @"Photo.png"

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // use cameraViewManager from now.
        __cameraViewManager = [[cameraViewManager alloc] initWithFrame:self.frame];
        [self addSubview:__cameraViewManager];
        
        // create blur view.
        blurredView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        blurredView.frame = self.bounds;
        blurredView.alpha = 0.f;
        [self insertSubview:blurredView aboveSubview:__cameraViewManager];
        
        // create capture button.
        captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [captureButton setBackgroundColor:[UIColor clearColor]];
        [captureButton addTarget:self action:@selector(captureButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        captureButton.frame = CGRectMake(0,0,self.frame.size.width/2,self.frame.size.width/2);
        captureButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2.25);
        [captureButton setImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/PhotoBig.png", kPath]] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
        [captureButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
        [captureButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
        captureButton.tag = 222;
        [self insertSubview:captureButton aboveSubview:blurredView];
        
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(captureButtonLongPress:)];
        [longPressGesture setMinimumPressDuration:0.6f];
        [captureButton addGestureRecognizer:longPressGesture];
        
        // create spinning view.
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [spinner setCenter:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.8)];
        [spinner setColor:[UIColor whiteColor]];
        [self insertSubview:spinner aboveSubview:blurredView];
        
        // add double tap to change camera
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(doubleTapToChangeCamera:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        // create label.
        savingVideoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,spinner.frame.origin.y+spinner.frame.size.height+5,self.frame.size.width,30.f)];
        savingVideoLabel.textAlignment = NSTextAlignmentCenter;
        savingVideoLabel.textColor = [UIColor lightGrayColor];
        savingVideoLabel.font = [UIFont systemFontOfSize:[self isIpad] ? 13 : 9];
        savingVideoLabel.alpha = 0.f;
        [self insertSubview:savingVideoLabel aboveSubview:blurredView];
        
        // add notification.
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSpinningAnimation) name:@"IBK-VideoSaved" object:nil];
    }
    return self;
}

- (void)doubleTapToChangeCamera:(UITapGestureRecognizer *)gesture {
    // check for blurred view.
    if (blurredView.alpha == 0.f){
        // invalidate timer.
        [inactiveTimer invalidate];
        inactiveTimer = nil;
        // toggle camera device.
        [__cameraViewManager cameraToggleButtonPressed];
        // add timer.
        inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopLiveCamera:) userInfo:nil repeats:NO];
    }
}
- (void)toggleSpinningAnimation {
    // check if recording.
    if ([__cameraViewManager managerIsRecordingVideo]){
        // set label text.
        savingVideoLabel.text = @"Saving Video to Camera Roll...";
        
        // remove timer.
        [inactiveTimer invalidate];
        inactiveTimer = nil;
        
        // stop live.
        [__cameraViewManager stopManagerLiveCamera];
        
        // add blur.
        [UIView animateWithDuration:0.4f animations:^{
            blurredView.alpha = 1.f;
            savingVideoLabel.alpha = 1.f;
        }];
        
        // disabling capture button.
        [captureButton setEnabled:NO];
        
        // start spinning.
        [spinner startAnimating];
    }else {
        // set label text.
        savingVideoLabel.text = @"Video Saved!";
        
        // start live.
        [__cameraViewManager startManagerLiveCamera];
        
        // add timer.
        inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopLiveCamera:) userInfo:nil repeats:NO];
        
        // stop spinning.
        [spinner stopAnimating];
        
        // remove blur.
        [UIView animateWithDuration:0.4f animations:^{
            blurredView.alpha = 0.f;
            savingVideoLabel.alpha = 0.f;
        }];
        
        // enabling capture button.
        [captureButton setEnabled:YES];
    }
}

- (void)captureButtonTapped:(UIButton *)button {
    // check for tag.
    if (button.tag == 222){
        // create manager view.
        [__cameraViewManager createView];
        
        // scale and slide to bottom.
        [UIView animateWithDuration:0.4 animations:^{
            button.transform = CGAffineTransformMakeScale(0.40f, 0.40f);
            button.frame = CGRectMake(0,0,button.frame.size.width,button.frame.size.height);
            button.center = CGPointMake(self.frame.size.width/2, self.frame.size.height-(button.frame.size.height/1.25));
            [button setImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", kPath, kImageBig]] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
            button.tag = 223;
            
            // start live camera manager.
            [__cameraViewManager startManagerLiveCamera];
            // remove blur view.
            blurredView.alpha = 0.f;
            inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(stopLiveCamera:) userInfo:nil repeats:NO];
        }];
    }else if (button.tag == 223){
        // invalidate timer and restart.
        [inactiveTimer invalidate];
        inactiveTimer = nil;
        inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopLiveCamera:) userInfo:nil repeats:NO];
        // take photo.
        [__cameraViewManager takePhoto];
        
        // photo animation.
        __block UIView *flashView = [[UIView alloc] initWithFrame:self.frame];
        flashView.backgroundColor = [UIColor blackColor];
        flashView.alpha = 0.f;
        [self insertSubview:flashView atIndex:1000]; // need to stay on top.
        // scale animation.
        [UIView animateWithDuration:0.05f animations:^{
            flashView.alpha = 1.f;
        }completion:^(BOOL finished){
            [UIView animateWithDuration:0.1f animations:^{
                flashView.alpha = 0.f;
            } completion:^(BOOL finished){
                if (finished){
                    [flashView removeFromSuperview];
                    flashView = nil;
                }
            }];
        }];
    }
}

- (void)captureButtonLongPress:(UILongPressGestureRecognizer *)gesture {
    // check for button state first.
    if (captureButton.tag == 223){
        // check for state.
        if (gesture.state == UIGestureRecognizerStateBegan){
            
            // start recording video.
            [self startVideoRecording];
        
        }else if (gesture.state == UIGestureRecognizerStateEnded){
            
            // stop recording video.
            [self stopVideoRecording];
        }
    }
}

- (void)startVideoRecording {
    // remove timer.
    [inactiveTimer invalidate];
    inactiveTimer = nil;
    // start capturing video.
    [__cameraViewManager startRecordingVideo];
    // change button image
    [UIView animateWithDuration:0.3f animations:^{
        [captureButton setImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Video.png", kPath]] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    }];
    
    // video button scale animation.
    [UIView animateWithDuration:0.5f delay:0.f options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut animations:^{
        // scale.
        captureButton.transform = CGAffineTransformMakeScale(0.45f, 0.45f);
    }completion:0];
}

- (void)stopVideoRecording {
    // remove scale animation.
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        // scale.
        captureButton.transform = CGAffineTransformMakeScale(0.40f, 0.40f);
    }completion:NULL];
    // re-start timer.
    inactiveTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(stopLiveCamera:) userInfo:nil repeats:NO];
    // stop capturing video.
    [__cameraViewManager stopRecordingVideo];
    // change button image
    [UIView animateWithDuration:0.3f animations:^{
        [captureButton setImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", kPath, kImageBig]] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    }];
}

- (void)stopLiveCamera:(NSTimer *)timer {
    // invalidate timer.
    [timer invalidate];
    timer = nil;
    
    // stop live camera manager.
    [__cameraViewManager stopManagerLiveCamera];
    
    // resize button.
    [UIView animateWithDuration:0.4 animations:^{
        captureButton.transform = CGAffineTransformMakeScale(1.f, 1.f);
        captureButton.frame = CGRectMake(0,0,self.frame.size.width/2,self.frame.size.width/2);
        captureButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2.25);
        [captureButton setImage:[[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", kPath, kImageBig]] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
        captureButton.tag = 222;
        
        // add blur view.
        blurredView.alpha = 1.f;
    }];
    
    // release all.
    [__cameraViewManager releaseAllObjects];
}
@end