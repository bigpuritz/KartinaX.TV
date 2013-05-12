//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PlaybackItem.h"


@implementation PlaybackItem {

}
- (id)initWithName:(NSString *)name start:(NSNumber *)start end:(NSNumber *)end  playbackStartPosition:(NSNumber *)position
         channelId:(NSNumber *)channelId channelName:(NSString *)channelName  live:(BOOL)live protectedChannel:(BOOL)protectedChannel {
    self = [super init];
    if (self) {
        self.name = name;
        self.start = start;
        self.end = end;
        self.playbackStartPosition = position;
        self.channelId = channelId;
        self.channelName = channelName;
        self.live = live;
        self.protectedChannel = protectedChannel;
    }
    return self;
}

@end