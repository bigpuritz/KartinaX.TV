//
// Created by mk on 23.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"
#import "RKKartinaRequest.h"

@protocol RKObjectMappingAware;


@interface SetSetting : RKKartinaRequest <RKObjectMappingAware>

@property(copy, nonatomic) NSDictionary *message;

@end