//
//  KartinaPreferencesViewController.m
//  KartinaX.TV
//
//  Created by mk on 26.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "KartinaPreferencesViewController.h"
#import "KartinaClient.h"
#import "KartinaSession.h"
#import "Login.h"
#import "Account.h"
#import "Settings.h"

@interface KartinaPreferencesViewController ()

@end

@implementation KartinaPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:@"KartinaPreferencesViewController" bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onConnectSuccess:)
                                                     name:kLoginSuccessfulNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onConnectFailed:)
                                                     name:kLoginFailedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onConnectFailed:)
                                                     name:kUserCredentialsMissingNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSetSettingSuccess:)
                                                     name:kSetSettingSuccessfulNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onSetSettingFail:)
                                                     name:kSetSettingFailedNotification
                                                   object:nil];
    }

    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)awakeFromNib {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

    NSString *username = [standardUserDefaults stringForKey:@"username"];
    NSString *password = [standardUserDefaults stringForKey:@"password"];

    [self.usernameField setStringValue:(username != nil ? username : @"")];
    [self.passwordField setStringValue:(password != nil ? password : @"")];

    [self initializeKartinaSettings];
}


- (void)initializeKartinaSettings {

    [self.packetName setStringValue:NSLocalizedString(@"not available", @"not available")];
    [self.packetExpire setStringValue:NSLocalizedString(@"not available", @"not available")];
    [self.serverComboBox removeAllItems];
    [self.timeshiftComboBox removeAllItems];
    [self.bitrateComboBox removeAllItems];
    [self.cachingComboBox removeAllItems];
    [self.timezoneComboBox removeAllItems];
    [self.protectedChannelsCode setEnabled:NO];
    [self.serverComboBox setEnabled:NO];
    [self.timeshiftComboBox setEnabled:NO];
    [self.timezoneComboBox setEnabled:NO];
    [self.bitrateComboBox setEnabled:NO];
    [self.cachingComboBox setEnabled:NO];

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([KartinaSession isLoggedIn]) {

        Login *login = [KartinaSession currentLogin];

        [self.protectedChannelsCode setEnabled:YES];
        [self.serverComboBox setEnabled:YES];
        [self.timeshiftComboBox setEnabled:YES];
        [self.timezoneComboBox setEnabled:YES];
        [self.bitrateComboBox setEnabled:YES];
        [self.cachingComboBox setEnabled:YES];

        NSString *protectedCode = [standardUserDefaults stringForKey:@"protectedCode"];
        [self.protectedChannelsCode setStringValue:(protectedCode != nil ? protectedCode : @"")];

        [self.packetName setStringValue:login.account.packetName];

        NSDate *gmtDate = [NSDate dateWithTimeIntervalSince1970:login.account.packetExpire.doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
        [self.packetExpire setStringValue:[formatter stringFromDate:gmtDate]];


        Settings *settings = login.settings;

        // streaming server
        for (NSString *serverDesc in settings.availableStreamingServers) {
            [self.serverComboBox addItemWithTitle:serverDesc];
            if ([settings.currentStreamingServerIP isEqualToString:settings.availableStreamingServers[serverDesc]]) {
                [self.serverComboBox setTitle:serverDesc];
            }
        }

        // timeshift
        for (NSString *item in settings.availableTimeshifts) {
            [self.timeshiftComboBox addItemWithTitle:item];
        }
        [self.timeshiftComboBox setTitle:settings.currentTimeshift];


        // timezone
        [self.timezoneComboBox addItemsWithTitles:@[
                @"-12", @"-11", @"-10", @"-9", @"-8", @"-7", @"-6", @"-5", @"-4", @"-3", @"-2", @"-1",
                @"0",
                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12"
        ]];
        [self.timezoneComboBox setTitle:settings.currentTimeZone];

        // bitrate
        for (NSString *bitrateTitle in settings.availableBitrates) {
            NSString *bitrateValue = settings.availableBitrates[bitrateTitle];
            [self.bitrateComboBox addItemWithTitle:bitrateTitle];
            if ([settings.currentBitrate isEqualToString:bitrateValue]) {
                [self.bitrateComboBox setTitle:bitrateTitle];
            }
        }

        // caching
        for (NSString *c in settings.availableCachings) {
            [self.cachingComboBox addItemWithTitle:c];
        }
        [self.cachingComboBox setTitle:settings.currentCaching];

    }

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

- (IBAction)connect:(id)sender {

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];

//    NSString *oldUsername = [standardUserDefaults stringForKey:@"username"];
//    NSString *oldPassword = [standardUserDefaults stringForKey:@"password"];

    NSString *newUsername = self.usernameField.stringValue;
    NSString *newPassword = self.passwordField.stringValue;

    [standardUserDefaults setObject:newUsername forKey:@"username"];
    [standardUserDefaults setObject:newPassword forKey:@"password"];

//    if (![oldUsername isEqualToString:newUsername] || ![oldPassword isEqualToString:newPassword]) {
        [self.loginProgressIndicator setHidden:NO];
        [self.loginProgressIndicator startAnimation:self];
        KartinaClient *client = [KartinaClient sharedInstance];
        [client loginWithUsername:newUsername AndPassword:newPassword];
//    }

}


- (void)onConnectSuccess:(NSNotification *)notification {
    [self.loginProgressIndicator stopAnimation:self];
    [self.loginProgressIndicator setHidden:YES];
    [self initializeKartinaSettings];
}

- (void)onConnectFailed:(NSNotification *)notification {
    [self.loginProgressIndicator stopAnimation:self];
    [self.loginProgressIndicator setHidden:YES];
    [self initializeKartinaSettings];
}


- (IBAction)streamingServerSelected:(NSPopUpButton *)sender {
    [self.setSettingProgressIndicator startAnimation:self];
    [self.setSettingProgressIndicator setHidden:NO];

    Settings *settings = [KartinaSession currentLogin].settings;
    NSString *ip = [settings streamingServerIpForName:sender.titleOfSelectedItem];

    [KartinaSession setSettingValue:ip forKey:@"stream_server"];
}

- (IBAction)timeshiftSelected:(NSPopUpButton *)sender {
    [self.setSettingProgressIndicator startAnimation:self];
    [self.setSettingProgressIndicator setHidden:NO];

    [KartinaSession setSettingValue:sender.titleOfSelectedItem forKey:@"timeshift"];
}

- (IBAction)timezoneSelected:(NSPopUpButton *)sender {
    [self.setSettingProgressIndicator startAnimation:self];
    [self.setSettingProgressIndicator setHidden:NO];

    [KartinaSession setSettingValue:sender.titleOfSelectedItem forKey:@"timezone"];
}

- (IBAction)bitrateSelected:(NSPopUpButton *)sender {
    [self.setSettingProgressIndicator startAnimation:self];
    [self.setSettingProgressIndicator setHidden:NO];

    Settings *settings = [KartinaSession currentLogin].settings;
    NSString *bitrate = [settings bitrateValueForName:sender.titleOfSelectedItem];

    [KartinaSession setSettingValue:bitrate forKey:@"bitrate"];
}

- (IBAction)cachingSelected:(NSPopUpButton *)sender {
    [self.setSettingProgressIndicator startAnimation:self];
    [self.setSettingProgressIndicator setHidden:NO];

    [KartinaSession setSettingValue:sender.titleOfSelectedItem forKey:@"http_caching"];
}

- (IBAction)protectedCodeEntered:(NSSecureTextField *)sender {
    [self doSaveProtectedCode];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    [self doSaveProtectedCode];
}

- (void)onSetSettingFail:(id)onSetSettingFail {
    [self.setSettingProgressIndicator stopAnimation:self];
    [self.setSettingProgressIndicator setHidden:YES];
}

- (void)onSetSettingSuccess:(id)onSetSettingSuccess {
    [self.setSettingProgressIndicator stopAnimation:self];
    [self.setSettingProgressIndicator setHidden:YES];
}

- (void)doSaveProtectedCode {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *newProtectedCode = self.protectedChannelsCode.stringValue;
    [standardUserDefaults setObject:newProtectedCode forKey:@"protectedCode"];
}

@end
