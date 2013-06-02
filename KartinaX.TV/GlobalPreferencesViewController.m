//
//  GlobalPreferencesViewController.m
//  KartinaX.TV
//
//  Created by mk on 01.06.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "GlobalPreferencesViewController.h"

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

@end
