//
//  intrestUserModel.h
//  zhidoushi
//
//  Created by nick on 15/4/23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface intrestUserModel : NSObject

@property(nonatomic,copy)NSString *userid;//用户ID	userid
@property(nonatomic,copy)NSString *imageurl;//图像路径	imageurl
@property(nonatomic,copy)NSString *username;//用户昵称	username
@property(nonatomic,copy)NSString *usersex;//性别	usersex
@property(nonatomic,copy)NSString *usersign;//个性签名	usersign
@property(nonatomic,copy)NSString *flwstatus;//关注状态	flwstatus
/**
 *  0 位置
 *  1 朋友关注
 *  2 活跃用户
 */
@property(nonatomic,copy)NSString *intertype;//感兴趣类型	intertype
@property(nonatomic,copy)NSString *city;//共同城市
@property(nonatomic,copy)NSString *flwusername;//共同关注人
@property(nonatomic,copy)NSString *updatetime;//更新时间
@property(nonatomic,copy)NSString *phonename;//电话号码名称
@property(nonatomic,copy)NSString *uname;//微博名称
@property(nonatomic,copy)NSString *ptotallose;//减重总数

/**
 *  0 开启
 *  1 关闭
 *  该字段没有返回，则默认为开启
 */ 
@property(nonatomic,copy)NSString *letterswh;//私信开关

/**
 *  关注该用户的人数
 *  v2.3.2版本后返回该字段
 */
//@property(nonatomic,copy)NSString *byflwct;//被关注数
@property(nonatomic,copy)NSString *fanscount;//被关注数

//当前cell是否被选择
@property (nonatomic,assign) BOOL isSelect;

@property(nonatomic,copy)NSString *createtime;//时间

+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;



@end
