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
@property (weak) IBOutlet NSSecureTextField *protectedChannelsCode;

- (IBAction)save:(id)sender;

@end
