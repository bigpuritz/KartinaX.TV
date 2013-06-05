//
// Created by mk on 03.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKObjectMapping.h>
#import "VODGenre.h"


@implementation VODGenre {

}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VODGenre class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id" : @"id",
            @"name" : @"name",
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];
    return mapping;
}

@end