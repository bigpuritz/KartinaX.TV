//
//  EPGViewController.h
//  KartinaX.TV
//
//  Created by mk on 10.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlaybackItem.h"

@interface EPGViewController : NSWindowController <NSBrowserDelegate, NSWindowDelegate>

@property(weak) IBOutlet NSBrowser *epgBrowser;
@property(weak) IBOutlet NSDatePicker *datePicker;
@property(weak) IBOutlet NSDatePickerCell *datePickerCell;
@property(weak) IBOutlet NSProgressIndicator *loadingIndicator;
@property (weak) IBOutlet NSTextField *currentDay;
@property (weak) IBOutlet NSTextField *currentTime;


- (IBAction)epgDateSelected:(id)sender;

- (void)show;
@end
