//
// Created by mk on 23.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <RestKit/RestKit.h>
#import "SetSetting.h"


@implementation SetSetting {

}


+ (RKObjectMapping *)objectMapping {

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[SetSetting class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"message" : @"message",
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];

    return mapping;
}

@end