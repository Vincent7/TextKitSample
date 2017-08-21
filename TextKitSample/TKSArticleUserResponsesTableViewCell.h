//
//  TKSArticleUserResponsesTableViewCell.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/30.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSArticleUserResponsesTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblResponseText;
@property (nonatomic, strong) UILabel *lblUserName;
@property (nonatomic, strong) UILabel *lblReadingTime;

- (void)setResponseUserName:(NSString *)userName;
- (void)setResponseText:(NSString *)response;
- (void)setResponseReadingTime:(NSString *)readingTime;
- (void)setResponseFav:(BOOL)isFav;
- (void)setResponseFavNumber:(NSInteger)favNumber;
@end
