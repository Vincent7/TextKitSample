//
//  TKSBaseSectionListDataSource.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseSectionListDataSource.h"

@implementation TKSBaseSectionListDataSource
@dynamic items;

- (id) initWithArray:(NSArray *)items
 cellReuseIdentifier:(NSString *)cellReuseIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
headerReuseIdentifier:(NSString *)headerReuseIdentifier configureHeaderBlock:(TableViewCellConfigureBlock)configureHeaderBlock
footerReuseIdentifier:(NSString *)footerReuseIdentifier configureFooterBlock:(TableViewCellConfigureBlock)configureFooterBlock{
    self = [super initWithArray:items cellReuseIdentifier:cellReuseIdentifier configureCellBlock:configureCellBlock];
    if (self) {
        self.items = items;
        self.headerIdentifier = headerReuseIdentifier;
        self.configureHeaderBlock = [configureHeaderBlock copy];
        
        self.footerIdentifier = footerReuseIdentifier;
        self.configureFooterBlock = [configureFooterBlock copy];
    }
    return self;
}

- (id<TKSSectionDataProtocol>) sectionItemAtIndexPathSection:(NSInteger)section {
    if (self.items.count > 0) {
        id<TKSSectionDataProtocol> sectionItem = [self.items objectAtIndex:section];
        return sectionItem;
    }
    return nil;
}

- (id) itemAtIndexPath:(NSIndexPath*)indexPath {
    id<TKSSectionDataProtocol> sectionItem = [self sectionItemAtIndexPathSection:indexPath.section];
    if (sectionItem) {
        return [sectionItem.rowDataList objectAtIndex:indexPath.row];
    }else{
        return nil;
    }
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    id<TKSSectionDataProtocol> sectionItem = [self sectionItemAtIndexPathSection:section];
    if (sectionItem) {
        if (sectionItem.rowDataList.count > sectionItem.dataNumberShownOriginal && !sectionItem.shouldExpandList) {
            return sectionItem.dataNumberShownOriginal;
        }
        return sectionItem.rowDataList.count;
    }else{
        return 0;
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
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

-(void)updateSectionDataItem:(id<TKSSectionDataProtocol>)item atSectionIndex:(NSInteger)index{
    NSMutableArray *mutableDataList = [NSMutableArray arrayWithArray:self.items];
    [mutableDataList replaceObjectAtIndex:index withObject:item];
    self.items = mutableDataList;
}
@end
