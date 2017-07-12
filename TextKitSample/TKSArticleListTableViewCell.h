//
//  TKSArticleListTableViewCell.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/9.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTCoreText.h"
@interface TKSArticleListTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblArticleTitle;
@property (nonatomic, strong) UILabel *lblArticleBriefText;
@property (nonatomic, strong) DTLazyImageView *previewImageView;

- (void)setArticleTitleText:(NSString *)title;
- (void)setArticleSubtitleText:(NSString *)subtitle;
- (void)setArticleBriefText:(NSString *)brief;
- (void)setImageUrls:(NSArray *)imageUrls andImageDataSize:(CGSize)imageDataSize;
@end
