//
//  YCCircleModel.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/5.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCCircleModel.h"

@implementation YCCircleModel

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    
    self.imageurlNormal = [self.imageurl componentsSeparatedByString:@"|"][0];
    
    self.imageurlSelect = [self.imageurl componentsSeparatedByString:@"|"][0];
    
    return self;
}

@end
