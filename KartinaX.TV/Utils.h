//
// Created by mk on 21.04.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface Utils : NSObject


+ (NSNumber *)dateDDMMYYAsUnixTimestamp:(NSDate *)date;

+ (NSNumber *)currentUnixTimestamp;

+ (NSString *)stringValue:(NSObject *)obj;

@end