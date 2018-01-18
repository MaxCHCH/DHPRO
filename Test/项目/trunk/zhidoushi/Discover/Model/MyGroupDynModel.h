//
//  MyGroupDynModel.h
//  zhidoushi
//
//  Created by nick on 15/7/3.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGroupDynModel : NSObject
/*
 1.团聊
 2.团组任务
 3.团组成就
 */
@property(nonatomic,copy)NSString *dynkind;//动态类型
@property(nonatomic,copy)NSString *dynid;//动态id
@property(nonatomic,copy)NSString *content;//团聊内容
@property(nonatomic,copy)NSString *talkimage;//团聊图片
@property(nonatomic,copy)NSString *title;//标题帖标题
@property(nonatomic,copy)NSString *userid;//用户id
@property(nonatomic,copy)NSString *username;//用户名称
@property(nonatomic,copy)NSString *userimage;//用户图片
@property(nonatomic,copy)NSString *gamecrtor;// 团长用户ID
@property(nonatomic,copy)NSString *gamename;//团组名称
@property(nonatomic,copy)NSString *isparter;//是否为该团成员
/*
 1.28天
 2.欢乐
 3.普通
 */
@property(nonatomic,copy)NSString *gamemode;//团组模式
@property(nonatomic,copy)NSString *createtime;//发布时间
@property(nonatomic,copy)NSString *praisestatus;//点赞状态
@property(nonatomic,copy)NSString *praisecount;//点赞数
@property(nonatomic,copy)NSString *commentcount;//评论数
@property(nonatomic,copy)NSString *gameid;//团组id
@property(nonatomic,copy)NSString *gameimage;//团组图片
@property(nonatomic,copy)NSString *contimage;//通知图片
@property(nonatomic,copy)NSString *pageview;//浏览量
+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;

@end
