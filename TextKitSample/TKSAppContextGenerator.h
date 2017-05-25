//
//  TKSAppContextGenerator.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKSAppContextGenerator : NSObject

//@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy, readonly, nonnull) NSString *device_name;            //设备名称
@property (nonatomic, copy, readonly, nonnull) NSString *os_name;            //系统名称
@property (nonatomic, copy, readonly, nonnull) NSString *os_version;            //系统版本
@property (nonatomic, copy, readonly, nonnull) NSString *qtime;        //发送请求的时间
@property (nonatomic, copy, readonly, nonnull) NSString *device_id;
@property (nonatomic, readonly) BOOL isReachable;


+ (instancetype _Nonnull )sharedInstance;
@end
