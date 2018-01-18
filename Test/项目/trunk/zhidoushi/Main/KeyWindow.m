//
//  KeyWindow.m
//  zhidoushi
//
//  Created by nick on 15/8/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "KeyWindow.h"

@implementation KeyWindow
#warning 重写点击事件 超出window的视图仍然响应
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}
@end
