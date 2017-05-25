//
//  TKSCommonParamsGenerator.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSCommonParamsGenerator.h"
#import "TKSAppContextGenerator.h"
@implementation TKSCommonParamsGenerator
+ (NSDictionary *)commonParamsDictionary
{
    TKSAppContextGenerator *context = [TKSAppContextGenerator sharedInstance];
    
    NSMutableDictionary *commonParams = [@{
                                           @"device_id":context.device_id,
                                           @"os_version":context.os_version,
                                           @"time":context.qtime
                                           } mutableCopy];
    
    return commonParams;
}
@end
