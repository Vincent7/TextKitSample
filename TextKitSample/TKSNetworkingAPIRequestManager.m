//
//  TKSNetworkingHttpSessionManager.m
//  TextKitSample
//
//  Created by Vincent on 2017/4/28.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSNetworkingAPIRequestManager.h"
#import "TKSAPIRequestGenerator.h"
#import "TKSAPIResponseHandler.h"
#import <AFNetworking.h>
@interface TKSNetworkingAPIRequestManager()
//AFNetworking stuff
@property (nonatomic, strong) AFURLSessionManager *sessionManager;
// 根据 requestid，存放 task
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;
// 根据 requestID，存放 requestModel
@property (nonatomic, strong) NSMutableDictionary *requestModelDict;
@end

@implementation TKSNetworkingAPIRequestManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static TKSNetworkingAPIRequestManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TKSNetworkingAPIRequestManager alloc] init];
    });
    return sharedInstance;
}

- (NSNumber *)callRequestWithRequestModel:(TKSBaseRequestModel *)requestModel{
    NSURLRequest *request = [[TKSAPIRequestGenerator sharedInstance] generateWithRequestModel:requestModel];
    typeof(self) __weak weakSelf = self;
    AFURLSessionManager *sessionManager = self.sessionManager;
    __block NSURLSessionDataTask *task = [sessionManager
                                          dataTaskWithRequest:request
                                          uploadProgress:requestModel.uploadProgressBlock
                                          downloadProgress:requestModel.downloadProgressBlock
                                          completionHandler:^(NSURLResponse * _Nonnull response,
                                                              id  _Nullable responseObject,
                                                              NSError * _Nullable error)
                                          {
                                              if (task.state == NSURLSessionTaskStateCanceling) {
                                                  // 如果这个operation是被cancel的，那就不用处理回调了。
                                              } else {
                                                  NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
                                                  [weakSelf.dispatchTable removeObjectForKey:requestID];
                                                  
                                                  //解析完成后通过调用requestModel.responseBlock进行回调
                                                  [TKSAPIResponseHandler handlerWithRequestDataModel:requestModel responseURL:response responseObject:responseObject error:error errorHandler:^(NSError *newError) {
                                                      requestModel.responseCallback(responseObject, newError);
                                                  }];
                                              }
                                          }];
    [task resume];
    NSNumber *requestID = [NSNumber numberWithUnsignedInteger:task.hash];
    [self.dispatchTable setObject:task forKey:requestID];
    return requestID;
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    NSURLSessionDataTask *task = [self.dispatchTable objectForKey:requestID];
    [task cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDList{
    typeof(self) __weak weakSelf = self;
    [requestIDList enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSURLSessionDataTask *task = [weakSelf.dispatchTable objectForKey:obj];
        [task cancel];
    }];
    [self.dispatchTable removeObjectsForKeys:requestIDList];
}

#pragma mark - private methods
- (AFURLSessionManager *)getCommonSessionManager{
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 15;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}
#pragma mark - getters and setters
- (AFURLSessionManager *)sessionManager{
    
    if (_sessionManager == nil) {
        _sessionManager = [self getCommonSessionManager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return _sessionManager;
}
- (NSMutableDictionary *)dispatchTable{
    
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}
@end
