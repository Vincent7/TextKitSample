//
//  TKSAPIResponseHandler.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/1.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSBaseRequestModel.h"
@interface TKSAPIResponseHandler : NSObject
+ (void)handlerWithRequestDataModel:(TKSBaseRequestModel *)requestDataModel responseURL:(NSURLResponse *)responseURL responseObject:(id)responseObject error:(NSError *)error errorHandler:(void(^)(NSError *newError))errorHandler;
@end
