//
//  RemoveAlert.m
//  zhidoushi
//
//  Created by licy on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "RemoveAlert.h"
#import "UIView+SSLAlertViewTap.h"

@implementation RemoveAlert

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <RemoveAlertDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - UI

#pragma mark 创建UI 并传值删除人数
- (void)createViewWithNumber:(int)number {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self ssl_addGeneralTap];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 163.5, self.width, 163.5)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 53)];
    label.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    label.text = [NSString stringWithFormat:@"是否将此%d人从团组中移除？",number];
    label.textColor = [WWTolls colorWithHexString:@"#959595"];
    label.font = MyFont(13.0);
    label.textAlignment = NSTextAlignmentCenter;
    [bottomView addSubview:label];
    
    UIView *firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, label.maxY, self.width, 0.2)];
    firstLineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [bottomView addSubview:firstLineView];
    
    //确认按钮
    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, firstLineView.maxY, self.width, 50)];
    confirmButton.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    confirmButton.titleLabel.font = MyFont(16.0);
    [bottomView addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, confirmButton.maxY + 10, self.width, 50)];
    cancelButton.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    cancelButton.titleLabel.font = MyFont(16.0);
    [bottomView addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Event Responses
#pragma mark 确认点击事件
- (void)confirmButtonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(removeAlertConfirmClick:)]) {
        [self.delegate removeAlertConfirmClick:self];
    }
    [self ssl_hidden];
}

#pragma mark 取消点击事件
- (void)cancelButtonClick:(UIButton *)button {
    [self ssl_hidden];
}

@end
