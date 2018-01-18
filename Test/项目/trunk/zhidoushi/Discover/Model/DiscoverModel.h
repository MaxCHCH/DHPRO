//
//  DiscoverModel.h
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscoverModel : NSObject
@property(nonatomic,copy)NSString *showid;//展示ID
@property(nonatomic,copy)NSString *showtype;//类型ID
@property(nonatomic,copy)NSString *userid;//用户ID
@property(nonatomic,copy)NSString *usersex;//用户性别
@property(nonatomic,copy)NSString *userimage;//用户头像
@property(nonatomic,copy)NSString *username;//用户昵称
@property(nonatomic,copy)NSString *content;//展示文字
@property(nonatomic,copy)NSString *showimage;//展示图片
@property(nonatomic,copy)NSString *createtime;//发布时间
@property(nonatomic,copy)NSString *praisecount;//点赞数
@property(nonatomic,copy)NSString *commentcount;//评论数
@property(nonatomic,copy)NSString *praisestatus;//点赞状态
@property(nonatomic,copy)NSString *showtag;//标签

//乐活吧同步属性
@property(nonatomic,copy)NSString *isparter;//是否参与者
@property(nonatomic,copy)NSString *gamename;//团组名称
@property(nonatomic,copy)NSString *gameid;//团组ID
@property(nonatomic,copy)NSString *showkind;//撒欢种类
@property(nonatomic,copy)NSString *talkimage;//乐活吧图片
@property(nonatomic,copy)NSString *gamecrtor;//团长id
@property(nonatomic,copy)NSString *pageview;//游览量
//团组动态模型
@property(nonatomic,copy)NSString *gamemode;//团组模型
@property(nonatomic,copy)NSString *gameimage;//团组封面
//搜索属性
@property(nonatomic,copy)NSString *type;//话题搜索类型 0团聊同步 1撒欢
@property(nonatomic,copy)NSString *title;//标题帖标题
+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
-(CGFloat)getDiscoverHeight;
@end
