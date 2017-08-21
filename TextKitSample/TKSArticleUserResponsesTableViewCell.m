//
//  TKSArticleUserResponsesTableViewCell.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/30.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleUserResponsesTableViewCell.h"
#import "TKSTextParagraphAttributeManager.h"
@interface TKSArticleUserResponsesTableViewCell()

@property (nonatomic, strong) NSAttributedString *userName;
@property (nonatomic, strong) NSAttributedString *response;
@property (nonatomic, strong) NSAttributedString *readingTime;
@property (nonatomic, strong) NSAttributedString *favNumberSelectedAttributedString;
@property (nonatomic, strong) NSAttributedString *favNumberDiselectedAttributedString;
@property (nonatomic, strong) UIButton *btnFav;

@property (nonatomic, strong) UIView *upperBoundarySeparateLine;

@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, assign) NSInteger favNumber;

@end
@implementation TKSArticleUserResponsesTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.lblResponseText];
        [self.contentView addSubview:self.lblUserName];
        [self.contentView addSubview:self.lblReadingTime];
        [self.contentView addSubview:self.btnFav];
        [self.contentView addSubview:self.upperBoundarySeparateLine];
        
        [self setupConstraints];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupConstraints{
    [self.upperBoundarySeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(.5);
    }];
    [self.lblReadingTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(18);
    }];
    [self.lblResponseText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblReadingTime.mas_bottom).offset(5);
        make.left.equalTo(self.lblReadingTime.mas_left);
        make.right.equalTo(self.lblReadingTime.mas_right);
    }];
    [self.lblUserName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lblResponseText.mas_bottom).offset(12);
        make.width.equalTo(@150);
        make.right.equalTo(self.lblReadingTime.mas_right);
        make.height.mas_equalTo(18);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-16);
    }];
    
    [self.btnFav mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lblResponseText.mas_bottom).offset(5);
        make.centerY.equalTo(self.lblUserName.mas_centerY);
        make.left.equalTo(self.lblReadingTime.mas_left);
        make.width.equalTo(@52);
        make.height.mas_equalTo(24);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - method for cell reuse
-(void)setResponseFav:(BOOL)isFav{
    self.isFav = isFav;
}
- (void)setResponseFavNumber:(NSInteger)favNumber{
    self.favNumber = favNumber;
    
    NSInteger selectedFavNumber = (self.isFav)?favNumber:favNumber+1;
    NSInteger diselectedFavNumber = (self.isFav)?favNumber-1:favNumber;
    
    NSString *selectedFavNumberString = [NSString stringWithFormat:@"%ld",selectedFavNumber];
    NSString *diselectedFavNumberString = [NSString stringWithFormat:@"%ld",diselectedFavNumber];
    
    NSMutableAttributedString *selectedAttrString = [[NSMutableAttributedString alloc]initWithString:selectedFavNumberString attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseFavButtonSelectedAttributeInfo]];
    self.favNumberSelectedAttributedString = selectedAttrString;
    
    NSMutableAttributedString *diselectedAttrString = [[NSMutableAttributedString alloc]initWithString:diselectedFavNumberString attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseFavButtonDiselectedAttributeInfo]];
    self.favNumberDiselectedAttributedString = diselectedAttrString;
}
-(void)setResponseUserName:(NSString *)userName{
    NSString *stringWithDashMark = [NSString stringWithFormat:@"- %@",userName];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:stringWithDashMark attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseUserNameAttributeInfo]];
    self.userName = attrString;
}
-(void)setResponseText:(NSString *)response{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:response attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseTextAttributeInfo]];
    self.response = attrString;
}
-(void)setResponseReadingTime:(NSString *)readingTime{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:readingTime attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseReadingTimeAttributeInfo]];
    self.readingTime = attrString;
}
#pragma mark - getter and setter
-(void)setIsFav:(BOOL)isFav{
    _isFav = isFav;
    [self.btnFav setSelected:isFav];
}

-(void)setUserName:(NSAttributedString *)userName{
    if (![_userName.string isEqualToString:userName.string]) {
        _userName = userName;
        [self.lblUserName setAttributedText:_userName];
    }
}
-(void)setResponse:(NSAttributedString *)response{
    if (![_response.string isEqualToString:response.string]) {
        _response = response;
        [self.lblResponseText setAttributedText:_response];
    }
}
-(void)setReadingTime:(NSAttributedString *)readingTime{
    if (![_readingTime.string isEqualToString:readingTime.string]) {
        _readingTime = readingTime;
        [self.lblReadingTime setAttributedText:_readingTime];
    }
}
-(void)setFavNumberSelectedAttributedString:(NSAttributedString *)favNumberSelectedAttributedString{
    if (![_favNumberSelectedAttributedString.string isEqualToString:favNumberSelectedAttributedString.string]) {
        _favNumberSelectedAttributedString = favNumberSelectedAttributedString;
        [self.btnFav setAttributedTitle:_favNumberSelectedAttributedString forState:UIControlStateSelected];
    }
}
-(void)setFavNumberDiselectedAttributedString:(NSAttributedString *)favNumberDiselectedAttributedString{
    if (![_favNumberDiselectedAttributedString.string isEqualToString:favNumberDiselectedAttributedString.string]) {
        _favNumberDiselectedAttributedString = favNumberDiselectedAttributedString;
        [self.btnFav setAttributedTitle:_favNumberDiselectedAttributedString forState:UIControlStateNormal];
    }
}
-(UIView *)upperBoundarySeparateLine{
    if (!_upperBoundarySeparateLine) {
        _upperBoundarySeparateLine = [UIView new];
        [_upperBoundarySeparateLine setBackgroundColor:[UIColor blackColor]];
        [_upperBoundarySeparateLine setAlpha:.3];
    }
    return _upperBoundarySeparateLine;
}
-(UILabel *)lblReadingTime{
    if (!_lblReadingTime) {
        _lblReadingTime = [UILabel new];
        [_lblReadingTime setNumberOfLines:1];
        [_lblReadingTime setAlpha:.3];
    }
    return _lblReadingTime;
}
-(UILabel *)lblResponseText{
    if (!_lblResponseText) {
        _lblResponseText = [UILabel new];
        [_lblResponseText setNumberOfLines:8];
    }
    return _lblResponseText;
}
-(UILabel *)lblUserName{
    if (!_lblUserName) {
        _lblUserName = [UILabel new];
        [_lblUserName setNumberOfLines:1];
        [_lblUserName setAlpha:.3];
    }
    return _lblUserName;
}
-(UIButton *)btnFav{
    if (!_btnFav) {
        _btnFav = [UIButton new];
        [_btnFav setImage:[UIImage imageNamed:@"unfavorite"] forState:UIControlStateNormal];
        [_btnFav setImage:[UIImage imageNamed:@"favorite"] forState:UIControlStateSelected];
        [_btnFav setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
        [_btnFav setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -5)];
    }
    return _btnFav;
}
@end
