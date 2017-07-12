//
//  TKSTextParagraphAttributeManager.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/10.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSTextParagraphAttributeManager.h"

@implementation TKSTextParagraphAttributeManager
+ (NSDictionary *)articleListTitleTextAttributeInfo {


    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];

    UIColor *textColor = [UIColor blackColor];
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleListTitleFont];
    [attributes setValue:textFont forKey:NSFontAttributeName];

    [attributes setValue:[self articleListTitleTextStyle] forKey:NSParagraphStyleAttributeName];

    return attributes;
}

+ (NSMutableParagraphStyle *)articleListTitleTextStyle {

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];

    style.lineSpacing = 3.0f;
//    style.paragraphSpacing = 25.f;
//    style.firstLineHeadIndent = 0.f;

    return style;
}

+ (NSDictionary *)articleListSubtitleTextAttributeInfo {
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(123, 123, 123);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleListSubtitleFont];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    //创建段落样式
    [attributes setValue:[self articleListSubtitleTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSMutableParagraphStyle *)articleListSubtitleTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    
    return style;
}

+ (NSDictionary *)articleDiscussPointQuoteTextAttributeInfo {
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(0, 0, 0);
//    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointQuoteTextFont];
//    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointQuoteTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSMutableParagraphStyle *)articleDiscussPointQuoteTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    
    return style;
}

+ (NSDictionary *)articleDiscussPointResponseTextAttributeInfo {
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(0, 0, 0);
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointResponseTextFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointResponseTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSMutableParagraphStyle *)articleDiscussPointResponseTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    
    return style;
}

+ (NSDictionary *)articleDiscussPointQuotePositionLabelTextAttributeInfo {
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(74, 144, 226);
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointQuotePositionLabelFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointResponseTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}


+ (NSDictionary *)refreshControlTextAttributeInfo {
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(74, 144, 226);
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont refreshControlFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    [attributes setValue:[self refreshControlTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}
+ (NSMutableParagraphStyle *)refreshControlTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    style.alignment = NSTextAlignmentCenter;
    return style;
}
+ (NSMutableParagraphStyle *)articleDiscussPointQuotePositionLabelTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    
    return style;
}
@end
