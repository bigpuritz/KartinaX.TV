//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RKObjectMappingAware.h"
#import "Account.h"
#import "RKObjectMapping.h"


@implementation Account {

}
+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Account class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"login" : @"loginId",
            @"packet_id" : @"packetId",
            @"packet_name" : @"packetName",
            @"packet_expire" : @"packetExpire"
    }];
    return mapping;
}

@end