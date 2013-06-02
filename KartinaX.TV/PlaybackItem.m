//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "PlaybackItem.h"


@implementation PlaybackItem {

}
- (id)initWithName:(NSString *)name start:(NSNumber *)start end:(NSNumber *)end  playbackStartPosition:(NSNumber *)position
           groupId:(NSNumber *)groupId groupName:(NSString *)groupName
         channelId:(NSNumber *)channelId channelName:(NSString *)channelName
  protectedChannel:(BOOL)protectedChannel {
    self = [super init];
    if (self) {
        self.name = name;
        self.start = start;
        self.end = end;
        self.playbackStartPosition = position;
        self.groupId = groupId;
        self.groupName = groupName;
        self.channelId = channelId;
        self.channelName = channelName;
        self.protectedChannel = protectedChannel;
        self.isVOD = NO;
    }
    return self;
}

- (id)initWithName:(NSString *)name vodId:(NSNumber *)vodId {
    self = [super init];
    if (self) {
        self.name = name;
        self.vodId = vodId;
        self.isVOD = YES;
    }
    return self;
}

- (BOOL)isPlaybackDurationAvailable {
    return self.start != nil && self.end != nil;
}


@end