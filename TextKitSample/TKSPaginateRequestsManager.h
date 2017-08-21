//
//  TKSPaginateRequestsManager.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/17.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaginateDataSourceProtocol.h"
#import "TKSBaseRequestEngine.h"
@protocol TKSPaginateRequestsManagerDelegate <NSObject>
-(void)didRefreshRequestFinishedWithRefreshDataArray:(NSArray *)refreshDataList andError:(NSError *)error;
-(void)didInsertRequestFinishedWithInsertedDataArray:(NSArray *)insertedDataList andError:(NSError *)error;
-(void)didRequestTimeout;
@end
@interface TKSPaginateRequestsManager : NSObject
@property (nonatomic, weak) id <TKSPaginateRequestsManagerDelegate> delegate;
@property (nonatomic, copy) NSString *refreshRequestPathString;
@property (nonatomic, copy) NSString *insertRequestPathString;
-(void)requestForUpdate;
-(void)requestForInsert;
-(BOOL)shouldAcceptInsertRequest;
@end
