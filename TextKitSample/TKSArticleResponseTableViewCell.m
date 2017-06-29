//
//  TKSArticleResponseTableViewCell.m
//  TextKitSample
//
//  Created by Vincent on 2017/6/16.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseTableViewCell.h"
#import "TKSTextParagraphAttributeManager.h"
@interface TKSArticleResponseTableViewCell()
@property (nonatomic, strong) NSString *quote;
@property (nonatomic, strong) NSString *response;
@property (nonatomic, strong) NSString *paraIdentifer;

@property (nonatomic, strong) UIImageView *upperBoundaryImageView;
@property (nonatomic, strong) UIImageView *lowerBoundaryImageView;

@property (nonatomic, strong) UIButton *btnQuoteContainer;
@property (nonatomic, strong) UILabel *lblQuotePosition;
@property (nonatomic, strong) UIView *backgroundContainer;

@end
@implementation TKSArticleResponseTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = rgb(247, 247, 247);
        [self.contentView addSubview:self.backgroundContainer];
        
        [self.backgroundContainer addSubview:self.btnQuoteContainer];
        [self.backgroundContainer addSubview:self.lblResponseText];
        
        [self.btnQuoteContainer addSubview:self.lblQuoteText];
        [self.btnQuoteContainer addSubview:self.lblQuotePosition];
        
        [self.contentView addSubview:self.upperBoundaryImageView];
        [self.contentView addSubview:self.lowerBoundaryImageView];
        
        [self.backgroundContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
        }];
        [self.upperBoundaryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundContainer.mas_top).offset(-4);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(4);
        }];
        [self.lowerBoundaryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundContainer.mas_bottom);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(4);
        }];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    [self setNeedsUpdateConstraints];
    
}
-(void)updateConstraints{
    [self.btnQuoteContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.bottom.equalTo(self.lblResponseText.mas_top).offset(-12);
    }];
    [self.lblQuoteText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.bottom.equalTo(self.lblQuotePosition.mas_top).offset(-16);
    }];
    [self.lblQuotePosition mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(22);
        make.left.equalTo(self.lblQuoteText.mas_left);
        make.right.equalTo(self.lblQuoteText.mas_right);
        make.bottom.mas_equalTo(-16);
    }];
    [self.lblResponseText mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.lblArticleTitle.mas_bottom).offset(10);
        make.left.equalTo(self.btnQuoteContainer.mas_left);
        make.right.equalTo(self.btnQuoteContainer.mas_right);
        make.bottom.equalTo(self.backgroundContainer.mas_bottom).offset(-16);
        
    }];
    [super updateConstraints];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark - reuse method
-(void)setQuoteText:(NSString *)quote{
    self.quote = quote;
    //    [self.lblArticleBriefText setHidden:[subtitle isEqualToString:@""]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:quote attributes:[TKSTextParagraphAttributeManager articleDiscussPointQuoteTextAttributeInfo]];
    [self.lblQuoteText setAttributedText:attrString];
}
-(void)setResponseText:(NSString *)response{
    self.response = response;
    //    [self.lblArticleBriefText setHidden:[subtitle isEqualToString:@""]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:response attributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseTextAttributeInfo]];
    [self.lblResponseText setAttributedText:attrString];
}
-(void)setParaIdentifer:(NSString *)paraIdentifer{
    self.paraIdentifer = paraIdentifer;
}
#pragma mark - getter and setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(UIView *)backgroundContainer{
    if (!_backgroundContainer) {
        _backgroundContainer = [UIView new];
        _backgroundContainer.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundContainer;
}
-(UIButton *)btnQuoteContainer{
    if (!_btnQuoteContainer) {
        _btnQuoteContainer = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnQuoteContainer.layer setBorderColor:[rgba(0, 0, 0, .32) CGColor]];
        [_btnQuoteContainer.layer setBorderWidth:.5f];
    }
    return _btnQuoteContainer;
}
-(UILabel *)lblQuoteText{
    if (!_lblQuoteText) {
        _lblQuoteText = [UILabel new];
        [_lblQuoteText setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblQuoteText setNumberOfLines:5];
    }
    return _lblQuoteText;
}
-(UILabel *)lblQuotePosition{
    if (!_lblQuotePosition) {
        _lblQuotePosition = [UILabel new];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:@"From Paragraph 23" attributes:[TKSTextParagraphAttributeManager articleDiscussPointQuotePositionLabelTextAttributeInfo]];
        [_lblQuotePosition setAttributedText:attrString];
//        [_lblQuotePosition setLineBreakMode:NSLineBreakByWordWrapping];
//        [_lblQuotePosition setNumberOfLines:0];
    }
    return _lblQuotePosition;
}

-(UILabel *)lblResponseText{
    if (!_lblResponseText) {
        _lblResponseText = [UILabel new];
        [_lblResponseText setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblResponseText setNumberOfLines:8];
    }
    return _lblResponseText;
}
-(UIImageView *)upperBoundaryImageView{
    if (!_upperBoundaryImageView) {
        _upperBoundaryImageView = [[UIImageView alloc]initWithImage:[TKSArticleResponseTableViewCell upperBoundaryShadowImage]];
    }
    return _upperBoundaryImageView;
}
-(UIImageView *)lowerBoundaryImageView{
    if (!_lowerBoundaryImageView) {
        _lowerBoundaryImageView = [[UIImageView alloc]initWithImage:[TKSArticleResponseTableViewCell lowerBoundaryShadowImage]];
    }
    return _lowerBoundaryImageView;
}
+ (UIImage *)upperBoundaryShadowImage {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize size = CGSizeMake(SCREEN_WIDTH, 2);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef fillPath = CGPathCreateWithRect(CGRectMake(0, 1, size.width, size.height-1), NULL);
        
        CGContextSaveGState(context); {
            CGContextEOClip(context);
            CGColorRef shadowColor = [UIColor colorWithWhite:0 alpha:.32].CGColor;
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1, shadowColor);
            CGContextBeginTransparencyLayer(context, NULL); {
                CGContextAddPath(context, fillPath);
                [[UIColor colorWithWhite:1 alpha:1.000] setFill];
                CGContextFillPath(context);
            } CGContextEndTransparencyLayer(context);
        } CGContextRestoreGState(context);
        CFRelease(fillPath);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}
+ (UIImage *)lowerBoundaryShadowImage {
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize size = CGSizeMake(SCREEN_WIDTH, 2);
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGPathRef fillPath = CGPathCreateWithRect(CGRectMake(0, 0, size.width, size.height-1), NULL);
        
        CGContextSaveGState(context); {
            CGContextEOClip(context);
            CGColorRef shadowColor = [UIColor colorWithWhite:0 alpha:0.32].CGColor;
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1, shadowColor);
            CGContextBeginTransparencyLayer(context, NULL); {
                CGContextAddPath(context, fillPath);
                [[UIColor colorWithWhite:1 alpha:1.000] setFill];
                CGContextFillPath(context);
            } CGContextEndTransparencyLayer(context);
        } CGContextRestoreGState(context);
        CFRelease(fillPath);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}
@end
