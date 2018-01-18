//
//  InformationModel.m
//  zhidoushi
//
//  Created by nick on 15/5/4.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "InformationModel.h"

@implementation InformationModel

-(NSString *)message{
    if ([self.noticetype isEqualToString:@"8"]) {//广播消息
        return @"广播消息来啦";
    }else return _message;
}

-(NSString *)content{
    if (_content.length > 192) {
        return [NSString stringWithFormat:@"%@...",[_content substringToIndex:191]];
    }
    return _content;
}

+(instancetype)modelWithDic:(NSDictionary*)dic{
    return [[self alloc] initWithDic:dic];
}

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
