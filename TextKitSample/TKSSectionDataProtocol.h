//
//  TKSSectionDataProtocol.h
//  TextKitSample
//
//  Created by Vincent on 2017/7/26.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TKSSectionDataProtocol <NSObject>
- (NSArray *) rowDataList;
- (id) sectionData;
- (BOOL) shouldExpandList;
- (NSInteger) dataNumberShownOriginal;
- (NSInteger) sectionIndex;
@end
