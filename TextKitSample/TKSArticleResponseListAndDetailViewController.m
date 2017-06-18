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
@interface TKSArticleResponseListAndDetailViewController () <UITableViewDelegate,TKSBaseRequestEngineDelegate>
@property (nonatomic, strong) UITableView *articleResponseListTableView;
@property (nonatomic, strong) NSArray *arrArticleDiscussPointDataSource;
@property (nonatomic, strong) TKSBaseArrayWithLoadMoreItemDataSource *articleDisscussDataSource;

@property (nonatomic, strong) CBStoreHouseRefreshControl *storeHouseRefreshControl;
@property (nonatomic, strong) TKSBaseRequestEngine *requestEngine;

@property (nonatomic, strong) NSString *articleHtmlContent;
@property (nonatomic, strong) UIViewController *articleDetailContentViewController;
@property (nonatomic, strong) UIView *sampleView;

@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic, assign) BOOL shouldExpandState;
@property (nonatomic, assign) CGFloat percentComplete;
@property (nonatomic, assign) BOOL interacting;

@property (nonatomic, strong) UIView *animationContainerView;
@property (nonatomic, strong) UIDynamicAnimator* animator;
@property (nonatomic, strong) UIDynamicBehavior* topBottomBehavior;

@property (nonatomic, strong) UIGravityBehavior* gravityBeahvior;
@property (nonatomic, strong) UISnapBehavior* snapBeahvior;
@property (nonatomic, strong) UIAttachmentBehavior* attachmentBehavior;
@property (nonatomic, strong) UICollisionBehavior* collisionBehavior;

@property (nonatomic, strong) UIFieldBehavior *topFieldBehavior;
@property (nonatomic, strong) UIFieldBehavior *bottomFieldBehavior;
@end

@implementation TKSArticleResponseListAndDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSDictionary *params = @{@"page": @"1"};
    self.requestEngine = [TKSBaseRequestEngine control:self path:[TKSNetworkingRequestPathManager articleDetailPathWithArticleId:self.articleId] param:nil requestType:GET];
    [self.view addSubview:self.articleResponseListTableView];
    [self.view addSubview:self.animationContainerView];
    
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithWhite:0.1 alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
//    [self.animationContainerView addSubview:self.articleDetailContentViewController.view];
//    [self addChildViewController:self.articleDetailContentViewController];//  2
//    [self.articleDetailContentViewController didMoveToParentViewController:self];
    [self.view addSubview:self.sampleView];
    
    
    //    [self.animator addBehavior:self.snapBeahvior];
    // Do any additional setup after loading the view.
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
    [self.animationContainerView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT)];
    [self.sampleView setFrame:CGRectMake(0, SCREENH_HEIGHT - 45, SCREEN_WIDTH, SCREENH_HEIGHT)];
//    [self.articleDetailContentViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(self.view.mas_height);
//        make.width.equalTo(self.view.mas_width);
////        make.top.equalTo(self.view.mas_bottom).offset(-44);
////        make.bottom.equalTo(@0);
//    }];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self.animator setValue:@(TRUE) forKey:@"debugEnabled"];

    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.sampleView]];
//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [collisionBehavior addBoundaryWithIdentifier:@"TopBoundary" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(SCREEN_WIDTH, 0)];
//    [collisionBehavior addBoundaryWithIdentifier:@"LeftBoundary" fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, SCREENH_HEIGHT)];
//    [collisionBehavior addBoundaryWithIdentifier:@"RightBoundary" fromPoint:CGPointMake(SCREEN_WIDTH, 0) toPoint:CGPointMake(SCREEN_WIDTH, SCREENH_HEIGHT)];
    [collisionBehavior addBoundaryWithIdentifier:@"bottomBoundary" fromPoint:CGPointMake(0, SCREENH_HEIGHT + SCREENH_HEIGHT - 44) toPoint:CGPointMake(SCREEN_WIDTH, SCREENH_HEIGHT + SCREENH_HEIGHT - 44)];
    self.collisionBehavior = collisionBehavior;
//
    UIGravityBehavior *g = [[UIGravityBehavior alloc] initWithItems:@[self.sampleView]];
    g.gravityDirection = CGVectorMake(0, 1);
    self.gravityBeahvior = g;
//
    self.topBottomBehavior = [[UIDynamicBehavior alloc]init];
    

    self.topFieldBehavior = [UIFieldBehavior springField];
    [self.topFieldBehavior addItem:self.sampleView];
    [self.topFieldBehavior setPosition:self.animationContainerView.center];
    [self.topFieldBehavior setStrength:2];
    UIRegion *topFieldRegion = [[UIRegion alloc]initWithSize:CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT)];
    [self.topFieldBehavior setRegion:topFieldRegion];
    
    self.bottomFieldBehavior = [UIFieldBehavior springField];
    [self.bottomFieldBehavior addItem:self.sampleView];
    [self.bottomFieldBehavior setPosition:CGPointMake(SCREEN_WIDTH/2, SCREENH_HEIGHT + SCREENH_HEIGHT/2 - 44)];
    [self.bottomFieldBehavior setStrength:2];
    UIRegion *bottomFieldRegion = [[UIRegion alloc]initWithSize:CGSizeMake(SCREEN_WIDTH, SCREENH_HEIGHT/2)];
    [self.bottomFieldBehavior setRegion:bottomFieldRegion];
    
//    [self.topBottomBehavior addChildBehavior:self.collisionBehavior];
//    [self.topBottomBehavior addChildBehavior:self.topFieldBehavior];
//    [self.topBottomBehavior addChildBehavior:self.bottomFieldBehavior];
    
    [self.animator addBehavior:self.collisionBehavior];
    [self.animator addBehavior:self.gravityBeahvior];
//    [self.animator addBehavior:self.topFieldBehavior];
//    [self.animator addBehavior:self.bottomFieldBehavior];
//    self.topFieldBehavior = [[UIFieldBehavior alloc]init]

    
    [self prepareGestureRecognizerInView:self.sampleView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [view addGestureRecognizer:gesture];
}
-(CGFloat)completionSpeed
{
    return 1 - self.percentComplete;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint touchPoint = [gesture locationInView:self.animationContainerView];
    CGPoint translationPoint = [gesture translationInView:gesture.view.superview];
    UIView* draggedView = gesture.view;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
//            self.interacting = YES;
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:draggedView attachedToAnchor:CGPointMake(gesture.view.superview.center.x, touchPoint.y)];
            [self.animator addBehavior:self.attachmentBehavior];

            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat fraction = touchPoint.y / (SCREENH_HEIGHT);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
//            self.shouldExpandState = (fraction > 0.5);
            CGFloat anchorYOffset;
            if (self.shouldExpandState) {
                anchorYOffset = 0;//- fraction * SCREENH_HEIGHT/4;
            }else{
                anchorYOffset = 0;//fraction * SCREENH_HEIGHT/4;
            }
            [self.attachmentBehavior setAnchorPoint:CGPointMake(gesture.view.superview.center.x, touchPoint.y + anchorYOffset)];
            [self.animator removeBehavior:self.gravityBeahvior];
//            [self.animator removeBehavior:self.topFieldBehavior];
//            [self.animator removeBehavior:self.bottomFieldBehavior];
//            [self.topBottomBehavior removeChildBehavior:self.topFieldBehavior];
//            [self.topBottomBehavior removeChildBehavior:self.bottomFieldBehavior];
//            CGPoint point = [gesture locationInView:self.view];
//            [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
            
            // 2. Calculate the percentage of guesture
            
            //Limit it between 0 and 1
            
//            [self updateInteractiveTransition:fraction];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            CGFloat fraction = touchPoint.y / (SCREENH_HEIGHT);
            fraction = fminf(fmaxf(fraction, 0.0), 1.0);
            self.shouldExpandState = (fraction > 0.5);
            [self.animator removeBehavior:self.attachmentBehavior];
            [self.animator addBehavior:self.gravityBeahvior];
//            [self.animator addBehavior:self.topFieldBehavior];
//            [self.animator addBehavior:self.bottomFieldBehavior];
//            [self.topBottomBehavior addChildBehavior:self.topFieldBehavior];
//            [self.topBottomBehavior addChildBehavior:self.bottomFieldBehavior];
//            self.interacting = NO;
            if (self.shouldExpandState) {
                self.gravityBeahvior.gravityDirection = CGVectorMake(0, 1);
            }else{
                self.gravityBeahvior.gravityDirection = CGVectorMake(0, -1);
            }
//            if (!self.shouldComplete || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
//                [self cancelInteractiveTransition];
//            } else {
//                [self finishInteractiveTransition];
//                self.isExpandState = !self.isExpandState;
//            }
            break;
        }
        default:
            break;
    }
}
//-(void)cancelInteractiveTransition{
//    CGFloat y;
//    if (!self.isExpandState) {
//        y = SCREENH_HEIGHT - 44;
//    }else{
//        y = 0;
//    }
//    [self.articleDetailContentViewController.view setFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREENH_HEIGHT)];
//}
//-(void)finishInteractiveTransition{
//    CGFloat y;
//    if (!self.isExpandState) {
//        y = 0;
//    }else{
//        y = SCREENH_HEIGHT - 44;
//    }
//    [self.articleDetailContentViewController.view setFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREENH_HEIGHT)];
//}
//-(void)updateInteractiveTransition:(CGFloat)fraction{
//    CGFloat y;
//    if (!self.isExpandState) {
//        y = SCREENH_HEIGHT * (1 - fraction);
//    }else{
//        y = (SCREENH_HEIGHT - 44) * (fraction);
//    }
//    [self.articleDetailContentViewController.view setFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREENH_HEIGHT)];
//}
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
        self.articleDisscussDataSource.items = self.arrArticleDiscussPointDataSource;
        [self.articleResponseListTableView reloadData];
        [self finishRefreshControl];
        //        NSLog(@"%@",data);
    }
    
}
#pragma mark - setter and getter
-(UIView *)sampleView{
    if (!_sampleView) {
        _sampleView = [[UIView alloc]init];
        _sampleView.backgroundColor = [UIColor yellowColor];
        _sampleView.userInteractionEnabled = YES;
    }
    return _sampleView;
}
-(UIView *)animationContainerView{
    if (!_animationContainerView) {
        _animationContainerView = [[UIView alloc]init];
        _animationContainerView.backgroundColor = [UIColor clearColor];
        _animationContainerView.userInteractionEnabled = NO;
    }
    return _animationContainerView;
}
-(UIViewController *)articleDetailContentViewController{
    if (!_articleDetailContentViewController) {
        _articleDetailContentViewController = [UIViewController new];
        _articleDetailContentViewController.view.backgroundColor = [UIColor blueColor];
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
            NSString *response = @"";
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"quote"] isEqual:[NSNull null]] &&[item objectForKey:@"quote"]) {
                quote = [item objectForKey:@"quote"];
            }
            if ([item respondsToSelector:@selector(objectForKey:)] && ![[item objectForKey:@"response"] isEqual:[NSNull null]] &&[item objectForKey:@"response"]) {
                response = [item objectForKey:@"response"];
            }
            [discussPointCell setQuoteText:quote];
            [discussPointCell setResponseText:response];
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
