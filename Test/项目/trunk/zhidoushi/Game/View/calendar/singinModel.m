//
//  singinModel.m
//  sampleCalendar
//
//  Created by nick on 15/10/19.
//  Copyright © 2015年 Attinad. All rights reserved.
//

#import "singinModel.h"

@implementation singinModel
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
