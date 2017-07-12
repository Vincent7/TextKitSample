//
//  TKSArticleResponseListAndDetailViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/6/5.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseListAndDetailViewController.h"
#import "TKSBaseRequestEngine.h"

#import "TKSBaseArrayWithLoadMoreItemDataSource.h"
#import "TKSArticleResponseTableViewCell.h"

#import "TKSArticleDetailViewController.h"
#import "TKSTextParagraphAttributeManager.h"

typedef enum : NSUInteger {
    barCollapsed,
    barExpanded,
    barScrolling,
} TKSScrollableNavigationBarState;
@interface TKSArticleResponseListAndDetailViewController () <UITableViewDelegate,TKSBaseRequestEngineDelegate,UICollisionBehaviorDelegate>
@property (nonatomic, strong) UITableView *articleResponseListTableView;
@property (nonatomic, strong) NSArray *arrArticleDiscussPointDataSource;
@property (nonatomic, strong) TKSBaseArrayWithLoadMoreItemDataSource *articleDisscussDataSource;

@property (nonatomic, strong) TKSBaseRequestEngine *requestEngine;

@property (nonatomic, strong) NSString *articleHtmlContent;
@property (nonatomic, strong) TKSArticleDetailViewController *articleDetailContentViewController;
@property (nonatomic, strong) UINavigationController *articleDetailContentNavController;
//@property (nonatomic, strong) UIView *sampleView;

@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, assign) BOOL shouldExpandState;
@property (nonatomic, assign) CGFloat percentComplete;
@property (nonatomic, assign) BOOL interacting;

@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIDynamicItemBehavior *itemBehavior;
@property (nonatomic, strong) UIGravityBehavior* gravityBeahvior;
@property (nonatomic, strong) UIAttachmentBehavior* attachmentBehavior;
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
@end
#define GRAVITYCOEFFICIENT 1.0
@implementation TKSArticleResponseListAndDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSDictionary *params = @{@"page": @"1"};
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleDetailPathWithArticleId:self.articleId] param:nil requestType:GET];
    [self.view addSubview:self.articleResponseListTableView];
    
    [self.articleResponseListTableView addSubview:self.refreshControl];
    [self.articleResponseListTableView sendSubviewToBack:self.refreshControl];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
//    [self.view addSubview:self.articleDetailContentNavController.view];
//    [self addChildViewController:self.articleDetailContentNavController];//  2
//    [self.articleDetailContentNavController didMoveToParentViewController:self];
//    
//    [self.articleDetailContentViewController.view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view addSubview:self.articleDetailContentViewController.view];
    [self addChildViewController:self.articleDetailContentViewController];//  2
    [self.articleDetailContentViewController didMoveToParentViewController:self];
    
    [self.articleDetailContentViewController.view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];

    self.lastAnchorPoint = CGPointZero;
//    [self.view addSubview:self.sampleView];
    
    [self.articleDetailContentViewController.view setFrame:CGRectMake(0, SCREENH_HEIGHT - [self navBarFrameHeight] - 1, SCREEN_WIDTH, SCREENH_HEIGHT - [self statusBarFrameHeight])];
    
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
    //    [self.animator addBehavior:self.snapBeahvior];
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
        make.bottom.equalTo(@-44);
    }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)setShouldExpandState:(BOOL)shouldExpandState{
    
    _shouldExpandState = shouldExpandState;
    
    NSUserDefaults *frameSize = [NSUserDefaults standardUserDefaults];
    //Put frame size into defaults
    CGRect navBarframe = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
                                    (shouldExpandState?-23.5:20),
                                    self.navigationController.navigationBar.frame.size.width,
                                    self.navigationController.navigationBar.frame.size.height);
    NSData *barFrameData = [NSKeyedArchiver archivedDataWithRootObject:[NSValue valueWithCGRect:navBarframe]];
    [frameSize setObject:barFrameData forKey:@"frame"];
    [frameSize synchronize];
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
        if (delta > 0) {
            if (newTopLine > navBarY) {
                return;
            }
        }
        CGFloat newBarYOffset = MIN([self statusBarFrameHeight], MAX(barFrame.origin.y - delta, -[self navBarFrameHeight] + [self statusBarFrameHeight])) ;
        CGPoint newBarOrigin = CGPointMake(barFrame.origin.x, newBarYOffset);

        barFrame.origin = newBarOrigin;
        self.navigationController.navigationBar.frame = barFrame;
        
    }
}
-(UIDynamicItemBehavior *)itemBehavior{
    if (!_itemBehavior) {
        _itemBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.articleDetailContentViewController.view]];
        _itemBehavior.density = 0.01;
        _itemBehavior.resistance = 10;
        _itemBehavior.friction = 0.0;
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
        _topFieldBehavior.position = CGPointMake(SCREEN_WIDTH/2, [self statusBarFrameHeight] + (SCREENH_HEIGHT - [self statusBarFrameHeight])/2);
        _topFieldBehavior.strength = 20;
    }
    return _topFieldBehavior;
}
-(UIFieldBehavior *)bottomFieldBehavior{
    if (!_bottomFieldBehavior) {
        _bottomFieldBehavior = [UIFieldBehavior springField];
        [_bottomFieldBehavior addItem:self.articleDetailContentViewController.view];
        CGSize regionSize = CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight] - [self navBarFrameHeight]);
        UIRegion *buttomBufferRegion = [[UIRegion alloc]initWithSize:regionSize];
        _bottomFieldBehavior.region = buttomBufferRegion;
        _bottomFieldBehavior.position = CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT - [self navBarFrameHeight] + (SCREENH_HEIGHT - [self statusBarFrameHeight])/2);
        _bottomFieldBehavior.strength = 20;
    }
    return _bottomFieldBehavior;
}
-(UICollisionBehavior *)topCollisionBehavior{
    if (!_topCollisionBehavior) {
        _topCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.articleDetailContentViewController.view]];
        [_topCollisionBehavior addBoundaryWithIdentifier:@"TopBoundary"
                                               fromPoint:CGPointMake(0, [self statusBarFrameHeight]-.5)
                                                 toPoint:CGPointMake(SCREEN_WIDTH, [self statusBarFrameHeight]-.5)];
        
    }
    return _topCollisionBehavior;
}
-(UICollisionBehavior *)bottomCollisionBehavior{
    if (!_bottomCollisionBehavior) {
        _bottomCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.articleDetailContentViewController.view]];
        [_bottomCollisionBehavior addBoundaryWithIdentifier:@"bottomBoundary"
                                                  fromPoint:CGPointMake(0, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight] - [self navBarFrameHeight])
                                                    toPoint:CGPointMake(SCREEN_WIDTH, SCREENH_HEIGHT + SCREENH_HEIGHT - [self statusBarFrameHeight] - [self navBarFrameHeight])];
    }
    return _bottomCollisionBehavior;
}

-(UIGravityBehavior *)gravityBeahvior{
    if (!_gravityBeahvior) {
        _gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.articleDetailContentViewController.view]];
        _gravityBeahvior.gravityDirection = CGVectorMake(0, GRAVITYCOEFFICIENT);
    }
    return _gravityBeahvior;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}
- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.view];
    CGPoint velocity = [gesture velocityInView:self.view];

    NSLog(@"%f",velocity.y);
    UIView* draggedView = gesture.view;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{

            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:draggedView attachedToAnchor:CGPointMake(gesture.view.superview.center.x, touchPoint.y)];
            [self.animator addBehavior:self.attachmentBehavior];
            self.lastAnchorPoint = touchPoint;
            NSLog(@"start anchor y: %f",self.lastAnchorPoint.y);
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
            
            [self.animator removeBehavior:self.topFieldBehavior];
            [self.animator removeBehavior:self.bottomFieldBehavior];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            self.lastAnchorPoint = CGPointZero;
            CGFloat fraction = touchPoint.y / (SCREENH_HEIGHT);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldExpandState = (fraction < 0.5);
            [self.animator removeBehavior:self.attachmentBehavior];
            
            if (!self.shouldExpandState) {
                self.gravityBeahvior.gravityDirection = CGVectorMake(0, 3);
                [self.animator addBehavior:self.bottomFieldBehavior];
                [self.animator addBehavior:self.bottomCollisionBehavior];
            }else{
                self.gravityBeahvior.gravityDirection = CGVectorMake(0, -3);
                [self.animator addBehavior:self.topFieldBehavior];
                [self.animator addBehavior:self.topCollisionBehavior];
                
            }
            
            
            break;
        }
        default:
            break;
    }
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
#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender{
//    NSDictionary *params = @{@"page": @"1"};
    [self.refreshControl beginRefreshing];
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleDetailPathWithArticleId:self.articleId] param:nil requestType:GET];
    //    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.refreshControl endRefreshing];
}
#pragma mark - network callback
-(void)engine:(TKSBaseRequestEngine *)engine didRequestFinishedWithData:(id)data andError:(NSError *)error{
    if ([engine isEqual:self.requestEngine]) {
        NSDictionary *articleDetail = [data objectForKey:@"results"];
        self.arrArticleDiscussPointDataSource = [NSArray arrayWithArray:[articleDetail objectForKey:@"article_responses"]];
        NSArray *htmlContentInfosList = [articleDetail objectForKey:@"article_html_contents"];
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
        self.articleHtmlContent = contentString;//[articleDetail objectForKey:@"article_html_content"];
        self.articleDetailContentViewController.htmlContentString = self.articleHtmlContent;
        [self.articleDetailContentViewController setUpTextViewWithArticleHtmlContent:self.articleDetailContentViewController.htmlContentString];
        self.articleDisscussDataSource.items = self.arrArticleDiscussPointDataSource;
        [self.articleResponseListTableView reloadData];
        [self finishRefreshControl];
        //        NSLog(@"%@",data);
    }
    
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
        _articleResponseListTableView = [[UITableView alloc] init];
        
        _articleResponseListTableView.delegate = self;
        _articleResponseListTableView.dataSource = self.articleDisscussDataSource;
        _articleResponseListTableView.alwaysBounceVertical = YES;
        
        _articleResponseListTableView.rowHeight = UITableViewAutomaticDimension;
        _articleResponseListTableView.estimatedRowHeight = 50;
        
        _articleResponseListTableView.separatorStyle = NO;
        
        [_articleResponseListTableView registerClass:[TKSArticleResponseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TKSArticleResponseTableViewCell class])];
        [_articleResponseListTableView registerClass:[TKSBaseLoadMoreTableViewCell class] forCellReuseIdentifier:NSStringFromClass([TKSBaseLoadMoreTableViewCell class])];
        _articleResponseListTableView.backgroundColor = rgb(247, 247, 247);
    }
    return _articleResponseListTableView;
}
-(NSArray *)sampleArray{
    return @[];
}
-(TKSBaseArrayWithLoadMoreItemDataSource *)articleDisscussDataSource{
    if (!_articleDisscussDataSource) {
        
        _articleDisscussDataSource = [[TKSBaseArrayWithLoadMoreItemDataSource alloc]initWithArray:[self sampleArray] cellReuseIdentifier:NSStringFromClass([TKSArticleResponseTableViewCell class]) configureCellBlock:^(id cell, id item) {
            TKSArticleResponseTableViewCell *discussPointCell = (TKSArticleResponseTableViewCell*)cell;
            
            NSString *quote = @"";
            NSString *paraIdentifer = @"";
            NSString *response = @"";
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"quote"] isEqual:[NSNull null]] &&[item objectForKey:@"quote"]) {
                quote = [item objectForKey:@"quote"];
            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"response"] isEqual:[NSNull null]] &&[item objectForKey:@"response"]) {
                response = [item objectForKey:@"response"];
            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"quote_identifer"] isEqual:[NSNull null]] &&[item objectForKey:@"quote_identifer"]) {
                paraIdentifer = [item objectForKey:@"quote_identifer"];
            }
            [discussPointCell setQuoteText:quote];
            [discussPointCell setResponseText:response];
            [discussPointCell setParaIdentifer:paraIdentifer];
            //            [articleCell.lblArticleTitle setText:[NSString stringWithFormat:@"%ld",[item integerValue]]];
            //            [articleCell.lblArticleBriefText setText:[self stringWithLineNumber:[self getRandomNumberBetween:1 and:5]]];
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
