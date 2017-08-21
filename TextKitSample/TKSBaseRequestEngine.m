//
//  TKSBaseRequestFactory.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseRequestEngine.h"
#import "TKSNetworkingAPIRequestManager.h"
#import "NSObject+TKSNetworkingAutoCancelRequests.h"
@interface TKSBaseRequestEngine()
@property (nonatomic, strong) NSNumber *requestID;
@property (nonatomic, strong) TKSBaseRequestModel *requestModel;
@property (nonatomic, weak) NSObject <TKSBaseRequestEngineDelegate>* control;
@end

@implementation TKSBaseRequestEngine

- (void)dealloc{
    [self cancelRequest];
}
- (void)cancelRequest{
    [[TKSNetworkingAPIRequestManager sharedInstance] cancelRequestWithRequestID:self.requestID];
}

+ (TKSBaseRequestEngine *)control:(NSObject <TKSBaseRequestEngineDelegate>*)requestControl
                         path:(NSString *)path
                        param:(NSDictionary *)parameters
                  requestType:(HTTPMethod)requestType{
    __block TKSBaseRequestEngine *requestEngine = [[TKSBaseRequestEngine alloc]init];
    requestEngine.delegate = requestControl;

    requestEngine.requestModel = [requestEngine dataModelWithPath:path param:parameters requestType:requestType uploadProgressBlock:^(NSProgress *taskProgress) {
        if ([requestControl respondsToSelector:@selector(engine:uploadRequestProgressCallback:)]) {
            [requestControl engine:requestEngine uploadRequestProgressCallback:taskProgress];
        }
    } downloadProgressBlock:^(NSProgress *taskProgress) {
        if ([requestControl respondsToSelector:@selector(engine:downloadRequestProgressCallback:)]) {
            [requestControl engine:requestEngine downloadRequestProgressCallback:taskProgress];
        }
    } complete:^(id data, NSError *error) {
        if ([requestControl respondsToSelector:@selector(engine:didRequestFinishedWithData:andError:andTag:)]) {
            requestEngine.isRequesting = NO;
            NSString *tag = [data objectForKey:@"tag"];
            [requestControl engine:requestEngine didRequestFinishedWithData:data andError:error andTag:tag];
        }
//        [weakControl.networkingAutoCancelRequests removeEngineWithRequestID:engine.requestID];
    }];
//    [requestEngine callRequestWithRequestModel:dataModel requestControl:requestControl];
    return requestEngine;
}

#pragma mark - private methods
- (TKSBaseRequestModel *)dataModelWithPath:(NSString *)path
                                     param:(NSDictionary *)parameters
                               requestType:(HTTPMethod)requestType
                       uploadProgressBlock:(ProgressCallback)uploadProgressBlock
                     downloadProgressBlock:(ProgressCallback)downloadProgressBlock
                                  complete:(CompletionDataCallback)responseBlock
{
    TKSBaseRequestModel *dataModel = [[TKSBaseRequestModel alloc]init];
    dataModel.apiMethodPath = path;
    dataModel.parameters = parameters;
    dataModel.requestType = requestType;
    dataModel.uploadProgressBlock = uploadProgressBlock;
    dataModel.downloadProgressBlock = downloadProgressBlock;
    dataModel.responseCallback = responseBlock;
    return dataModel;
}
- (void)callRequest;{
    [self callRequestWithRequestModel:self.requestModel requestControl:self.control];
}
- (void)callRequestWithRequestModel:(TKSBaseRequestModel *)dataModel requestControl:(NSObject *)control{
    self.requestID = [[TKSNetworkingAPIRequestManager sharedInstance] callRequestWithRequestModel:dataModel];
    self.isRequesting = YES;
    [control.networkingAutoCancelRequests setEngine:self requestID:self.requestID];
}

-(NSNumber *)requestIdentifer{
    return self.requestID;
}
#pragma mark - getters and setters
@end
