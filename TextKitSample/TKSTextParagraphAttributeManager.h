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

/**
 Discuss points and response notes list quote text on QuoteSectionHeader

 @return QuoteSectionHeader quote text attribute
 */
+ (NSDictionary *)articleQuoteTextAttributeInfo;
+ (NSDictionary *)articleQuoteReadInArticleAttributeInfo;
+ (NSDictionary *)articleQuoteAddNoteAttributeInfo;
+ (NSDictionary *)articleDiscussPointResponseUserNameAttributeInfo;
+ (NSDictionary *)articleDiscussPointResponseReadingTimeAttributeInfo;

+ (NSDictionary *)articleDiscussPointResponseHintTitleStringAttributeInfo;
+ (NSDictionary *)articleDiscussPointResponseNavigationBarTitleAttributeInfo;

+ (NSDictionary *)articleDiscussPointResponseFavButtonDiselectedAttributeInfo;
+ (NSDictionary *)articleDiscussPointResponseFavButtonSelectedAttributeInfo;
+ (NSDictionary *)articleDisscussPointSeeMoreFooterTitleAttributeInfo;
@end
