//
// Created by mk on 12.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Settings.h"
#import "RKObjectMapping.h"

@implementation Settings {

}


+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Settings class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"timeshift" : @"timeshift",
            @"timezone" : @"timezone",
            @"http_caching" : @"httpCaching",
            @"stream_server" : @"streamServer",
            @"bitrate" : @"bitrate"
    }];
    return mapping;
}


@end