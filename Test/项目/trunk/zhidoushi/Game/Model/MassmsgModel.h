//
//  MassmsgModel.h
//  zhidoushi
//
//  Created by licy on 15/6/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestBackModel.h"

@interface MassmsgModel : RequestBackModel

@property (nonatomic,strong) NSString *pushtype;//推送类型
@property (nonatomic,strong) NSString *msgid;//通知ID

//显示在提示框中的内容
@property (nonatomic,strong) NSString *content;//通知内容

@end
