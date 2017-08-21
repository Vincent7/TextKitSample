//
//  UIImage+TKSTableViewBoundaryShadow.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/30.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "UIImage+TKSTableViewBoundaryShadow.h"

@implementation UIImage (TKSTableViewBoundaryShadow)

+ (UIImage *)boundaryShadowImageWithDirect:(TKSShadowDirect)direct andShadowSize:(CGSize)size andShadowColor:(UIColor *)color{
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat shadowHeight = .3;
        CGFloat fillPathOriginY = .0;
        switch (direct) {
            case TKSShadowDirectUp:
                fillPathOriginY = size.height-shadowHeight;
                break;
            case TKSShadowDirectDown:
                fillPathOriginY = .0;
                break;
            default:
                break;
        }
        
        CGPathRef fillPath = CGPathCreateWithRect(CGRectMake(0, fillPathOriginY, size.width, size.height-shadowHeight), NULL);
        
        CGContextSaveGState(context); {
            CGContextEOClip(context);
            CGColorRef shadowColor = color.CGColor;
            CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1, shadowColor);
            CGContextBeginTransparencyLayer(context, NULL); {
                CGContextAddPath(context, fillPath);
                [[UIColor colorWithWhite:1 alpha:.500] setFill];
                CGContextFillPath(context);
            } CGContextEndTransparencyLayer(context);
        } CGContextRestoreGState(context);
        CFRelease(fillPath);
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}
+ (UIImage *)upperBoundaryShadowImage {
    return [UIImage boundaryShadowImageWithDirect:TKSShadowDirectUp andShadowSize:CGSizeMake(SCREEN_WIDTH, 1) andShadowColor:[UIColor colorWithWhite:0 alpha:0.2]];
}

+ (UIImage *)lowerBoundaryShadowImage {
    
    return [UIImage boundaryShadowImageWithDirect:TKSShadowDirectDown andShadowSize:CGSizeMake(SCREEN_WIDTH, 1) andShadowColor:[UIColor colorWithWhite:0 alpha:0.2]];;
}
@end
