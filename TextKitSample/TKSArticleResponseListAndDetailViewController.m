//
//  TKSArticleResponseListAndDetailViewController.m
//  TextKitSample
//
//  Created by Vincent on 2017/6/5.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseListAndDetailViewController.h"
#import "TKSBaseRequestEngine.h"
#import "CBStoreHouseRefreshControl.h"

#import "TKSBaseArrayWithLoadMoreItemDataSource.h"
#import "TKSArticleResponseTableViewCell.h"

#import "TKSArticleDetailViewController.h"

typedef enum : NSUInteger {
    barCollapsed,
    barExpanded,
    barScrolling,
} TKSScrollableNavigationBarState;
@interface TKSArticleResponseListAndDetailViewController () <UITableViewDelegate,TKSBaseRequestEngineDelegate,UICollisionBehaviorDelegate>
@property (nonatomic, strong) UITableView *articleResponseListTableView;
@property (nonatomic, strong) NSArray *arrArticleDiscussPointDataSource;
@property (nonatomic, strong) TKSBaseArrayWithLoadMoreItemDataSource *articleDisscussDataSource;

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@property (nonatomic, strong) TKSBaseRequestEngine *requestEngine;

@property (nonatomic, strong) NSString *articleHtmlContent;
@property (nonatomic, strong) TKSArticleDetailViewController *articleDetailContentViewController;
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


@end
#define GRAVITYCOEFFICIENT 1.0
@implementation TKSArticleResponseListAndDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSDictionary *params = @{@"page": @"1"};
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleDetailPathWithArticleId:self.articleId] param:nil requestType:GET];
    [self.view addSubview:self.articleResponseListTableView];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [self.view addSubview:self.articleDetailContentViewController.view];
    [self addChildViewController:self.articleDetailContentViewController];//  2
    [self.articleDetailContentViewController didMoveToParentViewController:self];
    
    [self.articleDetailContentViewController.view addObserver:self forKeyPath:@"center" options:NSKeyValueObservingOptionNew context:nil];
    
    self.lastAnchorPoint = CGPointZero;
//    [self.view addSubview:self.sampleView];
    
    
    //    [self.animator addBehavior:self.snapBeahvior];
    // Do any additional setup after loading the view.
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
-(void)dealloc{
    [self.articleDetailContentViewController.view removeObserver:self forKeyPath:@"center"];
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
    [self.articleDetailContentViewController.view setFrame:CGRectMake(0, SCREENH_HEIGHT - [self navBarFrameHeight] - 1, SCREEN_WIDTH, SCREENH_HEIGHT - [self statusBarFrameHeight])];
//    self.lastContentOffset = SCREENH_HEIGHT - 45;
    self.articleState = barCollapsed;
//    [self.articleDetailContentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self.view.mas_height);
//        make.width.equalTo(self.view.mas_width);
////        make.top.equalTo(self.view.mas_bottom).offset(-44);
////        make.bottom.equalTo(@0);
//    }];
    
    
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

- (void)refreshTriggered:(id)sender{
//    NSDictionary *params = @{@"page": @"1"};
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleDetailPathWithArticleId:self.articleId] param:nil requestType:GET];
    //    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.storeHouseRefreshControl finishingLoading];
}
#pragma mark - network callback
-(void)engine:(TKSBaseRequestEngine *)engine didRequestFinishedWithData:(id)data andError:(NSError *)error{
    if ([engine isEqual:self.requestEngine]) {
        NSDictionary *articleDetail = [data objectForKey:@"results"];
        self.arrArticleDiscussPointDataSource = [NSArray arrayWithArray:[articleDetail objectForKey:@"article_responses"]];
        self.articleHtmlContent = [articleDetail objectForKey:@"article_html_content"];
        self.articleDetailContentViewController.htmlContentString = self.articleHtmlContent;
        [self.articleDetailContentViewController setUpTextViewWithArticleHtmlContent:self.articleDetailContentViewController.htmlContentString];
        self.articleDisscussDataSource.items = self.arrArticleDiscussPointDataSource;
        [self.articleResponseListTableView reloadData];
        [self finishRefreshControl];
        //        NSLog(@"%@",data);
    }
    
}
#pragma mark - setter and getter

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
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"paraIdentifer"] isEqual:[NSNull null]] &&[item objectForKey:@"paraIdentifer"]) {
                paraIdentifer = [item objectForKey:@"paraIdentifer"];
            }
            [discussPointCell setQuoteText:quote];
            [discussPointCell setResponseText:response];
            //            [articleCell.lblArticleTitle setText:[NSString stringWithFormat:@"%ld",[item integerValue]]];
            //            [articleCell.lblArticleBriefText setText:[self stringWithLineNumber:[self getRandomNumberBetween:1 and:5]]];
        }];
    }
    return _articleDisscussDataSource;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    - (id)itemAtIndexPath:(NSIndexPath *)indexPath;
    NSString *paraIdentifer = @"8f91";
    id item = [self.articleDisscussDataSource itemAtIndexPath:indexPath];
    if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"paraIdentifer"] isEqual:[NSNull null]] &&[item objectForKey:@"paraIdentifer"]) {
        paraIdentifer = [item objectForKey:@"paraIdentifer"];
        
    }
    [self.animator addBehavior:self.topFieldBehavior];
    [self.animator addBehavior:self.topCollisionBehavior];
    [self.animator removeBehavior:self.bottomFieldBehavior];
    self.shouldExpandState = YES;
    [self.articleDetailContentViewController scrollWithParaIdentifer:paraIdentifer];
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
