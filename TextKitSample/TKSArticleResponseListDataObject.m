//
//  TKSArticleResponseListDataObject.m
//  TextKitSample
//
//  Created by Vincent on 2017/7/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSArticleResponseListDataObject.h"
@interface TKSArticleResponseListDataObject()

@end

@implementation TKSArticleResponseListDataObject
-(instancetype)initWithQuoteText:(NSString *)text andResponses:(NSArray *)responsesList{
    if ([super init]) {
        self.responsesList = responsesList;
        self.quoteText = text;
    }
    return self;
}
-(NSArray *)rowDataList{
    return self.responsesList;
}
-(id)sectionData{
    return self.quoteText;
}
-(NSInteger)dataNumberShownOriginal{
    return 5;
}
@end
