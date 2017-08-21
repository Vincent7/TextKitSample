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
#import "TKSArticleDetailTitlePreviewView.h"
//#import "UIColor+TKSColorScheme.h"
@interface TKSArticleDetailViewController () <NSLayoutManagerDelegate,DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate,UIScrollViewDelegate>
//@property (nonatomic, strong) NSTextContainer *container;
//@property (nonatomic, strong) NSLayoutManager *layoutManager;
//@property (nonatomic, strong) TKSTextStorage *textStorage;

@property (nonatomic, strong) DTAttributedTextView *sampleTextView;
@property (nonatomic, strong) NSMutableAttributedString *htmlAttributeString;

@property (nonatomic, strong) NSMutableDictionary *picIdentiferInfo;
@property (nonatomic, strong) NSMutableDictionary *mediaPlayers;

@property (nonatomic, strong) TKSArticleDetailTitlePreviewView *detailArticleTitleContainer;

@property (nonatomic, assign) BOOL lockScrollViewInterface;
@end

@implementation TKSArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lockScrollViewInterface = NO;
    
    [self.view addSubview:self.sampleTextView];
    [self.view addSubview:self.detailArticleTitleContainer];
    [self.detailArticleTitleContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(@64);
    }];
    [self.sampleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
    }];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setUpTextViewWithArticleHtmlContent:self.htmlContentString];
    
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
-(void)setExpendAnimProgress:(CGFloat)expendAnimProgress{
    _expendAnimProgress = expendAnimProgress;
    self.detailArticleTitleContainer.expendAnimProgress = expendAnimProgress;
}
-(void)setArticleTitle:(NSString *)articleTitle{
    if (![_articleTitle isEqualToString:articleTitle]) {
        _articleTitle = articleTitle;
        self.detailArticleTitleContainer.articleTitle = _articleTitle;
    }
}
-(UIView *)titleContainer{
    return self.detailArticleTitleContainer;
}
- (void)setHtmlContentString:(NSString *)htmlContentString{
    _htmlContentString = htmlContentString;
    
}
-(TKSArticleDetailTitlePreviewView *)detailArticleTitleContainer{
    if (!_detailArticleTitleContainer) {
        _detailArticleTitleContainer = [[TKSArticleDetailTitlePreviewView alloc] init];
        
    }
    return _detailArticleTitleContainer;
}
-(VJResponderChangeableScrollView *)scrollView{
    return _sampleTextView;
}
-(DTAttributedTextView *)sampleTextView{
    if (!_sampleTextView) {
        _sampleTextView = [[DTAttributedTextView alloc] initWithFrame:CGRectZero];
        _sampleTextView.shouldDrawLinks = YES;
        _sampleTextView.shouldDrawImages = YES;
        _sampleTextView.textDelegate = self;
        _sampleTextView.delegate = self;
        _sampleTextView.bounces = NO;
    }
    return _sampleTextView;
}
-(NSDictionary *)customParaStyleHead1{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @5,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-SemiBold",
             TKSCustomParaStyleTextColorHex: @"#000000",
             TKSCustomParaStyleLineHeightMultiple: @1.1};
}
-(NSDictionary *)customParaStyleHead2{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @15,
             TKSCustomParaStyleParagraphSpacingBefore: @5,
             TKSCustomParaStyleFontName: @"Raleway-Regular",
             TKSCustomParaStyleTextColorHex: @"#9B9B9B",
             TKSCustomParaStyleLineHeightMultiple: @1.2};
}
-(NSDictionary *)customParaStyleHead3{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-SemiBold",
             TKSCustomParaStyleTextColorHex: @"#000000",
             TKSCustomParaStyleLineHeightMultiple: @1.2};
}
-(NSDictionary *)customParaStyleHead4{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-Regular",
             TKSCustomParaStyleTextColorHex: @"#000000",
             TKSCustomParaStyleLineHeightMultiple: @1.2};
}
-(NSDictionary *)customParaStylePara{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-20,
             TKSCustomParaStyleParagraphSpacing: @20,
             TKSCustomParaStyleParagraphSpacingBefore: @20,
             TKSCustomParaStyleFontName: @"Raleway-Regular",
             TKSCustomParaStyleTextColorHex: @"#000000",
             TKSCustomParaStyleLineHeightMultiple: @1.4};
}
-(NSDictionary *)customParaStyleFigcaption{
    return @{TKSCustomParaStyleHeadIndent: @40,
             TKSCustomParaStyleTailIndent: @-40,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-Regular",
             TKSCustomParaStyleFontSize: @12,
             TKSCustomParaStyleTextColorHex: @"#9B9B9B",
             TKSCustomParaStyleLineHeightMultiple: @1};
}
-(NSDictionary *)customParaStylePre{
    return @{TKSCustomParaStyleHeadIndent: @40,
             TKSCustomParaStyleTailIndent: @-40,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Releway-Regular",
             TKSCustomParaStyleTextColorHex: @"#4A90E2",
             TKSCustomParaStyleLineHeightMultiple: @1};
}
-(NSDictionary *)customParaStyleBlockQuote{
    return @{TKSCustomParaStyleHeadIndent: @20,
             TKSCustomParaStyleTailIndent: @-40,
             TKSCustomParaStyleParagraphSpacing: @10,
             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-LightItalic",
             TKSCustomParaStyleTextColorHex: @"#9B9B9B",
             TKSCustomParaStyleLineHeightMultiple: @1};
}
-(NSDictionary *)customParaStyleOL{
    return @{TKSCustomParaStyleHeadIndent: @40,
             TKSCustomParaStyleTailIndent: @-20,
//             TKSCustomParaStyleParagraphSpacing: @10,
//             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-Regular",
//             TKSCustomParaStyleTextColorHex: @"#000000",
//             TKSCustomParaStyleLineHeightMultiple: @1
             };
}
-(NSDictionary *)customParaStyleLI{
    return @{TKSCustomParaStyleHeadIndent: @40,
             TKSCustomParaStyleTailIndent: @-20,
//             TKSCustomParaStyleParagraphSpacing: @10,
//             TKSCustomParaStyleParagraphSpacingBefore: @10,
             TKSCustomParaStyleFontName: @"Raleway-Regular",
//             TKSCustomParaStyleTextColorHex: @"#000000",
//             TKSCustomParaStyleLineHeightMultiple: @1
             };
}
-(NSDictionary *)customParaStyle{
    return @{@"h1":[self customParaStyleHead1],
             @"h2":[self customParaStyleHead2],
             @"h3":[self customParaStyleHead3],
             @"h4":[self customParaStyleHead4],
             @"p":[self customParaStylePara],
             @"pre":[self customParaStylePre],
             @"blockquote":[self customParaStyleBlockQuote],
             @"ol":[self customParaStyleOL],
             @"li":[self customParaStyleLI],
             @"figcaption":[self customParaStyleFigcaption]};
}
- (void)setUpTextViewWithArticleHtmlContent:(NSString *)htmlContent{
    
    NSString *dataEncodingWithLt = [htmlContent stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSString *dataEncodingWithGt = [dataEncodingWithLt stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSData *data = [dataEncodingWithGt dataUsingEncoding:NSUTF8StringEncoding];
    NSValue *sizeValue = [NSValue valueWithCGSize:CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT)];

    NSDictionary *builderOptions = @{
                                     DTDefaultFontFamily: @"Raleway",
                                     DTDefaultFontName: @"Raleway-Regular",
                                     DTCoreTextCustomParagraphStyleInfo: [self customParaStyle],
                                     DTDefaultFontSize: @16,
                                     DTDefaultHeadIndent: @20,
                                     DTMaxImageSize: sizeValue
                                     };
    DTHTMLAttributedStringBuilder *attrString = [[DTHTMLAttributedStringBuilder alloc] initWithHTML:data options:builderOptions  documentAttributes:nil];

    NSAttributedString *attributedString = [attrString generatedAttributedString];
    [self.sampleTextView setParaIdentiferIndexInfo:attrString.paragraphQuoteMarkObjectsInfo];
    [self.sampleTextView setAttributedString:attributedString];
   
}
-(void)scrollWithParaIdentifer:(NSString *)paraIdentifer{
    CGFloat offset = [self.sampleTextView.paraMarkManager getParaOriginYWithIdentifer:paraIdentifer];
//    self.sampleTextView
    [self.sampleTextView scrollRectToVisible:CGRectMake(0, offset - self.sampleTextView.frame.size.height/3, self.sampleTextView.frame.size.width, self.sampleTextView.frame.size.height)
                                    animated:YES];
    //高亮正在跳转的段落
    NSRange textRange = [self.sampleTextView.paraMarkManager getParaLocationRangeWithIdentifer:paraIdentifer];
    [self.sampleTextView updateTextAttributeAtRange:textRange andAttribute:[self highlightTextAttribute]];
}

-(NSDictionary *)highlightTextAttribute{
//    [tmpAttributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor redColor] range:textRange];
    NSDictionary *highlightAttribute = @{NSBackgroundColorAttributeName: rgb(236, 241, 255)};
    return highlightAttribute;
}

-(NSMutableAttributedString *)htmlAttributeString{
    if (!_htmlAttributeString) {
        _htmlAttributeString = [NSMutableAttributedString new];
    }
    return _htmlAttributeString;
}


-(NSMutableDictionary *)picIdentiferInfo{
    if (!_picIdentiferInfo) {
        _picIdentiferInfo = [NSMutableDictionary dictionary];
    }
    return _picIdentiferInfo;
}


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

#pragma UIScrollViewDelegate Method
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offset = scrollView.contentOffset.y;
//    if (scrollView.isDragging) {
//        if (offset <= 0) {
//            NSLog(@"NO");
//            scrollView.scrollEnabled = NO;
//        }else{
//            NSLog(@"YES");
//            scrollView.scrollEnabled = YES;
//        }
//    }else{
//        NSLog(@"YES");
//        scrollView.scrollEnabled = YES;
//    }
    
//    
//    if (scrollView.isDragging) {
//        self.lockScrollViewInterface = !(offset > 0);
//        scrollView.bounces = !self.lockScrollViewInterface;
//        [scrollView setUserInteractionEnabled:!self.lockScrollViewInterface];
//    }
    
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"YES");
//    scrollView.scrollEnabled = YES;
//    self.lockScrollViewInterface = NO;
//    [scrollView setUserInteractionEnabled:!self.lockScrollViewInterface];

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
