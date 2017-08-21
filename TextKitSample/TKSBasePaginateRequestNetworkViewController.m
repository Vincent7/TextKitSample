//
//  TKSBasePaginateRequestNetworkViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBasePaginateRequestNetworkViewController.h"

@interface TKSBasePaginateRequestNetworkViewController ()

@end

@implementation TKSBasePaginateRequestNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TKSPaginateRequestsManagerDelegate

-(void)didRefreshRequestFinishedWithRefreshDataArray:(NSArray *)refreshDataList andError:(NSError *)error{
    
}
-(void)didInsertRequestFinishedWithInsertedDataArray:(NSArray *)insertedDataList andError:(NSError *)error{
    
}
-(void)didRequestTimeout{
    
}
#pragma getter and setter
-(TKSPaginateRequestsManager *)paginateRequestManager{
    if (!_paginateRequestManager) {
        _paginateRequestManager = [TKSPaginateRequestsManager new];
    }
    return _paginateRequestManager;
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
