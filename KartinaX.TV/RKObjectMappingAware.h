//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class RKObjectMapping;

@protocol RKObjectMappingAware <NSObject>

+ (RKObjectMapping *)objectMapping;

@end