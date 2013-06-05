//
//  GlobalPreferencesViewController.h
//  KartinaX.TV
//
//  Created by mk on 01.06.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RHPreferences/RHPreferencesWindowController.h>

@interface GlobalPreferencesViewController : NSViewController <RHPreferencesViewControllerProtocol>

- (IBAction)clearEpgCache:(id)sender;
- (IBAction)playVideoOnStartupClicked:(id)sender;
- (IBAction)closeEpgWindowClicked:(id)sender;
- (IBAction)transparentEpgWindowClicked:(id)sender;

@property (weak) IBOutlet NSButton *playbackOnStartupButton;
@property (weak) IBOutlet NSButton *closeEPGWindowButton;
@property (weak) IBOutlet NSButton *transparentEPGWindowButton;
 
@end
