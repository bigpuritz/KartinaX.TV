//
//  EPGWindowController.m
//  KartinaX.TV
//
//  Created by mk on 28.05.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "EPGWindowController.h"
#import "INAppStoreWindow.h"
#import "EPGProgrammViewController.h"
#import "EPGVideothekViewController.h"

@interface EPGWindowController ()

@property(assign) IBOutlet EPGProgrammViewController *epgProgrammViewController;
@property(assign) IBOutlet EPGVideothekViewController *epgVideothekViewController;
@property(strong) NSTimer *timer;

@end


@implementation EPGWindowController

- (id)initWithWindow:(NSWindow *)window {
    self = [super initWithWindow:window];
    if (self) {

    }

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];


    self.epgProgrammViewController.parentController = self;
    self.epgVideothekViewController.parentController = self;

    [self timerFired];
}


- (void)windowDidLoad {
    [super windowDidLoad];

    INAppStoreWindow *aWindow = (INAppStoreWindow *) self.window;
    aWindow.titleBarHeight = 45.0;

    self.titleBar.frame = aWindow.titleBarView.bounds;
    self.titleBar.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [aWindow.titleBarView addSubview:self.titleBar];

    NSTabViewItem *item;
    item = [self.tabView tabViewItemAtIndex:0];
    [item setView:self.epgProgrammViewController.view];

    item = [self.tabView tabViewItemAtIndex:1];
    [item setView:self.epgVideothekViewController.view];

    // transparency
    [self.window setMovableByWindowBackground:NO];
    self.window.backgroundColor = [NSColor clearColor];
    [self.window setOpaque:NO];
    self.window.alphaValue = .9f;

    [[NSApp mainWindow] addChildWindow:self.window ordered:NSWindowAbove];

}


- (IBAction)showWindow:(id)sender {
    [NSCursor unhide];
    [self startTimer];
    [super showWindow:sender];
    [self.window makeKeyAndOrderFront:sender];
    [self.epgProgrammViewController selectCurrentShow];
}


- (void)windowWillClose:(NSNotification *)notification {
    [self stopTimer];
}


- (void)startTimer {

    if (self.timer != nil)
        [self stopTimer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [self.timer invalidate];
}

- (void)timerFired {
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dayFormatter setDateFormat:@"dd.MM.yyyy / HH:mm:ss"];
    self.currentDateTime.stringValue = [dayFormatter stringFromDate:[NSDate date]];
}


- (IBAction)epgTypeSelected:(id)sender {
    [self.tabView selectTabViewItemAtIndex:((NSSegmentedControl *) sender).selectedSegment];
}

- (void)startLoadingIndicator {
    [self.loadingIndicator startAnimation:self];
    [self.loadingIndicator setHidden:NO];
}

- (void)stopLoadingIndicator {
    [self.loadingIndicator stopAnimation:self];
    [self.loadingIndicator setHidden:YES];
}

- (void)cancel:(id)sender {
    [self close];
}


@end
