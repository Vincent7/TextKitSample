//
//  PaginateDataSourceProtocol.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/17.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol PaginateDataSourceProtocol <NSObject>

//- (id)networkRequestsManager;
- (NSString *)refreshRequestPath;
- (NSString *)insertRequestPath;

- (NSDictionary *)insertParamsInfo;
- (NSDictionary *)updateParamsInfo;

- (BOOL)isLoadingData;
- (NSNumber *)requestingInsertRequestDataIdentifer;
- (NSNumber *)requestingRefreshRequestDataIdentifer;

- (NSInteger)offset;
- (NSInteger)limit;
@end


