//
// Created by mk on 01.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKKartinaRequest.h"
#import "RKObjectMappingAware.h"


@interface VODList : NSObject <RKObjectMappingAware>

@property(copy, nonatomic) NSString *type;
@property(copy, nonatomic) NSNumber *total;
@property(copy, nonatomic) NSNumber *count;
@property(copy, nonatomic) NSNumber *page;
@property(copy, nonatomic) NSArray *items;

@end