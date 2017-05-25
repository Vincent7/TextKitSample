//
//  ViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/4/20.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleListViewController.h"

#import "TKSBaseRequestEngine.h"

#import "CBStoreHouseRefreshControl.h"

#import "TKSBaseArrayWithLoadMoreItemDataSource.h"
#import "TKSArticleListTableViewCell.h"
#import "TKSArticleDetailViewController.h"

@interface TKSArticleListViewController () <TKSBaseRequestEngineDelegate,UITableViewDelegate>

//@property (nonatomic, strong) NSTextContainer *container;
//@property (nonatomic, strong) NSLayoutManager *layoutManager;
//@property (nonatomic, strong) TKSTextStorage *textStorage;

@property (nonatomic, strong) TKSBaseRequestEngine *requestEngine;

@property (nonatomic, strong) UITableView *articleListTableView;

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;

@property (nonatomic, strong) TKSBaseArrayWithLoadMoreItemDataSource *articleListDataSource;

@property (nonatomic, strong) NSArray *arrArticleDataSource;
@end

@implementation TKSArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *params = @{@"page": @"1"};
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleListPath] param:params requestType:GET];
    [self.view addSubview:self.articleListTableView];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
//    self.sampleTextView = [[UITextView alloc] initWithFrame:CGRectZero textContainer: self.container];
//    [self.view addSubview:self.sampleTextView];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)engine:(TKSBaseRequestEngine *)engine didRequestFinishedWithData:(id)data andError:(NSError *)error{
    if ([engine isEqual:self.requestEngine]) {
        self.arrArticleDataSource = [NSArray arrayWithArray:[data objectForKey:@"results"]];
        self.articleListDataSource.items = self.arrArticleDataSource;
        [self.articleListTableView reloadData];
        [self finishRefreshControl];
//        NSLog(@"%@",data);
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
    
//    [self.articleListTableView scrollRectToVisible:CGRectMake(0, 300, SCREEN_WIDTH, SCREENH_HEIGHT) animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notifying refresh control of scrolling

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.storeHouseRefreshControl scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.storeHouseRefreshControl scrollViewDidEndDragging];
}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    NSDictionary *params = @{@"page": @"1"};
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleListPath] param:params requestType:GET];
//    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - tableview Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TKSArticleDetailViewController *vc = [TKSArticleDetailViewController new];
    NSDictionary *item = [self.articleListDataSource itemAtIndexPath:indexPath];
    NSString *htmlContent = [item objectForKey:@"articleHtmlContent"];
    vc.htmlContentString = htmlContent;
    
    [self.navigationController pushViewController:vc animated:YES];
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
        _articleListTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_pattern"]];
    }
    return _articleListTableView;
}

-(CBStoreHouseRefreshControl *)storeHouseRefreshControl{
    if (!_storeHouseRefreshControl) {
        _storeHouseRefreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.articleListTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"AKTA" color:[UIColor whiteColor] lineWidth:2 dropHeight:80 scale:0.7 horizontalRandomness:300 reverseLoadingAnimation:NO internalAnimationFactor:0.7];
    }
    return _storeHouseRefreshControl;
}
-(NSArray *)sampleArray{
    return @[];
}
-(TKSBaseArrayWithLoadMoreItemDataSource *)articleListDataSource{
    if (!_articleListDataSource) {
        
        _articleListDataSource = [[TKSBaseArrayWithLoadMoreItemDataSource alloc]initWithArray:[self sampleArray] cellReuseIdentifier:NSStringFromClass([TKSArticleListTableViewCell class]) configureCellBlock:^(id cell, id item) {
            TKSArticleListTableViewCell *articleCell = (TKSArticleListTableViewCell*)cell;
            
            NSString *title = @"";
            NSString *subtitle = @"";
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"articleSubtitle"] isEqual:[NSNull null]] &&[item objectForKey:@"articleSubtitle"]) {
                subtitle = [item objectForKey:@"articleSubtitle"];
            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"articleTitle"] isEqual:[NSNull null]] && [item objectForKey:@"articleTitle"]) {
                if (![subtitle isEqualToString:@""]) {
                    title = [NSString stringWithFormat:@"%@(Subtitle)",[item objectForKey:@"articleTitle"]];
                }else{
                    title = [item objectForKey:@"articleTitle"];
                }
                
            }
            
            [articleCell setArticleTitleText:title];
            [articleCell setArticleSubtitleText:subtitle];
//            [articleCell.lblArticleTitle setText:[NSString stringWithFormat:@"%ld",[item integerValue]]];
//            [articleCell.lblArticleBriefText setText:[self stringWithLineNumber:[self getRandomNumberBetween:1 and:5]]];
        }];
    }
    return _articleListDataSource;
}

-(NSArray *)arrArticleDataSource{
    if (!_arrArticleDataSource) {
        _arrArticleDataSource = [NSArray array];
    }
    return _arrArticleDataSource;
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
