//
// Created by mk on 03.06.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"


@interface VODGenre : NSObject <RKObjectMappingAware>

@property(copy, nonatomic) NSString *id;
@property(copy, nonatomic) NSString *name;

@end