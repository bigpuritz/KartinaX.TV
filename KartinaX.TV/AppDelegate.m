//
//  AppDelegate.m
//  KartinaX.TV
//
//  Created by mk on 09.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "AppDelegate.h"
#import "KartinaClient.h"
#import "KartinaSession.h"
#import "VLCKitMoviePlayerController.h"
#import "PlayerControlsController.h"
#import "KartinaPreferencesViewController.h"
#import "UpdatePreferencesViewController.h"


@interface AppDelegate () {
}

@property(nonatomic, strong) VLCKitMoviePlayerController *playerController;

@end

@implementation AppDelegate

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObject:@"ru"] forKey:@"AppleLanguages"];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showPreferences:)
                                                 name:kUserCredentialsMissingNotification
                                               object:nil];


    // 1. Create the master View Controller
    self.playerController = [[VLCKitMoviePlayerController alloc] initWithChannelStream:nil];
    [self.window makeFirstResponder:self.playerController.view];


    // 2. Add the view controller to the Window's content view
    NSView *movieView = self.playerController.view;
    [self.containerView addSubview:movieView];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[movieView(>=440)]|"
                                                                               options:0
                                                                               metrics:nil views:NSDictionaryOfVariableBindings(movieView)]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[movieView(>=60)]|"
                                                                               options:0
                                                                               metrics:nil views:NSDictionaryOfVariableBindings(movieView)]];

    PlayerControlsController *playerControls = [[PlayerControlsController alloc] init];
    [self.window addChildWindow:playerControls.window ordered:NSWindowAbove];
    [playerControls.window setFrameOrigin:NSMakePoint(
            self.window.frame.origin.x + self.window.frame.size.width / 2 - playerControls.window.frame.size.width / 2,
            self.window.frame.origin.y + 50
    )];
    playerControls.playerLifecycleDelegate = self.playerController;

    self.playerController.playerControlsController = playerControls;
    [self.window setMovableByWindowBackground:YES];
    self.window.delegate = self;

    // 3 start kartina session
    KartinaClient *client = [KartinaClient sharedInstance];
    client.delegate = [KartinaSession sharedInstance];

    // 4 login
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [standardUserDefaults stringForKey:@"username"];
    NSString *pass = [standardUserDefaults stringForKey:@"password"];
    [client loginWithUsername:username AndPassword:pass];

    // 5. remove cache items older than 1 week
    [client trimEPGCache];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)showPreferences:(id)sender {

    //if we have not created the window controller yet, create it now
    if (!_preferencesWindowController) {
        KartinaPreferencesViewController *kartinaPreferences = [[KartinaPreferencesViewController alloc] init];
        UpdatePreferencesViewController *updatePreferences = [[UpdatePreferencesViewController alloc] init];
        _preferencesWindowController = [[RHPreferencesWindowController alloc] initWithViewControllers:@[kartinaPreferences, updatePreferences]
                                                                                             andTitle:NSLocalizedString(@"Preferences", @"Preferences Window Title")];
    }

    [_preferencesWindowController showWindow:self];
}

- (IBAction)showEPG:(id)sender {
    [self.playerController showEpg];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    if ([KartinaSession isLoggedIn]) {
        KartinaClient *client = [KartinaClient sharedInstance];
        [client logout];
    }
    return NSTerminateNow;
}

@end
