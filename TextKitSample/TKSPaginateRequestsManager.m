//
//  TKSPaginateRequestsManager.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/17.
//  Copyright © 2017年 Vincent. All rights reserved.
//
typedef enum : NSUInteger {
    RefreshEnginesInfo,
    InsertEnginesInfo,
} EnginesInfoIdentifer;
#import "TKSPaginateRequestsManager.h"

@interface TKSPaginateRequestsManager() <PaginateDataSourceProtocol,TKSBaseRequestEngineDelegate>
@property (nonatomic, assign, readonly) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) BOOL isLoadingData;

@property (nonatomic, strong) NSNumber *insertingRequestIdentifer;
@property (nonatomic, strong) NSNumber *refreshingRequestIdentifer;

@property (nonatomic, strong) NSMutableDictionary *refreshRequestEngines;
@property (nonatomic, strong) NSMutableDictionary *insertedRequestEngines;

@property (nonatomic, strong) dispatch_group_t refreshRequestGroup;
@property (nonatomic, strong) dispatch_group_t insertRequestGroup;
@property (nonatomic, strong) dispatch_queue_t refreshRequestQueue;
@property (nonatomic, strong) dispatch_queue_t insertRequestQueue;

@property (nonatomic, strong) NSMutableDictionary *refreshSemaphoresInfo;
@property (nonatomic, strong) NSMutableDictionary *insertSemaphoresInfo;



//@property (nonatomic, strong) dispatch_semaphore_t refreshRequestSemaphore;
//@property (nonatomic, strong) dispatch_semaphore_t insertRequestSemaphore;
@end

@implementation TKSPaginateRequestsManager

-(BOOL)shouldAcceptInsertRequest{
    if (self.insertingRequestIdentifer) {
        return NO;
    }
    return YES;
}
- (void)paginateParamsInit{
    self.offset = 0;
}

- (void)updateOffsetWithLastLoadDataListLength:(NSInteger)len{
    self.offset += len;
}

-(void)requestForUpdate{
    if (self.refreshingRequestIdentifer) {
        NSLog(@"有请求正在执行");
        [self removeEngineInfoWithIdentifer:self.refreshingRequestIdentifer atEnginesInfo:RefreshEnginesInfo];
    }
    
    dispatch_group_async(self.refreshRequestGroup, self.refreshRequestQueue, ^{
        NSLog(@"请求刷新");
        dispatch_semaphore_t refreshRequestSemaphore = dispatch_semaphore_create(0);
        
        TKSBaseRequestEngine *updateRequestEngine = [TKSBaseRequestEngine control:self path:[self refreshRequestPath] param:self.updateParamsInfo requestType:GET];
        [updateRequestEngine callRequest];
        
        [self.refreshRequestEngines setObject:updateRequestEngine forKey:updateRequestEngine.requestIdentifer];
        
        [self.refreshSemaphoresInfo setObject:refreshRequestSemaphore forKey:updateRequestEngine.requestIdentifer];
        
        self.refreshingRequestIdentifer = updateRequestEngine.requestIdentifer;
        
        dispatch_semaphore_wait(refreshRequestSemaphore, DISPATCH_TIME_FOREVER);
    });
}
-(void)requestForInsert{
    if (self.insertingRequestIdentifer) {
        NSLog(@"有请求正在执行");
        [self removeEngineInfoWithIdentifer:self.insertingRequestIdentifer atEnginesInfo:InsertEnginesInfo];
    }
    dispatch_group_async(self.insertRequestGroup, self.insertRequestQueue, ^{
        NSLog(@"请求更多");
        dispatch_semaphore_t insertRequestSemaphore = dispatch_semaphore_create(0);
        
        TKSBaseRequestEngine *insertRequestEngine = [TKSBaseRequestEngine control:self path:[self insertRequestPath] param:self.insertParamsInfo requestType:GET];
        [insertRequestEngine callRequest];
        
        [self.insertedRequestEngines setObject:insertRequestEngine forKey:insertRequestEngine.requestIdentifer];
        
        [self.insertSemaphoresInfo setObject:insertRequestSemaphore forKey:insertRequestEngine.requestIdentifer];
        
        self.insertingRequestIdentifer = insertRequestEngine.requestIdentifer;
        
        dispatch_semaphore_wait(insertRequestSemaphore, DISPATCH_TIME_FOREVER);
    });
}


#pragma mark getter and setter
-(NSMutableDictionary *)refreshSemaphoresInfo{
    if (!_refreshSemaphoresInfo) {
        _refreshSemaphoresInfo = [NSMutableDictionary dictionary];
    }
    return _refreshSemaphoresInfo;
}

-(NSMutableDictionary *)insertSemaphoresInfo{
    if (!_insertSemaphoresInfo) {
        _insertSemaphoresInfo = [NSMutableDictionary dictionary];
    }
    return _insertSemaphoresInfo;
}

- (dispatch_queue_t)refreshRequestQueue{
    if (!_refreshRequestQueue) {
        _refreshRequestQueue = dispatch_queue_create("refresh 串行队列", DISPATCH_QUEUE_SERIAL);
    }
    return _refreshRequestQueue;
}

- (dispatch_queue_t)insertRequestQueue{
    if (!_insertRequestQueue) {
        _insertRequestQueue = dispatch_queue_create("insert 串行队列", DISPATCH_QUEUE_SERIAL);
    }
    return _insertRequestQueue;
}
-(dispatch_group_t)refreshRequestGroup{
    if (!_refreshRequestGroup) {
        _refreshRequestGroup = dispatch_group_create();
    }
    return _refreshRequestGroup;
}
-(dispatch_group_t)insertRequestGroup{
    if (!_insertRequestGroup) {
        _insertRequestGroup = dispatch_group_create();
    }
    return _insertRequestGroup;
}

- (NSMutableDictionary *)refreshRequestEngines{
    if (!_refreshRequestEngines) {
        _refreshRequestEngines = [NSMutableDictionary dictionary];
    }
    return _refreshRequestEngines;
}

- (NSMutableDictionary *)insertedRequestEngines{
    if (!_insertedRequestEngines) {
        _insertedRequestEngines = [NSMutableDictionary dictionary];
    }
    return _insertedRequestEngines;
}
//-(TKSBaseRequestEngine *)updateRequestEngine{
//    if (!_updateRequestEngine) {
//        _updateRequestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleListPath] param:self.updateParamsInfo requestType:GET];
//    }
//    return _updateRequestEngine;
//}
//-(TKSBaseRequestEngine *)insertRequestEngine{
//    _insertRequestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleListPath] param:self.insertParamsInfo requestType:GET];
//    return _insertRequestEngine;
//}
#pragma mark - PaginateDataSourceProtocol
-(NSString *)refreshRequestPath{
    return self.refreshRequestPathString;
}

-(NSString *)insertRequestPath{
    return self.insertRequestPathString;
}
-(NSNumber *)requestingInsertRequestDataIdentifer{
    return self.insertingRequestIdentifer;
}
-(NSNumber *)requestingRefreshRequestDataIdentifer{
    return self.refreshingRequestIdentifer;
}
-(NSInteger)limit{
    return 4;
}

-(NSDictionary *)insertParamsInfo{
    return @{@"offset": @(self.offset),
             @"limit": @(self.limit),
             @"is_update":@(0),
             @"tag":@"load_more_data"};
}

-(NSDictionary *)updateParamsInfo{
    return @{@"offset": @(0),
             @"limit": @(self.limit),
             @"is_update":@(1),
             @"tag":@"refresh_data"};
}

- (void)engine:(TKSBaseRequestEngine*)engine didRequestFinishedWithData:(id )data andError:(NSError *)error andTag:(NSString *)tag{
    if (data) {
        NSArray *list = [NSArray arrayWithArray:[data objectForKey:@"results"]];
        
        NSInteger is_update = [[data objectForKey:@"is_update"] integerValue];
        
        if (is_update) {
            self.offset = 0;
            [self removeEngineInfoWithIdentifer:engine.requestIdentifer atEnginesInfo:RefreshEnginesInfo];
            
            if ([self.delegate respondsToSelector:@selector(didRefreshRequestFinishedWithRefreshDataArray:andError:)]) {
                dispatch_group_notify(self.refreshRequestGroup, dispatch_get_main_queue(), ^{
                    [self.delegate didRefreshRequestFinishedWithRefreshDataArray:list andError:error];
                });
                
            }
        }else if (!is_update){
            [self removeEngineInfoWithIdentifer:engine.requestIdentifer atEnginesInfo:InsertEnginesInfo];
            
            if ([self.delegate respondsToSelector:@selector(didInsertRequestFinishedWithInsertedDataArray:andError:)]) {
                dispatch_group_notify(self.insertRequestGroup, dispatch_get_main_queue(), ^{
                    [self.delegate didInsertRequestFinishedWithInsertedDataArray:list andError:error];
                });
                
            }
        }
        [self updateOffsetWithLastLoadDataListLength:list.count];
    }else{
        if ([self.delegate respondsToSelector:@selector(didRequestTimeout)]) {
            dispatch_group_notify(self.insertRequestGroup, dispatch_get_main_queue(), ^{
                [self.delegate didRequestTimeout];
            });    
        }
    }
    
//    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, 10.0*NSEC_PER_SEC);
//    //执行延迟函数
//    dispatch_after(delay, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"获得数据");
//    });
}

- (void)removeEngineInfoWithIdentifer:(NSNumber *)identifer atEnginesInfo:(EnginesInfoIdentifer)enginesInfoIdentifer{
    NSLog(@"删除数据记录");
    NSMutableDictionary *enginesInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *semaphoresInfo = [NSMutableDictionary dictionary];
    switch (enginesInfoIdentifer) {
        case RefreshEnginesInfo:{
            enginesInfo = self.refreshRequestEngines;
            semaphoresInfo = self.refreshSemaphoresInfo;
            break;
        }
        case InsertEnginesInfo:{
            enginesInfo = self.insertedRequestEngines;
            semaphoresInfo = self.insertSemaphoresInfo;
            break;
        }
        default:
            break;
    }
    TKSBaseRequestEngine *engine = [enginesInfo objectForKey:identifer];
    [engine cancelRequest];
    dispatch_semaphore_t semaphore = [semaphoresInfo objectForKey:identifer];
    dispatch_semaphore_signal(semaphore);
    
    [enginesInfo removeObjectForKey:identifer];
    [semaphoresInfo removeObjectForKey:identifer];
    switch (enginesInfoIdentifer) {
        case RefreshEnginesInfo:{
            self.refreshingRequestIdentifer = nil;
            break;
        }
        case InsertEnginesInfo:{
            self.insertingRequestIdentifer = nil;
            break;
        }
        default:
            break;
    }
}
@end
