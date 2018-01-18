//
//  HomeGroupModel.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "HomeGroupModel.h"

@implementation HomeGroupModel

+(instancetype)modelWithDic:(NSDictionary*)dic{
    return [[self alloc] initWithDic:dic];
}

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

-(NSString *)desctag{
    if (_desctag && _desctag.length>0) {
        return [_desctag componentsSeparatedByString:@","].firstObject;
    }
    return _desctag;
}
@end
