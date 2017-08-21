//
//  TKSArticleResponseQuoteTextSectionView.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/24.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseQuoteTextSectionView.h"
#import "TKSTextParagraphAttributeManager.h"
#import "UIImage+TKSTableViewBoundaryShadow.h"
@interface TKSArticleResponseQuoteTextSectionView ()

@property (nonatomic, strong) UIView *containerBackgroundView;
@property (nonatomic, strong) UIImageView *imgRightArrow;

@property (nonatomic, strong) UILabel *lblQuoteText;
@property (nonatomic, strong) UIButton *btnReadInArticle __attribute__((deprecated));
@property (nonatomic, strong) UIButton *btnAddNote __attribute__((deprecated));
@property (nonatomic, strong) UIImageView *upperShadowImageView;

@property (nonatomic, strong) NSAttributedString *quoteAttributedString;
@property (nonatomic, strong) NSAttributedString *readInArticleAttributedString;
@property (nonatomic, strong) NSAttributedString *addNoteAttributedString;
@end

@implementation TKSArticleResponseQuoteTextSectionView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.containerBackgroundView];
        [self.containerBackgroundView addSubview:self.lblQuoteText];
        [self.containerBackgroundView addSubview:self.imgRightArrow];
        [self.contentView addSubview:self.upperShadowImageView];
        
        [self.contentView setBackgroundColor:rgb(247, 247, 247)];
        [self addConstraints];
    }
    return self;
}

-(void)addConstraints{
    [self.containerBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(2, 0, 0, 0));
    }];
    [self.upperShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    [self.lblQuoteText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.mas_equalTo(20);
        make.right.equalTo(self.imgRightArrow.mas_left).offset(-2);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(2);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14);
    }];
    [self.imgRightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lblQuoteText.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
//    [self.btnReadInArticle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lblQuoteText.mas_bottom).offset(10);
//        make.left.equalTo(self.lblQuoteText.mas_left);
//        make.width.mas_equalTo(150);
//        make.height.mas_equalTo(20);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//    }];
//    [self.btnAddNote mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.btnReadInArticle.mas_top);
//        make.right.equalTo(self.lblQuoteText.mas_right);
//        make.width.mas_equalTo(150);
//        make.height.mas_equalTo(20);
//        make.bottom.equalTo(self.btnReadInArticle.mas_bottom);
//    }];
}
-(UIView *)containerBackgroundView{
    if (!_containerBackgroundView) {
        _containerBackgroundView = [UIView new];
        [_containerBackgroundView setBackgroundColor:[UIColor whiteColor]];
    }
    return _containerBackgroundView;
}
-(UIImageView *)imgRightArrow{
    if (!_imgRightArrow) {
        _imgRightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"disclosure_indicator"]];
        _imgRightArrow.contentMode = UIViewContentModeRight;
    }
    return _imgRightArrow;
}
-(UILabel *)lblQuoteText{
    if (!_lblQuoteText) {
        _lblQuoteText = [UILabel new];
        _lblQuoteText.numberOfLines = 2;
        _lblQuoteText.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _lblQuoteText;
}

-(UIButton *)btnReadInArticle {
    if (!_btnReadInArticle) {
        _btnReadInArticle = [UIButton new];
        [_btnReadInArticle setAttributedTitle:self.readInArticleAttributedString forState:UIControlStateNormal];
        [_btnReadInArticle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    }
    return _btnReadInArticle;
}

-(UIButton *)btnAddNote{
    if (!_btnAddNote) {
        _btnAddNote = [UIButton new];
        [_btnAddNote setAttributedTitle:self.addNoteAttributedString forState:UIControlStateNormal];
        [_btnAddNote setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _btnAddNote;
}

-(void)setQuoteText:(NSString *)quoteText{
    if (![_quoteText isEqualToString:quoteText]) {
        _quoteText = quoteText;
        NSString *stringWithQuotationMark = [NSString stringWithFormat:@"\"%@\"",_quoteText];
        self.quoteAttributedString = [[NSAttributedString alloc]initWithString:stringWithQuotationMark attributes:[TKSTextParagraphAttributeManager articleQuoteTextAttributeInfo]];
    }
}

-(void)setQuoteAttributedString:(NSAttributedString *)quoteAttributedString{
    if (![_quoteAttributedString.string isEqualToString:quoteAttributedString.string]) {
        _quoteAttributedString = quoteAttributedString;
        [self.lblQuoteText setAttributedText:_quoteAttributedString];
    }
}

-(NSAttributedString *)readInArticleAttributedString{
    if (!_readInArticleAttributedString) {
        _readInArticleAttributedString = [[NSAttributedString alloc]initWithString:@"Read in article" attributes:[TKSTextParagraphAttributeManager articleQuoteReadInArticleAttributeInfo]];
    }
    return _readInArticleAttributedString;
}
-(NSAttributedString *)addNoteAttributedString{
    if (!_addNoteAttributedString) {
        _addNoteAttributedString = [[NSAttributedString alloc]initWithString:@"Add note" attributes:[TKSTextParagraphAttributeManager articleQuoteAddNoteAttributeInfo]];
    }
    return _addNoteAttributedString;
}
-(UIImageView *)upperShadowImageView{
    if (!_upperShadowImageView) {
        _upperShadowImageView = [[UIImageView alloc]initWithImage:[UIImage upperBoundaryShadowImage]];
    }
    return _upperShadowImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
