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

- (NSURL *)nsUrl {

    NSString *sanitizedURL = [self.url stringByReplacingOccurrencesOfString:@"http/ts://" withString:@"http://"];
    NSRange range = [sanitizedURL rangeOfString:@" "];

    sanitizedURL = [sanitizedURL substringToIndex:range.location];
    
    NSLog(@"range: %@", NSStringFromRange(range));
    NSLog(@"URL: %@", sanitizedURL);
    
    return self.url ? [NSURL URLWithString:sanitizedURL] : nil;
}


@end