//
//  BaseModel.h
//  zhidoushi
//
//  Created by xinglei on 14-9-15.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

- (id)initWithContent:(id)json;

- (void)setterModelData:(id)contentDic;

@end
