//
//  HomeGroupModel.h
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeGroupModel : NSObject
@property(nonatomic,copy)NSString *gameid;//游戏ID	gameid
@property(nonatomic,copy)NSString *imageurl;//图像路径	imageurl
@property(nonatomic,copy)NSString *gamename;//游戏名称	gamename
@property(nonatomic,copy)NSString *totalnumpeo;//游戏总人数	totalnumpeo
@property(nonatomic,copy)NSString *gametags;//游戏标签	gametags
@property(nonatomic,copy)NSString *gmbegintime;//游戏开始时间	gmbegintime
@property(nonatomic,copy)NSString *gmendtime;//游戏结束时间	gmendtime
@property(nonatomic,copy)NSString *isjoin;//是否可加入	isjoin
@property(nonatomic,copy)NSString *isjoinfail;//加入失败
@property(nonatomic,copy)NSString *username;//团长名称
@property(nonatomic,copy)NSString *gamemode;//团组类型
@property(nonatomic,copy)NSString *loseway;//减脂方式
@property(nonatomic,copy)NSString *isfull;//是够满员
@property(nonatomic,copy)NSString *taglist;//团组标签 ,号分割


/** 
 * 参与者类型
 * 0/1 : 创建的团组
 * 2   : 加入的团组
 */
@property (nonatomic, copy)NSString *partype;


/** 
 * 是否有新任务
 * 0 : 是
 * 1 : 否
 */
@property (nonatomic, copy)NSString *hastask;


/** 精华帖未读数量 */
@property (nonatomic, copy)NSString *titlenotread;


/**
 1 官方
 2 已爆满
 3 hot
 4 new
 **/
@property(nonatomic,copy)NSString *desctag;//标签

/**
 *  是否私密团
 *  0:是 1:否
 */
@property(nonatomic,copy)NSString *ispwd;



+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
