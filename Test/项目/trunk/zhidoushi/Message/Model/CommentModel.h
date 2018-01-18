//
//  CommentModel.h
//  zhidoushi
//
//  Created by nick on 15/7/21.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/*****团聊评论******/
@property(nonatomic,copy)NSString *valuetype;//评论类型 1团聊回复 2撒欢回复 3赞
@property(nonatomic,copy)NSString *valueid;//回复ID
@property(nonatomic,copy)NSString *kind;//回复级别 1一级回复 2二级回复 赞类型2团聊 3撒欢
@property(nonatomic,copy)NSString *userid;// 回复发起者ID
@property(nonatomic,copy)NSString *username;// 回复人昵称
@property(nonatomic,copy)NSString *userimage;//回复人头像
@property(nonatomic,copy)NSString *content;//回复内容
@property(nonatomic,copy)NSString *imageurl;//回复图片
@property(nonatomic,copy)NSString *parentid;//团聊ID
@property(nonatomic,copy)NSString *parentcontent;//团聊内容
@property(nonatomic,copy)NSString *parentimageurl;//团聊图片
@property(nonatomic,copy)NSString *parentuserid;//团聊发起人ID
@property(nonatomic,copy)NSString *parentusername;//团聊发起人名称
@property(nonatomic,copy)NSString *parentuserimage;//用户头像
@property(nonatomic,copy)NSString *byuserid;//被回复ID
@property(nonatomic,copy)NSString *byusername;//被回复人名称
@property(nonatomic,copy)NSString *bycontent;//被回复内容
@property(nonatomic,copy)NSString *byimageurl;//被回复图片
@property(nonatomic,copy)NSString *pushtime;//推送时间
@property(nonatomic,copy)NSString *status;//状态
@property(nonatomic,copy)NSString *title;//标题贴title

+(instancetype)modelWithDic:(NSDictionary*)dic;
-(instancetype)initWithDic:(NSDictionary*)dic;
@end
