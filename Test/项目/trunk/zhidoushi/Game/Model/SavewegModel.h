//
//  SavewegModel.h
//  zhidoushi
//
//  Created by licy on 15/6/23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavewegModel : NSObject

@property (nonatomic,strong) NSString *errcode;
@property (nonatomic,strong) NSString *errinfo;

/**
 *  当上传体重属性为0官方时，如果其他请求先于该请求上传成功，返回错误码GAM011 错误信息：今日体重和体重照片不允许重复上传
 *  个人上传将进行次数限制，达到上限次数后，返回状态2
 *  0 上传成功
 *  1 上传失败
 *  2 个人上传达到上限
 */
@property (nonatomic,strong) NSString *uplflag;
//游戏参与者ID
@property (nonatomic,strong) NSString *parterid;
/**
 *  1、上传体重属性为1时返回
 *  2、上传前当前体重-今日体重
 *  3、正数表示减重，负数表示增重
 */
@property (nonatomic,strong) NSString *loseweg;

@end
