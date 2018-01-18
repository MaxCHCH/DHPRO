//
//  GroupMemberMore28View.m
//  zhidoushi
//
//  Created by licy on 15/8/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupMemberMore28View.h"
#import "UIView+SSLAlertViewTap.h"

@implementation GroupMemberMore28View

//28天团团员更多弹窗

//分享团组图片
static NSString *GroupMorePregress = @"28-more-progress.png";
//分享团组图片
static NSString *GroupMemberImage = @"28-more-share.png";
//退出团组图片
static NSString *BreakupGroup = @"breakup-group.png";
//回减脂吧图片
static NSString *InviteMemberImage = @"28-more-jianzhiba.png";

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <GroupMemberMore28ViewDelegate>)delegate {
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
    
    NSArray *imageArray = @[GroupMorePregress,GroupMemberImage,BreakupGroup,InviteMemberImage];
    NSArray *textArray = @[@"减脂进度",@"分享团组",@"退出团组",@"回减脂吧"];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 250) / 2, 185 * SSL_Height_Value, 250, imageArray.count * 50)];
    bgView.layer.cornerRadius = 3.0;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
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
        
//        if (i == 1) {
//            imageView.width = 15;
//            imageView.left = 83.5;
//        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 10, 18, 100, 16)];
        [button addSubview:label];
        label.font = MyFont(16.0);
        label.textColor = [WWTolls colorWithHexString:@"#535353"];
        label.text = textArray[i];
        
//        if (i == 1) {
//            label.left = imageView.maxX + 12.5;
//        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, button.height - 0.5, button.width - 10, 0.5)];
        lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [button addSubview:lineView];
    }   
}

#pragma mark Event Responses
- (void)commanderButtonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(groupMemberMore28View:buttonClickWithIndex:)]) {
        [self.delegate groupMemberMore28View:self buttonClickWithIndex:button.tag];
    }
    [self ssl_hidden];
}

@end
