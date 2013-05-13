//
//  KartinaManager.h
//  KartinaX.TV
//
//  Created by mk on 09.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"

@class Login;
@class ChannelList;
@class ChannelStream;
@class EPGData;
@protocol KartinaClientDelegate;

@interface KartinaClient : NSObject

@property(nonatomic, weak) id <KartinaClientDelegate> delegate;

+ (KartinaClient *)sharedInstance;

- (void)loginWithUsername:(NSString *)username AndPassword:(NSString *)password;

- (void)loadChannelList;

- (void)loadChannelStream:(NSNumber *)channelId
                      gmt:(NSNumber *)unixTime
         protectedChannel:(BOOL)protectedChannel;

- (void)loadEPG:(NSDate *)date;

- (void)logout;

- (void)trimEPGCache;

@end
