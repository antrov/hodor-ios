//
//  HSensorService.m
//  Hodor
//
//  Created by Antrov on 17.10.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HSensorService.h"
#import <CoreMotion/CoreMotion.h>

#define THRESHOLD_DELTA 0.005f
#define MINIMAL_BUFFER  20

NSString * const HSensorServiceRecordDidStartNotification = @"com.antrov.hodor.sensorservice.record.start";
NSString * const HSensorServiceRecordDidStopNotification = @"com.antrov.hodor.sensorservice.record.stop";
NSString * const HSensorServiceMeasurementDidApearNotification = @"com.antrov.hodor.sensorservice.measurement";

@interface HSensorService ()
@property (nonatomic) CMMotionManager *manager;
@property (nonatomic) NSOperationQueue *queue;
@property (nonatomic) NSMutableArray *buffer;
@property (nonatomic) BOOL isRecording;
@end

@implementation HSensorService

+ (HSensorService *)instance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HSensorService new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [CMMotionManager new];
        self.queue = [NSOperationQueue new];
    }
    
    return self;
}

- (void)start {
    self.manager.deviceMotionUpdateInterval = 0.05;
    self.manager.showsDeviceMovementDisplay = YES;
    
    __block double yaw = 0;
    __block int bufferEmpty = 0;
    __weak HSensorService *weakSelf = self;
    
    [self.manager startDeviceMotionUpdatesToQueue:self.queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
        if (ABS(motion.attitude.yaw - yaw) > THRESHOLD_DELTA) {
            if (!weakSelf.isRecording) {
                weakSelf.isRecording = YES;
                weakSelf.buffer = [NSMutableArray new];
                bufferEmpty = 0;
                NSLog(@"start recording");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSNotificationCenter.defaultCenter postNotificationName:HSensorServiceRecordDidStartNotification object:nil];
                });
            }
        } else if (weakSelf.isRecording) {
            if (bufferEmpty > 5) {
                NSLog(@"stop recording with %d, samples", weakSelf.buffer.count);
                weakSelf.isRecording = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [NSNotificationCenter.defaultCenter postNotificationName:HSensorServiceRecordDidStopNotification object:nil];
                });
                
                if (weakSelf.buffer.count > MINIMAL_BUFFER) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [NSNotificationCenter.defaultCenter postNotificationName:HSensorServiceMeasurementDidApearNotification object:nil];
                    });
                }
            } else {
                bufferEmpty++;
            }
        }
        
        if (weakSelf.isRecording && motion.attitude != nil) {
            [weakSelf.buffer addObject:motion.attitude];
        }
        
        yaw = motion.attitude.yaw;
    }];
}

- (void)stop {
    
}

@end
