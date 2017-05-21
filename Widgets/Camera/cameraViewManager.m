//
//  cameraViewManager.m
//  camera
//
//  Created by Pigi Galdi on 12/08/15.
//
//

#import "cameraViewManager.h"

@implementation cameraViewManager

@synthesize previewLayer;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Custom initialization
        [self createView];
    }
    return self;
}

- (void)updateDeviceOrientation {
    // change to device orientation.
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait){
        [[self previewLayer].connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
        [[self previewLayer].connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    }else if (orientation == UIInterfaceOrientationLandscapeLeft){
        [[self previewLayer].connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }else if (orientation == UIInterfaceOrientationLandscapeRight){
        [[self previewLayer].connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
}

- (void)createView {
    //SETUP CAPTURE SESSION
    captureSession = [[AVCaptureSession alloc] init];
    
    //ADD VIDEO INPUT
    AVCaptureDevice *VideoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (VideoDevice) {
        NSError *error;
        videoInputDevice = [AVCaptureDeviceInput deviceInputWithDevice:VideoDevice error:&error];
        if (!error) {
            if ([captureSession canAddInput:videoInputDevice]){
                [captureSession addInput:videoInputDevice];
            }
        }
    }
    
    //ADD AUDIO INPUT
    AVCaptureDevice *audioCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error = nil;
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioCaptureDevice error:&error];
    if (audioInput){
        [captureSession addInput:audioInput];
    }
    
    //ADD VIDEO PREVIEW LAYER
    [self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession]];
    [self updateDeviceOrientation];
    [[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //ADD MOVIE FILE OUTPUT
    movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    Float64 TotalSeconds = 60;
    int32_t preferredTimeScale = 30;
    CMTime maxDuration = CMTimeMakeWithSeconds(TotalSeconds, preferredTimeScale);
    movieFileOutput.maxRecordedDuration = maxDuration;
    movieFileOutput.minFreeDiskSpaceLimit = 1024 * 1024;
    
    if ([captureSession canAddOutput:movieFileOutput]){
        [captureSession addOutput:movieFileOutput];
    }
    [self cameraSetOutputProperties];
    
    // ADD PHOTO OUTPUT.
    _stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = [[NSDictionary alloc]initWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    if ([captureSession canAddOutput:_stillImageOutput]){
        [captureSession addOutput:_stillImageOutput];
    }
    
    [captureSession setSessionPreset:AVCaptureSessionPresetMedium];
    if ([captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]){
        [captureSession setSessionPreset:AVCaptureSessionPreset640x480];
    }
    
    //----- DISPLAY THE PREVIEW LAYER -----
    //Display it full screen under out view controller existing controls
    CGRect layerRect = [[self layer] bounds];
    [previewLayer setBounds:layerRect];
    [previewLayer setPosition:CGPointMake(CGRectGetMidX(layerRect),
                                          CGRectGetMidY(layerRect))];
    [self.layer addSublayer:previewLayer];
    
    // set is not recording.
    [self setManagerIsRecordingVideo:NO];
}

//********* CAMERA SET OUTPUT PROPERTIES **********
- (void)cameraSetOutputProperties {
    //SET THE CONNECTION PROPERTIES (output properties)
    AVCaptureConnection *CaptureConnection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    [CaptureConnection setVideoOrientation:previewLayer.connection.videoOrientation];
}

//********** GET CAMERA IN SPECIFIED POSITION IF IT EXISTS **********
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *Devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *Device in Devices){
        if ([Device position] == position){
            return Device;
        }
    }
    return nil;
}

//********** CAMERA TOGGLE **********
- (void)cameraToggleButtonPressed {
    // check if device has more thant 1 camera.
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {

        NSError *error;
        AVCaptureDeviceInput *NewVideoInput;
        AVCaptureDevicePosition position = [[videoInputDevice device] position];
        if (position == AVCaptureDevicePositionBack){
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionFront] error:&error];
        }else if (position == AVCaptureDevicePositionFront){
            NewVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self cameraWithPosition:AVCaptureDevicePositionBack] error:&error];
        }
        
        if (NewVideoInput != nil){
            [captureSession beginConfiguration];
            [captureSession removeInput:videoInputDevice];
            if ([captureSession canAddInput:NewVideoInput]){
                [captureSession addInput:NewVideoInput];
                videoInputDevice = NewVideoInput;
            }else{
                [captureSession addInput:videoInputDevice];
            }
            //Set the connection properties again
            [self cameraSetOutputProperties];
            [captureSession commitConfiguration];
        }
    }
}

//********** START STOP RECORDING BUTTON **********
- (void)startRecordingVideo {
    // bool.
    [self setManagerIsRecordingVideo:YES];
    //Create temporary URL to record to
    NSString *outputPath = [[NSString alloc] initWithFormat:@"%@%@", NSTemporaryDirectory(), @"output.mov"];
    NSURL *outputURL = [[NSURL alloc] initFileURLWithPath:outputPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]){
        NSError *error;
        if ([fileManager removeItemAtPath:outputPath error:&error] == NO){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't record video right now." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
    }
    //Start recording
    [movieFileOutput startRecordingToOutputFileURL:outputURL recordingDelegate:self];
}
- (void)stopRecordingVideo {
    // stop recording.
    [movieFileOutput stopRecording];
}

//********** DID FINISH RECORDING TO OUTPUT FILE AT URL **********
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    BOOL RecordedSuccessfully = YES;
    if ([error code] != noErr){
        // A problem occurred: Find out if the recording was successful.
        id value = [[error userInfo] objectForKey:AVErrorRecordingSuccessfullyFinishedKey];
        if (value){
            RecordedSuccessfully = [value boolValue];
        }
    }
    if (RecordedSuccessfully){
        //----- RECORDED SUCESSFULLY -----
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileURL]){
            
            // post notification.
            [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-VideoSaved" object:nil];
            
            [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error){
                 if (error){
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Can't save video to Camera Roll." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                     [alert show];
                 }else {
                     // set bool to NO.
                     [self setManagerIsRecordingVideo:NO];
                     
                     // post notfication.
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"IBK-VideoSaved" object:nil];
                     
                     // loading and success message.
                     BBBulletinRequest* banner = [[objc_getClass("BBBulletinRequest") alloc] init];
                     [banner setTitle: @"iOS Blocks"];
                     [banner setMessage: @"Video saved to camera roll"];
                     [banner setDate: [NSDate date]];
                     [banner setSectionID:@"com.apple.camera"];
                     [(SBBulletinBannerController *)[objc_getClass("SBBulletinBannerController") sharedInstance] observer:nil addBulletin:banner forFeed:2 playLightsAndSirens:YES withReply:nil];
                 }
            }];
        }
    }
}

- (void)takePhoto {
    AVCaptureConnection *connection = [_stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    [connection setVideoOrientation:previewLayer.connection.videoOrientation];
    // save photo.
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil, nil, nil);
        }
    }];
}

- (void)startManagerLiveCamera {
    
    // device orientation.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDeviceOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // update orientation.
    [self updateDeviceOrientation];
    
    // start live capturing.
    [captureSession startRunning];
}
- (void)stopManagerLiveCamera {
    
    // stop live capturing.
    [captureSession stopRunning];
    
    // device orientation.
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)releaseAllObjects {
    captureSession = nil;
    movieFileOutput = nil;
    videoInputDevice = nil;
    _stillImageOutput = nil;
    previewLayer = nil;
}
@end