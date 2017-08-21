//
//  TKSBaseSingleRequestNetworkViewController.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseNetworkViewController.h"
#import "TKSSingleRequestsManager.h"
@interface TKSBaseSingleRequestNetworkViewController : TKSBaseNetworkViewController<TKSSingleRequestsManagerDelegate>
@property (nonatomic, strong) TKSSingleRequestsManager *requestManager;
@end
