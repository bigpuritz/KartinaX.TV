//
// Created by mk on 04.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class Login;
@class ChannelList;
@class ChannelStream;
@class EPGData;
@class SetSetting;
@class VODList;
@class VODItemDetails;
@class VODStream;

@protocol KartinaClientDelegate <NSObject>

@optional

- (void)onLoginSuccess:(Login *)login;

- (void)onLoginFail:(NSError *)error;

- (void)onLoadChannelListSuccess:(ChannelList *)channelList;

- (void)onLoadChannelListFail:(NSError *)error;

- (void)onLoadChannelStreamSuccess:(ChannelStream *)stream;

- (void)onLoadChannelStreamFail:(NSError *)error;

- (void)onLoadEpgDataSuccess:(EPGData *)epgData;

- (void)onLoadEpgDataFail:(NSError *)error;

- (void)onLogoutSuccess;

- (void)onLogoutFail:(NSError *)error;

- (void)onSetSettingSuccess:(SetSetting *)setting;

- (void)onSetSettingFail:(NSError *)error;

- (void)onLoadVODListSuccess:(VODList *)list;

- (void)onLoadVODListFail:(NSError *)error;

- (void)onLoadVODItemDetailsSuccess:(VODItemDetails *)item;

- (void)onLoadVODItemDetailsFail:(NSError *)error;

- (void)onVODStreamSuccess:(VODStream *)stream;

- (void)onVODStreamFail:(NSError *)error;
@end