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
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
}

+(UIFont *)articleSubtitleFontOfSize:(CGFloat)fontSize{
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
}

+(UIFont *)articleTextFontOfSize:(CGFloat)fontSize{
    return [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
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
@end
