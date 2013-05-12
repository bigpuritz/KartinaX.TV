//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <RestKit/RestKit/ObjectMapping/RKRelationshipMapping.h>
#import "ChannelGroup.h"
#import "RKObjectMapping.h"
#import "Channel.h"


@implementation ChannelGroup {

}
+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[ChannelGroup class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"id" : @"id",
            @"name" : @"name",
            @"color" : @"color"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"channels"
                                                                            toKeyPath:@"channels"
                                                                          withMapping:[Channel objectMapping]]];
    return mapping;
}

@end