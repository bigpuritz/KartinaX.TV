//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface RKKartinaRequest : NSObject

@property(copy, nonatomic) NSNumber *serverTime;
@property(copy, nonatomic) NSDictionary *error;

- (BOOL)hasError;

- (NSNumber *)errorCode;

- (NSString *)errorMessage;

@end