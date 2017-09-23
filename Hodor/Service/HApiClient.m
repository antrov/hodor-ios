//
//  HApiClient.m
//  Hodor
//
//  Created by Antrov on 23.09.2017.
//  Copyright © 2017 Antrov. All rights reserved.
//

#import "HApiClient.h"
#import <AFNetworking.h>

static NSString * const apiBaseUrl = @"http://192.168.0.106:3000/";

@interface HApiClient ()
@property (nonatomic) AFHTTPSessionManager *manager;
@end

@implementation HApiClient

+ (HApiClient *)instance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [HApiClient new];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:apiBaseUrl]];
        self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    return self;
}

- (PMKPromise *)getFromEndpoint:(NSString*)endpoint expectedResultClass:(Class)resultClass {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        [self.manager GET:endpoint parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *jsonError;
            NSArray *users = [resultClass arrayOfModelsFromData:responseObject error:&jsonError];
            
            if (jsonError == nil) {
                fulfill(users);
            } else {
                reject(jsonError);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            reject(error);
        }];
    }];
}

- (PMKPromise *)getUsers {
    return [self getFromEndpoint:@"/users" expectedResultClass:HUser.class];
}

@end
