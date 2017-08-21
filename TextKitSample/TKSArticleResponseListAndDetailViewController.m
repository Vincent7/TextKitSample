//
//  TKSArticleResponseListAndDetailViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/6/5.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseListAndDetailViewController.h"

#import "TKSBaseSectionListDataSource.h"
#import "TKSArticleResponseListDataObject.h"

#import "TKSArticleUserResponsesTableViewCell.h"
#import "TKSArticleResponseQuoteTextSectionView.h"
#import "TKSArticleResponseQuoteFooterSectionView.h"

#import "TKSArticleDetailViewController.h"
#import "TKSTextParagraphAttributeManager.h"

#import "TKSSingleRequestsManager.h"

typedef enum : NSUInteger {
    barCollapsed,
    barExpanded,
    barScrolling,
} TKSScrollableNavigationBarState;
@interface TKSArticleResponseListAndDetailViewController () <UITableViewDelegate,TKSBaseRequestEngineDelegate,UICollisionBehaviorDelegate,TKSSingleRequestsManagerDelegate,TKSArticleResponseQuoteFooterSectionViewDelegate>
@property (nonatomic, strong) UITableView *articleResponseListTableView;
@property (nonatomic, strong) NSArray <TKSArticleResponseListDataObject *>*arrArticleDiscussPointDataSource;
@property (nonatomic, strong) TKSBaseSectionListDataSource *articleDisscussDataSource;

@property (nonatomic, strong) TKSArticleDetailViewController *articleDetailContentViewController;
@property (nonatomic, strong) UINavigationController *articleDetailContentNavController;
//@property (nonatomic, strong) UIView *sampleView;

@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, assign) BOOL shouldExpandState;
@property (nonatomic, assign) CGFloat percentComplete;
@property (nonatomic, assign) BOOL interacting;

@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UIAttachmentBehavior* attachmentBehavior;
@property (nonatomic, strong) UIPushBehavior* pushBehavior;
@property (nonatomic, strong) UICollisionBehavior* topCollisionBehavior;
@property (nonatomic, strong) UICollisionBehavior* bottomCollisionBehavior;

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGPoint lastAnchorPoint;

@property (nonatomic, assign) TKSScrollableNavigationBarState articleState;
@property (nonatomic, assign) TKSScrollableNavigationBarState barState;
@property (nonatomic, strong) UIFieldBehavior *topFieldBehavior;
@property (nonatomic, strong) UIFieldBehavior *bottomFieldBehavior;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *arrShownIndexes;
@property (nonatomic, assign) NSInteger gestureState;

//@property (nonatomic, strong) NSAttributedString *navigationBarTitle;
@end
#define GRAVITYCOEFFICIENT 1.0
@implementation TKSArticleResponseListAndDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.articleResponseListTableView];
    
    [self.articleResponseListTableView addSubview:self.refreshControl];
    [self.articleResponseListTableView sendSubviewToBack:self.refreshControl];
    
    self.requestManager = [TKSSingleRequestsManager new];
    self.requestManager.delegate = self;
    self.requestManager.loadRequestPathString = [TKSNetworkingRequestPathManager articleDetailPathWithArticleId:self.articleId];
    [self refreshTriggered:nil];
    
    [self.view addSubview:self.articleDetailContentViewController.view];
    [self addChildViewController:self.articleDetailContentViewController];//  2
    [self.articleDetailContentViewController didMoveToParentViewController:self];
    
    [self.articleDetailContentViewController.view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];

    self.lastAnchorPoint = CGPointZero;
    
    [self.articleDetailContentViewController.view setFrame:CGRectMake(0, SCREENH_HEIGHT - [self navBarFrameHeight] - .5, SCREEN_WIDTH, SCREENH_HEIGHT)];
    
    self.articleState = barCollapsed;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
//    [self.animator setValue:@(TRUE) forKey:@"debugEnabled"];
    [self.animator addBehavior:self.topCollisionBehavior];
    [self.animator addBehavior:self.bottomCollisionBehavior];
    [self.animator addBehavior:self.itemBehavior];
    [self.animator addBehavior:self.bottomFieldBehavior];
    //    [self.animator addBehavior:self.gravityBeahvior];
    //    [self.animator addBehavior:self.topFieldBehavior];
    //    [self.animator addBehavior:self.bottomFieldBehavior];
    
    [self prepareGestureRecognizerInView:self.articleDetailContentViewController.view];
    
    self.articleDetailContentViewController.articleTitle = self.articleTitle;
    [self.navigationItem setTitle:self.articleTitle];
    [self.navigationController.navigationBar setTitleTextAttributes:[TKSTextParagraphAttributeManager articleDiscussPointResponseNavigationBarTitleAttributeInfo]];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [self.articleDetailContentViewController.view removeObserver:self forKeyPath:@"center"];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    [self.animationContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    //    }];
    [self.articleResponseListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.bottom.equalTo(@-64);
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)setShouldExpandState:(BOOL)shouldExpandState{
    
    _shouldExpandState = shouldExpandState;
//    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"zPosition"];
//    anim.fromValue = [NSNumber numberWithFloat:!shouldExpandState?-1:0];
//    anim.toValue = [NSNumber numberWithFloat:shouldExpandState?-1:0];
//    anim.duration = 0.1;
//    [self.navigationController.navigationBar.layer addAnimation:anim forKey:@"zPosition"];
//    self.navigationController.navigationBar.layer.zPosition = shouldExpandState?-1:0;
    
    [self.navigationController.navigationBar setUserInteractionEnabled:!shouldExpandState];
//    NSUserDefaults *frameSize = [NSUserDefaults standardUserDefaults];
//    //Put frame size into defaults
//    CGRect navBarframe = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
//                                    (shouldExpandState?-23.5:20),
//                                    self.navigationController.navigationBar.frame.size.width,
//                                    self.navigationController.navigationBar.frame.size.height);
//    NSData *barFrameData = [NSKeyedArchiver archivedDataWithRootObject:[NSValue valueWithCGRect:navBarframe]];
//    [frameSize setObject:barFrameData forKey:@"frame"];
//    [frameSize synchronize];
}
- (CGRect)statusBarFrame{
    return [UIApplication sharedApplication].statusBarFrame;
}
- (CGFloat)statusBarFrameHeight{
    return [self statusBarFrame].size.height;
}
- (CGRect)navBarFrame{
    return self.navigationController.navigationBar.frame;
}
- (CGFloat)navBarFrameHeight{
    return [self navBarFrame].size.height;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    // Do what you have to do here with the new position
    if ([keyPath isEqualToString:@"center"]) {
        
        UIView *changedView = object;
        CGPoint newCenter = [[change valueForKey:@"new"] CGPointValue];

        CGFloat newTopLine = newCenter.y - changedView.frame.size.height/2;
        CGFloat delta = _lastContentOffset - newTopLine;
        _lastContentOffset = newTopLine;

        CGRect barFrame = [self navBarFrame];
        CGFloat navBarY = [self statusBarFrameHeight] + [self navBarFrameHeight];
        
        CGFloat expendTotalDistance = (SCREENH_HEIGHT - self.articleDetailContentViewController.titleContainer.frame.size.height);
        CGFloat expendProgress = (expendTotalDistance - newTopLine)/expendTotalDistance;
        self.articleDetailContentViewController.expendAnimProgress = expendProgress;
        
        if (delta > 0) {
            if (newTopLine > navBarY) {
                return;
            }
        }
        CGFloat newBarYOffset = MIN([self statusBarFrameHeight],
                                    MAX(barFrame.origin.y - delta,
                                        -[self navBarFrameHeight])) ;
        CGPoint newBarOrigin = CGPointMake(barFrame.origin.x, newBarYOffset);
        
        
        barFrame.origin = newBarOrigin;
        self.navigationController.navigationBar.frame = barFrame;
        
        
        
    }
}
-(UIDynamicItemBehavior *)itemBehavior{
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.articleDetailContentViewController.view]];
        _itemBehavior.density = 0.01;
        _itemBehavior.resistance = 20;
        _itemBehavior.friction = 1.0;
        _itemBehavior.elasticity = 0.0;
        _itemBehavior.allowsRotation = false;
    }
    return _itemBehavior;
}
-(UIFieldBehavior *)topFieldBehavior{
    if (!_topFieldBehavior) {
        _topFieldBehavior = [UIFieldBehavior springField];
        [_topFieldBehavior addItem:self.articleDetailContentViewController.view];
        CGSize regionSize = CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight] - [self navBarFrameHeight]);
        UIRegion *topBufferRegion = [[UIRegion alloc]initWithSize:regionSize];
        _topFieldBehavior.region = topBufferRegion;
        _topFieldBehavior.position = CGPointMake(SCREEN_WIDTH/2, (SCREENH_HEIGHT)/2 - [self statusBarFrameHeight]);
        _topFieldBehavior.strength = 30;
    }
    return _topFieldBehavior;
}
-(UIFieldBehavior *)bottomFieldBehavior{
    if (!_bottomFieldBehavior) {
        _bottomFieldBehavior = [UIFieldBehavior springField];
        [_bottomFieldBehavior addItem:self.articleDetailContentViewController.view];
        CGSize regionSize = CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight]);
        UIRegion *buttomBufferRegion = [[UIRegion alloc]initWithSize:regionSize];
        _bottomFieldBehavior.region = buttomBufferRegion;
        _bottomFieldBehavior.position = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT - [self navBarFrameHeight] + (SCREENH_HEIGHT - [self statusBarFrameHeight])/2);
        _bottomFieldBehavior.strength = 30;
    }
    return _bottomFieldBehavior;
}
-(UICollisionBehavior *)topCollisionBehavior{
    if (!_topCollisionBehavior) {
        _topCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.articleDetailContentViewController.view]];
        [_topCollisionBehavior addBoundaryWithIdentifier:@"TopBoundary"
                                               fromPoint:CGPointMake(0, -1)
                                                 toPoint:CGPointMake(SCREEN_WIDTH, -1)];
        
    }
    return _topCollisionBehavior;
}

-(UICollisionBehavior *)bottomCollisionBehavior{
    if (!_bottomCollisionBehavior) {
        _bottomCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.articleDetailContentViewController.view]];
        [_bottomCollisionBehavior addBoundaryWithIdentifier:@"bottomBoundary"
                                                  fromPoint:CGPointMake(0, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight] - [self navBarFrameHeight] + 1)
                                                    toPoint:CGPointMake(SCREEN_WIDTH, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight] - [self navBarFrameHeight] + 1)];
    }
    return _bottomCollisionBehavior;
}

//-(UIGravityBehavior *)gravityBeahvior{
//    if (!_gravityBeahvior) {
//        _gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.articleDetailContentViewController.view]];
//        _gravityBeahvior.gravityDirection = CGVectorMake(0, GRAVITYCOEFFICIENT);
//    }
//    return _gravityBeahvior;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.articleDetailContentViewController.titleContainer addGestureRecognizer:gesture2];
//    [self.articleDetailContentViewController.scrollView addGestureRecognizer:gesture];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    
//    [self.articleDetailContentViewController.titleContainer ]
    if (!self.articleDetailContentViewController.scrollView.reading || [gesture.view isEqual:self.articleDetailContentViewController.titleContainer]) {
        CGPoint touchPoint = [gesture locationInView:self.view];
        CGPoint velocity = [gesture velocityInView:self.view];
        
        UIView* draggedView = self.articleDetailContentViewController.view;
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:{
                
                self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:draggedView attachedToAnchor:CGPointMake(gesture.view.superview.center.x, touchPoint.y)];
                [self.animator addBehavior:self.attachmentBehavior];
                [self.animator removeBehavior:self.pushBehavior];
                self.lastAnchorPoint = touchPoint;
                break;
            }
            case UIGestureRecognizerStateChanged: {
                
                self.articleState = barScrolling;
                
                if (!self.shouldExpandState && touchPoint.y > self.lastAnchorPoint.y) {
                    touchPoint = CGPointMake(touchPoint.x, self.lastAnchorPoint.y);
                }
                if (self.shouldExpandState && touchPoint.y < self.lastAnchorPoint.y) {
                    touchPoint = CGPointMake(touchPoint.x, self.lastAnchorPoint.y);
                }
                if(velocity.y > 0){
                    [self.animator removeBehavior:self.topCollisionBehavior];
                    [self.animator addBehavior:self.bottomCollisionBehavior];
                    
                }else{
                    
                    [self.animator removeBehavior:self.bottomCollisionBehavior];
                    [self.animator addBehavior:self.topCollisionBehavior];
                }
                [self.attachmentBehavior setAnchorPoint:CGPointMake(gesture.view.superview.center.x, touchPoint.y)];
                [self.animator addBehavior:self.attachmentBehavior];
                
                
                [self.animator removeBehavior:self.topFieldBehavior];
                [self.animator removeBehavior:self.bottomFieldBehavior];
                break;
            }
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled: {
//                [self.articleDetailContentViewController.scrollView setUserInteractionEnabled:YES];
                
                self.lastAnchorPoint = CGPointZero;
                //            NSLog(@"CURRENT VELOCITY: %f",velocity.y);
                if (fabs(velocity.y) < 50) {
                    CGFloat fraction = (touchPoint.y) / (SCREENH_HEIGHT);
                    fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                    self.shouldExpandState = (fraction < 0.5);
                }else{
                    CGFloat magnitude = sqrtf((velocity.y * velocity.y))/150;
                    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[draggedView] mode:UIPushBehaviorModeInstantaneous];
                    self.pushBehavior.pushDirection = CGVectorMake(0 , (velocity.y / 10));

                    self.pushBehavior.magnitude = magnitude;
                    [self.animator addBehavior:self.pushBehavior];
                    
                    if (magnitude > 10) {
                        self.shouldExpandState = (velocity.y<0);
                    }else{
                        CGFloat fraction = (touchPoint.y) / (SCREENH_HEIGHT);
                        fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                        self.shouldExpandState = (fraction < 0.5);
                    }
                }
                
                [self.animator removeBehavior:self.attachmentBehavior];
            
                if (!self.shouldExpandState) {
//                    self.gravityBeahvior.gravityDirection = CGVectorMake(0, 3);
                    [self.animator addBehavior:self.bottomFieldBehavior];
                    [self.animator addBehavior:self.bottomCollisionBehavior];
                }else{
//                    self.gravityBeahvior.gravityDirection = CGVectorMake(0, -3);
                    [self.animator addBehavior:self.topFieldBehavior];
                    [self.animator addBehavior:self.topCollisionBehavior];
                    
                    
                }
                break;
            }
            default:
                break;
        }
    }else{
        [self.animator removeBehavior:self.pushBehavior];
        [self.animator removeBehavior:self.attachmentBehavior];

        [self.animator addBehavior:self.topFieldBehavior];
        [self.animator addBehavior:self.topCollisionBehavior];
        
        [self.animator removeBehavior:self.bottomFieldBehavior];
        [self.animator removeBehavior:self.bottomCollisionBehavior];
    }
    
}
#pragma mark - TKSArticleResponseQuoteFooterSectionViewDelegate Method
-(void)footer:(TKSArticleResponseQuoteFooterSectionView *)footer didTapSeeMoreButton:(UIButton *)btnSeeMore{
    TKSArticleResponseListDataObject *item = [self.articleDisscussDataSource sectionItemAtIndexPathSection:footer.sectionIndex];
    item.shouldExpandList = YES;
    [self.articleDisscussDataSource updateSectionDataItem:item atSectionIndex:item.sectionIndex];
    [self.articleResponseListTableView reloadData];
}
#pragma mark - UITableView Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    - (id)itemAtIndexPath:(NSIndexPath *)indexPath;
    NSString *paraIdentifer;
    id item = [self.articleDisscussDataSource itemAtIndexPath:indexPath];
    if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"quote_identifer"] isEqual:[NSNull null]] &&[item objectForKey:@"quote_identifer"]) {
        paraIdentifer = [item objectForKey:@"quote_identifer"];
        
    }
    [self.animator addBehavior:self.topFieldBehavior];
    [self.animator addBehavior:self.topCollisionBehavior];
    [self.animator removeBehavior:self.bottomFieldBehavior];
    self.shouldExpandState = YES;
    [self.articleDetailContentViewController scrollWithParaIdentifer:paraIdentifer];
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
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    TKSArticleResponseQuoteFooterSectionView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([TKSArticleResponseQuoteFooterSectionView class])];
    TKSArticleResponseListDataObject *item = [self.articleDisscussDataSource sectionItemAtIndexPathSection:section];
//    item.shouldExpandList = NO;
    footer.delegate = self;
    self.articleDisscussDataSource.configureFooterBlock(footer,item);
    return footer;
}
- (nullable UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    id header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.articleDisscussDataSource.headerIdentifier];
    id item = [self.articleDisscussDataSource sectionItemAtIndexPathSection:section];
    self.articleDisscussDataSource.configureHeaderBlock(header,item);
    return header;
}
#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender{
//    NSDictionary *params = @{@"page": @"1"};
    [self.refreshControl beginRefreshing];
    [self.requestManager requestForLoadData];
    //    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.refreshControl endRefreshing];
}
#pragma mark - TKSSingleRequestsManagerDelegate Method
-(void)didRequestFinishedWithDataResult:(NSDictionary *)dataInfo andError:(NSError *)error{
    [super didRequestFinishedWithDataResult:dataInfo andError:error];
    NSMutableArray *sectionList = [NSMutableArray array];
    
    NSArray *list = [NSArray arrayWithArray:[dataInfo objectForKey:@"article_responses"]];
    
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *sectionDataInfo = obj;
        NSString *quote = @"";
        if ([sectionDataInfo respondsToSelector:@selector(objectForKey:)] && ![[sectionDataInfo objectForKey:@"quote"] isEqual:[NSNull null]] &&[sectionDataInfo objectForKey:@"quote"]) {
            quote = [sectionDataInfo objectForKey:@"quote"];
        }
        NSMutableArray *responses = [NSMutableArray array];
        if ([sectionDataInfo respondsToSelector:@selector(objectForKey:)] && ![[sectionDataInfo objectForKey:@"quote_responses_list"] isEqual:[NSNull null]] &&[sectionDataInfo objectForKey:@"quote_responses_list"]) {
            for (NSDictionary *responseInfo in [sectionDataInfo objectForKey:@"quote_responses_list"]) {
                [responses addObject:[responseInfo objectForKey:@"response_quote_text"]];
            }
            //            responses = [sectionDataInfo objectForKey:@"quote_response_list"];
        }
        TKSArticleResponseListDataObject *section = [[TKSArticleResponseListDataObject alloc]initWithQuoteText:quote andResponses:responses];
        section.sectionIndex = idx;
        section.shouldExpandList = NO;
        [sectionList addObject:section];
    }];
//    for (NSDictionary *sectionDataInfo in [NSArray arrayWithArray:[dataInfo objectForKey:@"article_responses"]]) {
//        NSString *quote = @"";
//        if ([sectionDataInfo respondsToSelector:@selector(objectForKey:)] && ![[sectionDataInfo objectForKey:@"quote"] isEqual:[NSNull null]] &&[sectionDataInfo objectForKey:@"quote"]) {
//            quote = [sectionDataInfo objectForKey:@"quote"];
//        }
//        NSMutableArray *responses = [NSMutableArray array];
//        if ([sectionDataInfo respondsToSelector:@selector(objectForKey:)] && ![[sectionDataInfo objectForKey:@"quote_responses_list"] isEqual:[NSNull null]] &&[sectionDataInfo objectForKey:@"quote_responses_list"]) {
//            for (NSDictionary *responseInfo in [sectionDataInfo objectForKey:@"quote_responses_list"]) {
//                [responses addObject:[responseInfo objectForKey:@"response_quote_text"]];
//            }
//            //            responses = [sectionDataInfo objectForKey:@"quote_response_list"];
//        }
//        TKSArticleResponseListDataObject *section = [[TKSArticleResponseListDataObject alloc]initWithQuoteText:quote andResponses:responses];
//        section.shouldExpandList = NO;
//        [sectionList addObject:section];
//    }
    
    self.arrArticleDiscussPointDataSource = sectionList;
    NSArray *htmlContentInfosList = [dataInfo objectForKey:@"article_html_contents"];
    NSString *contentString = [NSString string];
    
    NSArray *htmlContentsList = [htmlContentInfosList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGFloat aNumber = [[obj1 valueForKey:@"content_index"] floatValue];
        CGFloat bNumber = [[obj2 valueForKey:@"content_index"] floatValue];
        if (aNumber > bNumber) {
            return NSOrderedDescending;
        }else if (aNumber == bNumber){
            return NSOrderedSame;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    for (int i = 0; i < htmlContentsList.count; i++) {
        NSDictionary *htmlContent = [htmlContentsList objectAtIndex:i];
        NSString *partContent = [htmlContent objectForKey:@"html_content"];
        contentString = [contentString stringByAppendingString:partContent];
    }
    
    self.articleDetailContentViewController.htmlContentString = contentString;
    [self.articleDetailContentViewController setUpTextViewWithArticleHtmlContent:self.articleDetailContentViewController.htmlContentString];
    self.articleDisscussDataSource.items = self.arrArticleDiscussPointDataSource;
    [self.articleResponseListTableView reloadData];
    [self finishRefreshControl];
}

#pragma mark - setter and getter
-(NSMutableArray *)arrShownIndexes{
    if (!_arrShownIndexes) {
        _arrShownIndexes = [NSMutableArray array];
    }
    return _arrShownIndexes;
}
-(UIRefreshControl *)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [UIRefreshControl new];
        NSAttributedString *loadingAttrString = [[NSAttributedString alloc]initWithString:@"Loading" attributes:[TKSTextParagraphAttributeManager refreshControlTextAttributeInfo]];
        [_refreshControl setAttributedTitle:loadingAttrString];
        [_refreshControl addTarget:self action:@selector(refreshTriggered:) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

-(TKSArticleDetailViewController *)articleDetailContentViewController{
    if (!_articleDetailContentViewController) {
        _articleDetailContentViewController = [TKSArticleDetailViewController new];
        self.shouldExpandState = NO;
    }
    return _articleDetailContentViewController;
}

-(UITableView *)articleResponseListTableView{
    if (!_articleResponseListTableView) {
        _articleResponseListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        _articleResponseListTableView.delegate = self;
        _articleResponseListTableView.dataSource = self.articleDisscussDataSource;
        _articleResponseListTableView.alwaysBounceVertical = YES;
        
        _articleResponseListTableView.rowHeight = UITableViewAutomaticDimension;
        _articleResponseListTableView.estimatedRowHeight = 50;
        _articleResponseListTableView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _articleResponseListTableView.estimatedSectionHeaderHeight = 100;
        _articleResponseListTableView.sectionFooterHeight = UITableViewAutomaticDimension;
        _articleResponseListTableView.estimatedSectionFooterHeight = 20;
//        _articleResponseListTableView
        
        _articleResponseListTableView.separatorStyle = NO;
        
        [_articleResponseListTableView registerClass:[TKSArticleUserResponsesTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TKSArticleUserResponsesTableViewCell class])];
        [_articleResponseListTableView registerClass:[TKSArticleResponseQuoteFooterSectionView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TKSArticleResponseQuoteFooterSectionView class])];
        [_articleResponseListTableView registerClass:[TKSArticleResponseQuoteTextSectionView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TKSArticleResponseQuoteTextSectionView class])];
        _articleResponseListTableView.backgroundColor = rgb(247, 247, 247);
    }
    return _articleResponseListTableView;
}
-(NSArray *)sampleArray{
    return @[];
}
-(TKSBaseSectionListDataSource *)articleDisscussDataSource{
    if (!_articleDisscussDataSource) {
        
        _articleDisscussDataSource = [[TKSBaseSectionListDataSource alloc]initWithArray:[self sampleArray] cellReuseIdentifier:NSStringFromClass([TKSArticleUserResponsesTableViewCell class]) configureCellBlock:^(id cell, id item) {
            TKSArticleUserResponsesTableViewCell *discussPointCell = (TKSArticleUserResponsesTableViewCell*)cell;
            
            NSString *userName = @"Vincent";
            NSString *readingTime = @"7/20 - 12 mins";
            NSString *response = item;
            NSInteger favNumber = 25;
            BOOL isfav = rand()%2;
            
            [discussPointCell setResponseUserName:userName];
            [discussPointCell setResponseText:response];
            [discussPointCell setResponseReadingTime:readingTime];
            [discussPointCell setResponseFav:isfav];
            [discussPointCell setResponseFavNumber:favNumber];
            
        } headerReuseIdentifier:NSStringFromClass([TKSArticleResponseQuoteTextSectionView class]) configureHeaderBlock:^(id cell, TKSArticleResponseListDataObject *item) {
            TKSArticleResponseQuoteTextSectionView *discussPointSectionView = (TKSArticleResponseQuoteTextSectionView*)cell;
            
            NSString *quote = @"";
            quote = item.quoteText;
            discussPointSectionView.sectionIndex = item.sectionIndex;
            [discussPointSectionView setQuoteText:quote];

        }footerReuseIdentifier:NSStringFromClass([TKSArticleResponseQuoteFooterSectionView class]) configureFooterBlock:^(id cell, TKSArticleResponseListDataObject *item) {
            TKSArticleResponseQuoteFooterSectionView *showMoreSectionView = (TKSArticleResponseQuoteFooterSectionView*)cell;
            
//            BOOL shouldShowMoreButton = NO;
//            shouldShowMoreButton = item.shouldExpandList;
            showMoreSectionView.sectionIndex = item.sectionIndex;
            [showMoreSectionView setShowSeeMoreButton:item.shouldExpandList];
        }];
    }
    return _articleDisscussDataSource;
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
