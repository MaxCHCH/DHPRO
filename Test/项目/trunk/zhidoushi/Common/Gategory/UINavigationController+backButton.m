//
//  UINavigationController+backButton.m
//  zhidoushi
//
//  Created by xinglei on 14-9-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "UINavigationController+backButton.h"

@implementation UINavigationController (backButton)

-(void)customBackButton{
    
    //左侧按钮
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 40, 44)];
    contentView.tag = 10007;
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(-2, 12, 28, 22);
    [leftBtn setImage:[UIImage imageNamed:@"01"] forState:UIControlStateNormal];
    //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 8) ];
    [leftBtn addTarget:self action:@selector(LeftAction) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:leftBtn];
    //竖线
    UIImageView *lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, 1, 44)];
    lineImage.image = [UIImage imageNamed:@"Line01"];
    [contentView addSubview:lineImage];
    [self.navigationBar addSubview:contentView];
}

-(void)LeftAction{
    
    UIView *view = [self.navigationBar viewWithTag:10007];
    [view removeFromSuperview];
    [self popViewControllerAnimated:YES];
}

@end
