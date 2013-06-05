//
// Created by mk on 05.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AppSettings.h"


@implementation AppSettings {

}
+ (BOOL)shouldStartPlaybackOnStartup {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *val = [defaults objectForKey:@"startPlaybackOnStartup"];
    return val != nil ? val.boolValue : YES;
}

+ (BOOL)shouldCloseEPGWindowOnClick {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *val = [defaults objectForKey:@"closeEPGWindowOnClick"];
    return val != nil ? val.boolValue : YES;
}

+ (BOOL)shouldUseTrancparencyForEPGWindow {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *val = [defaults objectForKey:@"useTrancparencyForEPGWindow"];
    return val != nil ? val.boolValue : YES;
}

+ (void)startPlaybackOnStartup:(BOOL)flag {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:flag] forKey:@"startPlaybackOnStartup"];
}

+ (void)closeEPGWindowOnClick:(BOOL)flag {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:flag] forKey:@"closeEPGWindowOnClick"];
}

+ (void)useTrancparencyForEPGWindow:(BOOL)flag {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:flag] forKey:@"useTrancparencyForEPGWindow"];
}

@end