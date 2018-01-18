//
//  PlanModel.h
//  zhidoushi
//
//  Created by xinglei on 15/1/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanModel : NSObject

//@property(nonatomic,strong)NSString * grpcomplete;//全组目标完成度
//@property(nonatomic,strong)NSString * mecomplete;//我的目标完成度
@property(nonatomic,strong)NSString * username;//用户名称
@property(nonatomic,assign)float complete;//完成度

@end

@interface ClrCleObject : NSObject
/**
 * 减脂圈子
 */
@property(nonatomic,strong)NSArray * circleList;
/**
 * 圈子名称
 */
@property(nonatomic,assign)NSString * circlename;
/**
 * 图像URL
 */
@property(nonatomic,assign)NSString * imageurl;


@end