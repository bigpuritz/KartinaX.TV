//
// Created by mk on 15.04.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <VLCKit/VLCKit.h>
#import "PlayerLifecycleDelegate.h"
#import "VLCKitMoviePlayerController.h"
#import "KartinaSession.h"
#import "ChannelStream.h"
#import "PlayerControlsController.h"
#import "PlayerControlsView.h"
#import "EPGWindowController.h"
#import "VODStream.h"


@interface VLCKitMoviePlayerController ()

@property(strong) VLCMediaPlayer *player;


@end

@implementation VLCKitMoviePlayerController {

    BOOL inFullScreen;
}

- (instancetype)initWithChannelStream:(ChannelStream *)stream {

    if ((self = [super init])) {

        inFullScreen = NO;

        _view = [[PlayerView alloc] initWithFrame:NSMakeRect(0, 0, 640, 480)];
        _view.playerLifecycleDelegate = self;

        [_view setTranslatesAutoresizingMaskIntoConstraints:NO];

        // [_view layer].backgroundColor = [[NSColor blackColor] CGColor];

        NSTrackingArea *tracker = [[NSTrackingArea alloc] initWithRect:[_view bounds]
                                                               options:(NSTrackingActiveInKeyWindow |
                                                                       NSTrackingMouseEnteredAndExited |
                                                                       NSTrackingMouseMoved |
                                                                       NSTrackingInVisibleRect)
                                                                 owner:self
                                                              userInfo:nil];
        [_view addTrackingArea:tracker];


        [_view setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        _view.fillScreen = YES;
        _player = [[VLCMediaPlayer alloc] initWithVideoView:_view];
        _player.delegate = self;

        [self startPlayerWithChannelStream:stream];


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(channelStreamLoaded:)
                                                     name:kChannelStreamLoadSuccessfulNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(vodStreamLoaded:)
                                                     name:kVODStreamLoadSuccessfulNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(entersFullScreen)
                                                     name:NSWindowWillEnterFullScreenNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(exitsFullScreen)
                                                     name:NSWindowWillExitFullScreenNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(windowDidResize)
                                                     name:NSWindowDidResizeNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)windowDidResize {
    PlayerControlsView *playerControlsView = self.playerControlsController.controllerView;
    [playerControlsView.window setFrameOrigin:NSMakePoint(
            self.view.window.frame.origin.x + self.view.frame.size.width / 2 - playerControlsView.window.frame.size.width / 2,
            self.view.window.frame.origin.y + 50
    )];
}

- (void)entersFullScreen {
    [NSCursor hide];
    inFullScreen = YES;
}

- (void)exitsFullScreen {
    [NSCursor unhide];
    inFullScreen = NO;
}

- (void)constrainItem:(id)item toCenterOfItem:(id)containerItem {
    [containerItem addConstraint:[NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerItem
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0]];
    [containerItem addConstraint:[NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:containerItem
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0]];
}


- (void)startPlayerWithChannelStream:(ChannelStream *)stream {
    if (stream != nil && stream.streamURL != nil) {
        VLCMedia *media = [VLCMedia mediaWithURL:[stream.streamURL copy]];
        media.delegate = self;
        [media addOptions:@{
                @"--no-http-reconnect" : [NSNull null],
                @"--network-caching" : stream.networkCachingInMs
        }];
        [_player setMedia:media];
        [_player play];
    }
}

- (void)startPlayerWithVODStream:(VODStream *)stream {
    if (stream != nil && stream.streamURL != nil) {
        VLCMedia *media = [VLCMedia mediaWithURL:[stream.streamURL copy]];
        media.delegate = self;
        [media addOptions:@{
                @"--no-http-reconnect" : [NSNull null],
                @"--network-caching" : stream.networkCachingInMs
        }];
        [_player setMedia:media];
        [_player play];
    }
}

- (void)showEpg {

    if (_epgWindowController == nil ) {
        _epgWindowController = [[EPGWindowController alloc] initWithWindowNibName:@"EPGWindowController"];
    }
    [_epgWindowController showWindow:self];

}


/*********   PlayerLifecycleDelegate Protocol methods.... ********/

- (void)epgRequested {
    [self showEpg];
}

- (void)toggleFullScreenRequested {
    [self.view.window toggleFullScreen:self];
}

- (void)playPauseToggleRequested {

    if (self.player.isPlaying == YES) {
        [self.player pause];
        [self.playerControlsController stopTimer];
    } else {

        PlaybackItem *currentPlaybackItem = [KartinaSession currentPlaybackItem];
        if (currentPlaybackItem.playbackStartPosition != nil)   // playing archive?
            currentPlaybackItem.playbackStartPosition = self.playerControlsController.currentSliderPosition;


        [[NSNotificationCenter defaultCenter]
                postNotificationName:kPlaybackItemSelectedNotification
                              object:self
                            userInfo:@{@"playbackItem" : currentPlaybackItem}
        ];
    }

}

- (void)stopRequested {
    [self.player stop];
    [self.playerControlsController stopTimer];
}


- (void)pauseRequested {
    [self.player pause];
    [self.playerControlsController stopTimer];
}


- (void)playbackStartPositionRequested:(NSNumber *)position {

    PlaybackItem *currentPlaybackItem = [KartinaSession currentPlaybackItem];
    currentPlaybackItem.playbackStartPosition = position;
    [[NSNotificationCenter defaultCenter]
            postNotificationName:kPlaybackItemSelectedNotification
                          object:self
                        userInfo:@{@"playbackItem" : currentPlaybackItem}
    ];
}


- (void)playbackItemTimeDidEnd {

    NSLog(@"playback item time did end....");
}

- (void)kartinaSessionMissing {

    [self.player stop];

}


/********************************************************************/

- (void)channelStreamLoaded:(NSNotification *)notification {
    ChannelStream *stream = [notification.userInfo objectForKey:@"channelStream"];
    [self startPlayerWithChannelStream:stream];
}

- (void)vodStreamLoaded:(NSNotification *)notification {
    VODStream *stream = [notification.userInfo objectForKey:@"vodStream"];
    [self startPlayerWithVODStream:stream];
}


- (void)mediaDidFinishParsing:(VLCMedia *)aMedia {
    NSLog(@"media did finished parsing: %@", aMedia);
}

- (void)media:(VLCMedia *)aMedia metaValueChangedFrom:(id)oldValue forKey:(NSString *)key {
    NSLog(@"meta value changed for key: %@", key);
}

- (void)mediaPlayerTimeChanged:(NSNotification *)aNotification {

}

- (void)mediaPlayerStateChanged:(NSNotification *)aNotification {
    // VLCMediaPlayerState state = self.player.state;
    /**
    VLCMediaPlayerStateStopped,        //< Player has stopped
    VLCMediaPlayerStateOpening,        //< Stream is opening
    VLCMediaPlayerStateBuffering,      //< Stream is buffering
    VLCMediaPlayerStateEnded,          //< Stream has ended
    VLCMediaPlayerStateError,          //< Player has generated an error
    VLCMediaPlayerStatePlaying,        //< Stream is playing
    VLCMediaPlayerStatePaused          //< Stream is paused
    */

    [self.playerControlsController.controllerView setPlaying:self.player.isPlaying];

}


- (void)geometryIncrease {

    //    self.player.scaleFactor += .1;
    //
    //    NSLog(@"factor: %f", self.player.scaleFactor);
    // "1:1", "4:3", "16:9", "16:10", "185:100", "221:100", "235:100", "239:100", "5:4"
    //    [self.player setVideoCropGeometry:"16:10"];
    //    char * aspradio = (char *)[@"4:3" UTF8String];    //16:10
    //    [self.player setVideoAspectRatio:aspradio];

}

- (void)geometryDecrease {
    //    self.player.scaleFactor -= .1;
    //    [self.player setVideoCropGeometry:"16:9"];
    //    NSLog(@"factor: %f", self.player.scaleFactor);
    //    char * aspradio = (char *)[@"16:9" UTF8String];    //16:10
    //    [self.player setVideoAspectRatio:aspradio];
}


- (void)mouseEntered:(NSEvent *)event {
    [self.playerControlsController.window.animator setAlphaValue:1];
}


- (void)mouseExited:(NSEvent *)event {
    [self fadeOutPlayerControlsDelayed];
}


- (void)mouseMoved:(NSEvent *)event {
    [self fadeInPlayerControls];
    [self fadeOutPlayerControlsDelayed];
}


#pragma mark - Private methods

- (void)fadeInPlayerControls {

    if (inFullScreen) {
        [NSCursor unhide];
    }

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutPlayerControls) object:nil];
    [self.playerControlsController.window.animator setAlphaValue:1];
    [self fadeOutPlayerControlsDelayed];
}


- (void)fadeOutPlayerControlsDelayed {
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutPlayerControls) object:nil];
    [self performSelector:@selector(fadeOutPlayerControls) withObject:nil afterDelay:2.0];
}


- (void)fadeOutPlayerControls {
    if (inFullScreen && !self.epgWindowController.window.isVisible) {
        [NSCursor hide];
    }
    [self.playerControlsController.window.animator setAlphaValue:0];
}


@end