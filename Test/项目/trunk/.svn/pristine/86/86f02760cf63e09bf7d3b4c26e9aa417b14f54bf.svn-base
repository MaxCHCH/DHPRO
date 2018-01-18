//
//  BreakUpAlertView.m
//  zhidoushi
//
//  Created by licy on 15/8/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BreakUpAlertView.h"

@implementation BreakUpAlertView

#pragma mark - UI

#pragma mark 创建UI
- (void)createView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addGeneralTap];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 250) / 2, SCREEN_HEIGHT_MIDDLE(87) - 30, 250, 87)];
    bgView.backgroundColor = [UIColor blackColor];
    [bgView makeCorner:5.0];
    bgView.alpha = 0.7;
    [self addSubview:bgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, bgView.width, bgView.height - 20)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.width - 250) / 2, SCREEN_HEIGHT_MIDDLE(87) - 30, 250, 87)];
    label.text = @"您的申请已经提交\n我们会在1-3个工作日内\n告知您审核结果";
    [bgView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.textColor = [WWTolls colorWithHexString:@"#ffffff"];
    label.font = MyFont(16.0);
}   

@end
