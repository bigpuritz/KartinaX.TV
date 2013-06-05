//
// Created by mk on 01.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import <RestKit/RestKit/ObjectMapping/RKObjectMapping.h>
#import "VODList.h"
#import "VODItem.h"


@implementation VODList {

}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VODList class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"type" : @"type",
            @"total" : @"total",
            @"count" : @"count",
            @"page" : @"page",
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rows"
                                                                            toKeyPath:@"items"
                                                                          withMapping:[VODItem objectMapping]]];

    return mapping;
}

@end