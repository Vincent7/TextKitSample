//
//  UIImage+TKSTableViewBoundaryShadow.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/30.
//  Copyright © 2017年 Vincent. All rights reserved.
//
typedef enum {
    TKSShadowDirectUp,
    TKSShadowDirectDown
} TKSShadowDirect;
#import <UIKit/UIKit.h>

@interface UIImage (TKSTableViewBoundaryShadow)
+ (UIImage *)boundaryShadowImageWithDirect:(TKSShadowDirect)direct andShadowSize:(CGSize)size andShadowColor:(UIColor *)color;
+ (UIImage *)upperBoundaryShadowImage;
+ (UIImage *)lowerBoundaryShadowImage;
@end
