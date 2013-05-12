//
//  KartinaPreferencesViewController.m
//  KartinaX.TV
//
//  Created by mk on 26.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "KartinaPreferencesViewController.h"
#import "KartinaClient.h"

@interface KartinaPreferencesViewController ()

@end

@implementation KartinaPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"KartinaPreferencesViewController" bundle:nibBundleOrNil];
    if (self) {

    }

    return self;
}

- (void)awakeFromNib {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSString *username = [standardUserDefaults stringForKey:@"username"];
    NSString *password = [standardUserDefaults stringForKey:@"password"];
    NSString *protectedCode = [standardUserDefaults stringForKey:@"protectedCode"];

    [self.usernameField setStringValue:(username != nil ? username : @"")];
    [self.passwordField setStringValue:(password != nil ? password : @"")];
    [self.protectedChannelsCode setStringValue:(protectedCode != nil ? protectedCode : @"")];
}


#pragma mark - RHPreferencesViewControllerProtocol

- (NSString *)identifier {
    return NSStringFromClass(self.class);
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"KartinaSettings"];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"KartinaSettings", @"KartinaSettings");
}

- (NSView *)initialKeyView {
    return self.usernameField;
}

- (IBAction)save:(id)sender {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSString *oldUsername = [standardUserDefaults stringForKey:@"username"];
    NSString *oldPassword = [standardUserDefaults stringForKey:@"password"];
    NSString *oldProtectedCode = [standardUserDefaults stringForKey:@"protectedCode"];

    NSString *newUsername = self.usernameField.stringValue;
    NSString *newPassword = self.passwordField.stringValue;
    NSString *newProtectedCode = self.protectedChannelsCode.stringValue;

    [standardUserDefaults setObject:newUsername forKey:@"username"];
    [standardUserDefaults setObject:newPassword forKey:@"password"];
    [standardUserDefaults setObject:newProtectedCode forKey:@"protectedCode"];

    if (![oldUsername isEqualToString:newUsername] || [oldPassword isEqualToString:newPassword]) {
        KartinaClient *client = [KartinaClient sharedInstance];
        [client loginWithUsername:newUsername AndPassword:newPassword];
    }

    [self.view.window close];
}
@end
