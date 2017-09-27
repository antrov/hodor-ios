//
//  HMeasurement.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HMeasurement.h"

@interface JSONValueTransformer (CustomNSDate)
@end

@implementation JSONValueTransformer (CustomTransformer)

- (NSDate *)NSDateFromNSString:(NSString *)string {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return [formatter dateFromString:string];
}

- (NSString *)JSONObjectFromNSDate:(NSDate *)date {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    return [formatter stringFromDate:date];
}

@end

@implementation HMeasurement

- (NSString *)JSONObjectForUser {
    return nil;
}

@end
