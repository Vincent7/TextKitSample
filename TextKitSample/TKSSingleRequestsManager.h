//
//  TKSSingleRequestsManager.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSBaseRequestEngine.h"
@protocol TKSSingleRequestsManagerDelegate <NSObject>
-(void)didRequestFinishedWithDataResult:(NSDictionary *)dataInfo andError:(NSError *)error;
@end
@interface TKSSingleRequestsManager : NSObject
@property (nonatomic, weak) id <TKSSingleRequestsManagerDelegate> delegate;
@property (nonatomic, copy) NSString *loadRequestPathString;
-(void)requestForLoadData;
-(BOOL)shouldAcceptDataRequest;
@end
