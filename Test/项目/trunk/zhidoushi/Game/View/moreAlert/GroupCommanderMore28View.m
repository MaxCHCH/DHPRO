//
//  GroupCommanderMore28View.m
//  zhidoushi
//
//  Created by licy on 15/8/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupCommanderMore28View.h"
#import "UIView+SSLAlertViewTap.h"

@interface GroupCommanderMore28View ()

@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *textArray;

@end

@implementation GroupCommanderMore28View

//28天团团长更多弹窗

//减脂进度图片
static NSString *GroupMorePregress = @"28-more-progress.png";
//分享团组图片
static NSString *GroupMemberImage = @"28-more-share.png";
//解散团组图片
static NSString *BreakupGroupImage = @"breakup-group.png";
//回减脂吧图片
static NSString *InviteMemberImage = @"28-more-jianzhiba.png";
//修改密码图片
static NSString *UpdatePasswordImage = @"update_password.png";

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <GroupCommanderMore28ViewDelegate>)delegate {
    if (self = [self initWithFrame:frame]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)createViewWithIsBreakUp:(BOOL)isBreakUp andHasPassword:(BOOL)hasPassword {
    
    if (isBreakUp) {
        self.textArray = [NSMutableArray arrayWithObjects:@"减脂进度",@"分享团组",@"回减脂吧",@"解散团组", nil];
        self.imageArray = [NSMutableArray arrayWithObjects:GroupMorePregress,GroupMemberImage,InviteMemberImage,BreakupGroupImage, nil];
    } else {
        self.textArray = [NSMutableArray arrayWithObjects:@"减脂进度",@"分享团组",@"回减脂吧", nil];
        self.imageArray = [NSMutableArray arrayWithObjects:GroupMorePregress,GroupMemberImage,InviteMemberImage, nil];
    }
    
    if (hasPassword) {
        [self.imageArray addObject:UpdatePasswordImage];
        [self.textArray addObject:@"修改密码"];
    }
    
    [self createView];
}

- (void)createView {
    
    [self ssl_addGeneralTap];
    
    NSMutableArray *imageArray = self.imageArray;
    NSArray *textArray = self.textArray;
    
    CGFloat bgHeight = 50 * imageArray.count;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake((self.width - 250) / 2, 150 * SSL_Height_Value, 250, bgHeight)];
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
        
//        if (i == 2) {
//            imageView.width = 15;
//            imageView.left = 83.5;
//        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.maxX + 10, 18, 100, 16)];
        [button addSubview:label];
        label.font = MyFont(16.0);
        label.textColor = [WWTolls colorWithHexString:@"#535353"];
        label.text = textArray[i];
        
//        if (i == 2) {
//            label.left = imageView.maxX + 12.5;
//        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(5, button.height - 0.5, button.width - 10, 0.5)];
        lineView.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [button addSubview:lineView];
    }
}

#pragma mark Event Responses
- (void)commanderButtonClick:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(groupCommanderMore28View:buttonClickWithIndex:)]) {
        [self.delegate groupCommanderMore28View:self buttonClickWithIndex:button.tag];
    }
    [self ssl_hidden];
}

@end
