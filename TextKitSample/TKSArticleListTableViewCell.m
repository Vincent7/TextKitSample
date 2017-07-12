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

@property (nonatomic, strong) NSDictionary *previewImageUrlsInfo;
@property (nonatomic, assign) CGSize previewImageDataSize;

@property (nonatomic, strong) UIImageView *upperBoundaryImageView;
@property (nonatomic, strong) UIImageView *lowerBoundaryImageView;
@property (nonatomic, strong) UIView *backgroundContainer;
@property (nonatomic, strong) UIView *whiteBackgroundContainer;
@end

@implementation TKSArticleListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];//rgb(247, 247, 247);
        [self.contentView addSubview:self.backgroundContainer];
        
        [self.backgroundContainer addSubview:self.lblArticleTitle];
        [self.backgroundContainer addSubview:self.lblArticleBriefText];
        [self.backgroundContainer addSubview:self.previewImageView];
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
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateConstraints{
    CGFloat previewImageHeight = (SCREEN_WIDTH - 40) * self.previewImageDataSize.height / self.previewImageDataSize.width;
    if (![self.subtitle isEqualToString:@""]) {
        [self.lblArticleTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.equalTo(self.lblArticleBriefText.mas_top).offset(-10);
        }];
        [self.lblArticleBriefText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lblArticleTitle.mas_left);
            make.right.equalTo(self.lblArticleTitle.mas_right);
            make.bottom.equalTo(self.previewImageView.mas_top).offset(-10);

        }];
        if (self.previewImageUrlsInfo.allKeys.count > 0) {
            
            [self.previewImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(previewImageHeight));
                make.left.equalTo(self.lblArticleTitle.mas_left);
                make.right.equalTo(self.lblArticleTitle.mas_right);
                make.bottom.equalTo(self.backgroundContainer.mas_bottom).offset(-10);
            }];
        }else{
            [self.previewImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.backgroundContainer.mas_bottom);
                make.left.equalTo(self.lblArticleBriefText.mas_left);
                make.right.equalTo(self.lblArticleBriefText.mas_right);
                make.height.equalTo(@0);
            }];
        }
    }else{
        [self.lblArticleBriefText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblArticleTitle.mas_bottom).offset(10);
            make.left.equalTo(self.lblArticleTitle.mas_left);
            make.right.equalTo(self.lblArticleTitle.mas_right);
            make.height.equalTo(@0);
        }];
        [self.lblArticleTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.equalTo(self.backgroundContainer.mas_bottom);
        }];
        if (self.previewImageUrlsInfo.allKeys.count > 0) {
            [self.previewImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(previewImageHeight));
                make.left.equalTo(self.lblArticleTitle.mas_left);
                make.right.equalTo(self.lblArticleTitle.mas_right);
                make.bottom.equalTo(self.lblArticleTitle.mas_bottom).offset(-10);
            }];
        }else{
            [self.previewImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lblArticleBriefText.mas_bottom).offset(10);
                make.left.equalTo(self.lblArticleBriefText.mas_left);
                make.right.equalTo(self.lblArticleBriefText.mas_right);
                make.height.equalTo(@0);
            }];
        }
    }
    [super updateConstraints];
}

#pragma mark - setter and getter
-(UIView *)backgroundContainer{
    if (!_backgroundContainer) {
        _backgroundContainer = [UIView new];
        _backgroundContainer.backgroundColor = [UIColor whiteColor];
    }
    return _backgroundContainer;
}
-(UILabel *)lblArticleTitle{
    if (!_lblArticleTitle) {
        _lblArticleTitle = [UILabel new];
        [_lblArticleTitle setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblArticleTitle setNumberOfLines:3];
    }
    return _lblArticleTitle;
}

-(UILabel *)lblArticleBriefText{
    if (!_lblArticleBriefText) {
        _lblArticleBriefText = [UILabel new];
        [_lblArticleBriefText setLineBreakMode:NSLineBreakByTruncatingTail];
        [_lblArticleBriefText setNumberOfLines:4];
    }
    return _lblArticleBriefText;
}
-(DTLazyImageView *)previewImageView{
    if (!_previewImageView) {
        _previewImageView = [DTLazyImageView new];
        _previewImageView.backgroundColor = [UIColor clearColor];
//        DTLazyImageView *imageContentView = [DTLazyImageView new];
//        
//        imageContentView = [[DTLazyImageView alloc] initWithFrame:frame];//CGRectMake(10, frame.origin.y, self.sampleTextView.frame.size.width - 20, 100)];
//        imageContentView.contentView = attributedTextContentView;
//        imageContentView.delegate = self;
//        
//        // url for deferred loading
//        imageContentView.image = [(DTImageTextAttachment *)attachment image];
//        imageContentView.imageUrlsInfo = attachment.contentURLsInfo;
//        
//        imageContentView.backgroundColor = [UIColor clearColor];
//        return imageContentView;
    }
    return _previewImageView;
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
-(void)setImageUrls:(NSArray *)imageUrls andImageDataSize:(CGSize)imageDataSize{
//    self.previewImageUrls = imageUrls;
    NSMutableDictionary *imageUrlsInfo = [NSMutableDictionary dictionary];
    for (NSString *urlString in imageUrls) {
        NSString *imageSizeDescription = [self getImageSizeDescriptionFromImageUrlString:urlString];
        if (imageSizeDescription) {
            [imageUrlsInfo setObject:[NSURL URLWithString:urlString] forKey:imageSizeDescription];
        }
        
    }
    self.previewImageUrlsInfo = [NSDictionary dictionaryWithDictionary:imageUrlsInfo];
    self.previewImageDataSize = imageDataSize;
    self.previewImageView.imageUrlsInfo = self.previewImageUrlsInfo;
    [self.previewImageView restartLoadImage];
//    self.previewImageView.imageUrlsInfo
}

-(NSString *)getImageSizeDescriptionFromImageUrlString:(NSString *)imageUrlString{
    NSString *imageIdentifer;
    NSString *imageSizeDescription;
    NSString *src = imageUrlString;
    NSRegularExpression *imageIdentiferRegex = [NSRegularExpression
                                                regularExpressionWithPattern:@"((?!/)[^\\s?!/]+?)[.](jpg|png|gif|jpeg|tiff)"
                                                options:0
                                                error:nil];
    NSUInteger numberOfImageIdentiferMatches = [imageIdentiferRegex numberOfMatchesInString:src
                                                                                    options:0
                                                                                      range:NSMakeRange(0, [src length])];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if (numberOfImageIdentiferMatches > 0) {
        NSArray *arrMatch = [imageIdentiferRegex matchesInString:src options:0 range:NSMakeRange(0, src.length)];
        NSTextCheckingResult *imgContentUrl = arrMatch.firstObject;
        imageIdentifer = [src substringWithRange:imgContentUrl.range];
        
    }
    
    if ([imageIdentifer length]) {
        NSString *imageSizePattern = [NSString stringWithFormat:@"(?<=max/)\\d+"];
        NSRegularExpression *imageSizeRegex = [NSRegularExpression
                                               regularExpressionWithPattern:imageSizePattern
                                               options:0
                                               error:nil];
        NSTextCheckingResult *imageSizeMatch = [imageSizeRegex firstMatchInString:src
                                                                          options:0
                                                                            range:NSMakeRange(0, [src length])];
        if (imageSizeMatch) {
            imageSizeDescription = [src substringWithRange:imageSizeMatch.range];
            return imageSizeDescription;
        }
    }
    return nil;
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





















