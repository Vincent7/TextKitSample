//
//  TKSArticleListTableViewCell.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/9.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleListTableViewCell.h"
#import "TKSTextParagraphAttributeManager.h"
@interface TKSArticleListTableViewCell()
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *brief;

@property (nonatomic, strong) UIImageView *upperBoundaryImageView;
@property (nonatomic, strong) UIImageView *lowerBoundaryImageView;

@end

@implementation TKSArticleListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.lblArticleTitle];
        [self.contentView addSubview:self.lblArticleBriefText];
        [self.contentView addSubview:self.upperBoundaryImageView];
        [self.contentView addSubview:self.lowerBoundaryImageView];
        
        [self.upperBoundaryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        [self.lowerBoundaryImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        [self setNeedsUpdateConstraints];
    }
    return self;
}
- (void)prepareForReuse{
    [super prepareForReuse];
    [self setNeedsUpdateConstraints];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateConstraints{
    
    if (![self.subtitle isEqualToString:@""]) {
        [self.lblArticleTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(11);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.equalTo(self.lblArticleBriefText.mas_top).offset(-10);
        }];
        [self.lblArticleBriefText mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lblArticleTitle.mas_bottom).offset(10);
            make.left.equalTo(self.lblArticleTitle.mas_left);
            make.right.equalTo(self.lblArticleTitle.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-19);

        }];
    }else{
        [self.lblArticleBriefText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblArticleTitle.mas_bottom).offset(10);
            make.left.equalTo(self.lblArticleTitle.mas_left);
            make.right.equalTo(self.lblArticleTitle.mas_right);
            make.height.equalTo(@0);
        }];
        [self.lblArticleTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(11);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-19);
        }];
        
    }
    [super updateConstraints];
}

#pragma mark - setter and getter
-(UILabel *)lblArticleTitle{
    if (!_lblArticleTitle) {
        _lblArticleTitle = [UILabel new];
        [_lblArticleTitle setLineBreakMode:NSLineBreakByWordWrapping];
        [_lblArticleTitle setNumberOfLines:0];
    }
    return _lblArticleTitle;
}

-(UILabel *)lblArticleBriefText{
    if (!_lblArticleBriefText) {
        _lblArticleBriefText = [UILabel new];
        [_lblArticleBriefText setLineBreakMode:NSLineBreakByClipping];
        [_lblArticleBriefText setNumberOfLines:0];
    }
    return _lblArticleBriefText;
}
-(UIImageView *)upperBoundaryImageView{
    if (!_upperBoundaryImageView) {
        _upperBoundaryImageView = [[UIImageView alloc]initWithImage:[TKSArticleListTableViewCell upperBoundaryShadowImage]];
    }
    return _upperBoundaryImageView;
}
-(UIImageView *)lowerBoundaryImageView{
    if (!_lowerBoundaryImageView) {
        _lowerBoundaryImageView = [[UIImageView alloc]initWithImage:[TKSArticleListTableViewCell lowerBoundaryShadowImage]];
    }
    return _lowerBoundaryImageView;
}
-(void)setArticleTitleText:(NSString *)title{
    self.title = title;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:title attributes:[TKSTextParagraphAttributeManager articleListTitleTextAttributeInfo]];
    [self.lblArticleTitle setAttributedText:attrString];
}

-(void)setArticleSubtitleText:(NSString *)subtitle{
    self.subtitle = subtitle;
//    [self.lblArticleBriefText setHidden:[subtitle isEqualToString:@""]];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:subtitle attributes:[TKSTextParagraphAttributeManager articleListSubtitleTextAttributeInfo]];
    [self.lblArticleBriefText setAttributedText:attrString];
}

-(void)setArticleBriefText:(NSString *)brief{
    
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





















