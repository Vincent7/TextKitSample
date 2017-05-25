//
//  TKSArticleDetailViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/12.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleDetailViewController.h"
#import "TKSTextStorage.h"
#import "DTCoreText.h"

@interface TKSArticleDetailViewController () <NSLayoutManagerDelegate,DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
@property (nonatomic, strong) NSTextContainer *container;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic, strong) TKSTextStorage *textStorage;

@property (nonatomic, strong) DTAttributedTextView *sampleTextView;
@property (nonatomic, strong) NSMutableAttributedString *htmlAttributeString;

@property (nonatomic, strong) NSMutableDictionary *picIdentiferInfo;
@end

@implementation TKSArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sampleTextView];
    [self.sampleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    // Do any additional setup after loading the view.
}

- (void)setHtmlContentString:(NSString *)htmlContentString{
    _htmlContentString = htmlContentString;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setUpTextViewWithArticleHtmlContent:self.htmlContentString];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.sampleTextView relayoutText];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(DTAttributedTextView *)sampleTextView{
    if (!_sampleTextView) {
        _sampleTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _sampleTextView.shouldDrawLinks = YES;
        _sampleTextView.shouldDrawImages = YES;
        _sampleTextView.textDelegate = self;
    }
    return _sampleTextView;
}
- (void)setUpTextViewWithArticleHtmlContent:(NSString *)htmlContent{
//    NSString *htmlSampleString =
    NSString *path = [[NSBundle mainBundle] pathForResource:@"htmlSampleText" ofType:@"html"];
    NSString *sampleHtmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSString *dataEncodingWithLt = [sampleHtmlContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    NSString *dataEncodingWithGt = [dataEncodingWithLt stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSData *data = [dataEncodingWithGt dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *builderOptions = @{
                                     DTDefaultFontFamily: @"Helvetica"
                                     };
    DTHTMLAttributedStringBuilder *attrString = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:builderOptions  documentAttributes:nil];

//    NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                            initWithData: [htmlContent dataUsingEncoding:NSUTF8StringEncoding]
//                                            options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                            documentAttributes: nil
//                                            error: nil
//                                            ];
    NSAttributedString *attributedString = [attrString generatedAttributedString];
    [self.sampleTextView setAttributedString:attributedString];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSAttributedString *attributedString = [[NSAttributedString alloc]
//                                                initWithData: [htmlContent dataUsingEncoding:NSUTF8StringEncoding]
//                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//                                                documentAttributes: nil
//                                                error: nil
//                                                ];
//        [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
//            if ([attrs objectForKey:@"NSParagraphStyle"]) {
//                NSFont *paragraphFont = [attrs objectForKey:@"NSFont"];
//                NSMutableParagraphStyle *paragraphStyle = [attrs objectForKey:@"NSParagraphStyle"];
//                NSString *description = paragraphStyle.description;
//                if (range.location+range.length >= attributedString.length) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.sampleTextView setAttributedText:attributedString];
//                    });
//                    
//                }
//                NSLog(@"\n%@\n%@",description,paragraphFont);
//                
//            }
//        }];
//    });

    
//    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:mediumText];
    
    
}
- (void)setUpTextViewWithArticleInfo:(NSDictionary *)info{

    NSString *mediumText = @"";
    NSArray *articleParagraphs = info[@"results"][@"articleParagraph"];
    NSMutableArray *titleRanges = [NSMutableArray array];
    NSMutableArray *textRanges = [NSMutableArray array];
    for (int i = 0; i < articleParagraphs.count; i++) {
        NSString *paragraphMark = [[articleParagraphs objectAtIndex:i] objectForKey:@"paragraphMark"];
        NSString *paragraphText = [[articleParagraphs objectAtIndex:i] objectForKey:@"paragraphText"];
        if (![paragraphMark isEqualToString:@"p"]) {
            NSRange titleRange = NSMakeRange(mediumText.length, paragraphText.length+1);
            [titleRanges addObject:[NSValue valueWithRange:titleRange]];
        }else{
            NSRange textRange = NSMakeRange(mediumText.length, paragraphText.length+1);
            [textRanges addObject:[NSValue valueWithRange:textRange]];
        }
        mediumText = [mediumText stringByAppendingString:[NSString stringWithFormat:@"%@\n",paragraphText]];
    }
    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:mediumText];
    for (NSValue *rangeObject in titleRanges) {
        NSRange range = [rangeObject rangeValue];
        [_textStorage setAttributes:[self titleStyleDict] range:range];

    }
    for (NSValue *rangeObject in textRanges) {
        NSRange range = [rangeObject rangeValue];
        [_textStorage setAttributes:[self textStyleDict] range:range];
    }
}

-(NSMutableAttributedString *)htmlAttributeString{
    if (!_htmlAttributeString) {
        _htmlAttributeString = [NSMutableAttributedString new];
    }
    return _htmlAttributeString;
}

- (NSDictionary *)titleStyleDict {


    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    UIColor *textColor = [UIColor blackColor];
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:[UIColor redColor] forKey:NSBackgroundColorAttributeName];
    UIFont *textFont = [UIFont boldSystemFontOfSize:30.f];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    [attributes setValue:@-30 forKey:NSBaselineOffsetAttributeName];
    //创建段落样式
    [attributes setValue:[self style] forKey:NSParagraphStyleAttributeName];

    return attributes;
}

- (NSDictionary *)textStyleDict {

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    UIColor *textColor = [UIColor blackColor];
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    [attributes setValue:[UIColor greenColor] forKey:NSBackgroundColorAttributeName];
    UIFont *textFont = [UIFont systemFontOfSize:16.f];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    [attributes setValue:@-15 forKey:NSBaselineOffsetAttributeName];

    [attributes setValue:[self style] forKey:NSParagraphStyleAttributeName];

    return attributes;
}
-(NSMutableDictionary *)picIdentiferInfo{
    if (!_picIdentiferInfo) {
        _picIdentiferInfo = [NSMutableDictionary dictionary];
    }
    return _picIdentiferInfo;
}
- (NSMutableParagraphStyle *)style {

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];

    style.lineSpacing = 8.5f;
    style.paragraphSpacing = 25.f;
    style.firstLineHeadIndent = 0.f;

    return style;
}

- (NSTextContainer *)container{
    if (!_container) {
        _container = [NSTextContainer new];

        _layoutManager = [NSLayoutManager new];
        _layoutManager.delegate = self;
        [_layoutManager addTextContainer:_container];

        _textStorage = [TKSTextStorage new];
        [_textStorage addLayoutManager:_layoutManager];
    }
    return _container;
}

-(void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag{
    //This is only for first Glyph
    CGRect lineFragmentRect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:0 effectiveRange:nil];
    NSLog(@"Line Height:%f",lineFragmentRect.size.height);
    // The height of this rect is the line height.
}

#pragma mark - DTLazyImageViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
                    viewForAttachment:(DTTextAttachment *)attachment
                                frame:(CGRect)frame{
//    NSRegularExpression *regex = [NSRegularExpression
//                                  regularExpressionWithPattern:@"((?!/)[^\\s?!/]+?)[.](gif|jpeg|png)"
//                                  options:0
//                                  error:nil];
//    NSUInteger numberOfMatches = [regex numberOfMatchesInString:attachment.contentURL.absoluteString
//                                                        options:0
//                                                          range:NSMakeRange(0, [attachment.contentURL.absoluteString length])];
//    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    if (numberOfMatches > 0) {
//        NSArray *arrMatch = [regex matchesInString:attachment.contentURL.absoluteString options:0 range:NSMakeRange(0, attachment.contentURL.absoluteString.length)];
//        NSTextCheckingResult *imgContentUrl = arrMatch.firstObject;
//        NSString *imageIdentifer = [attachment.contentURL.absoluteString substringWithRange:imgContentUrl.range];
//        if ([self.picIdentiferInfo.allKeys containsObject:imageIdentifer]) {
//            imageContentView = (DTLazyImageView*)[self.picIdentiferInfo objectForKey:imageIdentifer];
//        }else{
//            imageContentView = [[DTLazyImageView alloc] initWithFrame:CGRectMake(10, frame.origin.y, self.sampleTextView.frame.size.width - 20, 100)];
//            imageContentView.contentView = attributedTextContentView;
//            imageContentView.delegate = self;
//            
//            // url for deferred loading
//            imageContentView.url = attachment.contentURL;
//            [self.picIdentiferInfo setObject:imageContentView forKey:imageIdentifer];
//        }
//    }
    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
        DTLazyImageView *imageContentView = [DTLazyImageView new];
        
        imageContentView = [[DTLazyImageView alloc] initWithFrame:frame];//CGRectMake(10, frame.origin.y, self.sampleTextView.frame.size.width - 20, 100)];
        imageContentView.contentView = attributedTextContentView;
        imageContentView.delegate = self;
        
        // url for deferred loading
        imageContentView.image = [(DTImageTextAttachment *)attachment image];
        imageContentView.url = attachment.contentURL;
        imageContentView.backgroundColor = [UIColor blueColor];
        return imageContentView;
        
    }
    return nil;
}
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size {
    NSURL *url = lazyImageView.url;
    CGSize imageSize = size;//CGSizeMake(self.sampleTextView.frame.size.width - 20, 100);
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    
    BOOL didUpdate = NO;
    
    // update all attachments that match this URL (possibly multiple images with same size)
    for (DTTextAttachment *oneAttachment in [_sampleTextView.attributedTextContentView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        // update attachments that have no original size, that also sets the display size
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            
            didUpdate = YES;
        }
    }
    
    if (didUpdate)
    {
        // layout might have changed due to image sizes
        // do it on next run loop because a layout pass might be going on
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_sampleTextView relayoutText];
        });
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
