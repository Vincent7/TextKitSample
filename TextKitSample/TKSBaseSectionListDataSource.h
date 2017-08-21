//
//  TKSBaseSectionListDataSource.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseArrayDataSource.h"
#import "TKSSectionDataProtocol.h"
@interface TKSBaseSectionListDataSource : TKSBaseArrayDataSource
@property (nonatomic, strong) NSArray <id<TKSSectionDataProtocol>>*items;
@property (nonatomic, copy) NSString *headerIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureHeaderBlock;
@property (nonatomic, copy) NSString *footerIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock configureFooterBlock;

- (id<TKSSectionDataProtocol>)sectionItemAtIndexPathSection:(NSInteger)section;

- (id) initWithArray:(NSArray *)items
 cellReuseIdentifier:(NSString *)cellReuseIdentifier configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock
headerReuseIdentifier:(NSString *)headerReuseIdentifier configureHeaderBlock:(TableViewCellConfigureBlock)configureHeaderBlock
footerReuseIdentifier:(NSString *)footerReuseIdentifier configureFooterBlock:(TableViewCellConfigureBlock)configureFooterBlock;

-(void)updateSectionDataItem:(id<TKSSectionDataProtocol>)item atSectionIndex:(NSInteger)index;
@end

