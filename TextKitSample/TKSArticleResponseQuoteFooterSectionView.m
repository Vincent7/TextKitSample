//
//  TKSArticleResponseQuoteFooterSectionView.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/30.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseQuoteFooterSectionView.h"
#import "UIImage+TKSTableViewBoundaryShadow.h"
#import "TKSTextParagraphAttributeManager.h"

@interface TKSArticleResponseQuoteFooterSectionView()
@property (nonatomic, strong) UIButton *btnShowMore;
@property (nonatomic, strong) UIImageView *lowerShadowImageView;

@property (nonatomic, assign) BOOL showSeeMoreButton;
@property (nonatomic, strong) NSAttributedString *showMoreButtonAttributedTitle;
@end
@implementation TKSArticleResponseQuoteFooterSectionView


-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.btnShowMore];
        [self.contentView addSubview:self.lowerShadowImageView];
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
-(void)setShowSeeMoreButton:(BOOL)showSeeMoreButton{
    if (_showSeeMoreButton != showSeeMoreButton) {
        _showSeeMoreButton = showSeeMoreButton;
        [self.btnShowMore setHidden:showSeeMoreButton];
        [self setNeedsUpdateConstraints];
    }
}


-(void)updateConstraints{
    if (!self.showSeeMoreButton) {
        [self.btnShowMore mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lowerShadowImageView.mas_bottom).offset(11);
            make.centerX.equalTo(self.contentView.mas_centerX);
            //        make.centerY.equalTo(self.contentView.mas_centerY).offset(1);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(16);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
        }];
        [self.lowerShadowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(2);
            
        }];
    }else{
        [self.btnShowMore mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.centerX.equalTo(self.contentView.mas_centerX);
            //        make.centerY.equalTo(self.contentView.mas_centerY).offset(1);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(0);
        }];
        [self.lowerShadowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(2);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-18);
        }];
    }
    [super updateConstraints];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - getter and setter
-(NSAttributedString *)showMoreButtonAttributedTitle{
    if (!_showMoreButtonAttributedTitle) {
        _showMoreButtonAttributedTitle = [[NSAttributedString alloc]initWithString:@"See more" attributes:[TKSTextParagraphAttributeManager articleDisscussPointSeeMoreFooterTitleAttributeInfo]];
    }
    return _showMoreButtonAttributedTitle;
    
}
-(UIButton *)btnShowMore{
    if (!_btnShowMore) {
        _btnShowMore = [UIButton new];
        [_btnShowMore setAttributedTitle:self.showMoreButtonAttributedTitle forState:UIControlStateNormal];
        [_btnShowMore addTarget:self action:@selector(didTapBtnSeeMore) forControlEvents:UIControlEventTouchUpInside];
//        [_btnShowMore setAttributedTitle:self.showMoreButtonAttributedTitle forState:UIControlStateNormal];
    }
    return _btnShowMore;
}
-(UIImageView *)lowerShadowImageView{
    if (!_lowerShadowImageView) {
        _lowerShadowImageView = [[UIImageView alloc]initWithImage:[UIImage lowerBoundaryShadowImage]];
    }
    return _lowerShadowImageView;
}

- (void)didTapBtnSeeMore{
    if (self.delegate && [self.delegate respondsToSelector:@selector(footer:didTapSeeMoreButton:)]) {
        [self.delegate footer:self didTapSeeMoreButton:self.btnShowMore];
    }
}
@end
