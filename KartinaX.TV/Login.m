//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Login.h"
#import "Account.h"
#import "Settings.h"
#import "SetSetting.h"
#import "VODList.h"
#import "VODItemDetails.h"
#import "VODStream.h"
#import <RestKit/RestKit.h>


@implementation Login {

}

+ (RKObjectMapping *)objectMapping {

    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Login class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"sid" : @"sid",
            @"sid_name" : @"sidName",
            @"services" : @"services",
            @"error" : @"error",
            @"servertime" : @"serverTime"
    }];

    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"account"
                                                                            toKeyPath:@"account"
                                                                          withMapping:[Account objectMapping]]];
    [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"settings"
                                                                            toKeyPath:@"settings"
                                                                          withMapping:[Settings objectMapping]]];
    return mapping;
}

- (BOOL)isArchiveAvailable {
    NSNumber *val = [self.services objectForKey:@"archive"];
    return val != nil && val.intValue == 1 ? YES : NO;
}

- (BOOL)isVodAvailable {
    NSNumber *val = [self.services objectForKey:@"vod"];
    return val != nil && val.intValue == 1 ? YES : NO;
}


@end