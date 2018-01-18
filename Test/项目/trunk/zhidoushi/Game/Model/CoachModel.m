//
//  CoachModel.m
//  zhidoushi
//
//  Created by xinglei on 14/12/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "CoachModel.h"

@implementation CoachModel

-(void)setUserid:(NSString *)userid
{
    if (userid.length!=0 || [userid isKindOfClass:[NSString class]] || (userid!=nil)) {
        _userid = userid;
    }else{
        _userid = nil;
    }
}

@end
