//
//  ViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/4/20.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleListViewController.h"



//#import "CBStoreHouseRefreshControl.h"

#import "TKSBaseArrayWithLoadMoreItemDataSource.h"
#import "TKSArticleListTableViewCell.h"
#import "TKSArticleDetailViewController.h"
#import "TKSArticleResponseListAndDetailViewController.h"
#import "TKSTextParagraphAttributeManager.h"

@interface TKSArticleListViewController () <UITableViewDelegate>

//@property (nonatomic, strong) NSTextContainer *container;
//@property (nonatomic, strong) NSLayoutManager *layoutManager;
//@property (nonatomic, strong) TKSTextStorage *textStorage;



@property (nonatomic, strong) UITableView *articleListTableView;

@property (nonatomic, strong) TKSBaseArrayDataSource *articleListDataSource;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *arrShownIndexes;
@end

@implementation TKSArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.paginateRequestManager = [TKSPaginateRequestsManager new];
    self.paginateRequestManager.delegate = self;
    self.paginateRequestManager.refreshRequestPathString = [TKSNetworkingRequestPathManager articleListPath];
    self.paginateRequestManager.insertRequestPathString = [TKSNetworkingRequestPathManager articleListPath];
    [self refreshTriggered:nil];
    
//    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleListPath] param:self.updateParamsInfo requestType:GET];
    [self.view addSubview:self.articleListTableView];
    [self.articleListTableView addSubview:self.refreshControl];
    [self.articleListTableView sendSubviewToBack:self.refreshControl];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor navigationBarBackgroundColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
//    self.sampleTextView = [[UITextView alloc] initWithFrame:CGRectZero textContainer: self.container];
//    [self.view addSubview:self.sampleTextView];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - TKSTextParagraphAttributeManager Delegate
-(void)didRefreshRequestFinishedWithRefreshDataArray:(NSArray *)refreshDataList andError:(NSError *)error{
    self.articleListDataSource.items = refreshDataList;
    [self.articleListTableView reloadData];
    [self finishRefreshControl];
}

-(void)didInsertRequestFinishedWithInsertedDataArray:(NSArray *)insertedDataList andError:(NSError *)error{
    if (insertedDataList.count > 0){
        NSMutableArray *previousDataList = [NSMutableArray arrayWithArray:self.articleListDataSource.items];
        NSInteger previousDataCount = previousDataList.count;
        NSInteger insertedDataCount = insertedDataList.count;
        NSMutableArray *needsUpdateIndexPaths = [NSMutableArray array];
        for (NSInteger i = previousDataCount; i < previousDataCount+insertedDataCount; i++) {
            NSIndexPath *needsUpdataIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [needsUpdateIndexPaths addObject:needsUpdataIndexPath];
        }
        
        self.articleListDataSource.items = [previousDataList arrayByAddingObjectsFromArray:insertedDataList];;
        
        [self.articleListTableView beginUpdates];
        [self.articleListTableView insertRowsAtIndexPaths:needsUpdateIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.articleListTableView endUpdates];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.articleListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [UIView animateWithDuration:0.2 animations:^{
//        self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
//                                                                   [UIApplication sharedApplication].statusBarFrame.size.height,
//                                                                   self.navigationController.navigationBar.frame.size.width,
//                                                                   self.navigationController.navigationBar.frame.size.height);
//    }];
//    [self.articleListTableView scrollRectToVisible:CGRectMake(0, 300, SCREEN_WIDTH, SCREENH_HEIGHT) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Notifying refresh control of scrolling
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.storeHouseRefreshControl scrollViewDidScroll];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self.storeHouseRefreshControl scrollViewDidEndDragging];
//}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender{
    [self.refreshControl beginRefreshing];
    [self.paginateRequestManager requestForUpdate];
    
//    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}
- (void)insertTriggered:(id)sender{
    [self.paginateRequestManager requestForInsert];
}
- (void)finishRefreshControl
{
    [self.refreshControl endRefreshing];
//    [self.storeHouseRefreshControl finishingLoading];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKSArticleResponseListAndDetailViewController *vc = [TKSArticleResponseListAndDetailViewController new];
    NSDictionary *item = [self.articleListDataSource itemAtIndexPath:indexPath];
    NSString *articleId = [item objectForKey:@"id"];
    NSString *articleTitle = [item objectForKey:@"article_title"];
    vc.articleId = articleId;
    vc.articleTitle = articleTitle;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (![self.arrShownIndexes containsObject:indexPath]) {
        [self.arrShownIndexes addObject:indexPath];
        cell.transform = CGAffineTransformMakeTranslation(0.f, cell.frame.size.height);
        cell.layer.shadowColor = [[UIColor blackColor]CGColor];
        cell.layer.shadowOffset = CGSizeMake(10, 10);
        cell.alpha = 0;
        
        //2. Define the final state (After the animation) and commit the animation
        [UIView beginAnimations:@"rotation" context:NULL];
        [UIView setAnimationDuration:0.2];
        cell.transform = CGAffineTransformMakeTranslation(0.f, 0);
        cell.alpha = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 0);
        [UIView commitAnimations];
        // Your animation code here.
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (![self.paginateRequestManager shouldAcceptInsertRequest]) {
        return;
    }
//    CGFloat offset = scrollView.contentOffset.y;
    
    NSIndexPath *indexPath = self.articleListTableView.indexPathsForVisibleRows.lastObject;
    if (!indexPath) return;
    NSUInteger numberOfRows = [self.articleListTableView numberOfRowsInSection:0];
    if (indexPath.row + 2 > numberOfRows) {
        [self insertTriggered:nil];
    }
}
#pragma mark - getter and setter

-(UITableView *)articleListTableView{
    if (!_articleListTableView) {
        _articleListTableView = [[UITableView alloc] init];
        
        _articleListTableView.delegate = self;
        _articleListTableView.dataSource = self.articleListDataSource;
        _articleListTableView.alwaysBounceVertical = YES;
        
        _articleListTableView.rowHeight = UITableViewAutomaticDimension;
        _articleListTableView.estimatedRowHeight = 50;
        
        _articleListTableView.separatorStyle = NO;
        
        [_articleListTableView registerClass:[TKSArticleListTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TKSArticleListTableViewCell class])];
        [_articleListTableView registerClass:[TKSBaseLoadMoreTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TKSBaseLoadMoreTableViewCell class])];
        _articleListTableView.backgroundColor = rgb(247, 247, 247);
    }
    return _articleListTableView;
}
-(UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
//        NSAttributedString *loadingAttrString = [[NSAttributedString alloc]initWithString:@"Loading" attributes:[TKSTextParagraphAttributeManager refreshControlTextAttributeInfo]];
//        [_refreshControl setAttributedTitle:loadingAttrString];
        [_refreshControl addTarget:self action:@selector(refreshTriggered:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

-(NSArray *)sampleArray{
    return @[];
}
-(TKSBaseArrayDataSource *)articleListDataSource{
    if (!_articleListDataSource) {
        
        _articleListDataSource = [[TKSBaseArrayDataSource alloc]initWithArray:[self sampleArray] cellReuseIdentifier:NSStringFromClass([TKSArticleListTableViewCell class]) configureCellBlock:^(id cell, id item) {
            TKSArticleListTableViewCell *articleCell = (TKSArticleListTableViewCell*)cell;
//            NSString *articleId = @"";
            NSString *title = @"";
            NSArray *arrSubtitle;
            NSArray *arrPreviewImageInfos;
//            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"id"] isEqual:[NSNull null]] &&[item objectForKey:@"id"]) {
//                articleId = [item objectForKey:@"id"];
//            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"article_preview_subtitles"] isEqual:[NSNull null]] &&[item objectForKey:@"article_preview_subtitles"]) {
                arrSubtitle = [item objectForKey:@"article_preview_subtitles"];
            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"article_title"] isEqual:[NSNull null]] && [item objectForKey:@"article_title"]) {
                title = [item objectForKey:@"article_title"];
            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"article_preview_images_list"] isEqual:[NSNull null]] &&[item objectForKey:@"article_preview_images_list"]) {
                arrPreviewImageInfos = [item objectForKey:@"article_preview_images_list"];
            }
            NSString *subtitle = @"";
            for (NSDictionary *textInfo in arrSubtitle) {
                subtitle = [subtitle stringByAppendingString:[textInfo objectForKey:@"text"]];
            }
            [articleCell setArticleTitleText:title];
            [articleCell setArticleSubtitleText:subtitle];
            NSArray *arrImageUrls;
            CGFloat imageDataWidth = 0;
            CGFloat imageDataHeight = 0;
            if (arrPreviewImageInfos && arrPreviewImageInfos.count > 0) {
                NSDictionary *previewImageUrlsInfo = arrPreviewImageInfos.firstObject;
                imageDataHeight = [[previewImageUrlsInfo objectForKey:@"preview_image_height"] floatValue];
                imageDataWidth = [[previewImageUrlsInfo objectForKey:@"preview_image_width"] floatValue];
                arrImageUrls = [previewImageUrlsInfo objectForKey:@"article_preview_image_urls_list"];
                
            }
            [articleCell setImageUrls:arrImageUrls andImageDataSize:CGSizeMake(imageDataWidth, imageDataHeight)];
//            [articleCell.lblArticleTitle setText:[NSString stringWithFormat:@"%ld",[item integerValue]]];
//            [articleCell.lblArticleBriefText setText:[self stringWithLineNumber:[self getRandomNumberBetween:1 and:5]]];
        }];
    }
    return _articleListDataSource;
}
-(NSMutableArray *)arrShownIndexes{
    if (!_arrShownIndexes) {
        _arrShownIndexes = [NSMutableArray array];
    }
    return _arrShownIndexes;
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
//    
//}



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
//    //创建段落样式
//    [attributes setValue:[self style] forKey:NSParagraphStyleAttributeName];
//    
//    return attributes;
//}
//
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
////        NSString *p1Text = info[@"articleParagraph"][9][@"paragraphText"];
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
@end
