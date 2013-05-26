//
//  UpdatePreferencesViewController.m
//  KartinaX.TV
//
//  Created by mk on 29.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "UpdatePreferencesViewController.h"

@interface UpdatePreferencesViewController ()

@end

@implementation UpdatePreferencesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:@"UpdatePreferencesViewController" bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


#pragma mark - RHPreferencesViewControllerProtocol

- (NSString *)identifier {
    return NSStringFromClass(self.class);
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"UpdateSettings"];
}

- (NSString *)toolbarItemLabel {
    return NSLocalizedString(@"UpdateSettings", @"UpdateSettings");
}


@end
