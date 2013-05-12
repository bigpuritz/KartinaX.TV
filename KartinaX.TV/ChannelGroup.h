//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"


@interface ChannelGroup : NSObject <RKObjectMappingAware>

@property(copy, nonatomic) NSNumber *id;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *color;
@property(copy, nonatomic) NSArray *channels;

@end