//
// Created by mk on 04.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "KartinaClientDelegate.h"

@class Login;
@class ChannelList;
@class ChannelStream;
@class PlaybackItem;


@interface KartinaSession : NSObject <KartinaClientDelegate>


extern NSString *const kUserCredentialsMissingNotification;

extern NSString *const kLoginSuccessfulNotification;
extern NSString *const kLoginFailedNotification;

extern NSString *const kLogoutSuccessfulNotification;
extern NSString *const kLogoutFailedNotification;

extern NSString *const kChannelListLoadSuccessfulNotification;
extern NSString *const kChannelListLoadFailedNotification;

extern NSString *const kChannelStreamLoadSuccessfulNotification;
extern NSString *const kChannelStreamLoadFailedNotification;

extern NSString *const kPlaybackItemSelectedNotification;

extern NSString *const kEPGLoadSuccessfulNotification;
extern NSString *const kEPGLoadFailedNotification;

extern NSString *const kSetSettingSuccessfulNotification;
extern NSString *const kSetSettingFailedNotification;

+ (KartinaSession *)sharedInstance;

+ (Login *)currentLogin;

+ (ChannelList *)channelList;

+ (ChannelStream *)currentChannelStream;

+ (PlaybackItem *)currentPlaybackItem;

+ (PlaybackItem *)replaceCurrentPlaybackItemWithNext;

+ (EPGData *)epgDataForDate:(NSDate *)date;

+ (BOOL)isLoggedIn;

+ (NSString *)protectedCode;

+ (void)setSettingValue:(NSString *)value forKey:(NSString *)key;

@end