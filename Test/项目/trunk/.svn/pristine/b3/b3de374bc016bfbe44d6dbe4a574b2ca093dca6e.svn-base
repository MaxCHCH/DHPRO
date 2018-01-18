//
//  GroupVisitorMore28View.m
//  zhidoushi
//
//  Created by licy on 15/8/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupVisitorMore28View.h"
#import "UIView+SSLAlertViewTap.h"

@implementation GroupVisitorMore28View

//28天团访客视角更多弹窗

//分享团组图片
static NSString *GroupMemberImage = @"28-more-share.png";
//回减脂吧图片
static NSString *InviteMemberImage = @"28-more-jianzhiba.png";

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <GroupVisitorMore28ViewDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    
    return self;
}

- (void)createView {
    
    [self ssl_addGeneralTap];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 250) / 2, 185 * SSL_Height_Value, 250, 100)];
    bgView.layer.cornerRadius = 3.0;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
    NSArray *imageArray = @[GroupMemberImage,InviteMemberImage];
    NSArray *textArray = @[@"分享团组",@"回减脂吧"];
    
    for (int i = 0; i < imageArray.count; i++) {
        
        CGFloat y = i * 50;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, bgView.width, 50)];
        button.tag = i;
        [bgView addSubview:button];
        [button addTarget:self action:@selector(commanderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(81, (button.height - 20) / 2, 20, 20)];
        [imageView setImage:[UIImage imageNamed:imageArray[i]]];
        [button addSubview:imageView];
        
        if (i == 2) {
            imageView.width = 15;
            imageView.left = 83.5;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 10, 18, 100, 16)];
        [button addSubview:label];
        label.font = MyFont(16.0);
        label.textColor = [WWTolls colorWithHexString:@"#535353"];
        label.text = textArray[i];
        
        if (i == 2) {
            label.left = imageView.maxX + 12.5;
        }   
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, button.height - 0.5, button.width - 10, 0.5)];
        lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [button addSubview:lineView];
    }
}

#pragma mark Event Responses
- (void)commanderButtonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(groupVisitorMore28View:buttonClickWithIndex:)]) {
        [self.delegate groupVisitorMore28View:self buttonClickWithIndex:button.tag];
    }
    [self ssl_hidden];
}

@end
