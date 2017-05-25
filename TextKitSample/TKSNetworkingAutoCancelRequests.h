//
//  TKSNetworkingAutoCancelRequests.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TKSBaseRequestEngine;
@interface TKSNetworkingAutoCancelRequests : NSObject
- (void)setEngine:(TKSBaseRequestEngine *)engine requestID:(NSNumber *)requestID;
- (void)removeEngineWithRequestID:(NSNumber *)requestID;
@end
