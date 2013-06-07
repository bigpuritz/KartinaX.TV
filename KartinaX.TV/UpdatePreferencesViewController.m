//
//  UpdatePreferencesViewController.m
//  KartinaX.TV
//
//  Created by mk on 29.04.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Sparkle/Sparkle.h>
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

//// This method allows you to provide a custom version comparator.
//// If you don't implement this method or return nil, the standard version comparator will be used.
//- (id <SUVersionComparison>)versionComparatorForUpdater:(SUUpdater *)updater {
//    return self;
//}

//- (SUAppcastItem *)bestValidUpdateInAppcast:(SUAppcast *)appcast forUpdater:(SUUpdater *)bundle{
//    NSLog(@"appcast: %@", appcast);
//    NSLog(@"updater: %@", bundle);
//
//    SUAppcast *cast = appcast;
//    NSArray *items =  cast.items;
//    for (SUAppcastItem *item in items) {
//        NSLog(@">> version %@", item.versionString);
//    }
//
//    NSLog(@"------------------------------------------------");
//
//    SUAppcastItem *item = nil;
//    NSEnumerator *updateEnumerator = [[appcast items] objectEnumerator];
//    do {
//        item = [updateEnumerator nextObject];
//    } while (item);
//    NSLog(@">> version from enumerator %@", item.versionString);
//
//    return nil;
//}


//- (NSComparisonResult)compareVersion:(NSString *)versionA toVersion:(NSString *)versionB {
//
//    NSLog(@">>> VersionA : %@", versionA);
//    NSLog(@">>> VersionB : %@", versionB);
//    return NSOrderedSame;
//}


@end
