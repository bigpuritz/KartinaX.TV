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
@property (weak) IBOutlet NSComboBox *serverComboBox;
@property (weak) IBOutlet NSComboBox *timeshiftComboBox;
@property (weak) IBOutlet NSComboBox *timezoneComboBox;
@property (weak) IBOutlet NSComboBox *bitrateComboBox;
@property (weak) IBOutlet NSComboBox *cachingComboBox;


- (IBAction)connect:(id)sender; 
- (IBAction)streamingServerSelected:(NSComboBox *)sender;
- (IBAction)timeshiftSelected:(NSComboBox *)sender;
- (IBAction)timezoneSelected:(NSComboBox *)sender;
- (IBAction)bitrateSelected:(NSComboBox *)sender;
- (IBAction)cachingSelected:(NSComboBox *)sender;
- (IBAction)protectedCodeEntered:(NSSecureTextField *)sender;

- (void)controlTextDidChange:(NSNotification *)notification;

@end
