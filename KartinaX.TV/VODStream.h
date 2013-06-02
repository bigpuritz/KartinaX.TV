//
// Created by mk on 02.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"
#import "RKKartinaRequest.h"


@interface VODStream : RKKartinaRequest <RKObjectMappingAware>

@property(copy, nonatomic) NSString *url;

- (NSURL *)streamURL;

- (NSString *)networkCachingInMs;

@end