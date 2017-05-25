//
//  TKSNetworkingRequestPathManager.m
//  TextKitSample
//
//  Created by Vincent on 2017/4/21.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSNetworkingRequestPathManager.h"
#import "TKSNetworkingRequestPathManager+PathUniformTool.h"
@implementation TKSNetworkingRequestPathManager

+ (NSString *)serverPath{
    return SERVERADDRESS;
}
+ (NSString *)mediumArticleDetailPath{
    return @"medium_overviews";
}

+ (NSString *)articleDetailPathWithArticleId:(NSString *)articleId{
    NSString *serverAddress = [TKSNetworkingRequestPathManager serverPath];
    NSString *articleListPath = [TKSNetworkingRequestPathManager mediumArticleDetailPath];
    NSString *prefixPath = [TKSNetworkingRequestPathManager unifyRequestPath:[NSString stringWithFormat:@"%@%@",serverAddress,articleListPath]];
    return [NSString stringWithFormat:@"%@%@.json",prefixPath,articleId];
}

+ (NSString *)articleListPath{
    NSString *serverAddress = [TKSNetworkingRequestPathManager serverPath];
    NSString *articleListPath = [TKSNetworkingRequestPathManager mediumArticleDetailPath];
    NSString *requestPath = [TKSNetworkingRequestPathManager unifyRequestPath:[NSString stringWithFormat:@"%@%@.json",serverAddress,articleListPath]];
    return requestPath;
}

@end
