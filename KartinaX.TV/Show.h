//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"


@interface Show : NSObject <RKObjectMappingAware, NSCoding>

@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *formattedStart;
@property(copy, nonatomic) NSNumber *start;
@property(copy, nonatomic) NSNumber *end;

- (id)initWithName:(NSString *)name start:(NSNumber *)start end:(NSNumber *)end;

- (NSString *)displayName;

- (BOOL)isInArchiveRange;

- (BOOL)isMoreThan2WeeksOld;

- (BOOL)isLessThan30MinOld;
@end