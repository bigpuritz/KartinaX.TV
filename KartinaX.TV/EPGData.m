//
// Created by mk on 13.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EPGData.h"
#import "Show.h"


@implementation EPGData {

}
- (EPGDataItem *)itemForChannel:(NSNumber *)channelId {

    if (self.items == nil)
        return nil;

    for (EPGDataItem *item in self.items) {
        if ([item.channelId isEqualToNumber:channelId])
            return item;
    }

    return nil;
}

- (void)enhanceShowInformation {

    for (EPGDataItem *item in self.items) {

        NSArray *shows = item.shows;
        for (int i = 0; i < shows.count - 1; i++) {
            Show *show1 = shows[i];
            Show *show2 = shows[i + 1];
            show1.end = [NSNumber numberWithInt:show2.start.intValue];
        }

        Show *last = (Show *) shows.lastObject;
        last.end = [NSNumber numberWithInt:last.start.intValue + 60 * 60]; // 1 hour
    }

}

- (Show *)showForChannel:(NSNumber *)channelId AndStart:(NSNumber *)start {
    EPGDataItem *item = [self itemForChannel:channelId];
    if (item != nil) {
        for (Show *show in item.shows) {
            if ([show.start isEqualToNumber:start])
                return show;
        }
    }

    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_date forKey:@"date"];
    [coder encodeObject:_items forKey:@"items"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.date = [coder decodeObjectForKey:@"date"];
        self.items = [coder decodeObjectForKey:@"items"];
    }
    return self;
}


@end