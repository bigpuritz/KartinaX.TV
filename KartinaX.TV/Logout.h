//
// Created by mk on 13.05.13.
// Copyright (c) 2013 Maxim Kalina. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"
#import "RKKartinaRequest.h"

@interface Logout : RKKartinaRequest <RKObjectMappingAware>

@property(copy, nonatomic) NSString *message;

@end