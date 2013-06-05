//
//  EPGVideothekViewController.h
//  KartinaX.TV
//
//  Created by mk on 30.05.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "EPGWindowController.h"
#import "AGScopeBar.h"


@interface EPGVideothekViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate, AGScopeBarDelegate>

@property(weak) EPGWindowController *parentController;
@property(weak) IBOutlet AGScopeBar *scopeBar;
@property (weak) IBOutlet NSTableView *vodTableView;
@property (weak) IBOutlet NSView *vodDetailsView;
@property (weak) IBOutlet NSTextField *vodDetailsTitle;
@property (weak) IBOutlet NSImageView *vodDetailsImage;
@property (weak) IBOutlet NSTextField *vodDetailsYear;
@property (weak) IBOutlet NSTextField *vodDetailsCountry;
@property (weak) IBOutlet NSTextField *vodDetailsImdb;
@property (weak) IBOutlet NSTextField *vodDetailsKinopoisk;
@property (weak) IBOutlet NSTextField *vodDetailsDirector;
@property (weak) IBOutlet NSTextField *vodDetailsGenres;
@property (weak) IBOutlet NSTextField *vodDetailsDescription;

@property (weak) IBOutlet NSTextField *vodDetailsScenario;
@property (weak) IBOutlet NSTextField *vodDetailsActors;
@property (weak) IBOutlet NSTextField *vodDetailsLength;

@property (weak) IBOutlet NSSearchField *vodSearchField;

- (IBAction)playVODRequested:(id)sender;
- (IBAction)loadMoreRequested:(id)sender;
- (IBAction)searchVODByNameRequested:(id)sender;
 

@end
