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

NSString * const HUserDataChangedNotification = @"com.antrov.hodor.userdata.changed";

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
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

- (PMKPromise *)getResourceArray:(NSString*)endpoint expectedResultClass:(Class)resultClass {
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

- (PMKPromise *)createResource:(JSONModel *)resource endpoint:(NSString *)endpoint {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
       [self.manager POST:endpoint parameters:[resource toDictionary] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           fulfill(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           reject(error);
       }];
    }];
}

- (PMKPromise *)updateResource:(JSONModel *)resource endpoint:(NSString *)endpoint {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        [self.manager PUT:endpoint parameters:[resource toDictionary] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            fulfill(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            reject(error);
        }];
    }];
}

- (PMKPromise *)deleteResource:(NSString *)endpoint {
    return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
        [self.manager DELETE:endpoint parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            fulfill(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            reject(error);
        }];
    }];
}

#pragma mark Public methods

- (PMKPromise *)getUsers {    
    return [self getResourceArray:@"/users" expectedResultClass:HUser.class];
}

- (PMKPromise *)createUser:(HUser *)user {
    return [self createResource:user endpoint:@"/users"];
}

- (PMKPromise *)updateUser:(HUser *)user {
    return [self updateResource:user endpoint:[NSString stringWithFormat:@"/%@/%@", @"users", user.id]];
}

- (PMKPromise *)deleteUser:(HUser *)user {
    return [self deleteResource:[NSString stringWithFormat:@"/%@/%@", @"users", user.id]];
}

- (PMKPromise *)getMeasurements {
    return [self getResourceArray:@"/measurements?_expand=user" expectedResultClass:HMeasurement.class];
}

@end
