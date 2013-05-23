//
// Created by mk on 12.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"

@class RKObjectMapping;


@interface Settings : NSObject <RKObjectMappingAware>

@property(copy, nonatomic) NSDictionary *timeshift;
@property(copy, nonatomic) NSDictionary *timezone;
@property(copy, nonatomic) NSDictionary *httpCaching;
@property(copy, nonatomic) NSDictionary *streamServer;
@property(copy, nonatomic) NSDictionary *bitrate;


+ (RKObjectMapping *)objectMapping;


- (NSDictionary *)availableBitrates;

- (NSString *)currentBitrate;

- (NSString *)currentTimeZone;

- (NSArray *)availableTimeshifts;

- (NSString *)currentTimeshift;

- (NSString *)currentStreamingServerIP;

- (NSDictionary *)availableStreamingServers;

- (NSString *)currentCaching;

- (NSArray *)availableCachings;


- (NSString *)streamingServerIpForName:(NSString *)string;

- (NSString *)bitrateValueForName:(NSString *)string;
@end

