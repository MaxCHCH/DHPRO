//
//  GroupViewController.h
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import "GroupTalkTableViewCell.h"
#import "GroupHappyViewController.h"

@protocol sendMessageDelegate <NSObject>

-(void)sendSuccess;

@end

@interface GroupViewController : BaseViewController

@property(nonatomic,copy)NSString *groupId;//团组id

/**
 *  是否私密团
 *  0:是 1:否
 */
@property (nonatomic,copy) NSString *ispwd;

/*
 0 : 创建且参与
 1 : 创建仅指导
 2 : 仅参与        
 3 : 游客
 */     
/**
 *  普通团时
 *  1 团长
 *  2 团员
 *  3 访客
 */
@property(nonatomic,copy)NSString *gameangle;//视角

/*
 0 ： 未开始
 1 ： 第 1 周
 2 ： 第 2 周
 3 ： 第 3 周
 4 ： 第 4 周
 5 ： 已结束
 */
@property(nonatomic,copy)NSString *gamests;//团组阶段
@property(nonatomic,copy)NSString *gameDetailStatus;//10086时表示创建页面跳转
@property(nonatomic,strong)GroupTalkTableViewCell * groupCell;
@property(nonatomic,strong)UILabel *xuanyan;//团组宣言

@property (nonatomic,strong) NSString *gamePwd;
/**
 0刷新
 1减脂吧
 2全部团组
 3官方团
 4团组搜索
 5撒欢广场－团聊
 6撒欢广场－标题贴
 7撒欢广场－团组动态
 8足迹
 9通知列表
 10我的动态－团聊
 11我的动态－团组任务
 12我的动态－标题贴
 13我的动态－团组动态
 **/

@property(nonatomic,assign)int clickevent;//详情页点击来源
@property(nonatomic,copy)NSString *joinClickevent;//加入点击来源

@property(nonatomic,copy)NSString *comeTitleTalkid;//标题贴来源团聊id
@end





