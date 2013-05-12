//
//  PlayerView.m
//  KartinaX.TV
//
//  Created by mk on 09.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "PlayerView.h"
#import "PlayerLifecycleDelegate.h"

@implementation PlayerView


- (void)mouseDown:(NSEvent *)theEvent {
    if (theEvent.clickCount == 2) {
        [self.playerLifecycleDelegate toggleFullScreenRequested];
    }

}

- (void)mouseUp:(NSEvent *)theEvent {
    // NSLog(@"player mouse up");
}

- (void)keyUp:(NSEvent *)theEvent {
    // NSLog(@"player key up");
}

- (void)keyDown:(NSEvent *)theEvent {

    if ([theEvent modifierFlags] & (NSCommandKeyMask)) {

        if (theEvent.keyCode == 35) /* P */ {
            [self.playerLifecycleDelegate epgRequested];
        }

        if (theEvent.keyCode == 3) /* F */ {
            [self.playerLifecycleDelegate toggleFullScreenRequested];
        }


    } else if (theEvent.keyCode == 49) {
        [self.playerLifecycleDelegate playPauseToggleRequested];
    }

}


@end
