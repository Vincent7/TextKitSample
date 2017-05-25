//
//  TKSNetworkingAutoCancelRequests.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSNetworkingAutoCancelRequests.h"
@interface TKSNetworkingAutoCancelRequests()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *,TKSBaseRequestEngine *> *requestEngines;
@end

@implementation TKSNetworkingAutoCancelRequests

-(void)dealloc{
    [self.requestEngines removeAllObjects];
    self.requestEngines = nil;
}

- (NSMutableDictionary *)requestEngines{
    
    if (_requestEngines == nil) {
        _requestEngines = [[NSMutableDictionary alloc] init];
    }
    return _requestEngines;
}

- (void)setEngine:(TKSBaseRequestEngine *)engine requestID:(NSNumber *)requestID{
    
    if (engine && requestID) {
        self.requestEngines[requestID] = engine;
    }
}

- (void)removeEngineWithRequestID:(NSNumber *)requestID{
    
    if (requestID) {
        [self.requestEngines removeObjectForKey:requestID];
    }
}
@end
