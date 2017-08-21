//
//  UIColor+TKSColorScheme.h
//  TextKitSample
//
//  Created by Vincent on 2017/8/4.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TKSColorScheme)

+ (UIColor *)navigationBarBackgroundColor;
+ (UIColor *)navigationBarTitleTextColor;
+ (UIColor *)weakHintTextColor;
+ (UIColor *)weakHintUserInterfaceControlColor;
+ (UIColor *)selectedControlTextColor;
+ (UIColor *)diselectedControlTextColor;
+ (UIColor *)highlightTextColor;
+ (UIColor *)unhighlightTextColor;
+ (UIColor *)highlightUserInterfaceControlColor;
+ (UIColor *)unhighlightUserInterfaceControlColor;
+ (UIColor *)articleMainBodyTextColor;

@end
