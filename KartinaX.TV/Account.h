//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class RKObjectMapping;


@interface Account : NSObject<RKObjectMappingAware>

@property(copy, nonatomic) NSNumber *loginId;
@property(copy, nonatomic) NSNumber *packetId;
@property(copy, nonatomic) NSString *packetName;
@property(copy, nonatomic) NSNumber *packetExpire;


+ (RKObjectMapping *)objectMapping;

@end