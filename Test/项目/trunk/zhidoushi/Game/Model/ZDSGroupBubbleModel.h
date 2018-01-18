//
//  ZDSGroupBubbleModel.h
//  zhidoushi
//
//  Created by licy on 15/5/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZDSGroupBubbleModel : NSObject

@property (nonatomic,copy) NSString *waittime;
/*
 0 处理成功
 1 处理失败
 */
@property (nonatomic,copy) NSString *result;

@end
