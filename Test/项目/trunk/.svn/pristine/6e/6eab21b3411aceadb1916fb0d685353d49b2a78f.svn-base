//
//  MoreAlertView.m
//  zhidoushi
//
//  Created by licy on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MoreAlertView.h"

static NSString *GengduoImage = @"gengduo-500-404";


@implementation MoreAlertView

#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <MoreAlertViewDelegate>)delegate {
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
    
    [self ssl_addBlackBlur];
    [self ssl_addOnlyTap];
    NSMutableArray *textArray = [NSMutableArray arrayWithObjects:@"团组成员",@"邀请团员",@"退出团组", nil];
    
    CGFloat bgHeight = 45 * textArray.count;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - bgHeight - 10, SCREEN_WIDTH - 20, bgHeight)];
    bgView.layer.cornerRadius = 5.0;
    bgView.clipsToBounds = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    bgView.userInteractionEnabled = YES;
    
    for (int i = 0; i < textArray.count; i++) {
        
        CGFloat y = i * 45;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, bgView.width, 45)];
        button.tag = i;
        [button setTitle:textArray[i] forState:UIControlStateNormal];
        [button setTitleColor:OrangeColor forState:UIControlStateNormal];
        [bgView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
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
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - 250) / 2, 185 * SSL_Height_Value, 250, 151)];
//    [self addSubview:imageView];
//    [imageView setImage:[UIImage imageNamed:@"gengduo-500-302"]];
//    imageView.userInteractionEnabled = YES;
//    
//    for (int i = 0; i < 4; i++) {
//        CGFloat y = i * 50;
//        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, y, imageView.width, 50)];
//        button.tag = i;
//        [imageView addSubview:button];
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        button.backgroundColor = [UIColor clearColor];
//    }
}

#pragma mark Event Responses

- (void)buttonClick:(UIButton *)button {
    
    NSLog(@"button.tag:%ld",button.tag);
    
    if ([self.delegate respondsToSelector:@selector(moreAlertView:buttonClickWithIndex:)]) {
        [self.delegate moreAlertView:self buttonClickWithIndex:button.tag];
    }
    [self ssl_hidden];
}

@end
