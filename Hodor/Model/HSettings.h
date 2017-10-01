//
//  HSettings.h
//  Hodor
//
//  Created by Antrov on 01.10.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HSettings : JSONModel
@property (nonatomic) BOOL screenTurnOff;
@property (nonatomic) BOOL darknessDetection;
@property (nonatomic) NSInteger hoursIndexFrom;
@property (nonatomic) NSInteger hoursIndexTo;
@end
