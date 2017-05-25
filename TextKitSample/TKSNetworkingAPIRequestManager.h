//
//  TKSNetworkingHttpSessionManager.h
//  TextKitSample
//
//  Created by Vincent on 2017/4/28.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "TKSBaseRequestModel.h"
typedef void(^successedBlockWithResponse)(id JSON);
typedef void(^failedBlockWithRequest)(NSError *error);

@interface TKSNetworkingAPIRequestManager : NSObject
+ (instancetype)sharedInstance;
- (NSNumber *)callRequestWithRequestModel:(TKSBaseRequestModel *)requestModel;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
@end
