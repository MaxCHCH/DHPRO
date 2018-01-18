//
//  GroupHeaderModel.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupHeaderModel.h"

@implementation GroupHeaderModel

- (NSString *)fstaskpct {
    if ([WWTolls isNull:_fstaskpct]) {
        return @"0";
    }
    return _fstaskpct;
}

- (NSString *)fstaskcount {
    if ([WWTolls isNull:_fstaskcount]) {
        _fstaskcount = @"0";
    }
    return _fstaskcount;
}

-(NSString *)desctag{
    if (_desctag && _desctag.length>0) {
        return [_desctag componentsSeparatedByString:@","].firstObject;
    }
    return _desctag;
}

@end
