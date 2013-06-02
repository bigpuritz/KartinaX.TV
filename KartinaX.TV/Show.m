//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Show.h"
#import "Utils.h"
#import <RestKit/RestKit.h>

@implementation Show {

}

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Show class]];
    [mapping addAttributeMappingsFromDictionary:@{
            @"ut_start" : @"start",
            @"progname" : @"name",
            @"t_start" : @"formattedStart"
    }];
    return mapping;
}


- (id)initWithName:(NSString *)name start:(NSNumber *)start end:(NSNumber *)end {
    self = [super init];
    if (self) {
        self.name = name;
        self.start = start;
        self.end = end;
    }
    return self;
}

- (NSString *)title {
    NSArray *lines = [self.name componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    return lines[0];
}

- (NSString *)description {
    NSArray *lines = [self.name componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSUInteger count = lines.count;
    if (count <= 1) {
        return @"";
    }

    NSMutableString *desc = [[NSMutableString alloc] init];
    for (NSUInteger i = 1; i < count; i++) {
        [desc appendString:lines[i]];
    }
    return desc;
}

- (NSString *)formattedStartEnd {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"HH:mm"];

    NSDate *gmtDateStart = [NSDate dateWithTimeIntervalSince1970:[self.start doubleValue]];
    NSDate *gmtDateEnd = [NSDate dateWithTimeIntervalSince1970:[self.end doubleValue]];

    return [@[[formatter stringFromDate:gmtDateStart], @"-", [formatter stringFromDate:gmtDateEnd]] componentsJoinedByString:@" "];
}


- (NSString *)displayName {


    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    [formatter setDateFormat:@"HH:mm"];

    NSDate *gmtDate = [NSDate dateWithTimeIntervalSince1970:[self.start doubleValue]];
    return [@[[formatter stringFromDate:gmtDate], self.title] componentsJoinedByString:@" "];
}

- (BOOL)isInArchiveRange {
    NSNumber *currentTimestamp = [Utils currentUnixTimestamp];
    int secondsSinceStart = currentTimestamp.intValue - self.start.intValue;

    // more than 30 min but less than 2 weeks after start?
    int _30mins = 60 * 30;
    int _2weeks = 60 * 60 * 24 * 14;
    return secondsSinceStart > _30mins && secondsSinceStart < _2weeks;
}

- (BOOL)isMoreThan2WeeksOld {
    NSNumber *currentTimestamp = [Utils currentUnixTimestamp];
    int secondsSinceStart = currentTimestamp.intValue - self.start.intValue;
    int _2weeks = 60 * 60 * 24 * 14;
    return secondsSinceStart >= _2weeks;
}


- (BOOL)isLessThan30MinOld {
    NSNumber *currentTimestamp = [Utils currentUnixTimestamp];
    int secondsSinceStart = currentTimestamp.intValue - self.start.intValue;
    // more than 30 min but less than 2 weeks after start?
    int _30mins = 60 * 30;
    return secondsSinceStart > 0 && secondsSinceStart <= _30mins;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_formattedStart forKey:@"formattedStart"];
    [coder encodeObject:_start forKey:@"start"];
    [coder encodeObject:_end forKey:@"end"];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super init]) {
        self.name = [coder decodeObjectForKey:@"name"];
        self.formattedStart = [coder decodeObjectForKey:@"formattedStart"];
        self.start = [coder decodeObjectForKey:@"start"];
        self.end = [coder decodeObjectForKey:@"end"];
    }
    return self;
}

@end