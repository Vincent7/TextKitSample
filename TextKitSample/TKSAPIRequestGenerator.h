//
//  TKSAPIRequestGenerator.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/2.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSBaseRequestModel.h"

@interface TKSAPIRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateWithRequestModel:(TKSBaseRequestModel *)model;

@end
