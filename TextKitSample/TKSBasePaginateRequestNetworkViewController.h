//
//  TKSBasePaginateRequestNetworkViewController.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseNetworkViewController.h"
#import "TKSPaginateRequestsManager.h"

@interface TKSBasePaginateRequestNetworkViewController : TKSBaseNetworkViewController<TKSPaginateRequestsManagerDelegate>
@property (nonatomic, strong) TKSPaginateRequestsManager *paginateRequestManager;
@end
