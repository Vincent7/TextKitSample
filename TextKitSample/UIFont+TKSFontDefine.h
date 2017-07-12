//
//  UIFont+TKSFontDefine.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/10.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont(TKSFontDefine)
+(UIFont *)articleTitleFontOfSize:(CGFloat)fontSize;
+(UIFont *)articleSubtitleFontOfSize:(CGFloat)fontSize;
+(UIFont *)articleTextFontOfSize:(CGFloat)fontSize;
+(UIFont *)articleDiscussPointQuoteTextOfSize:(CGFloat)fontSize;
+(UIFont *)articleDiscussPointResponseTextOfSize:(CGFloat)fontSize;


+(UIFont *)articleListTitleFont;
+(UIFont *)articleListSubtitleFont;
+(UIFont *)articleListBriefFont;
+(UIFont *)articleDiscussPointQuoteTextFont;
+(UIFont *)articleDiscussPointResponseTextFont;
+(UIFont *)articleDiscussPointQuotePositionLabelFont;

+(UIFont *)refreshControlFont;
@end
