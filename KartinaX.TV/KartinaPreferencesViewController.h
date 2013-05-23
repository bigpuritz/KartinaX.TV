//
//  KartinaPreferencesViewController.h
//  KartinaX.TV
//
//  Created by mk on 26.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RHPreferencesWindowController.h"

@interface KartinaPreferencesViewController : NSViewController <RHPreferencesViewControllerProtocol>

@property (weak) IBOutlet NSTextField *usernameField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *packetName;
@property (weak) IBOutlet NSTextField *packetExpire;
@property (weak) IBOutlet NSProgressIndicator *loginProgressIndicator;
@property (weak) IBOutlet NSProgressIndicator *setSettingProgressIndicator;

@property (weak) IBOutlet NSSecureTextField *protectedChannelsCode;
@property (weak) IBOutlet NSPopUpButton *serverComboBox;
@property (weak) IBOutlet NSPopUpButton *timeshiftComboBox;
@property (weak) IBOutlet NSPopUpButton *timezoneComboBox;
@property (weak) IBOutlet NSPopUpButton *bitrateComboBox;
@property (weak) IBOutlet NSPopUpButton *cachingComboBox;


- (IBAction)connect:(id)sender; 
- (IBAction)streamingServerSelected:(NSPopUpButton *)sender;
- (IBAction)timeshiftSelected:(NSPopUpButton *)sender;
- (IBAction)timezoneSelected:(NSPopUpButton *)sender;
- (IBAction)bitrateSelected:(NSPopUpButton *)sender;
- (IBAction)cachingSelected:(NSPopUpButton *)sender;
- (IBAction)protectedCodeEntered:(NSSecureTextField *)sender;

- (void)controlTextDidChange:(NSNotification *)notification;

@end
