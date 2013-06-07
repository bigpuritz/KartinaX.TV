//
// Created by mk on 06.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Sparkle/Sparkle.h>
#import "SUUpdaterDelegate.h"


@implementation SUUpdaterDelegate {

}


// This method allows you to provide a custom version comparator.
// If you don't implement this method or return nil, the standard version comparator will be used.
- (id <SUVersionComparison>)versionComparatorForUpdater:(SUUpdater *)updater {
    NSLog(@"asking for custom comparator....");
    return nil;
}


@end