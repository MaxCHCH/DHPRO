//
//  ZDStagLabel.h
//  zhidoushi
//
//  Created by nick on 15/8/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "WPHotspotLabel.h"
typedef void(^tagClick)(NSString *tag);
typedef void(^otherClick)();
@interface ZDStagLabel : WPHotspotLabel
@property(nonatomic,strong)UIColor *fontColor;//字体颜色
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)tagClick tagClick;//标签点击事件
@property(nonatomic,copy)otherClick otherClick;//标签点击事件
-(void)setContent:(NSString *)content WithTagClick:(tagClick)tag AndOtherClick:(otherClick)other;
@end
