//
//  HApiClient.h
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HUser.h"
#import "HMeasurement.h"
#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

@interface HApiClient : NSObject

+ (HApiClient*)instance;

- (PMKPromise *)getUsers;
- (PMKPromise *)createUser:(HUser *)user;
- (PMKPromise *)updateUser:(HUser *)user;
- (PMKPromise *)deleteUser:(HUser *)user;

- (PMKPromise *)getMeasurements;
- (PMKPromise *)createMeasurement:(HMeasurement *)measurement;
- (PMKPromise *)updateMeasurement:(HMeasurement *)measurement;

@end

extern NSString * const HUserDataChangedNotification;
