//
//  TKSArticleDetailViewController.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/12.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKSArticleDetailViewController : UIViewController
@property (nonatomic, strong)NSString *htmlContentString;
- (void)setUpTextViewWithArticleHtmlContent:(NSString *)htmlContent;
@end
