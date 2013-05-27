//
// Created by mk on 12.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Settings.h"
#import "RKObjectMapping.h"
#import "Utils.h"

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
        NSString *val = [Utils stringValue:availableBitrate[@"val"]];
        NSString *key = [@[availableBitrate[@"title"], @" (", availableBitrate[@"val"], @")"] componentsJoinedByString:@""];
        [bitrates setObject:val forKey:key];
    }

    return bitrates;
}

- (NSString *)bitrateValueForName:(NSString *)name {
    return self.availableBitrates[name];
}

- (NSString *)currentBitrate {
    return [Utils stringValue:self.bitrate[@"value"]];
}

- (NSString *)currentTimeZone {
    return [Utils stringValue:self.timezone[@"value"]];
}

- (NSArray *)availableTimeshifts {
    NSArray *timeshiftObjects = self.timeshift[@"list"];
    NSMutableArray *available = [[NSMutableArray alloc] init];
    for (NSObject *obj in timeshiftObjects) {
        [available addObject:[Utils stringValue:obj]];
    }
    return available;
}

- (NSString *)currentTimeshift {
    return [Utils stringValue:self.timeshift[@"value"]];
}

- (NSString *)currentStreamingServerIP {
    return [Utils stringValue:self.streamServer[@"value"]];
}

- (NSDictionary *)availableStreamingServers {
    NSMutableDictionary *servers = [[NSMutableDictionary alloc] init];
    NSArray *availableServers = self.streamServer[@"list"];
    for (NSDictionary *serverInfo in availableServers) {
        [servers setObject:[Utils stringValue:serverInfo[@"ip"]] forKey:[Utils stringValue:serverInfo[@"descr"]]];
    }
    return servers;
}

- (NSString *)streamingServerIpForName:(NSString *)name {
    return self.availableStreamingServers[name];
}

- (NSString *)currentCaching {
    return [Utils stringValue:self.httpCaching[@"value"]];
}

- (NSArray *)availableCachings {
    NSArray *cachingsAsNumbers = self.httpCaching[@"list"];
    NSMutableArray *cachings = [[NSMutableArray alloc] init];
    for (NSObject *obj in cachingsAsNumbers) {
        [cachings addObject:[Utils stringValue:obj]];
    }
    return cachings;
}


@end