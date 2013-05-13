//
// Created by mk on 13.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"


@interface EPGDataItem : NSObject <RKObjectMappingAware, NSCoding>

@property(copy, nonatomic) NSNumber *channelId;
@property(copy, nonatomic) NSString *channelName;
@property(nonatomic, strong) NSArray *shows;

@end