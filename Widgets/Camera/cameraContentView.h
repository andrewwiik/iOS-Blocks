//
//  cameraContentView.h
//  camera
//
//  Created by Pigi Galdi on 11/08/15.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//
#import <objc/runtime.h>
//
#import "cameraViewManager.h"

@interface cameraContentView : UIView {
    // manager.
    cameraViewManager *_cameraViewManager;
    UIVisualEffectView *_blurredView;
    // capture button.
    UIButton *_captureButton;
    NSTimer *_inactiveTimer;
    UIActivityIndicatorView *_spinner;
    UILabel *_savingVideoLabel;
}
@property (nonatomic, retain) cameraViewManager *_cameraViewManager;
@property (nonatomic, retain) UIVisualEffectView *_blurredView;
// capture button.
@property (nonatomic, retain) UIButton *_captureButton;
@property (nonatomic, retain) NSTimer *_inactiveTimer;
@property (nonatomic, assign) BOOL isIpad;
@property (nonatomic, retain) UIActivityIndicatorView *_spinner;
@property (nonatomic, retain) UILabel *_savingVideoLabel;
@end