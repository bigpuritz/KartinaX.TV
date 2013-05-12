//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "RKObjectMappingAware.h"
#import "RKKartinaRequest.h"

@class Account;
@class Settings;


@interface Login : RKKartinaRequest <RKObjectMappingAware>

@property(copy, nonatomic) NSString *sid;
@property(copy, nonatomic) NSString *sidName;
@property(nonatomic, strong) Account *account;
@property(nonatomic, strong) Settings *settings;
@property(copy, nonatomic) NSDictionary *services;

- (BOOL)isArchiveAvailable;

- (BOOL)isVodAvailable;

@end