//
//  EPGWindowController.h
//  KartinaX.TV
//
//  Created by mk on 28.05.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EPGWindowController : NSWindowController <NSWindowDelegate>

@property(strong) IBOutlet NSView *titleBar;
@property(weak) IBOutlet NSTabView *tabView;
@property(weak) IBOutlet NSTextField *currentDateTime;
@property(weak) IBOutlet NSProgressIndicator *loadingIndicator;

- (IBAction)epgTypeSelected:(id)sender;

- (void)startLoadingIndicator;

- (void)stopLoadingIndicator;

- (void) cancel:(id)sender ;

@end
