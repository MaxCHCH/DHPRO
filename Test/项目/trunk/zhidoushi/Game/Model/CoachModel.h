//
//  CoachModel.h
//  zhidoushi
//
//  Created by xinglei on 14/12/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoachModel : NSObject

@property(nonatomic,strong)NSString * userid;//用户ID
@property(nonatomic,strong)NSString * username;
@property(nonatomic,strong)NSString * usersign;//个性签名
@property(nonatomic,strong)NSString * imageurl;
@property(nonatomic,strong)NSString * flwstatus;//关注状态 0 未关注 1 已关注
@property(nonatomic,copy)NSString *usersex;//<#descript#>
@end
