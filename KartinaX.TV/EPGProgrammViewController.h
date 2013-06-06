//
//  EPGProgrammViewController.h
//  KartinaX.TV
//
//  Created by mk on 30.05.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EPGWindowController.h"

@interface EPGProgrammViewController : NSViewController <NSBrowserDelegate>

@property(assign) EPGWindowController *parentController;
@property(weak) IBOutlet NSBrowser *epgBrowser;
@property(weak) IBOutlet NSDatePicker *datePicker;
@property(weak) IBOutlet NSDatePickerCell *datePickerCell;

- (IBAction)epgDateSelected:(id)sender;

- (void) selectCurrentShow;

@end
