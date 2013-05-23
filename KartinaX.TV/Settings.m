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

- (NSDictionary *)availableBitrates {
    NSMutableDictionary *bitrates = [[NSMutableDictionary alloc] init];

    NSArray *availableBitrates = self.bitrate[@"names"];
    for (NSDictionary *availableBitrate in availableBitrates) {
        NSString *key = [@[availableBitrate[@"title"], @" (", availableBitrate[@"val"], @")"] componentsJoinedByString:@""];
        [bitrates setObject:availableBitrate[@"val"] forKey:key];
    }

    return bitrates;
}

- (NSString *)bitrateValueForName:(NSString *)name {
    return self.availableBitrates[name];
}

- (NSString *)currentBitrate {
    NSNumber *v = self.bitrate[@"value"];
    return v.stringValue;
}

- (NSString *)currentTimeZone {
    return self.timezone[@"value"];
}

- (NSArray *)availableTimeshifts {
    return self.timeshift[@"list"];
}

- (NSString *)currentTimeshift {
    return self.timeshift[@"value"];
}

- (NSString *)currentStreamingServerIP {
    return self.streamServer[@"value"];
}

- (NSDictionary *)availableStreamingServers {
    NSMutableDictionary *servers = [[NSMutableDictionary alloc] init];
    NSArray *availableServers = self.streamServer[@"list"];
    for (NSDictionary *serverInfo in availableServers) {
        [servers setObject:serverInfo[@"ip"] forKey:serverInfo[@"descr"]];
    }
    return servers;
}

- (NSString *)streamingServerIpForName:(NSString *)name {
    return self.availableStreamingServers[name];
}

- (NSString *)currentCaching {
    return self.httpCaching[@"value"];
}

- (NSArray *)availableCachings {
    NSArray *cachingsAsNumbers = self.httpCaching[@"list"];
    NSMutableArray *cachings = [[NSMutableArray alloc] init];
    for (NSNumber *c in cachingsAsNumbers) {
        [cachings addObject:c.stringValue];
    }
    return cachings;
}


@end