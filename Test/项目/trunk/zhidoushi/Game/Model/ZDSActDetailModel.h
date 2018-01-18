//
//  ZDSActDetailModel.h
//  zhidoushi
//
//  Created by licy on 15/5/26.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//活动详情
@interface ZDSActDetailModel : NSObject

#pragma mark 成功节点
/*
 0:游戏参与者
 1:非游戏参与者
 */
@property (nonatomic,copy) NSString *userangle;//用户视角
@property (nonatomic,copy) NSString *userid;//创建者用户ID
@property (nonatomic,copy) NSString *imageurl;//创建者头像
@property (nonatomic,copy) NSString *username;//创建者昵称
@property (nonatomic,copy) NSString *createtime;//活动创建时间
@property (nonatomic,copy) NSString *acttime;//活动时间
@property (nonatomic,copy) NSString *place;//活动地点
@property (nonatomic,copy) NSString *content;//活动内容
@property (nonatomic,copy) NSString *activityid;//活动内容
@property (nonatomic,copy) NSString *gameid;//活动内容
@property (nonatomic,copy) NSString *actdate;//活动日期
@property (nonatomic,copy) NSString *acttiming;//活动时间

#pragma mark 错误节点

/*
 发生错误时返回
 活动被删除时，返回 IEA084，当前活动已被删除
 */
@property (nonatomic,copy) NSString *errcode;

//发生错误时返回
@property (nonatomic,copy) NSString *errinfo;

@end
