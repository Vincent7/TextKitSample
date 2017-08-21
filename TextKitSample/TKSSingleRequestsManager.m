//
//  TKSSingleRequestsManager.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSSingleRequestsManager.h"
@interface TKSSingleRequestsManager() <TKSBaseRequestEngineDelegate>
@property (nonatomic, assign) BOOL isLoadingData;

@property (nonatomic, strong) dispatch_group_t loadRequestGroup;
@property (nonatomic, strong) dispatch_queue_t loadRequestQueue;

@property (nonatomic, strong) NSMutableDictionary *loadSemaphoresInfo;

@property (nonatomic, strong) NSMutableDictionary *loadRequestEngines;
@property (nonatomic, strong) NSNumber *loadingRequestIdentifer;
@end
@implementation TKSSingleRequestsManager

-(BOOL)shouldAcceptDataRequest{
    return YES;
}

-(void)requestForLoadData{
    if (self.loadingRequestIdentifer) {
        NSLog(@"有请求正在执行");
        [self removeEngineInfoWithIdentifer:self.loadingRequestIdentifer];
    }
    dispatch_group_async(self.loadRequestGroup, self.loadRequestQueue, ^{
        NSLog(@"请求更多");
        dispatch_semaphore_t loadRequestSemaphore = dispatch_semaphore_create(0);
        
        TKSBaseRequestEngine *loadRequestEngine = [TKSBaseRequestEngine control:self path:[self loadRequestPath] param:self.loadParamsInfo requestType:GET];
        [loadRequestEngine callRequest];
        
        [self.loadRequestEngines setObject:loadRequestEngine forKey:loadRequestEngine.requestIdentifer];
        
        [self.loadSemaphoresInfo setObject:loadRequestSemaphore forKey:loadRequestEngine.requestIdentifer];
        
        self.loadingRequestIdentifer = loadRequestEngine.requestIdentifer;
        
        dispatch_semaphore_wait(loadRequestSemaphore, DISPATCH_TIME_FOREVER);
    });
}


#pragma mark - setter and getter
- (NSMutableDictionary *)loadRequestEngines{
    if (!_loadRequestEngines) {
        _loadRequestEngines = [NSMutableDictionary dictionary];
    }
    return _loadRequestEngines;
}
-(NSMutableDictionary *)loadSemaphoresInfo{
    if (!_loadSemaphoresInfo) {
        _loadSemaphoresInfo = [NSMutableDictionary dictionary];
    }
    return _loadSemaphoresInfo;
}

- (dispatch_queue_t)loadRequestQueue{
    if (!_loadRequestQueue) {
        _loadRequestQueue = dispatch_queue_create("load 串行队列", DISPATCH_QUEUE_SERIAL);
    }
    return _loadRequestQueue;
}
-(dispatch_group_t)loadRequestGroup{
    if (!_loadRequestGroup) {
        _loadRequestGroup = dispatch_group_create();
    }
    return _loadRequestGroup;
}
- (NSString *)loadRequestPath{
    return self.loadRequestPathString;
}
#pragma mark - TKSBaseRequestEngineDelegate Methods
- (void)engine:(TKSBaseRequestEngine*)engine didRequestFinishedWithData:(id )data andError:(NSError *)error andTag:(NSString *)tag{
    NSDictionary *dataInfo = [NSDictionary dictionaryWithDictionary:[data objectForKey:@"results"]];
    [self removeEngineInfoWithIdentifer:engine.requestIdentifer];
    
    if ([self.delegate respondsToSelector:@selector(didRequestFinishedWithDataResult:andError:)]) {
        dispatch_group_notify(self.loadRequestGroup, dispatch_get_main_queue(), ^{
            [self.delegate didRequestFinishedWithDataResult:dataInfo andError:error];
        });
    }
}

- (void)removeEngineInfoWithIdentifer:(NSNumber *)identifer{

    NSMutableDictionary *enginesInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *semaphoresInfo = [NSMutableDictionary dictionary];
    
    enginesInfo = self.loadRequestEngines;
    semaphoresInfo = self.loadSemaphoresInfo;
    
    TKSBaseRequestEngine *engine = [enginesInfo objectForKey:identifer];
    [engine cancelRequest];
    dispatch_semaphore_t semaphore = [semaphoresInfo objectForKey:identifer];
    dispatch_semaphore_signal(semaphore);
    
    [enginesInfo removeObjectForKey:identifer];
    [semaphoresInfo removeObjectForKey:identifer];
    
    self.loadingRequestIdentifer = nil;
}

-(NSDictionary *)loadParamsInfo{
    return @{@"tag": @"article_detail"};
}
@end
