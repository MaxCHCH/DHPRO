//
//  YCTagButton.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/10.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCTagButton.h"
#import "WWTolls.h"

@implementation YCTagButton

-(void)setTagStr:(NSString *)tagStr{
    _tagStr = tagStr;
    [self setTitle:tagStr forState:UIControlStateNormal];
}

@end
