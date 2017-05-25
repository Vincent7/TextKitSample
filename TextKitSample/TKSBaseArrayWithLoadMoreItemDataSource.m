//
//  TKSBaseArrayWithLoadMoreItemDataSource.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/9.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseArrayWithLoadMoreItemDataSource.h"

@implementation TKSBaseArrayWithLoadMoreItemDataSource
- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row < self.items.count) {
        return self.items[(NSUInteger)indexPath.row];
    }else{
        //TODO:
        return @"LoadMore";
    }
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section]+1;
}
- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell;
    if (indexPath.row < self.items.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                               forIndexPath:indexPath];
        id item = [self itemAtIndexPath:indexPath];
        self.configureCellBlock(cell,item);
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TKSBaseLoadMoreTableViewCell class])
                                               forIndexPath:indexPath];
    }
    
    return cell;
}

@end
