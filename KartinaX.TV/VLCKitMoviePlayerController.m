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
#import "EPGViewController.h"
#import "PlayerControlsView.h"


@interface VLCKitMoviePlayerController ()

@property(strong) VLCMediaPlayer *player;


@end

@implementation VLCKitMoviePlayerController {

    NSProgressIndicator *_spinner;
    BOOL inFullScreen;
}

- (instancetype)initWithStreamURL:(NSURL *)streamURL {

    if ((self = [super init])) {

        inFullScreen = NO;

        _view = [[PlayerView alloc] initWithFrame:NSMakeRect(0, 0, 640, 480)];
        _view.playerLifecycleDelegate = self;

        [_view setTranslatesAutoresizingMaskIntoConstraints:NO];

        _spinner = [[NSProgressIndicator alloc] initWithFrame:NSZeroRect];
        [_spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_spinner setStyle:NSProgressIndicatorSpinningStyle];
        [_spinner startAnimation:self];
        [_view addSubview:_spinner];
        [self constrainItem:_spinner toCenterOfItem:_view];

        _unplayableLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 150, 25)];
        [_unplayableLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_unplayableLabel setTextColor:[NSColor whiteColor]];
        [_unplayableLabel setBackgroundColor:[NSColor blackColor]];
        [_unplayableLabel setStringValue:@"Preview unavailable"];
        [_unplayableLabel setAlignment:NSCenterTextAlignment];
        [_unplayableLabel setBordered:NO];
        [_view addSubview:_unplayableLabel];
        [_view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_unplayableLabel(==150)]"
                                                                      options:0
                                                                      metrics:nil views:NSDictionaryOfVariableBindings(_unplayableLabel)]];
        [self constrainItem:_unplayableLabel toCenterOfItem:_view];
        [_unplayableLabel setHidden:YES];

        [_view layer].backgroundColor = [[NSColor blackColor] CGColor];


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

        [self initPlayerWithURL:streamURL];


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(channelStreamLoaded:)
                                                     name:kChannelStreamLoadSuccessfulNotification
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


- (void)initPlayerWithURL:(NSURL *)url {
    _contentURL = [url copy];
    if (_contentURL != nil) {
        VLCMedia *media = [VLCMedia mediaWithURL:_contentURL];
        media.delegate = self;
        [_player setMedia:media];
        [_player play];
    }

}

- (void)showEpg {
    if (self.epgViewController == nil) {
        self.epgViewController = [[EPGViewController alloc] init];
        [self.epgViewController.window setFrameOrigin:NSMakePoint(
                self.view.window.frame.origin.x + self.view.frame.size.width / 2 - self.epgViewController.window.frame.size.width / 2,
                self.view.window.frame.origin.y + 50
        )];
    }
    [_epgViewController show];


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


/********************************************************************/

- (void)channelStreamLoaded:(NSNotification *)notification {
    ChannelStream *stream = [notification.userInfo objectForKey:@"channelStream"];
    [self initPlayerWithURL:stream.nsUrl];
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
    if (inFullScreen && !self.epgViewController.window.isVisible) {
        [NSCursor hide];
    }
    [self.playerControlsController.window.animator setAlphaValue:0];
}


@end