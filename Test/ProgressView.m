//
//  ProgressView.m
//  ProgressViewDemo
//
//  Created by 思 彭 on 2017/4/20.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView ()

@end

@implementation ProgressView


-(void)drawRect:(CGRect)rect{
    
    // 创建贝瑟尔路径
    
    /*
    CGFloat width = self.progress / rect.size.width * rect.size.width;
    // 显示的宽度 = 服务器返回的数值 / 设置的总宽度 * 满值;
     
     显示的宽度= 满值 * 比例值
     比例值 = 服务器返回的宽度 / 满值
     */
    
    CGFloat width = rect.size.width * self.progress / rect.size.width;
     // 显示的宽度 = 服务器返回的数值 * 设置的总宽度 /  满值;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, rect.size.height) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(rect.size.height, rect.size.height)];
    [[UIColor redColor] setFill];
    [path fill];
}

- (void)setProgress:(CGFloat)progress{
    
    _progress = progress;
    // 重绘，系统会先创建与view相关联的上下文，然后再调用drawRect
    [self setNeedsDisplay];
}


@end
