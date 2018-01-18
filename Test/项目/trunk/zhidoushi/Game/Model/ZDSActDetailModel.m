//
//  ZDSActDetailModel.m
//  zhidoushi
//
//  Created by licy on 15/5/26.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSActDetailModel.h"

@implementation ZDSActDetailModel

- (NSString *)content {
    
    NSMutableString *muString = [[NSMutableString alloc] init];
    NSMutableString *dateAndTimeString = [[NSMutableString alloc] init];
    
    if (![WWTolls isNull:self.actdate]) {
        [dateAndTimeString appendString:[WWTolls timeString22:[NSString stringWithFormat:@"%@ 00:00:00",self.actdate]]];
    }
    
    if (![WWTolls isNull:self.acttiming]) {
        [dateAndTimeString appendString:[self.acttiming substringToIndex:5]];
    }
    
    if (![WWTolls isNull:dateAndTimeString]) {
        [muString appendString:[NSString stringWithFormat:@"%@，",[dateAndTimeString copy]]];
    }
    
    if (![WWTolls isNull:self.place]) {
        [muString appendString:[NSString stringWithFormat:@"%@，",self.place]];
    }
    
    return [[muString stringByAppendingString:_content] copy];
}

@end
