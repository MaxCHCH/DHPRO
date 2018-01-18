//
//  MyGroupDynModel.m
//  zhidoushi
//
//  Created by nick on 15/7/3.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyGroupDynModel.h"

@implementation MyGroupDynModel
+(instancetype)modelWithDic:(NSDictionary*)dic{
    return [[self alloc] initWithDic:dic];
}

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(NSString *)content{
    if (_content.length<1) {
        return @"";
    }
    return [_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
