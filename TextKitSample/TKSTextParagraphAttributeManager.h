//
//  TKSTextParagraphAttributeManager.h
//  TextKitSample
//
//  Created by Vincent on 2017/5/10.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TKSTextParagraphAttributeManager : NSObject
+ (NSDictionary *)articleListTitleTextAttributeInfo;
+ (NSDictionary *)articleListSubtitleTextAttributeInfo;

+ (NSDictionary *)articleDiscussPointResponseTextAttributeInfo;
+ (NSDictionary *)articleDiscussPointQuoteTextAttributeInfo;
+ (NSDictionary *)articleDiscussPointQuotePositionLabelTextAttributeInfo;

+ (NSDictionary *)refreshControlTextAttributeInfo;
@end
