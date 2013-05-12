//
//  Channel.h
//  KartinaX.TV
//
//  Created by mk on 10.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"

@class Show;

@interface Channel : NSObject <RKObjectMappingAware>

@property(copy, nonatomic) NSNumber *id;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSDictionary *streamParams;
@property(copy, nonatomic) NSNumber *isVideo;
@property(copy, nonatomic) NSNumber *isArchiveAvailable;
@property(copy, nonatomic) NSString *icon;
@property(copy, nonatomic) NSNumber *protectedChannel;
@property(copy, nonatomic) NSString *epgProgname;
@property(copy, nonatomic) NSNumber *epgStart;
@property(copy, nonatomic) NSNumber *epgEnd;
@property(copy, nonatomic) NSNumber *hide;

@property(strong, nonatomic, readonly) NSDictionary *epg; // NSString -> array of Show's


- (Show *)currentShow;

- (BOOL)hasEPGForDate:(NSString *)date;

- (void)addEPGForDate:(NSString *)date epg:(NSArray *)shows;

- (BOOL)hasArchive;

- (BOOL)isProtected;

@end
