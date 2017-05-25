//
//  TKSAppContextGenerator.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSAppContextGenerator.h"
#import "AFNetworkReachabilityManager.h"
@implementation TKSAppContextGenerator
- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}
+ (instancetype)sharedInstance
{
    static TKSAppContextGenerator *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TKSAppContextGenerator alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        _device_id = @"[OpenUDID value]";
        _os_name = [[UIDevice currentDevice] systemName];
        _os_version = [[UIDevice currentDevice] systemVersion];
        _device_name = [[UIDevice currentDevice] name];
        
    }
    return self;
}

- (NSString *)qtime
{
    NSString *time = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    return time;
}
@end
