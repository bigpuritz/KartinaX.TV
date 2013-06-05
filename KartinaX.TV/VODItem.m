//
// Created by mk on 01.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKObjectMapping.h>
#import "VODItem.h"


@implementation VODItem {

}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VODItem class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id" : @"id",
            @"dt_modify" : @"lastModificationDate",
            @"name" : @"name",
            @"name_orig" : @"nameOriginal",
            @"description" : @"description",
            @"poster" : @"posterRelativeURL",
            @"year" : @"year",
            @"rate_imdb" : @"ratingImdb",
            @"rate_kinopoisk" : @"ratingKinopoisk",
            @"rate_mpaa" : @"ratingMpaa",
            @"country" : @"country",
            @"genre_str" : @"genres",
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];
    return mapping;
}

- (NSImage *)posterImage {
    NSURL *url = [NSURL URLWithString:self.posterRelativeURL
                        relativeToURL:[NSURL URLWithString:@"http://iptv.kartina.tv/"]];
    return [[NSImage alloc] initByReferencingURL:url];
}


@end