//
//  UIColor+TKSColorScheme.m
//  TextKitSample
//
//  Created by Vincent on 2017/8/4.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "UIColor+TKSColorScheme.h"

@implementation UIColor (TKSColorScheme)

/**
 Base color scheme

 @return base color scheme
 */
+(UIColor *)deepGreenColor{
    return rgb(65, 117, 5);
}
+(UIColor *)mediumGreenColor{
    return rgb(160, 210, 80);
}
+(UIColor *)lightGreenColor{
    return rgb(200, 230, 100);
}
+(UIColor *)mediumGrayColor{
    return rgb(199, 199, 240);
}

+(UIColor *)lightGrayColor{
    return rgb(178, 178, 178);
}


+(UIColor *)navigationBarTitleTextColor{
    return [UIColor mediumGreenColor];
}

+(UIColor *)navigationBarBackgroundColor{
    return [UIColor deepGreenColor];
}

+(UIColor *)weakHintTextColor{
    return [UIColor lightGrayColor];
}

+(UIColor *)weakHintUserInterfaceControlColor{
    return [UIColor lightGrayColor];
}
+(UIColor *)selectedControlTextColor{
    return [UIColor mediumGreenColor];
}
+(UIColor *)diselectedControlTextColor{
    return [UIColor lightGreenColor];
}
+(UIColor *)highlightTextColor{
    return [UIColor deepGreenColor];
}

+(UIColor *)unhighlightTextColor{
    return [UIColor mediumGreenColor];
}

+(UIColor *)highlightUserInterfaceControlColor{
    return [UIColor mediumGreenColor];
}

+(UIColor *)unhighlightUserInterfaceControlColor{
    return [UIColor lightGreenColor];
}

+(UIColor *)articleMainBodyTextColor{
    return [UIColor blackColor];
}


@end
