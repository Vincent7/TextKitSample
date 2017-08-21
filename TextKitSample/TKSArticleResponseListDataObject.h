//
//  TKSArticleResponseListDataObject.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TKSSectionDataProtocol.h"
@interface TKSArticleResponseListDataObject : NSObject<TKSSectionDataProtocol>
-(instancetype)initWithQuoteText:(NSString *)text andResponses:(NSArray *)responsesList;

@property (nonatomic, strong) NSArray *responsesList;
@property (nonatomic, copy) NSString *quoteText;
@property (nonatomic, assign) BOOL shouldExpandList;
@property (nonatomic, readonly) NSInteger dataNumberShownOriginal;
@property (nonatomic, assign) NSInteger sectionIndex;
@end
