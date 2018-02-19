/*
 * Media remote framework header.
 *
 * Copyright (c) 2013-2014 Cykey (David Murray)
 * All rights reserved.
 */

#ifndef MEDIAREMOTE_H_
#define MEDIAREMOTE_H_

#include <CoreFoundation/CoreFoundation.h>

#if __cplusplus
extern "C" {
#endif

#pragma mark - Notifications
    extern CFStringRef kMRMediaRemoteNowPlayingInfoDidChangeNotification;
    extern CFStringRef kMRMediaRemoteNowPlayingPlaybackQueueDidChangeNotification;
    extern CFStringRef kMRMediaRemotePickableRoutesDidChangeNotification;
    extern CFStringRef kMRMediaRemoteNowPlayingApplicationDidChangeNotification;
    extern CFStringRef kMRMediaRemoteNowPlayingApplicationIsPlayingDidChangeNotification;
    extern CFStringRef kMRMediaRemoteRouteStatusDidChangeNotification;
    extern CFStringRef kMRMediaRemoteSupportedCommandsDidChangeNotification;
    extern CFStringRef kMRDeviceInfoDidChangeNotification;
    extern CFStringRef kMRMediaRemoteNowPlayingApplicationDisplayNameDidChangeNotification;
    extern CFStringRef kMRMediaRemoteAnyApplicationIsPlayingDidChangeNotification;

#pragma mark - Command information
    extern CFStringRef kMRMediaRemoteCommandInfoCanBeControlledByScrubbingKey;
#pragma mark - Keys
    extern CFStringRef kMRMediaRemoteNowPlayingApplicationPIDUserInfoKey;
    extern CFStringRef kMRMediaRemoteNowPlayingApplicationIsPlayingUserInfoKey;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoAlbum;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoArtist;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoArtworkData;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoArtworkMIMEType;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoChapterNumber;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoComposer;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoDuration;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoElapsedTime;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoGenre;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoIsAdvertisement;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoIsBanned;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoIsInWishList;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoIsLiked;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoIsMusicApp;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoPlaybackRate;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoProhibitsSkip;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoQueueIndex;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoRadioStationIdentifier;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoRepeatMode;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoShuffleMode;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoStartTime;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoSupportsFastForward15Seconds;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoSupportsIsBanned;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoSupportsIsLiked;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoSupportsRewind15Seconds;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTimestamp;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTitle;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTotalChapterCount;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTotalDiscCount;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTotalQueueCount;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTotalTrackCount;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoTrackNumber;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoUniqueIdentifier;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoRadioStationIdentifier;
    extern CFStringRef kMRMediaRemoteNowPlayingInfoRadioStationHash;
    extern CFStringRef kMRMediaRemoteOptionMediaType;
    extern CFStringRef kMRMediaRemoteOptionSourceID;
    extern CFStringRef kMRMediaRemoteOptionTrackID;
    extern CFStringRef kMRMediaRemoteOptionStationID;
    extern CFStringRef kMRMediaRemoteOptionStationHash;
    extern CFStringRef kMRMediaRemoteRouteDescriptionUserInfoKey;
    extern CFStringRef kMRMediaRemoteRouteStatusUserInfoKey;
#pragma mark - API
    typedef NS_ENUM(NSInteger, MRCommand) {
        kMRPlay = 0,
        kMRPause = 1,
        kMRTogglePlayPause = 2,
        kMRStop = 3,
        kMRNextTrack = 4,
        kMRPreviousTrack = 5,
        kMRToggleShuffle = 6,
        kMRToggleRepeat = 7,
        kMRStartForwardSeek = 8,
        kMREndForwardSeek = 9,
        kMRStartBackwardSeek = 10,
        kMREndBackwardSeek = 11,
        kMRGoBackFifteenSeconds1 = 12,
        kMRSkipFifteenSeconds = 13,
        kMRGoBackThirtySeconds = 14,
        kMRSkipThirtySeconds1 = 15,
        kMRSkipFifteenSeconds2 = 16,
        kMRGoBackFifteenSeconds = 18,
        kMRChangePlaybackRate = 19,
        kMRRateTrack = 20,
        kMRLikeTrack = 21,
        kMRBanTrack = 22,
        kMRBookmarkTrack = 23,
        kMRSeekToPlaybackPosition = 24
    };
    Boolean MRMediaRemoteSendCommand(MRCommand command, id userInfo);
    void MRMediaRemoteSetPlaybackSpeed(int speed);
    void MRMediaRemoteSetElapsedTime(double elapsedTime);
    void MRMediaRemoteSetNowPlayingApplicationOverrideEnabled(Boolean enabled);
    void MRMediaRemoteRegisterForNowPlayingNotifications(dispatch_queue_t queue);
    void MRMediaRemoteUnregisterForNowPlayingNotifications();
    void MRMediaRemoteBeginRouteDiscovery();
    void MRMediaRemoteEndRouteDiscovery();
    CFArrayRef MRMediaRemoteCopyPickableRoutes();
    typedef void (^MRMediaRemoteGetNowPlayingInfoCompletion)(CFDictionaryRef information);
    typedef void (^MRMediaRemoteGetNowPlayingApplicationPIDCompletion)(int PID);
    typedef void (^MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion)(Boolean isPlaying);
    typedef void (^MRMediaRemoteGetNowPlayingApplicationDisplayIDCompletion)(CFStringRef information);
    void MRMediaRemoteGetNowPlayingApplicationDisplayID(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingApplicationDisplayIDCompletion completion);
    void MRMediaRemoteGetNowPlayingApplicationPID(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingApplicationPIDCompletion completion);
    void MRMediaRemoteGetNowPlayingInfo(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingInfoCompletion completion);
    void MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_queue_t queue, MRMediaRemoteGetNowPlayingApplicationIsPlayingCompletion completion);
    void MRMediaRemoteKeepAlive();
    void MRMediaRemoteSetElapsedTime(double time);
    void MRMediaRemoteSetShuffleMode(int mode);
    void MRMediaRemoteSetRepeatMode(int mode);
    int MRMediaRemoteSelectSourceWithID(CFStringRef identifier);
    void MRMediaRemoteSetPickedRouteWithPassword(CFStringRef route, CFStringRef password);
    CFArrayRef MRMediaRemoteCopyPickableRoutesForCategory(NSString *category);
    Boolean MRMediaRemotePickedRouteHasVolumeControl();
    void MRMediaRemoteSetCanBeNowPlayingApplication(Boolean can);
    void MRMediaRemoteSetNowPlayingInfo(CFDictionaryRef information);
    Boolean MRMediaRemoteCommandInfoGetBooleanValueForKey(id commandInfo, CFStringRef key);
    MRCommand MRMediaRemoteCommandInfoGetCommand(id commandInfo);
    Boolean MRMediaRemoteCommandInfoGetEnabled(id commandInfo);
    void MRMediaRemoteCopySupportedCommands(dispatch_queue_t queue, void(^block)(NSArray *));
#if __cplusplus
}
#endif

#endif

// MRMediaRemoteCopySupportedCommands(dispatch_get_main_queue(), ^(NSArray *commands){
//     for (id command in commands) {
//         if (MRMediaRemoteCommandInfoGetCommand(command) == kMRSeekToPlaybackPosition) {
//             if (MRMediaRemoteCommandInfoGetEnabled(command)) {
//                 if (MRMediaRemoteCommandInfoGetBooleanValueForKey(command, kMRMediaRemoteCommandInfoCanBeControlledByScrubbingKey) != 0) {
//                     // Scrubbing is possible
//                 }
//             }
//         }
//     }
// });

