//
//  cameraViewManager.h
//  camera
//
//  Created by Pigi Galdi on 12/08/15.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define CAPTURE_FRAMES_PER_SECOND		20

#import <objc/runtime.h>
@interface BBBulletinRequest : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* message;
@property (nonatomic, copy) NSString* sectionID;
@property (nonatomic, retain) NSDate* date;
@end
@interface SBBulletinBannerController
+ (id)sharedInstance;
- (void)observer:(id)observer addBulletin:(BBBulletinRequest *)bulletin forFeed:(int)feed playLightsAndSirens:(BOOL)siren withReply:(id)reply;
@end

@interface cameraViewManager : UIView <AVCaptureFileOutputRecordingDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> {
    // init.
    AVCaptureSession *captureSession;
    AVCaptureMovieFileOutput *movieFileOutput;
    AVCaptureDeviceInput *videoInputDevice;
    AVCaptureStillImageOutput *_stillImageOutput;
}
@property (nonatomic, assign) BOOL managerIsRecordingVideo;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
- (void)createView;
- (void)cameraSetOutputProperties;
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position;
- (void)startRecordingVideo;
- (void)stopRecordingVideo;
- (void)cameraToggleButtonPressed;
- (void)startManagerLiveCamera;
- (void)stopManagerLiveCamera;
- (void)takePhoto;
- (void)releaseAllObjects;
@end
