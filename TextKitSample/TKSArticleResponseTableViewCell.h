//
//  TKSArticleResponseTableViewCell.h
//  TextKitSample
//
//  Created by Vincent on 2017/6/16.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSArticleResponseTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *lblQuoteText;
@property (nonatomic, strong) UILabel *lblResponseText;

- (void)setQuoteText:(NSString *)quote;
- (void)setResponseText:(NSString *)response;
- (void)setParaIdentifer:(NSString *)paraIdentifer;
@end
