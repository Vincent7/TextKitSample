//
//  TKSAPIRequestGenerator.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSAPIRequestGenerator.h"
#import "AFNetworking.h"
#import "TKSCommonParamsGenerator.h"
@interface TKSAPIRequestGenerator ()
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;
@end

@implementation TKSAPIRequestGenerator
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static TKSAPIRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TKSAPIRequestGenerator alloc] init];
    });
    return sharedInstance;
}
#pragma mark - public methods
- (NSURLRequest *)generateWithRequestModel:(TKSBaseRequestModel *)dataModel{
    NSMutableDictionary *commonParams = [NSMutableDictionary dictionaryWithDictionary:[TKSCommonParamsGenerator commonParamsDictionary]];
    [commonParams addEntriesFromDictionary:dataModel.parameters];
    
    NSString *urlString = dataModel.apiMethodPath;
    NSError *error;
    NSMutableURLRequest *request;

    if (dataModel.requestType == GET) {
        request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:commonParams error:&error];
    } else if (dataModel.requestType == POST) {
        request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:commonParams error:&error];
    }
    if (error || request == nil) {
        NSLog(@"NSMutableURLRequests生成失败：\n---------------------------\n\
              urlString:%@\n\
              \n---------------------------\n",urlString);
        return nil;
    }
    
    request.timeoutInterval = 15.0;
    return request;
}
#pragma mark - getters and setters
- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = 15.0;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    }
    return _httpRequestSerializer;
}
@end
