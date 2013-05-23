//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PlaybackItem : NSObject

@property(nonatomic, strong) NSNumber *channelId;
@property(nonatomic, strong) NSString *channelName;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *start;
@property(nonatomic, strong) NSNumber *end;
@property(nonatomic, strong) NSNumber *playbackStartPosition;
@property(nonatomic) BOOL protectedChannel;
@property(nonatomic) BOOL live;

- (id)initWithName:(NSString *)name start:(NSNumber *)start end:(NSNumber *)end playbackStartPosition:(NSNumber *)position
         channelId:(NSNumber *)channelId channelName:(NSString *)channelName live:(BOOL)live protectedChannel:(BOOL)protectedChannel;

- (BOOL)isPlaybackDurationAvailable;

@end