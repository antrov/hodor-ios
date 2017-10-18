//
//  HSensorService.h
//  Hodor
//
//  Created by Antrov on 17.10.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSensorService : NSObject

+ (HSensorService *)instance;

- (void)start;
- (void)stop;

@end

extern NSString * const HSensorServiceRecordDidStartNotification;
extern NSString * const HSensorServiceRecordDidStopNotification;
extern NSString * const HSensorServiceMeasurementDidApearNotification;
