//
//  CommanderMoreAlertView.m
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CommanderMoreAlertView.h"

@implementation CommanderMoreAlertView

//团组成员图片
static NSString *GroupMemberImage = @"group-member.png";
//邀请团员图片
static NSString *InviteMemberImage = @"more-invite-Member.png";
//团组介绍图片
static NSString *GroupIntroduceImage = @"intruduce-group.png";
//群发通知图片
static NSString *MessageAllImage = @"message-all-noti.png";
//解散团组图片
static NSString *BreakUpGroupImage = @"breakup-group.png";
//修改密码图片
static NSString *UpdatePasswordImage = @"update_password.png";

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <CommanderMoreAlertViewDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)createViewWithHasPassword:(BOOL)hasPassword {
    
    [self ssl_addBlackBlur];
    [self ssl_addOnlyTap];
    
    NSMutableArray *imageArray = [NSMutableArray arrayWithObjects:GroupMemberImage,InviteMemberImage,BreakUpGroupImage, nil];
    NSMutableArray *textArray = [NSMutableArray arrayWithObjects:@"编辑团组",@"团组成员",@"邀请团员",@"解散团组", nil];
    
    if (hasPassword) {
        [imageArray addObject:UpdatePasswordImage];
        [textArray addObject:@"修改密码"];
    }
    
    CGFloat bgHeight = 45 * imageArray.count;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - bgHeight - 10, SCREEN_WIDTH - 20, bgHeight)];
    bgView.layer.cornerRadius = 5.0;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
    for (int i = 0; i < imageArray.count; i++) {
        
        CGFloat y = i * 45;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, bgView.width, 45)];
        button.tag = i;
        [button setTitle:textArray[i] forState:UIControlStateNormal];
        [button setTitleColor:OrangeColor forState:UIControlStateNormal];
        [bgView addSubview:button];
        [button addTarget:self action:@selector(commanderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(81, (button.height - 20) / 2, 20, 20)];
//        [imageView setImage:[UIImage imageNamed:imageArray[i]]];
//        [button addSubview:imageView];
//        
////        if (i == 2) {
////            imageView.width = 15;
////            imageView.left = 83.5;
////        }
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 10, 18, 100, 16)];
//        [button addSubview:label];
//        label.font = MyFont(16.0);
//        label.textColor = [WWTolls colorWithHexString:@"#535353"];
//        label.text = textArray[i];
//        
//        if (i == 2) {
//            label.left = imageView.maxX + 12.5;
//        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, button.height - 0.5, button.width, 0.5)];
        lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [button addSubview:lineView];
    }
}

#pragma mark Event Responses
- (void)commanderButtonClick:(UIButton *)button {

    if ([self.delegate respondsToSelector:@selector(commanderMoreAlertView:buttonClickWithIndex:)]) {
        [self.delegate commanderMoreAlertView:self buttonClickWithIndex:button.tag];
    }
    [self ssl_hidden];
}

@end


