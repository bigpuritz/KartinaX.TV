//
//  Channel.m
//  KartinaX.TV
//
//  Created by mk on 10.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "Channel.h"
#import "RKObjectMapping.h"
#import "Show.h"

@interface Channel ()


@end

@implementation Channel

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Channel class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id" : @"id",
            @"name" : @"name",
            @"stream_params" : @"streamParams",
            @"is_video" : @"isVideo",
            @"protected" : @"protectedChannel",
            @"have_archive" : @"isArchiveAvailable",
            @"icon" : @"icon",
            @"epg_progname" : @"epgProgname",
            @"epg_start" : @"epgStart",
            @"epg_end" : @"epgEnd",
            @"hide" : @"hide"
    }];
    return mapping;
}

//- (Show *)currentShow {
//    return [[Show alloc] initWithName:self.epgProgname start:self.epgStart end:self.epgEnd];
//}
//
//
//- (BOOL)hasEPGForDate:(NSString *)date {
//    if (self.epg && [self.epg objectForKey:date] != nil) {
//        return YES;
//    }
//    return NO;
//}
//
//
//- (void)addEPGForDate:(NSString *)date epg:(NSArray *)shows {
//    if (!self.epg)
//        _epg = [[NSMutableDictionary alloc] init];
//
//    [((NSMutableDictionary *) _epg) setObject:shows forKey:date];
//}

- (BOOL)hasArchive {
    if (self.isArchiveAvailable.intValue == 1)
        return YES;

    return NO;
}

- (BOOL)isProtected {
    if (self.protectedChannel.intValue == 1)
        return YES;

    return NO;
}


@end
