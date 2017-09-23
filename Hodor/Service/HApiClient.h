//
//  HApiClient.h
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HUser.h"
#import "HHistoryItem.h"
#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

@interface HApiClient : NSObject

+ (HApiClient*)instance;

- (PMKPromise *)getUsers;

@end
