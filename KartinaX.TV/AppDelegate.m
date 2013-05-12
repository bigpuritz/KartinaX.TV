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
    self.playerController = [[VLCKitMoviePlayerController alloc] initWithStreamURL:nil];
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

    /*
    [self.window makeKeyAndOrderFront:self];
    */

    // 3 start kartina session
    KartinaClient *client = [KartinaClient sharedInstance];
    client.delegate = [KartinaSession sharedInstance];

    // 4 login
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [standardUserDefaults stringForKey:@"username"];
    NSString *pass = [standardUserDefaults stringForKey:@"password"];
    [client loginWithUsername:username AndPassword:pass];
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

/*
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
CGFloat newWidth = frameSize.width;
CGFloat newHeight = ((newWidth / 16) * 9);
return (NSSize) {newWidth, newHeight};
}
  */

/*******************************************************************************************************************************************/



// Returns the directory the application uses to store the Core Data store file. This code uses a directory named "net.javaforge.os-.kartina.KartinaX_TV" in the user's Application Support directory.
- (NSURL *)applicationFilesDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *appSupportURL = [[fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"net.javaforge.os-.kartina.KartinaX_TV"];
}

// Creates if necessary and returns the managed object model for the application.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"KartinaX_TV" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. (The directory for the store is created, if necessary.)
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSLog(@"%@:%@ No model to generate a store from", [self class], NSStringFromSelector(_cmd));
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationFilesDirectory = [self applicationFilesDirectory];
    NSError *error = nil;

    NSDictionary *properties = [applicationFilesDirectory resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&error];

    if (!properties) {
        BOOL ok = NO;
        if ([error code] == NSFileReadNoSuchFileError) {
            ok = [fileManager createDirectoryAtPath:[applicationFilesDirectory path] withIntermediateDirectories:YES attributes:nil error:&error];
        }
        if (!ok) {
            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    } else {
        if (![properties[NSURLIsDirectoryKey] boolValue]) {
            // Customize and localize this error.
            NSString *failureDescription = [NSString stringWithFormat:@"Expected a folder to store application data, found a file (%@).", [applicationFilesDirectory path]];

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            [dict setValue:failureDescription forKey:NSLocalizedDescriptionKey];
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:101 userInfo:dict];

            [[NSApplication sharedApplication] presentError:error];
            return nil;
        }
    }

    NSURL *url = [applicationFilesDirectory URLByAppendingPathComponent:@"KartinaX_TV.storedata"];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (![coordinator addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:url options:nil error:&error]) {
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _persistentStoreCoordinator = coordinator;

    return _persistentStoreCoordinator;
}

// Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) 
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];

    return _managedObjectContext;
}


// Returns the NSUndoManager for the application. In this case, the manager returned is that of the managed object context for the application.
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}

// Performs the save action for the application, which is to send the save: message to the application's managed object context. Any encountered errors are presented to the user.
- (IBAction)saveAction:(id)sender {
    NSError *error = nil;

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing before saving", [self class], NSStringFromSelector(_cmd));
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    // Save changes in the application's managed object context before the application terminates.

    if (!_managedObjectContext) {
        return NSTerminateNow;
    }

    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%@ unable to commit editing to terminate", [self class], NSStringFromSelector(_cmd));
        return NSTerminateCancel;
    }

    if (![[self managedObjectContext] hasChanges]) {
        return NSTerminateNow;
    }

    NSError *error = nil;
    if (![[self managedObjectContext] save:&error]) {

        // Customize this code block to include application-specific recovery steps.              
        BOOL result = [sender presentError:error];
        if (result) {
            return NSTerminateCancel;
        }

        NSString *question = NSLocalizedString(@"Could not save changes while quitting. Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];

        if (answer == NSAlertAlternateReturn) {
            return NSTerminateCancel;
        }
    }

    return NSTerminateNow;
}

@end
