//
// Created by mk on 10.03.13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RKKartinaRequest.h"


@implementation RKKartinaRequest {

}
- (BOOL)hasError {
    return self.error != nil;
}

- (NSNumber *)errorCode {
    return self.error ? [self.error objectForKey:@"code"] : nil;
}

- (NSString *)errorMessage {
    return self.error ? [self.error objectForKey:@"message"] : nil;
}

@end