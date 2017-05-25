//
//  NSObject+TKSNetworkingAutoCancelRequests.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "NSObject+TKSNetworkingAutoCancelRequests.h"
#import <objc/runtime.h>
@implementation NSObject(TKSNetworkingAutoCancelRequests)
- (TKSNetworkingAutoCancelRequests *)networkingAutoCancelRequests{
    TKSNetworkingAutoCancelRequests *requests = objc_getAssociatedObject(self, @selector(networkingAutoCancelRequests));
    if (requests == nil) {
        requests = [[TKSNetworkingAutoCancelRequests alloc]init];
        objc_setAssociatedObject(self, @selector(networkingAutoCancelRequests), requests, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requests;
}
@end
