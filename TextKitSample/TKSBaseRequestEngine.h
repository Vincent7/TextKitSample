//
//  TKSBaseRequestFactory.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//
#import <Foundation/Foundation.h>
//#import "TKSBaseNetworkViewController.h"
@class TKSBaseRequestEngine;
@protocol TKSBaseRequestEngineDelegate <NSObject>
@optional
- (void)engine:(TKSBaseRequestEngine*)engine didRequestFinishedWithData:(id )data andError:(NSError *)error;
- (void)engine:(TKSBaseRequestEngine*)engine uploadRequestProgressCallback:(NSProgress *)progress;
- (void)engine:(TKSBaseRequestEngine*)engine downloadRequestProgressCallback:(NSProgress *)progress;
@end


@interface TKSBaseRequestEngine : NSObject
@property (nonatomic, weak) NSObject <TKSBaseRequestEngineDelegate>* delegate;
+ (TKSBaseRequestEngine * )control:(NSObject <TKSBaseRequestEngineDelegate>*)requestControl
                             path:(NSString * )path
                            param:(NSDictionary * )parameters
                      requestType:(HTTPMethod)requestType;
@end
