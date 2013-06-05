//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface PlaybackItem : NSObject

@property(nonatomic, strong) NSNumber *groupId;
@property(nonatomic, strong) NSString *groupName;
@property(nonatomic, strong) NSNumber *channelId;
@property(nonatomic, strong) NSString *channelName;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *start;
@property(nonatomic, strong) NSNumber *end;
@property(nonatomic, strong) NSNumber *playbackStartPosition;
@property(nonatomic) BOOL protectedChannel;
@property(nonatomic) BOOL isVOD;
@property(nonatomic, strong) NSNumber *vodId;

- (id)initWithName:(NSString *)name start:(NSNumber *)start end:(NSNumber *)end playbackStartPosition:(NSNumber *)position
           groupId:(NSNumber *)groupId groupName:(NSString *)groupName
         channelId:(NSNumber *)channelId channelName:(NSString *)channelName
  protectedChannel:(BOOL)protectedChannel;


- (id)initWithName:(NSString *)name  vodId:(NSNumber *)vodId length:(NSNumber *)length;

- (BOOL)isPlaybackDurationAvailable;

- (BOOL)canSpoolPlaybackPosition;


@end