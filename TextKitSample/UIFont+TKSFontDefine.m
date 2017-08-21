//
//  UIFont+TKSFontDefine.m
//  TextKitSample
//
//  Created by Vincent on 2017/5/10.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "UIFont+TKSFontDefine.h"

@implementation UIFont(TKSFontDefine)
+(UIFont *)articleTitleFontOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-Bold" size:fontSize];
//    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
}

+(UIFont *)articleSubtitleFontOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-Medium" size:fontSize];
//    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}



+(UIFont *)articleTextFontOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-Regular" size:fontSize];
//    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
}

+(UIFont *)articleDiscussPointQuoteTextOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-SemiBoldItalic" size:fontSize];
//    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
}
+(UIFont *)articleDiscussPointSubTextOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-MediumItalic" size:fontSize];
    //    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
}

+(UIFont *)articleDiscussPointResponseTextOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-Medium" size:fontSize];
    //    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
}
+(UIFont *)articleDiscussPointQuotePositionLabelTextOfSize:(CGFloat)fontSize{
    return [UIFont fontWithName:@"Raleway-Medium" size:fontSize];
    //    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
}

+(UIFont *)articleListTitleFont{
    return [UIFont articleTitleFontOfSize:24];
}
+(UIFont *)articleListSubtitleFont{
    return [UIFont articleSubtitleFontOfSize:16];
}
+(UIFont *)articleListBriefFont{
    return [UIFont articleTextFontOfSize:16];
}

+(UIFont *)articleDiscussPointQuoteTextFont{
    return [UIFont articleDiscussPointQuoteTextOfSize:16];
}

+(UIFont *)articleDiscussPointQuoteButtonTextFont{
    return [UIFont articleDiscussPointQuoteTextOfSize:16];
}

+(UIFont *)articleDiscussPointResponseTextFont{
    return [UIFont articleDiscussPointResponseTextOfSize:18];
}

+(UIFont *)articleDiscussPointQuotePositionLabelFont{
    return [UIFont articleDiscussPointResponseTextOfSize:18];
}
+(UIFont *)refreshControlFont{
    return [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
}

+(UIFont *)articleDiscussPointResponseUserNameLabelFont{
    return [UIFont articleDiscussPointSubTextOfSize:14];
}
+(UIFont *)articleDiscussPointResponseReadingTimeLabelFont{
    return [UIFont articleDiscussPointSubTextOfSize:14];
}

+(UIFont *)articleDiscussPointResponsePageTitleLabelFont{
    return [UIFont fontWithName:@"Raleway-Medium" size:18];
    //    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}
+(UIFont *)articleDiscussPointFavButtonTitleFont{
    return [UIFont fontWithName:@"Raleway-Medium" size:18];
    //    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}

+(UIFont *)articleDiscussPointSeeMoreFooterButtonTitleFont{
    return [UIFont fontWithName:@"Raleway-Medium" size:14];
}
@end
