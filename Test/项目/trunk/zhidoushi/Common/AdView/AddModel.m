//
//  AddModel.m
//  zhidoushi
//
//  Created by xiang on 15-1-23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "AddModel.h"
#import "NSObject+MJCoding.h"
@implementation AddModel
MJCodingImplementation
-(void)setAdType:(NSString *)adType
{
    if (_adType!=adType) {
        _adType = adType;
    }
}
@end
