//
//  BMIAlertSView.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/12.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BMIAlertSView.h"
#import "UIView+SSLAlertViewTap.h"
#import "UIView+ViewController.h"

@implementation BMIAlertSView
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <BMIAlertSViewDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}
- (void)closeBtn{
    [self ssl_hidden];
}
-(void)clickWEGButton:(NSString*)parterid{
    if ([_delegate respondsToSelector:@selector(setWEG:)]) { // 如果协议响应了sendValue:方法
        [_delegate setWEG:parterid]; // 通知执行协议方法
    }

    
    //phasepro
    //uploadweg
    //imageurl1
    //imageurl2

}
- (void)createView{
//    self.backgroundColor = [UIColor clearColor];
    [self ssl_addGeneralTap];
    
    UIView *view_middle = [UIView new];
    [view_middle setFrame:CGRectMake(30, 80, SCREEN_WIDTH - 60, 0)];
    view_middle.backgroundColor = [UIColor whiteColor];
    [self addSubview:view_middle];
    
//    [self addConstraint:[NSLayoutConstraint constraintWithItem:view_middle attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    
//    // align view_middle from the left
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-32-[view_middle]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view_middle)]];
//    
//    // align view_middle from the top
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[view_middle]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view_middle)]];
//    
//    // height constraint
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view_middle(==400)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view_middle)]];
    
    
    UIButton *button_close = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_close setImage:[UIImage imageNamed:@"qx-20"] forState:(UIControlStateNormal)];
    [button_close addTarget:self action:@selector(closeBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [button_close setFrame:CGRectMake(view_middle.frame.size.width-15 - 15, 15, 15, 15)];
    [view_middle addSubview:button_close];

    
//    // center button_close horizontally in view_middle
//    [view_middle addConstraint:[NSLayoutConstraint constraintWithItem:button_close attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view_middle attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    
//    // align button_close from the right
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button_close]-10-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button_close)]];
//    
//    // align button_close from the top
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[button_close]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button_close)]];
//    
//    // width constraint
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button_close(==18)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button_close)]];
//    
//    // height constraint
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[button_close(==18)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button_close)]];
    
    UILabel *label_titleTop = [UILabel new];
    label_titleTop.textAlignment = NSTextAlignmentCenter;
    [label_titleTop setFrame:CGRectMake(0, 60,view_middle.width, 17)];
    [label_titleTop setText:@"BMI功能解锁啦"];
    label_titleTop.font = MyFont(15);
    [view_middle addSubview:label_titleTop];
//    // center label_titleTop horizontally in view_middle
//    [view_middle addConstraint:[NSLayoutConstraint constraintWithItem:label_titleTop attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view_middle attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
//    
//    // align label_titleTop from the top
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[label_titleTop]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label_titleTop)]];
//    
//    // width constraint
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label_titleTop(==100)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label_titleTop)]];
//    
//    // height constraint
//    [view_middle addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label_titleTop(==15)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label_titleTop)]];
    
    UILabel *label_titleTop2 = [UILabel new];
    [label_titleTop2 setText:@"什么是BMI？"];
    label_titleTop2.font = MyFont(15);
    [label_titleTop2 setFrame:CGRectMake(20, label_titleTop.bottom + 40, 500, 18)];
    [view_middle addSubview:label_titleTop2];
    
    label_titleTop = [UILabel new];
    [label_titleTop setFrame:CGRectMake(20, label_titleTop2.bottom, view_middle.width - 40, 56)];
    label_titleTop.font = MyFont(13);
    label_titleTop.textColor = ContentColor;
    [label_titleTop setText:@"身体质量指数，是目前国际上常用的的衡量人体胖瘦程度以及是否健康的一个标准"];
    label_titleTop.numberOfLines = 0;
    [label_titleTop setTextColor:[WWTolls colorWithHexString:@"#4f777f"]];
    [view_middle addSubview:label_titleTop];

    
    label_titleTop2 = [UILabel new];
    [label_titleTop2 setFrame:CGRectMake(20, label_titleTop.bottom, 500, 15)];
    [label_titleTop2 setText:@"如何计算BMI？"];
    label_titleTop2.font = MyFont(15);
    [view_middle addSubview:label_titleTop2];
    
    
    label_titleTop = [UILabel new];
    label_titleTop.textColor = ContentColor;
    label_titleTop.font = MyFont(13);
    [label_titleTop setFrame:CGRectMake(20, label_titleTop2.bottom,view_middle.width - 40, 78)];
    label_titleTop.font = MyFont(13);
    [label_titleTop setTextColor:ContentColor];
    label_titleTop.numberOfLines = 0;
    [label_titleTop setText:@"体质指数（BMI）=体重（kg）÷身高^2(m),所以设置好你的身高后，每次记录体重时，我们斗湖为你计算出你的BMI哦。"];
    [view_middle addSubview:label_titleTop];
    
    _button_setHeight = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button_setHeight setImage:[UIImage imageNamed:@"szsg-600-98"] forState:(UIControlStateNormal)];
    [_button_setHeight setFrame:CGRectMake(0,label_titleTop.bottom + 15, view_middle.frame.size.width, 50*SCREEN_WIDTH/375)];
    [_button_setHeight addTarget:self action:@selector(clickWEGButton:) forControlEvents:(UIControlEventTouchUpInside)];
    view_middle.height = _button_setHeight.bottom;
    [view_middle addSubview:_button_setHeight];

    
}


@end
