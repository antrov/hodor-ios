//
//  HHistoryItem.h
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "HUser.h"

@interface HMeasurement: JSONModel
@property (nonatomic) NSString *id;
@property (nonatomic) HUser <Optional> *user;
@property (nonatomic) NSString <Optional> *userId;
@property (nonatomic) NSDate *timestamp;
@end
