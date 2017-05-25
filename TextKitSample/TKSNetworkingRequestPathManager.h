//
//  TKSNetworkingRequestPathManager.h
//  TextKitSample
//
//  Created by Vincent on 2017/4/21.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKSNetworkingRequestPathManager : NSObject
+ (NSString *)serverPath;
+ (NSString *)articleDetailPathWithArticleId:(NSString *)articleId;
+ (NSString *)articleListPath;
@end
