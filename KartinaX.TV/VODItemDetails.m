//
// Created by mk on 02.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKObjectMapping.h>
#import "VODItemDetails.h"


@implementation VODItemDetails {

}


+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VODItemDetails class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id" : @"id",
            @"name" : @"name",
            @"name_orig" : @"nameOriginal",
            @"description" : @"description",
            @"poster" : @"posterRelativeURL",
            @"length" : @"lengthMin",
            @"genre_str" : @"genres",
            @"director" : @"director",
            @"scenario" : @"scenario",
            @"actors" : @"actors",
            @"year" : @"year",
            @"rate_imdb" : @"ratingImdb",
            @"rate_kinopoisk" : @"ratingKinopoisk",
            @"rate_mpaa" : @"ratingMpaa",
            @"country" : @"country",
            @"videos" : @"videosDictionary",
            @"genres" : @"genresDictionary"

    }];
    return mapping;
}

- (NSImage *)posterImage {
    NSURL *url = [NSURL URLWithString:self.posterRelativeURL
                        relativeToURL:[NSURL URLWithString:@"http://iptv.kartina.tv/"]];
    return [[NSImage alloc] initByReferencingURL:url];
}


@end