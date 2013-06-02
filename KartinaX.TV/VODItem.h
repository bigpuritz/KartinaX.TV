//
// Created by mk on 01.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"


@interface VODItem : NSObject <RKObjectMappingAware>

@property(copy, nonatomic) NSString *id;
@property(copy, nonatomic) NSDate *lastModificationDate;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *nameOriginal;
@property(copy, nonatomic) NSString *description;
@property(copy, nonatomic) NSString *posterRelativeURL;
@property(copy, nonatomic) NSString *year;
@property(copy, nonatomic) NSString *ratingImdb;
@property(copy, nonatomic) NSString *ratingKinopoisk;
@property(copy, nonatomic) NSString *ratingMpaa;
@property(copy, nonatomic) NSString *country;
@property(copy, nonatomic) NSString *genres;


- (NSImage *)posterImage;

@end