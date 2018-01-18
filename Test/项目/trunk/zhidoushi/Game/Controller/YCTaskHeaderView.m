//
//  YCTaskHeaderView.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/12.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCTaskHeaderView.h"

@implementation YCTaskHeaderView

- (instancetype)init {
    
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YCTaskHeaderView class]) owner:nil options:nil] lastObject];
    }
    return self;
}

@end
