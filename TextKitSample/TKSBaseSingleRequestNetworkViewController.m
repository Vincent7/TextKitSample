//
//  TKSBaseSingleRequestNetworkViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseSingleRequestNetworkViewController.h"

@interface TKSBaseSingleRequestNetworkViewController ()

@end

@implementation TKSBaseSingleRequestNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TKSSingleRequestsManagerDelegate

-(void)didRequestFinishedWithDataResult:(NSDictionary *)dataInfo andError:(NSError *)error{
    
}

#pragma getter and setter
-(TKSSingleRequestsManager *)requestManager{
    if (!_requestManager) {
        _requestManager = [TKSSingleRequestsManager new];
    }
    return _requestManager;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
