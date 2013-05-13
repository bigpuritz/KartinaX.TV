//
// Created by mk on 13.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EPGDataItem.h"
#import "Show.h"
#import <RestKit/RestKit.h>

@implementation EPGDataItem {

}
+ (RKObjectMapping *)objectMapping {

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[EPGDataItem class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id" : @"channelId",
            @"name" : @"channelName"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"epg"
                                                                            toKeyPath:@"shows"
                                                                          withMapping:[Show objectMapping]]];
    return mapping;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_channelId forKey:@"channelId"];
    [coder encodeObject:_channelName forKey:@"channelName"];
    [coder encodeObject:_shows forKey:@"shows"];

}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.channelId = [coder decodeObjectForKey:@"channelId"];
        self.channelName = [coder decodeObjectForKey:@"channelName"];
        self.shows = [coder decodeObjectForKey:@"shows"];
    }
    return self;
}


@end