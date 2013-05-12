//
// Created by mk on 15.04.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <Foundation/Foundation.h>
#import <VLCKit/VLCKit.h>
#import "PlayerView.h"
#import "PlayerLifecycleDelegate.h"

@class PlaybackItem;
@class VLCVideoView;
@class PlayerControlsController;
@class PlayerView;
@class EPGViewController;

@interface VLCKitMoviePlayerController : NSObject <VLCMediaPlayerDelegate, VLCMediaDelegate, PlayerLifecycleDelegate>

@property(copy, readonly) NSURL *contentURL;
@property(strong, readonly) PlayerView *view;
@property(nonatomic, strong) NSTextField *unplayableLabel;
@property(nonatomic, strong) PlayerControlsController *playerControlsController;
@property(nonatomic, strong) EPGViewController *epgViewController;

- (instancetype)initWithStreamURL:(NSURL *)streamURL;

- (void)showEpg;

@end