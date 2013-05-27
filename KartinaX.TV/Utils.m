//
// Created by mk on 21.04.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Utils.h"


@implementation Utils {

}
+ (NSNumber *)dateDDMMYYAsUnixTimestamp:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDate *startDate = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
    return [NSNumber numberWithInt:(int) [startDate timeIntervalSince1970]];
}

+ (NSNumber *)currentUnixTimestamp {
    return [NSNumber numberWithInt:(int) [[NSDate date] timeIntervalSince1970]];
}

+ (NSString *)stringValue:(NSObject *)obj {
    return [NSString stringWithFormat:@"%@", obj];
}


@end