//
//  TKSBaseRequestModel.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/1.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKSBaseRequestModel : NSObject
@property (nonatomic, strong) NSString *apiMethodPath;              //网络请求地址
@property (nonatomic, strong) NSDictionary *parameters;             //请求参数
@property (nonatomic, assign) HTTPMethod requestType;  //网络请求方式
@property (nonatomic, copy) CompletionDataCallback responseCallback;      //请求着陆回调

// upload
// upload file

// download
// download file

// progressBlock
@property (nonatomic, copy) ProgressCallback uploadProgressBlock;
@property (nonatomic, copy) ProgressCallback downloadProgressBlock;
@end
