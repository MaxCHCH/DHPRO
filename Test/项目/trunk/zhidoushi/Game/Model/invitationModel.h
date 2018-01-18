//
//  invitationModel.h
//  zhidoushi
//
//  Created by xinglei on 14/12/28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface invitationModel : NSObject

@property(nonatomic,strong)NSString * userid;//
@property(nonatomic,strong)NSString * username;//
@property(nonatomic,strong)NSString * usersign;//个性签名
@property(nonatomic,strong)NSString * imageurl;//图像路径
@property(nonatomic,strong)NSString * invitests;//邀请状态
@property(nonatomic,strong)NSString * flwstatus;
@end
