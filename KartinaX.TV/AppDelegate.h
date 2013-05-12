//
//  AppDelegate.h
//  KartinaX.TV
//
//  Created by mk on 09.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class RHPreferencesWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property(assign) IBOutlet NSWindow *window;
@property(weak) IBOutlet NSView *containerView;
@property(retain) RHPreferencesWindowController *preferencesWindowController;


@property(readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


#pragma mark - IBActions
- (IBAction)showPreferences:(id)sender;

- (IBAction)showEPG:(id)sender;


@end
