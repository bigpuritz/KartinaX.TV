//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ChannelStream.h"
#import "RKObjectMapping.h"


@implementation ChannelStream {

}
+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ChannelStream class]];
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