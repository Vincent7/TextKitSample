//
//  TKSArticleDetailTitlePreviewView.m
//  TextKitSample
//
//  Created by Vincent on 2017/8/18.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleDetailTitlePreviewView.h"
#import "TKSTextParagraphAttributeManager.h"
@interface TKSArticleDetailTitlePreviewView()
@property (nonatomic, assign) BOOL didSetupConstraints;
@property (nonatomic, strong) UIView *loadingView;//TODO:自定义loading动画
@property (nonatomic, strong) UILabel *lblHintView;
@property (nonatomic, strong) UILabel *lblTitleView;

@property (nonatomic, strong) NSAttributedString *hintString;
@property (nonatomic, strong) NSAttributedString *titleString;
@end
@implementation TKSArticleDetailTitlePreviewView{
    BOOL _didSetupConstraints;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _didSetupConstraints = NO;
        
        self.backgroundColor = [UIColor navigationBarBackgroundColor];
        [self addSubview:self.loadingView];
        [self addSubview:self.lblHintView];
        [self addSubview:self.lblTitleView];
        self.expendAnimProgress = 0;
    }
    return self;
}

-(void)updateConstraints{
    if (!_didSetupConstraints) {
        [self.lblHintView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.top.mas_equalTo(20);
        }];
        [self.lblTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY).offset(10);
            make.width.lessThanOrEqualTo(self).offset(-40);
            make.top.mas_equalTo(20);
        }];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
            make.centerY.equalTo(self.lblTitleView.mas_centerY);
            make.right.equalTo(self.lblHintView.mas_left).offset(-14);
        }];
        _didSetupConstraints = YES;
    }
    [super updateConstraints];
}

#pragma mark - getter and setter
-(void)setExpendAnimProgress:(CGFloat)expendAnimProgress{
    _expendAnimProgress = expendAnimProgress;
    CGFloat hintAlpha = (expendAnimProgress > .8)?0:((.8-expendAnimProgress)/.8);
    [self.lblHintView setAlpha:hintAlpha];
    [self.loadingView setAlpha:hintAlpha];
    CGFloat titleAlpha = (expendAnimProgress > .6)?((expendAnimProgress-.6)/.4):0;
    [self.lblTitleView setAlpha:titleAlpha];
}

-(NSAttributedString *)hintString{
    if (!_hintString) {
        _hintString = [[NSAttributedString alloc]initWithString:@"View article" attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseHintTitleStringAttributeInfo]];
    }
    return _hintString;
}
-(NSAttributedString *)titleString{
    if (!_titleString || ![_titleString.string isEqualToString:self.articleTitle]) {
        _titleString = [[NSAttributedString alloc]initWithString:self.articleTitle attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseNavigationBarTitleAttributeInfo]];
    }
    return _titleString;
}
-(void)setArticleTitle:(NSString *)articleTitle{
    if (![_articleTitle isEqualToString:articleTitle]) {
        _articleTitle = articleTitle;
        [self.lblTitleView setAttributedText:self.titleString];
    }
}
-(UILabel *)lblTitleView{
    if (!_lblTitleView) {
        _lblTitleView = [[UILabel alloc]init];
//        [_lblTitleView setAttributedText:self.titleString];
    }
    return _lblTitleView;
}
-(UILabel *)lblHintView{
    if (!_lblHintView) {
        _lblHintView = [[UILabel alloc]init];
        [_lblHintView setAttributedText:self.hintString];
    }
    return _lblHintView;
}
-(UIView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[UIView alloc]init];
    }
    return _loadingView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
