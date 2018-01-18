//
//  WWCodeTextField.m
//  zhidoushi
//
//  Created by xinglei on 14/11/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWCodeTextField.h"

#import "GlobalUse.h"

@interface WWCodeTextField ()

@end

@implementation WWCodeTextField

-(instancetype)initWithFrame:(CGRect)frame withType:(WWTextFieldType)type{

    if (self = [super initWithFrame:frame]) {
//        self.wwFieldType = type;
//        [self setBorderStyle:UITextBorderStyleRoundedRect];
        [self setFont:[UIFont systemFontOfSize:15]];
        [self setKeyboardType:UIKeyboardTypeNumberPad];
    }
    return self;
}


-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13，15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

@end
