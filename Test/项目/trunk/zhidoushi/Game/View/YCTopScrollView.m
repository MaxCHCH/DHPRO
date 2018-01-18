//
//  YCTopScrollView.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/10.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCTopScrollView.h"

#import "YCCircleModel.h"

#import "YCSquareButton.h"

#import "GroupTypeViewController.h"

#import "UIView+ViewController.h"

@implementation YCTopScrollView

- (void)setCircleArr:(NSArray *)circleArr {
    /** 左右边距*/
    CGFloat marginLR = 10;
    
    /** 上下边距*/
    CGFloat marginTB = 15;
    
    /** X方向的边距*/
    CGFloat marginX = 15;
    
    /** 按钮的宽度*/
    CGFloat btnW = 70;
    //    /** 按钮的高度*/
    CGFloat btnH = btnW + 7.5 + [WWTolls heightForString:@"哈哈" fontSize:13];

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

     
    for (int i = 0; i < circleArr.count; i++){
        
        YCCircleModel *model = circleArr[i];
        
        YCSquareButton *btn = [YCSquareButton squareButtonWithCircleModel:model];
        
        [btn addTarget:self action:@selector(goToType:) forControlEvents:UIControlEventTouchUpInside];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = marginLR + (btn.width + marginX) * i;
        btn.y = marginTB;
        
        [self addSubview:btn];
        
    }
    self.contentSize = CGSizeMake(marginLR * 2 + btnW * circleArr.count + (circleArr.count - 1) * marginX, 0);
    
}

- (void)goToType:(YCSquareButton*)btn{
    GroupTypeViewController *gt = [GroupTypeViewController new];
    gt.hidesBottomBarWhenPushed = YES;
    gt.gamecircle = btn.circleM.circlename;
    [self.viewController.navigationController pushViewController:gt animated:YES];
}

@end
