//
// Created by mk on 04.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "KartinaSession.h"
#import "Login.h"
#import "ChannelList.h"
#import "ChannelStream.h"
#import "EPGData.h"
#import "Utils.h"
#import "KartinaClient.h"
#import "PlaybackItem.h"
#import "Show.h"
#import "SetSetting.h"
#import "VODList.h"
#import "VODItemDetails.h"
#import "VODStream.h"
#import "AppSettings.h"

@interface KartinaSession ()

@property(nonatomic, strong) Login *login;
@property(nonatomic, strong) ChannelList *channelList;
@property(nonatomic, strong) PlaybackItem *currentPlaybackItem;
@property(nonatomic, strong) NSMutableDictionary *epg; // @todo should be externalized!
@property(nonatomic, strong) NSArray *vodGenres;

@end

@implementation KartinaSession {

}

NSString *const kUserCredentialsMissingNotification = @"UserCredentialsMissingNotification";
NSString *const kLoginSuccessfulNotification = @"LoginSuccessfulNotification";
NSString *const kLoginFailedNotification = @"LoginFailedNotification";

NSString *const kLogoutSuccessfulNotification = @"LogoutSuccessfulNotification";
NSString *const kLogoutFailedNotification = @"LogoutFailedNotification";

NSString *const kChannelListLoadSuccessfulNotification = @"ChannelListLoadSuccessfulNotification";
NSString *const kChannelListLoadFailedNotification = @"ChannelListLoadFailedNotification";

NSString *const kChannelStreamLoadSuccessfulNotification = @"ChannelStreamLoadSuccessfulNotification";
NSString *const kChannelStreamLoadFailedNotification = @"ChannelStreamLoadFailedNotification";

NSString *const kPlaybackItemSelectedNotification = @"PlaybackItemSelectedNotification";

NSString *const kEPGLoadSuccessfulNotification = @"EPGLoadSuccessfulNotification";
NSString *const kEPGLoadFailedNotification = @"EPGLoadFailedNotification";

NSString *const kSetSettingSuccessfulNotification = @"SetSettingSuccessfulNotification";
NSString *const kSetSettingFailedNotification = @"SetSettingFailedNotification";

NSString *const kVODListLoadSuccessfulNotification = @"VODListLoadSuccessfulNotification";
NSString *const kVODListLoadFailedNotification = @"VODListLoadFailedNotification";

NSString *const kVODItemDetailsLoadSuccessfulNotification = @"VODItemDetailsLoadSuccessfulNotification";
NSString *const kVODItemDetailsLoadFailedNotification = @"VODItemDetailsLoadFailedNotification";

NSString *const kVODStreamLoadSuccessfulNotification = @"VODStreamLoadSuccessfulNotification";
NSString *const kVODStreamLoadFailedNotification = @"VODStreamLoadFailedNotification";


static KartinaSession *instance = nil;    // static instance variable


+ (KartinaSession *)sharedInstance {
    if (instance == nil) {
        instance = (KartinaSession *) [[super allocWithZone:NULL] init];
    }
    return instance;
}


- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackItemSelected:)
                                                     name:kPlaybackItemSelectedNotification
                                                   object:nil];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)playbackItemSelected:(NSNotification *)notification {
    self.currentPlaybackItem = [notification.userInfo objectForKey:@"playbackItem"];

    // load stream corresponding to the selected playback item
    KartinaClient *client = [KartinaClient sharedInstance];

    if (self.currentPlaybackItem.isVOD == YES) {

        [client loadVODStream:self.currentPlaybackItem.vodId];

    } else {

        [client loadChannelStream:self.currentPlaybackItem.channelId
                              gmt:self.currentPlaybackItem.playbackStartPosition
                 protectedChannel:self.currentPlaybackItem.protectedChannel];
    }
}

+ (Login *)currentLogin {
    return [KartinaSession sharedInstance].login;
}

+ (ChannelList *)channelList {
    return [KartinaSession sharedInstance].channelList;
}


+ (PlaybackItem *)currentPlaybackItem {
    return [KartinaSession sharedInstance].currentPlaybackItem;
}

+ (PlaybackItem *)replaceCurrentPlaybackItemWithNext {
    KartinaSession *session = [KartinaSession sharedInstance];

    EPGData *epdData = [session epgDataForCurrentPlaybackItem];
    Show *nextShow = [epdData showForChannel:session.currentPlaybackItem.channelId AndStart:session.currentPlaybackItem.end];


    if (nextShow != nil) {
        PlaybackItem *nextPlaybackItem = [[PlaybackItem alloc] initWithName:nextShow.name
                                                                      start:nextShow.start end:nextShow.end
                                                      playbackStartPosition:nextShow.start
                                                                    groupId:session.currentPlaybackItem.groupId
                                                                  groupName:session.currentPlaybackItem.groupName
                                                                  channelId:session.currentPlaybackItem.channelId
                                                                channelName:session.currentPlaybackItem.channelName
                                                           protectedChannel:session.currentPlaybackItem.protectedChannel];
        session.currentPlaybackItem = nextPlaybackItem;
        return session.currentPlaybackItem;
    }

    return nil;
}


+ (EPGData *)epgDataForDate:(NSDate *)date {
    KartinaSession *session = [KartinaSession sharedInstance];
    return [session.epg objectForKey:[Utils dateDDMMYYAsUnixTimestamp:date]];
}

- (EPGData *)epgDataForCurrentPlaybackItem {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.currentPlaybackItem.start.doubleValue];
    return [KartinaSession epgDataForDate:date];
}

+ (NSArray *)vodGenres {
    return [[KartinaSession sharedInstance] vodGenres];
}

+ (BOOL)isLoggedIn {
    return [KartinaSession sharedInstance].login != nil;
}

+ (NSString *)protectedCode {
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [standardUserDefaults stringForKey:@"protectedCode"];

    if (code != nil && [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        return code;
    }
    return nil;
}

+ (void)setSettingValue:(NSString *)value forKey:(NSString *)key {

    KartinaClient *client = [KartinaClient sharedInstance];
    [client setSettingValue:value forKey:key];
}


- (NSMutableDictionary *)epg {
    if (_epg == nil) {
        _epg = [[NSMutableDictionary alloc] init];
    }
    return _epg;
}

- (void)onLoginSuccess:(Login *)login {
    self.login = login;
    [self sendNotification:kLoginSuccessfulNotification userInfo:@{@"login" : self.login}];

    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadChannelList];
    [client loadVODGenres];
}

- (void)onLoginFail:(NSError *)error {
    self.login = nil;
    self.currentPlaybackItem = nil;

    if (error.code == 0)
        [self sendErrorNotification:error name:kUserCredentialsMissingNotification];
    else
        [self sendErrorNotification:error name:kLoginFailedNotification];

}

- (void)onLoadChannelListSuccess:(ChannelList *)channelList {
    self.channelList = channelList;
    [self sendNotification:kChannelListLoadSuccessfulNotification userInfo:@{@"channelList" : self.channelList}];

    // load epg for today....
    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadEPG:[NSDate new]];

    // start playback immediately
    if (self.currentPlaybackItem == nil && [AppSettings shouldStartPlaybackOnStartup]) {

        NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
        NSNumber *lastPlayedChannelId = [NSNumber numberWithInteger:[standardUserDefaults integerForKey:@"lastPlayedChannelId"]];

        Channel *channel = [self.channelList channelForId:lastPlayedChannelId];
        if (channel == nil)
            channel = self.channelList.firstChannel;

        PlaybackItem *item = [[PlaybackItem alloc] initWithName:channel.epgProgname
                                                          start:channel.epgStart end:channel.epgEnd
                                          playbackStartPosition:nil
                                                        groupId:channel.groupId groupName:channel.groupName
                                                      channelId:channel.id channelName:channel.name
                                               protectedChannel:channel.isProtected];

        [[NSNotificationCenter defaultCenter]
                postNotificationName:kPlaybackItemSelectedNotification
                              object:self
                            userInfo:@{@"playbackItem" : item}
        ];
    }

}

- (void)onLoadChannelListFail:(NSError *)error {
    self.channelList = nil;
    [self sendErrorNotification:error name:kChannelListLoadFailedNotification];
}

- (void)onLoadChannelStreamSuccess:(ChannelStream *)stream {
//    self.currentChannelStream = stream;

    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setInteger:stream.channelId.intValue forKey:@"lastPlayedChannelId"];

    [self sendNotification:kChannelStreamLoadSuccessfulNotification
                  userInfo:@{@"channelStream" : stream}];
}

- (void)onLoadChannelStreamFail:(NSError *)error {
    [self sendErrorNotification:error name:kChannelStreamLoadFailedNotification];
}

- (void)onLoadEpgDataSuccess:(EPGData *)epgData {
    NSNumber *unixTime = [Utils dateDDMMYYAsUnixTimestamp:epgData.date];
    [self.epg setObject:epgData forKey:unixTime];
    [self sendNotification:kEPGLoadSuccessfulNotification userInfo:@{@"epg" : epgData}];
}

- (void)onLoadEpgDataFail:(NSError *)error {
    [self sendErrorNotification:error name:kEPGLoadFailedNotification];
}

- (void)onLogoutSuccess {
    self.login = nil;
}

- (void)onLogoutFail:(NSError *)error {

}

- (void)onSetSettingSuccess:(SetSetting *)setting {
    [self sendNotification:kSetSettingSuccessfulNotification userInfo:@{@"setting" : setting}];
}

- (void)onSetSettingFail:(NSError *)error {
    [self sendErrorNotification:error name:kSetSettingFailedNotification];
}


- (void)onLoadVODListSuccess:(VODList *)list {
    [self sendNotification:kVODListLoadSuccessfulNotification userInfo:@{@"vodList" : list}];
}

- (void)onLoadVODListFail:(NSError *)error {
    [self sendErrorNotification:error name:kVODListLoadFailedNotification];
}

- (void)onLoadVODItemDetailsSuccess:(VODItemDetails *)item {
    [self sendNotification:kVODItemDetailsLoadSuccessfulNotification userInfo:@{@"vodItemDetails" : item}];
}

- (void)onLoadVODItemDetailsFail:(NSError *)error {
    [self sendErrorNotification:error name:kVODItemDetailsLoadFailedNotification];
}

- (void)onVODStreamSuccess:(VODStream *)stream {
    [self sendNotification:kVODStreamLoadSuccessfulNotification
                  userInfo:@{@"vodStream" : stream}];
}

- (void)onVODStreamFail:(NSError *)error {
    [self sendErrorNotification:error name:kVODStreamLoadFailedNotification];
}


- (void)onVODGenresLoadSucces:(NSArray *)array {
    self.vodGenres = array;
}

- (void)onVODGenresLoadFail:(NSError *)error {
    self.vodGenres = nil;
}


- (void)sendNotification:(NSString *)name userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter]
            postNotificationName:name
                          object:self
                        userInfo:userInfo
    ];
}

- (void)sendErrorNotification:(NSError *)error name:(NSString *)name {

    NSLog(@"Uncaught error: %@, %@", error, error.userInfo);
    [[NSNotificationCenter defaultCenter]
            postNotificationName:name
                          object:self
                        userInfo:@{@"error" : error}
    ];

    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Error", @"Error")
                                     defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:error.localizedDescription];
    [alert runModal];


}


@end