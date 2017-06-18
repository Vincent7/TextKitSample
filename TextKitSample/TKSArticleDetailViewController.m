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
#import "DTWebVideoView.h"
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface TKSArticleDetailViewController () <NSLayoutManagerDelegate,DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate>
//@property (nonatomic, strong) NSTextContainer *container;
//@property (nonatomic, strong) NSLayoutManager *layoutManager;
//@property (nonatomic, strong) TKSTextStorage *textStorage;

@property (nonatomic, strong) DTAttributedTextView *sampleTextView;
@property (nonatomic, strong) NSMutableAttributedString *htmlAttributeString;

@property (nonatomic, strong) NSMutableDictionary *picIdentiferInfo;
@property (nonatomic, strong) NSMutableDictionary *mediaPlayers;
@end

@implementation TKSArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.sampleTextView];
    [self.sampleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    // Do any additional setup after loading the view.
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

#pragma mark - setter and getter
- (void)setHtmlContentString:(NSString *)htmlContentString{
    _htmlContentString = htmlContentString;
    
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
-(NSDictionary *)customParaStyleHead1{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @20,
             TKSCustomParaStyleLineHeightMultiple: @1.1};
}
-(NSDictionary *)customParaStyleHead2{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @20,
             TKSCustomParaStyleParagraphSpacingBefore: @20,
             TKSCustomParaStyleLineHeightMultiple: @1.2};
}
-(NSDictionary *)customParaStyleHead3{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @20,
             TKSCustomParaStyleParagraphSpacingBefore: @20,
             TKSCustomParaStyleLineHeightMultiple: @1.2};
}
-(NSDictionary *)customParaStyleHead4{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @20,
             TKSCustomParaStyleParagraphSpacingBefore: @20,
             TKSCustomParaStyleLineHeightMultiple: @1.2};
}
-(NSDictionary *)customParaStylePara{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @20,
             TKSCustomParaStyleParagraphSpacingBefore: @20,
             TKSCustomParaStyleLineHeightMultiple: @1.4};
}
-(NSDictionary *)customParaStyleFigcaption{
    return @{TKSCustomParaStyleHeadIndent: @40,
             TKSCustomParaStyleTailIndent: @-40,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleLineHeightMultiple: @1};
}
-(NSDictionary *)customParaStylePre{
    return @{TKSCustomParaStyleHeadIndent: @40,
             TKSCustomParaStyleTailIndent: @-40,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleLineHeightMultiple: @1};
}
-(NSDictionary *)customParaStyle{
    return @{@"h1":[self customParaStyleHead1],
             @"h2":[self customParaStyleHead2],
             @"h3":[self customParaStyleHead3],
             @"h4":[self customParaStyleHead4],
             @"p":[self customParaStylePara],
             @"pre":[self customParaStylePre],
             @"figcaption":[self customParaStyleFigcaption]};
}
- (void)setUpTextViewWithArticleHtmlContent:(NSString *)htmlContent{
//    NSString *htmlSampleString =
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"htmlSampleText" ofType:@"html"];
//    NSString *sampleHtmlContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSString *dataEncodingWithLt = [sampleHtmlContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSString *dataEncodingWithLt = [htmlContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSString *dataEncodingWithGt = [dataEncodingWithLt stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSData *data = [dataEncodingWithGt dataUsingEncoding:NSUTF8StringEncoding];
    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT)];

    NSDictionary *builderOptions = @{
                                     DTDefaultFontFamily: @"Raleway",
                                     DTDefaultFontName: @"Raleway-Light",
                                     DTCoreTextCustomParagraphStyleInfo: [self customParaStyle],
                                     DTDefaultFontSize: @16,
                                     DTMaxImageSize: sizeValue
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
//- (void)setUpTextViewWithArticleInfo:(NSDictionary *)info{
//
//    NSString *mediumText = @"";
//    NSArray *articleParagraphs = info[@"results"][@"articleParagraph"];
//    NSMutableArray *titleRanges = [NSMutableArray array];
//    NSMutableArray *textRanges = [NSMutableArray array];
//    for (int i = 0; i < articleParagraphs.count; i++) {
//        NSString *paragraphMark = [[articleParagraphs objectAtIndex:i] objectForKey:@"paragraphMark"];
//        NSString *paragraphText = [[articleParagraphs objectAtIndex:i] objectForKey:@"paragraphText"];
//        if (![paragraphMark isEqualToString:@"p"]) {
//            NSRange titleRange = NSMakeRange(mediumText.length, paragraphText.length+1);
//            [titleRanges addObject:[NSValue valueWithRange:titleRange]];
//        }else{
//            NSRange textRange = NSMakeRange(mediumText.length, paragraphText.length+1);
//            [textRanges addObject:[NSValue valueWithRange:textRange]];
//        }
//        mediumText = [mediumText stringByAppendingString:[NSString stringWithFormat:@"%@\n",paragraphText]];
//    }
//    [_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:mediumText];
//    for (NSValue *rangeObject in titleRanges) {
//        NSRange range = [rangeObject rangeValue];
//        [_textStorage setAttributes:[self titleStyleDict] range:range];
//
//    }
//    for (NSValue *rangeObject in textRanges) {
//        NSRange range = [rangeObject rangeValue];
//        [_textStorage setAttributes:[self textStyleDict] range:range];
//    }
//}

-(NSMutableAttributedString *)htmlAttributeString{
    if (!_htmlAttributeString) {
        _htmlAttributeString = [NSMutableAttributedString new];
    }
    return _htmlAttributeString;
}

//- (NSDictionary *)titleStyleDict {
//
//
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//
//    UIColor *textColor = [UIColor blackColor];
//    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
//    [attributes setValue:[UIColor redColor] forKey:NSBackgroundColorAttributeName];
//    UIFont *textFont = [UIFont boldSystemFontOfSize:30.f];
//    [attributes setValue:textFont forKey:NSFontAttributeName];
//    [attributes setValue:@-30 forKey:NSBaselineOffsetAttributeName];
//    //创建段落样式
//    [attributes setValue:[self style] forKey:NSParagraphStyleAttributeName];
//
//    return attributes;
//}
//
//- (NSDictionary *)textStyleDict {
//
//    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
//
//    UIColor *textColor = [UIColor blackColor];
//    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
//    [attributes setValue:[UIColor greenColor] forKey:NSBackgroundColorAttributeName];
//    UIFont *textFont = [UIFont systemFontOfSize:16.f];
//    [attributes setValue:textFont forKey:NSFontAttributeName];
//    [attributes setValue:@-15 forKey:NSBaselineOffsetAttributeName];
//
//    [attributes setValue:[self style] forKey:NSParagraphStyleAttributeName];
//
//    return attributes;
//}
-(NSMutableDictionary *)picIdentiferInfo{
    if (!_picIdentiferInfo) {
        _picIdentiferInfo = [NSMutableDictionary dictionary];
    }
    return _picIdentiferInfo;
}
//- (NSMutableParagraphStyle *)style {
//
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//
//    style.lineSpacing = 8.5f;
//    style.paragraphSpacing = 25.f;
//    style.firstLineHeadIndent = 0.f;
//
//    return style;
//}
//
//- (NSTextContainer *)container{
//    if (!_container) {
//        _container = [NSTextContainer new];
//
//        _layoutManager = [NSLayoutManager new];
//        _layoutManager.delegate = self;
//        [_layoutManager addTextContainer:_container];
//
//        _textStorage = [TKSTextStorage new];
//        [_textStorage addLayoutManager:_layoutManager];
//    }
//    return _container;
//}
//
//-(void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag{
//    //This is only for first Glyph
//    CGRect lineFragmentRect = [layoutManager lineFragmentUsedRectForGlyphAtIndex:0 effectiveRange:nil];
//    NSLog(@"Line Height:%f",lineFragmentRect.size.height);
//    // The height of this rect is the line height.
//}

#pragma mark - DTLazyImageViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView
                    viewForAttachment:(DTTextAttachment *)attachment
                                frame:(CGRect)frame{
    if ([attachment isKindOfClass:[DTVideoTextAttachment class]])
    {
        NSURL *url = (id)attachment.contentURL;
        
        // we could customize the view that shows before playback starts
        UIView *grayView = [[UIView alloc] initWithFrame:frame];
        grayView.backgroundColor = [DTColor blackColor];
        
        // find a player for this URL if we already got one
        AVPlayer *avplayer = [[AVPlayer alloc]initWithURL:url];
        __block AVPlayerViewController *playerController = nil;

        [self.mediaPlayers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:url.absoluteString]) {
                playerController = (AVPlayerViewController*)obj;
                *stop = YES;
            }
        }];
        
        
        if (!playerController)
        {
            playerController = [[AVPlayerViewController alloc] init];
            playerController.player = avplayer;
            [self.mediaPlayers setObject:playerController forKey:url.absoluteString];
        }
        
//        NSString *airplayAttr = [attachment.attributes objectForKey:@"x-webkit-airplay"];
//        if ([airplayAttr isEqualToString:@"allow"])
//        {
//            playerController.player.allowsExternalPlayback = YES;
//        }
//        
//        NSString *controlsAttr = [attachment.attributes objectForKey:@"controls"];
//        if (controlsAttr)
//        {
//            playerController.player.controlStyle = MPMovieControlStyleEmbedded;
//        }
//        else
//        {
//            player.controlStyle = MPMovieControlStyleNone;
//        }
//        
//        NSString *loopAttr = [attachment.attributes objectForKey:@"loop"];
//        if (loopAttr)
//        {
//            player.repeatMode = MPMovieRepeatModeOne;
//        }
//        else
//        {
//            player.repeatMode = MPMovieRepeatModeNone;
//        }
//        
//        NSString *autoplayAttr = [attachment.attributes objectForKey:@"autoplay"];
//        if (autoplayAttr)
//        {
//            player.shouldAutoplay = YES;
//        }
//        else
//        {
//            player.shouldAutoplay = NO;
//        }
        
//        [playerController prepareToPlay];
        
        playerController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        playerController.view.frame = grayView.bounds;
        [grayView addSubview:playerController.view];
        
        return grayView;
    }else
    if([attachment isKindOfClass:[DTImageTextAttachment class]]){
        DTLazyImageView *imageContentView = [DTLazyImageView new];
        
        imageContentView = [[DTLazyImageView alloc] initWithFrame:frame];//CGRectMake(10, frame.origin.y, self.sampleTextView.frame.size.width - 20, 100)];
        imageContentView.contentView = attributedTextContentView;
        imageContentView.delegate = self;
        
        // url for deferred loading
        imageContentView.image = [(DTImageTextAttachment *)attachment image];
        imageContentView.imageUrlsInfo = attachment.contentURLsInfo;
        
        imageContentView.backgroundColor = [UIColor clearColor];
        return imageContentView;
        
    }else if ([attachment isKindOfClass:[DTIframeTextAttachment class]])
    {
        DTWebVideoView *videoView = [[DTWebVideoView alloc] initWithFrame:frame];
        videoView.attachment = attachment;
        
        return videoView;
    }
    return nil;
}
- (void)lazyImageView:(DTLazyImageView *)lazyImageView didChangeImageSize:(CGSize)size andImageUrl:(NSURL *)url{
    
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
- (NSMutableDictionary *)mediaPlayers{
    if (!_mediaPlayers)
    {
        _mediaPlayers = [NSMutableDictionary dictionary];
    }
    
    return _mediaPlayers;
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
