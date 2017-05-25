//
//  TKSNetworkingRequestPathManager+pathUniformTool.m
//  TextKitSample
//
//  Created by Vincent on 2017/4/24.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSNetworkingRequestPathManager+PathUniformTool.h"

@implementation TKSNetworkingRequestPathManager(PathUniformTool)
+ (NSString *)unifyRequestPath:(NSString *)requestPath{
    if (![[requestPath substringFromIndex:requestPath.length-1] isEqualToString:@"/"]) {
        return [requestPath stringByAppendingString:@"/"];
    }else{
        return requestPath;
    }
}
@end
