//
//  TKSTextStorage.m
//  TextKitSample
//
//  Created by Vincent on 2017/4/25.
//  Copyright © 2017年 Vincent. All rights reserved.
//

#import "TKSTextStorage.h"

@implementation TKSTextStorage{
    NSMutableAttributedString *_imp;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _imp = [NSMutableAttributedString new];
    }
    return self;
}
-(NSString *)string{
    return [_imp string];
}
- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(nullable NSRangePointer)range
{
    return [_imp attributesAtIndex:location effectiveRange:range];
}
-(void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedAttributes|NSTextStorageEditedCharacters range:range changeInLength:str.length-range.length];
    [self endEditing];
}
-(void)setAttributes:(NSDictionary<NSString *,id> *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}
//-(void)processEditing{
//    NSRange lineRange = NSUnionRange(self.editedRange, [self.string lineRangeForRange:self.editedRange]);  //正在编辑的整个段落范围
//    [self.attributedString.string enumerateSubstringsInRange:lineRange options:NSStringEnumerationByWords usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
//        if ([substring isEqualToString:@"GGGHub"]) {
//            [self setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:substringRange];  //当出现GGGHub单词时字体变红
//        }
//        else{
//            [self setAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:substringRange]; //默认字体是黑色
//        }
//    }];
//    [super processEditing];
//}
@end
