//
//  PlayerView.h
//  KartinaX.TV
//
//  Created by mk on 09.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <VLCKit/VLCKit.h>

@protocol PlayerLifecycleDelegate;


@interface PlayerView : VLCVideoView

@property(nonatomic, weak) id <PlayerLifecycleDelegate> playerLifecycleDelegate;

@end
