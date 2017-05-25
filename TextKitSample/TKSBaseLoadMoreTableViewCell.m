//
//  TKSBaseLoadMoreTableViewCell.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/9.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSBaseLoadMoreTableViewCell.h"

@implementation TKSBaseLoadMoreTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.lblLoadMore];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}
- (void)updateConstraints{
    [self.lblLoadMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.right.mas_equalTo(-8);
        make.bottom.mas_equalTo(-8);
    }];
    [super updateConstraints];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - getter and setter
- (UILabel *)lblLoadMore{
    if (!_lblLoadMore) {
        _lblLoadMore = [UILabel new];
        [_lblLoadMore setText:@"Load More"];
        [_lblLoadMore setBackgroundColor:[UIColor purpleColor]];
    }
    return _lblLoadMore;
}
@end
