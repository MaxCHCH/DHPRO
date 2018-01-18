//
//  GroupTalkModel.m
//  zhidoushi
//
//  Created by xinglei on 14/12/24.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "GroupTalkModel.h"

@implementation GroupTalkModel

- (NSString *)content {
    
    if ([self.bartype isEqualToString:@"1"]) {
        
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


