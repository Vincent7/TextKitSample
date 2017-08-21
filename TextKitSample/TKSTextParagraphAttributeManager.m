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
    
    return [self NormalTextStyle];
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
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    return style;
}
+ (NSMutableParagraphStyle *)articleDiscussPointReadInArticleStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByTruncatingTail;
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
//    style.alignment = NSTextAlignmentLeft;
    return style;
}
+ (NSMutableParagraphStyle *)articleDiscussPointAddNoteStyle {
    
    return [self NormalTextStyle];
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
+ (NSMutableParagraphStyle *)NormalTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    
    return style;
}
+ (NSMutableParagraphStyle *)articleDiscussPointResponseTextStyle {
    return [self NormalTextStyle];
}
+ (NSMutableParagraphStyle *)articleDiscussPointResponseUserNameTextStyle {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineSpacing = 3.0f;
    style.paragraphSpacing = 0.f;
    style.firstLineHeadIndent = 0.f;
    style.alignment = NSTextAlignmentRight;
    
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

+ (NSDictionary *)articleQuoteTextAttributeInfo {
    
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = [UIColor highlightTextColor];//TODO: 颜色管理
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointQuoteTextFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointQuoteTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleQuoteReadInArticleAttributeInfo {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgba(0, 0, 0, 0.54);
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointQuoteButtonTextFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointReadInArticleStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleQuoteAddNoteAttributeInfo {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgba(0, 0, 0, 0.54);
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointQuoteButtonTextFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointAddNoteStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleDiscussPointResponseUserNameAttributeInfo {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(0, 0, 0);
    
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointResponseUserNameLabelFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointResponseUserNameTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleDiscussPointResponseReadingTimeAttributeInfo {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = rgb(0, 0, 0);
    
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointResponseReadingTimeLabelFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self articleDiscussPointResponseTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleDiscussPointResponseHintTitleStringAttributeInfo {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = [UIColor unhighlightTextColor];
    
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointResponsePageTitleLabelFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self NormalTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}
+ (NSDictionary *)articleDiscussPointResponseNavigationBarTitleAttributeInfo;{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = [UIColor navigationBarTitleTextColor];
    
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointResponsePageTitleLabelFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self NormalTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleDiscussPointResponseFavButtonDiselectedAttributeInfo;{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = [UIColor diselectedControlTextColor];
    
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointFavButtonTitleFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self NormalTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}
+ (NSDictionary *)articleDiscussPointResponseFavButtonSelectedAttributeInfo;{
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = [UIColor selectedControlTextColor];
    
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointFavButtonTitleFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self NormalTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}

+ (NSDictionary *)articleDisscussPointSeeMoreFooterTitleAttributeInfo {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    UIColor *textColor = [UIColor lightGrayColor];
    //    UIColor *backgroudColor = rgb(236, 241, 255);
    [attributes setValue:textColor forKey:NSForegroundColorAttributeName];
    UIFont *textFont = [UIFont articleDiscussPointSeeMoreFooterButtonTitleFont];
    //    [attributes setValue:backgroudColor forKey:NSBackgroundColorAttributeName];
    [attributes setValue:textFont forKey:NSFontAttributeName];
    
    //创建段落样式
    [attributes setValue:[self NormalTextStyle] forKey:NSParagraphStyleAttributeName];
    
    return attributes;
}
@end
