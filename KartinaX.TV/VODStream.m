//
// Created by mk on 02.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKObjectMapping.h>
#import "VODStream.h"


@implementation VODStream {

}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[VODStream class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"url" : @"url",
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];
    return mapping;
}

- (NSURL *)streamURL {
    NSString *sanitizedURL = [self.url stringByReplacingOccurrencesOfString:@"http/ts://" withString:@"http://"];
    NSRange range = [sanitizedURL rangeOfString:@" "];
    sanitizedURL = [sanitizedURL substringToIndex:range.location];
    return self.url ? [NSURL URLWithString:sanitizedURL] : nil;
}

- (NSString *)networkCachingInMs {
    NSRange rangeStart = [self.url rangeOfString:@":http-caching="];
    NSRange rangeEnd = [self.url rangeOfString:@":no-http-reconnect"];
    NSString *cachingValue = [self.url substringWithRange:NSMakeRange(rangeStart.location + rangeStart.length, rangeEnd.location - rangeStart.location - rangeStart.length)];
    cachingValue = [cachingValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return cachingValue;
}

@end