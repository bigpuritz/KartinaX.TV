//
// Created by mk on 13.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "EPGDataItem.h"

@class Show;


@interface EPGData : NSObject <NSCoding>

@property(nonatomic, strong) NSDate *date;
@property(nonatomic, strong) NSArray *items;  // array of EPGDataItem's


- (EPGDataItem *)itemForChannel:(NSNumber *)channelId;

- (void)enhanceShowInformation;

- (Show *)showForChannel:(NSNumber *)channelId AndStart:(NSNumber *)start;

@end