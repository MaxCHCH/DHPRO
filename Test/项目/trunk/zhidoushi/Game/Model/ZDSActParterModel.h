//
//  ZDSActParterModel.h
//  zhidoushi
//
//  Created by licy on 15/5/26.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//活动参与者列表
@interface ZDSActParterModel : NSObject

@property (nonatomic,copy) NSString *userid;//创建者用户ID
@property (nonatomic,copy) NSString *username;//创建者昵称

@property (nonatomic) int partercount;//参与者总数
@property (nonatomic,copy) NSString *parterList;//参与者列表
/*
 1 男
 2 女
 */
@property (nonatomic,copy) NSString *usersex;//性别
@property (nonatomic,copy) NSString *usersign;//个性签名
@property (nonatomic,copy) NSString *imageurl;//图像路径
/*
 0 关注
 1 已关注
 */
@property (nonatomic,copy) NSString *flwstatus;//关注状态
@property (nonatomic,strong) NSArray *flwstatusDictList;//关注状态字典(用来翻译关注状态)
@property (nonatomic,copy) NSString *dtypecode;//数据字典类型代码
@property (nonatomic,copy) NSString *dictcode;//数据字典代码
@property (nonatomic,copy) NSString *dictname;//数据字典名称


@end
