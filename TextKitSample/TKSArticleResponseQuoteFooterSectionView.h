//
//  TKSArticleResponseQuoteFooterSectionView.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/30.
//  Copyright © 2017年 Vincent. All rights reserved.
//
@class TKSArticleResponseQuoteFooterSectionView;
@protocol TKSArticleResponseQuoteFooterSectionViewDelegate <NSObject>

- (void)footer:(TKSArticleResponseQuoteFooterSectionView *)footer didTapSeeMoreButton:(UIButton *)btnSeeMore;

@end
#import <UIKit/UIKit.h>

@interface TKSArticleResponseQuoteFooterSectionView : UITableViewHeaderFooterView
@property (nonatomic, weak) id<TKSArticleResponseQuoteFooterSectionViewDelegate>delegate;
@property (nonatomic, assign) NSInteger sectionIndex;
- (void)setShowSeeMoreButton:(BOOL)showSeeMoreButton;
@end
