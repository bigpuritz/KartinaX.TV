//
//  GlobalPreferencesViewController.m
//  KartinaX.TV
//
//  Created by mk on 01.06.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <TMCache/TMCache.h>
#import "GlobalPreferencesViewController.h"
#import "AppSettings.h"

@interface GlobalPreferencesViewController ()

@end

@implementation GlobalPreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"GlobalPreferencesViewController" bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }

    return self;
}


- (void)awakeFromNib {
    [self.playbackOnStartupButton setState:[AppSettings shouldStartPlaybackOnStartup] ? NSOnState : NSOffState];
    [self.closeEPGWindowButton setState:[AppSettings shouldCloseEPGWindowOnClick] ? NSOnState : NSOffState];
    [self.transparentEPGWindowButton setState:[AppSettings shouldUseTrancparencyForEPGWindow] ? NSOnState : NSOffState];
}


#pragma mark - RHPreferencesViewControllerProtocol

- (NSString *)identifier {
    return NSStringFromClass(self.class);
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"GlobalSettings"];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"GlobalSettings", @"GlobalSettings");
}

- (IBAction)clearEpgCache:(id)sender {
    [[TMCache sharedCache] removeAllObjects];
}

- (IBAction)playVideoOnStartupClicked:(id)sender {
    [AppSettings startPlaybackOnStartup:(BOOL) ((NSButton *) sender).state];
}

- (IBAction)closeEpgWindowClicked:(id)sender {
    [AppSettings closeEPGWindowOnClick:(BOOL) ((NSButton *) sender).state];
}

- (IBAction)transparentEpgWindowClicked:(id)sender {
    [AppSettings useTrancparencyForEPGWindow:(BOOL) ((NSButton *) sender).state];
}
@end
