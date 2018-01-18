//
//  UITextField(LimitLength).h
//  zhidoushi
//
//  Created by xiang on 15-2-4.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField(LimitLength)
/**
 *  使用时只要调用此方法，加上一个长度(int)，就可以实现了字数限制
 *
 *  @param length
 */
- (void)limitTextLength:(int)length;

- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;
@end
