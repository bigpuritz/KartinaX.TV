//
//  PlayerControlsView.m
//  JKSMoviePlayer
//
//  Created by Johan Sørensen on 8/22/12.
//  Copyright (c) 2012 Johan Sørensen. All rights reserved.
//

#import "PlayerControlsView.h"

#ifndef NSCOLOR
#define NSCOLOR(r, g, b, a) [NSColor colorWithCalibratedRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#endif

@interface JKSMoviePlayerSliderCell : NSSliderCell
@end

@implementation JKSMoviePlayerSliderCell

- (NSRect)knobRectFlipped:(BOOL)flipped {
    NSRect knobRect = [super knobRectFlipped:flipped];
    knobRect.origin.x += 6;
    knobRect.origin.y += 7.5;
    knobRect.size.height = 8;
    knobRect.size.width = 8;
    return knobRect;
}


- (void)drawKnob:(NSRect)knobRect {
    NSBezierPath *outerPath = [NSBezierPath bezierPathWithOvalInRect:knobRect];
    NSGradient *outerGradient = [[NSGradient alloc] initWithColors:@[NSCOLOR(193, 193, 193, 1), NSCOLOR(120, 120, 120, 1)]];
    [outerGradient drawInBezierPath:outerPath angle:90];
    NSBezierPath *innerPath = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(knobRect, 2, 2)];
    NSGradient *innerGradient = [[NSGradient alloc] initWithColors:@[NSCOLOR(154, 154, 154, 1), NSCOLOR(127, 127, 127, 1)]];
    [innerGradient drawInBezierPath:innerPath angle:90];
}


- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped {


    NSRect sliderRect = aRect;
    sliderRect.origin.y += (NSMaxY(sliderRect) / 2) - 4;
    sliderRect.origin.x += 2;
    sliderRect.size.width -= 4;
    sliderRect.size.height = 11;

    NSBezierPath *barPath = [NSBezierPath bezierPathWithRoundedRect:sliderRect xRadius:4 yRadius:4];
    NSGradient *borderGradient = [[NSGradient alloc] initWithColors:@[NSCOLOR(3, 3, 3, 1), NSCOLOR(23, 23, 23, 1)]];
    [borderGradient drawInBezierPath:barPath angle:90];
    NSBezierPath *innerPath = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(sliderRect, 1, 1) xRadius:4 yRadius:4];
    [NSCOLOR(13, 13, 13, 1) setFill];
    [innerPath fill];
}


@end


@interface JKSMoviePlayerSlider : NSSlider
@end

@implementation JKSMoviePlayerSlider
+ (Class)cellClass {
    return [JKSMoviePlayerSliderCell class];
}
@end


@implementation PlayerControlsView

- (id)initWithFrame:(NSRect)frame {

    if ((self = [super initWithFrame:frame])) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setWantsLayer:YES];

        NSRect playPauseRect = NSMakeRect(0, 0, 24, 24);
        _playPauseButton = [self createButtonWithFrame:playPauseRect image:[self playImage]];
        [self addSubview:_playPauseButton];

        _timeSlider = [[JKSMoviePlayerSlider alloc] initWithFrame:NSMakeRect(0, 0, 235, 20)];
        [_timeSlider setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:_timeSlider];

        _timeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 35, 16)];
        [_timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timeLabel setBezeled:NO];
        [_timeLabel setDrawsBackground:NO];
        [_timeLabel setEditable:NO];
        [_timeLabel setSelectable:NO];
        [_timeLabel setTextColor:[NSColor whiteColor]];
        [_timeLabel setStringValue:@"--:--:--"];
        [self addSubview:_timeLabel];

        _epgButton = [self createButtonWithFrame:playPauseRect image:[self epgImage]];
        [_epgButton setToolTip:NSLocalizedString(@"EPG", @"EPG")];
        [self addSubview:_epgButton];


        //[self addConstraintWithItem:_timeSlider toItem:self attribute:NSLayoutAttributeCenterX];
        [self addConstraintWithItem:_timeSlider toItem:self attribute:NSLayoutAttributeCenterY];
        [self addConstraintWithItem:_playPauseButton toItem:_timeSlider attribute:NSLayoutAttributeCenterY];
        [self addConstraintWithItem:_timeLabel toItem:_timeSlider attribute:NSLayoutAttributeCenterY];
        [self addConstraintWithItem:_epgButton toItem:_timeSlider attribute:NSLayoutAttributeCenterY];

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_playPauseButton(==24)]-[_timeSlider]-5-[_timeLabel]-10-[_epgButton(==24)]-|"
                                                                     options:0
                                                                     metrics:nil views:NSDictionaryOfVariableBindings(_playPauseButton, _timeSlider, _timeLabel, _epgButton)]];


    }

    return self;
}


- (void)drawRect:(NSRect)dirtyRect {


    NSBezierPath *outerBorder = [NSBezierPath bezierPathWithRoundedRect:[self bounds] xRadius:5 yRadius:5];
    NSGradient *borderGradient = [[NSGradient alloc] initWithColors:@[NSCOLOR(20, 20, 20, 1), NSCOLOR(86, 86, 86, 1)]];
    [borderGradient drawInBezierPath:outerBorder angle:90];

    NSRect innerRect = NSInsetRect([self bounds], 0, 2);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:innerRect xRadius:5 yRadius:5];
    NSGradient *backgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
            NSCOLOR(56, 56, 56, 1), 0.0,
            NSCOLOR(39, 39, 39, 1), 0.5,
            NSCOLOR(23, 23, 23, 1), 0.51,
            NSCOLOR(13, 13, 13, 1), 1.0,
            nil];
    [backgroundGradient drawInBezierPath:path angle:-90];

    [NSCOLOR(0, 0, 0, 1) setStroke];
    [outerBorder stroke];
}


- (void)setPlaying:(BOOL)flag {
    if (flag) {
        [self.playPauseButton setToolTip:NSLocalizedString(@"Pause", @"Pause")];
        [self.playPauseButton setImage:[self pauseImage]];
    } else {
        [self.playPauseButton setToolTip:NSLocalizedString(@"Play", @"Play")];
        [self.playPauseButton setImage:[self playImage]];
    }
}


#pragma mark - Private methods

- (void)addConstraintWithItem:(id)view toItem:(id)otherView attribute:(NSLayoutAttribute)attribute {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:attribute
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:otherView
                                                     attribute:attribute
                                                    multiplier:1.0
                                                      constant:0]];
}


- (NSButton *)createButtonWithFrame:(NSRect)frame image:(NSImage *)image {
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, 25, 18)];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setButtonType:NSMomentaryChangeButton];
    [button setBordered:NO];
    [button setImage:image];
    return button;
}


- (NSImage *)playImage {
    return [NSImage imageNamed:@"PlayerPlay"];
}


- (NSImage *)pauseImage {
    return [NSImage imageNamed:@"PlayerPause"];
}


- (NSImage *)epgImage {
    return [NSImage imageNamed:@"PlayerEPG"];
}


@end