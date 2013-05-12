//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKKartinaRequest.h"
#import "RKObjectMappingAware.h"


@interface ChannelStream : RKKartinaRequest <RKObjectMappingAware>

@property(copy, nonatomic) NSString *url;
@property(copy, nonatomic) NSNumber *channelId;

- (NSURL *)nsUrl;

@end