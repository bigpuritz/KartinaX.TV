//
// Created by mk on 02.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"


@interface VODItemDetails : NSObject <RKObjectMappingAware>


@property(copy, nonatomic) NSString *id;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *nameOriginal;
@property(copy, nonatomic) NSString *description;
@property(copy, nonatomic) NSString *posterRelativeURL;
@property(copy, nonatomic) NSString *lengthMin;
@property(copy, nonatomic) NSString *genres;
@property(copy, nonatomic) NSString *year;
@property(copy, nonatomic) NSString *director;
@property(copy, nonatomic) NSString *scenario;
@property(copy, nonatomic) NSString *actors;
@property(copy, nonatomic) NSString *ratingImdb;
@property(copy, nonatomic) NSString *ratingKinopoisk;
@property(copy, nonatomic) NSString *ratingMpaa;
@property(copy, nonatomic) NSString *country;
@property(copy, nonatomic) NSArray *videosDictionary;
@property(copy, nonatomic) NSArray *genresDictionary;


- (NSImage *)posterImage;

@end