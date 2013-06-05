//
// Created by mk on 05.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface AppSettings : NSObject

+ (BOOL)shouldStartPlaybackOnStartup;

+ (void)startPlaybackOnStartup:(BOOL)flag;

+ (BOOL)shouldCloseEPGWindowOnClick;

+ (void)closeEPGWindowOnClick:(BOOL)flag;

+ (BOOL)shouldUseTrancparencyForEPGWindow;

+ (void)useTrancparencyForEPGWindow:(BOOL)flag;


@end