//
//  TKSArticleResponseListAndDetailViewController.h
//  TextKitSample
//
//  Created by Vincent on 2017/6/5.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseSingleRequestNetworkViewController.h"

@interface TKSArticleResponseListAndDetailViewController : TKSBaseSingleRequestNetworkViewController
@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *articleTitle;
@end
