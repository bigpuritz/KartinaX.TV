//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"
#import "RKKartinaRequest.h"

@class ChannelGroup;
@class Channel;


@interface ChannelList : RKKartinaRequest <RKObjectMappingAware>

@property(copy, nonatomic) NSArray *channelGroups;

- (ChannelGroup *)firstChannelGroup;

- (Channel *)firstChannel;

- (Channel *)channelForId:(NSNumber *)id;

@end