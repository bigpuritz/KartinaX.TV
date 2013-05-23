//
//  PlayerControlsController.m
//  KartinaX.TV
//
//  Created by mk on 17.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "PlayerControlsController.h"
#import "PlayerControlsView.h"
#import "KartinaSession.h"
#import "Utils.h"
#import "PlayerLifecycleDelegate.h"

@interface PlayerControlsController ()

@property(strong) NSTimer *timer;

@end

@implementation PlayerControlsController {

}


- (id)init {
    self = [super initWithWindowNibName:@"PlayerControlsController"];
    if (self) {
        [self.window setMovableByWindowBackground:NO];
        self.window.backgroundColor = [NSColor clearColor];
        [self.window setOpaque:NO];
        self.window.alphaValue = .0f;

        [self.window.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.window.contentView setWantsLayer:YES];

        _controllerView = [[PlayerControlsView alloc] initWithFrame:NSMakeRect(0, 0, 440, 40)];
        [self.window.contentView addSubview:_controllerView];
        [_controllerView setAlphaValue:1];

        [self.window.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_controllerView
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.window.contentView
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0
                                                                             constant:0]];
        [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(>=5)-[_controllerView(==440)]-(>=5)-|"
                                                                                        options:0
                                                                                        metrics:nil views:NSDictionaryOfVariableBindings(_controllerView)]];
        [self.window.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=60)-[_controllerView(==40)]-5-|"
                                                                                        options:0
                                                                                        metrics:nil views:NSDictionaryOfVariableBindings(_controllerView)]];


        [_controllerView.playPauseButton setTarget:self];
        [_controllerView.playPauseButton setAction:@selector(playPauseToggle:)];
        [_controllerView.playPauseButton setEnabled:NO];

        [_controllerView.timeSlider setTarget:self];
        [_controllerView.timeSlider setAction:@selector(scrubberChanged:)];
        [_controllerView.timeSlider setEnabled:NO];

        [_controllerView.epgButton setTarget:self];
        [_controllerView.epgButton setAction:@selector(epg)];
        [_controllerView.epgButton setEnabled:YES];


        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(channelStreamLoaded:)
                                                     name:kChannelStreamLoadSuccessfulNotification
                                                   object:nil];

    }
    return self;
}


- (void)channelStreamLoaded:(NSNotification *)notification {

    // ChannelStream *stream = [notification.userInfo objectForKey:@"channelStream"];

    [self initSlider];
    [_controllerView.playPauseButton setEnabled:YES];
    [self startTimer];
}

- (void)initSlider {

    PlaybackItem *currentPlaybackItem = [KartinaSession currentPlaybackItem];
    NSSlider *slider = _controllerView.timeSlider;

    slider.minValue = currentPlaybackItem.start.doubleValue;
    slider.maxValue = currentPlaybackItem.end.doubleValue;

    if (currentPlaybackItem.playbackStartPosition == nil) {
        slider.doubleValue = [Utils currentUnixTimestamp].doubleValue;
        [_controllerView.timeSlider setEnabled:NO];
    } else {
        slider.doubleValue = [currentPlaybackItem.playbackStartPosition doubleValue];
        [_controllerView.timeSlider setEnabled:YES];
    }

}


- (void)epg {
    [self.playerLifecycleDelegate epgRequested];
}

#pragma mark - Control actions

- (void)playPauseToggle:(id)sender {
    [self.playerLifecycleDelegate playPauseToggleRequested];
}


- (void)scrubberChanged:(NSSlider *)sender {

    [self updateTimeLabel];

    NSEvent *event = [[NSApplication sharedApplication] currentEvent];
    BOOL startingDrag = event.type == NSLeftMouseDown;
    BOOL endingDrag = event.type == NSLeftMouseUp;
    BOOL dragging = event.type == NSLeftMouseDragged;

    NSAssert(startingDrag || endingDrag || dragging, @"unexpected event type caused slider change: %@", event);

    if (startingDrag) {
        // do whatever needs to be done when the slider starts changing
    }
    // do whatever needs to be done for "uncommitted" changes
    if (endingDrag) {
        // do whatever needs to be done when the slider end changing
        if (self.playerLifecycleDelegate != nil)
            [self.playerLifecycleDelegate playbackStartPositionRequested:[NSNumber numberWithDouble:sender.doubleValue]];

    }

}


- (void)startTimer {

    if (self.timer != nil)
        [self stopTimer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerFired:)
                                                userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (NSNumber *)currentSliderPosition {
    return [NSNumber numberWithDouble:self.controllerView.timeSlider.doubleValue];
}


- (void)timerFired:(NSTimer *)theTimer {

    if (![KartinaSession isLoggedIn]) {

        [self.playerLifecycleDelegate kartinaSessionMissing];
        [self stopTimer];

    } else {

        PlaybackItem *currentPlaybackItem = [KartinaSession currentPlaybackItem];

        if (currentPlaybackItem.isPlaybackDurationAvailable) {

            NSSlider *slider = self.controllerView.timeSlider;
            [slider setDoubleValue:slider.doubleValue + 1];

            if (slider.maxValue == slider.doubleValue) {
                [self.playerLifecycleDelegate playbackItemTimeDidEnd];
                PlaybackItem *newItem = [KartinaSession replaceCurrentPlaybackItemWithNext];
                if (newItem != nil) {
                    [self initSlider];
                } else {
                    [self stopTimer];
                }
            }

            [self updateTimeLabel];

        }
    }
}


- (void)updateTimeLabel {

    NSSlider *slider = self.controllerView.timeSlider;
    double secondsDiff = slider.doubleValue - slider.minValue;

    NSUInteger hours = (NSUInteger) (secondsDiff / 60 / 60);
    NSUInteger minutes = (NSUInteger) ((secondsDiff - (hours * 60 * 60)) / 60);
    NSUInteger secondsLeftOver = (NSUInteger) (secondsDiff - (hours * 60 * 60) - (minutes * 60));
    NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, secondsLeftOver];

    [self.controllerView.timeLabel setStringValue:timeString];
}

- (BOOL)acceptsFirstResponder {
    return NO;
}


@end
