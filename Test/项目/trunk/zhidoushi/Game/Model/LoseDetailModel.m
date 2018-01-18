//
//  LoseDetailModel.m
//  zhidoushi
//
//  Created by licy on 15/6/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "LoseDetailModel.h"

@implementation LoseDetailModel

- (NSString *)initialweg {
    if ([WWTolls isNull:_initialweg]) {
        _initialweg = @"0";
    }
    return _initialweg;
}

- (NSString *)latestweg {
    if ([WWTolls isNull:_latestweg]) {
        _latestweg = @"0";
    }
    return _latestweg;
}

- (NSString *)ploseweg {
    if ([WWTolls isNull:_ploseweg]) {
        _ploseweg = @"0";
    }
    
    return _ploseweg;
}   

@end
