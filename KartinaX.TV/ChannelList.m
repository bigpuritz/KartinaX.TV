//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "ChannelList.h"
#import "RKObjectMapping.h"
#import "ChannelGroup.h"
#import "Channel.h"


@implementation ChannelList {

}
+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ChannelList class]];

    [mapping addAttributeMappingsFromDictionary:@{
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"groups"
                                                                            toKeyPath:@"channelGroups"
                                                                          withMapping:[ChannelGroup objectMapping]]];

    return mapping;
}

- (ChannelGroup *)firstChannelGroup {
    return self.channelGroups ? [self.channelGroups objectAtIndex:0] : nil;
}

- (Channel *)firstChannel {
    ChannelGroup *g = [self firstChannelGroup];
    return g ? [g.channels objectAtIndex:0] : nil;
}

- (Channel *)channelForId:(NSNumber *)id {
    for (ChannelGroup *g in self.channelGroups) {
        for (Channel *c in g.channels) {
            if ([c.id isEqualToNumber:id]) {
                return c;
            }
        }
    }
    return nil;
}


@end