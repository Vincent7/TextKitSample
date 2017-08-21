//
//  TKSArticleDetailViewController.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/12.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VJResponderChangeableScrollView.h"
@interface TKSArticleDetailViewController : UIViewController
@property (nonatomic, strong) NSString *htmlContentString;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, readonly)VJResponderChangeableScrollView *scrollView;
@property (nonatomic, readonly) UIView *titleContainer;

@property (nonatomic, assign) CGFloat expendAnimProgress;
- (void)setUpTextViewWithArticleHtmlContent:(NSString *)htmlContent;
- (void)scrollWithParaIdentifer:(NSString *)paraIdentifer;
@end
