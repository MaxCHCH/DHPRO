//
//  GroupHeaderModel.h
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupHeaderModel : NSObject
@property(nonatomic,copy)NSString *headerImage;//团长头像
@property(nonatomic,copy)NSString *xuanyan;//团长宣言
@property(nonatomic,copy)NSString *username;//团长名称
@property(nonatomic,copy)NSString *groupImage;//团组封面
@property(nonatomic,copy)NSString *groupName;//团组名称
/*
 2:欢乐模式
 1:闯关模式
 */
@property(nonatomic,copy)NSString *groupType;//团组类型
@property(nonatomic,copy)NSString *groupTags;//团组标签
@property(nonatomic,copy)NSString *goodSum;//团组点赞数量
@property(nonatomic,copy)NSString *userSum;//团组人数
@property(nonatomic,copy)NSString *gametask;//目标
@property(nonatomic,copy)NSString *beginTime;//开始时间
@property(nonatomic,copy)NSString *endTime;//结束时间
@property(nonatomic,copy)NSString *upWeightUserSum;//上传体重人数
@property(nonatomic,copy)NSString *gamests;//体重上传动态
@property(nonatomic,copy)NSString *whichweek;//第几周
@property(nonatomic,copy)NSString *psbegintime;//阶段开始时间
@property(nonatomic,copy)NSString *psendtime;//阶段结束时间
@property(nonatomic,copy)NSString *pstask;//阶段任务
@property(nonatomic,copy)NSString *phgoalweg;//阶段目标体重
/*
 1 是不显示
 0 显示
 */
@property(nonatomic,copy)NSString *showupload;//是否显示上传按钮
@property(nonatomic,copy)NSString *disendtime;//距离结束天数
@property(nonatomic,copy)NSString *disstrtime;//距离开始时间
@property(nonatomic,copy)NSString *passtype;//通关类型

@property(nonatomic,copy)NSString *nowWeight;//当前体重
@property(nonatomic,copy)NSString *mecomplete;//完成度
@property(nonatomic,copy)NSString *needlose;//还需减重
@property(nonatomic,copy)NSString *jieduantime;//阶段时间
@property(nonatomic,copy)NSString *jianzhongbi;//减重百分比
@property(nonatomic,copy)NSString *mubiaotizhong;//目标体重
@property(nonatomic,copy)NSString *score;//积分奖励
@property(nonatomic,copy)NSArray *userArray;//团组成员
@property(nonatomic,copy)NSString *gamecrtor;//创建者userid

/**
    解析算法：
    (gmpasswordL-1126L-0126L)/9299L
    加密算法：
    gmpasswordL*9299L+1126L+0126L
    (注：L表示long类型，应使用long类型计算，否则增长后会溢出)
 */
@property(nonatomic,copy)NSString *gmpassword;//密码（已加密）


//-----------------------------------普通团-----------------------------------
/**
 *  1 28天4%团
 *  2 欢乐
 *  3 普通团
 */
@property(nonatomic,copy)NSString *gamemode;
@property(nonatomic,copy)NSString *indays;//在团天数
@property(nonatomic,copy)NSString *fstaskcount;//完成任务次数
@property(nonatomic,copy)NSString *initialweg;//初始体重
@property(nonatomic,copy)NSString *latestweg;//当前体重
/**
 *  只返回数字，不带百分号
 *  个人减重百分比
 */
@property(nonatomic,copy)NSString *losepercent;
/**
 *  只返回数字，不带单位KG
 *  个人累计减重
 */
@property(nonatomic,copy)NSString *ptotallose;
/**
 *  任务内容
 *  仅当任务存在时返回
 */
@property(nonatomic,copy)NSString *taskcontent;
/**
 *  任务图片
 *  仅当任务图片存在时返回
 */
@property(nonatomic,copy)NSString *taskimage;
/**
 *  任务id
 *  仅当任务存在时返回
 */
@property(nonatomic,copy)NSString *taskid;

/**
 *  任务完结状态
 0 结束
 1 未完结
 */
@property(nonatomic,copy)NSString *taskcmpl;

/**
 *  任务完成状态
 *  仅当任务存在时返回
 0 已完成
 1 未完成
 */
@property(nonatomic,copy)NSString *tasksts;
/**
 *  完成任务人数
 *  仅当任务存在时返回

 */
@property(nonatomic,copy)NSString *fstaskpct;

//发布任务月份次数
@property(nonatomic,copy)NSString *taskMonth;//发布任务月份
@property(nonatomic,copy)NSString *taskNum;//发布任务次数


//催促次数
@property(nonatomic,copy)NSString *urgecount;

/**
 *  0 是
 *  1 否
 */
@property(nonatomic,copy)NSString *isfull;//是否满员

/**
    0 已提交
    1 未提交
 */
@property(nonatomic,copy)NSString *dissolvesub;//是否提交解散申请

/*
 1 官方
 2 已爆满
 3 hot
 4 new
 */
@property(nonatomic,copy)NSString *desctag;//描述标签


@property(nonatomic,copy)NSString *ispunch;//是否打卡，团长团员特有
//-----------------------------------团长特有-----------------------------------
/**
 *  当前团员人数
 *  包含创建者和参与者
 */
@property(nonatomic,copy)NSString *partercount;
@property(nonatomic,copy)NSString *todayaddct;//今日新增人数
@property(nonatomic,copy)NSString *todayupwgct;//今日上传体重人数

//-----------------------------------访客特有-----------------------------------
@property(nonatomic,copy)NSString *dyncount;//团组动态数
@property(nonatomic,copy)NSString *gametags;//游戏标签
@property(nonatomic,copy)NSString *crtorintro;//团长介绍
@property(nonatomic,copy)NSString *loseway;//减脂方法
@property(nonatomic,copy)NSString *gtotallose;//团组总减重


@property(nonatomic,copy)NSString *friendcount;//好友数量
@property(nonatomic,strong)NSArray *friendList;//好友数组
@property(nonatomic,copy)NSString *taglist;//标签
@property(nonatomic,copy)NSString *sendmsgct;//剩余多少次通知发送


/*
 1 团长
 2 团员
 3、访客
 详情页视角	gameangle
 团组创建者	gamecrtor
 创建者昵称	crtorname
 创建者头像	crtorimage
 团组名称	gamename
 团组图像路径	imageurl
 团组开始时间	gmbegintime
 团组结束时间	gmendtime
 总人数	totalnumpeo
 赞状态	praisestatus
 点赞数	praisecount
 讨论数	talkcount
 游戏口号	gmslogan
 游戏目标	gametask
 距结束天数	disendtime
 游戏标签	gametags
 上传体重人数	totalupweg
 参与者数量	partercount
 参与者列表	parterList
 游戏参与者表ID	parterid
 用户ID	userid
 用户图像路径	imageurl
 游戏阶段	gmphase
 第几周	whichweek
 阶段开始时间	psbegintime
 阶段结束时间	psendtime
 阶段任务	pstask
 阶段目标体重	phgoalweg
 阶段积分	psscore
 参与者ID	parterid
 当前用户游戏状态	gamests
 是否显示上传按钮	showupload
 */
@end
