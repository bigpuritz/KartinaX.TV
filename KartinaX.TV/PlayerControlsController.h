//
//  PlayerControlsController.h
//  KartinaX.TV
//
//  Created by mk on 17.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlaybackItem.h"

@class PlayerControlsView;
@protocol PlayerLifecycleDelegate;

@interface PlayerControlsController : NSWindowController

@property(nonatomic, weak) id <PlayerLifecycleDelegate> playerLifecycleDelegate;
@property(strong) PlayerControlsView *controllerView;

- (void)startTimer;

- (void)stopTimer;

- (NSNumber *)currentSliderPosition;

@end
