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

@end