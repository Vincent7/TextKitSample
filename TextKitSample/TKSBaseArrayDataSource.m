//
//  TKSBaseArrayDataSource.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/8.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseArrayDataSource.h"
@interface TKSBaseArrayDataSource ()



@end

@implementation TKSBaseArrayDataSource
-(void)setItems:(NSArray *)items{
    _items = items;
}

-(id)initWithArray:(NSArray *)items cellReuseIdentifier:(NSString *)cellReuseIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock{
    self = [super init];
    if (self) {
        self.items = items;
        self.cellIdentifier = cellReuseIdentifier;
        self.configureCellBlock = [configureCellBlock copy];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    return self.items[(NSUInteger)indexPath.row];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier
                                              forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell,item);
    return cell;
}

-(void)updateRowDataItem:(id)item atIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:self.items];
    [mutableDataList replaceObjectAtIndex:indexPath.row withObject:item];
    self.items = mutableDataList;
}
@end
