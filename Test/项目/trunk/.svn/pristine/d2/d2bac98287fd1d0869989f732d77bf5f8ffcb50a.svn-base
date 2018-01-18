//
//  ShareView.m
//  zhidoushi
//
//  Created by xinglei on 14-9-16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _initShareControl:nil];
    }
    return self;
}

-(void)_initShareControl:(UIImage *)image{
    
    shareImage = image;
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [maskView addGestureRecognizer:singleTap];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    
    shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_HEIGHT, 260)];
    shareView.backgroundColor = [UIColor whiteColor];
    
    UILabel *repeatLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    repeatLabel.textAlignment = NSTextAlignmentCenter;
    repeatLabel.textColor = [UIColor grayColor];
    repeatLabel.text = @"分享到";
    repeatLabel.font = [UIFont systemFontOfSize:21];
    [shareView addSubview:repeatLabel];
    
    NSArray *imgArray1 = [NSArray arrayWithObjects:@"news-sina",@"news-wx",@"news-pyq", nil];
    NSArray *imgArray2 = [NSArray arrayWithObjects:@"news-qqzone",@"news-txwb",@"news-fz", nil];
    NSMutableArray *totalImg = [NSMutableArray arrayWithObjects:imgArray1,imgArray2 ,nil];
    
    NSArray *oneNames = nil;
    oneNames = @[@"新浪微博",@"微信",@"朋友圈"];
    NSArray *towNames = [NSArray arrayWithObjects:@"QQ空间",@"腾讯微博",@"复制链接", nil];
    NSMutableArray *totalArr = [NSMutableArray array];
    [totalArr addObject:oneNames];
    [totalArr addObject:towNames];
    int tag = 0;
    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 3; j ++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.cornerRadius = 5;
            button.frame = CGRectMake(30+j*100,repeatLabel.bottom+20+105*i, 60, 60);
            [button addTarget:self action:@selector(allShare:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 20000+tag;
            tag++;
            [button setImage:[UIImage imageNamed:totalImg[i][j]] forState:UIControlStateNormal];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30+j*100,button.bottom+5, 60, 20)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:13];
            label.text = totalArr[i][j];
            [shareView addSubview:label];
            [shareView addSubview:button];
        }
        
    }
    [maskView addSubview:shareView];
    
    [UIView animateWithDuration:0.33 animations:^{
        shareView.top = SCREEN_HEIGHT-260;
    }];
    
} //自定义分享菜单栏

-(void)allShare:(UIButton *)button{
    
    switch (button.tag-20000) {
        case 0:
            //            NSLog(@"新浪");
            
            break;
        case 1:
            //            NSLog(@"微信好友");
            
            break;
        case 2:
            //            NSLog(@"微信朋友圈");
            break;
        case 3:
            //            NSLog(@"QQ空间");
            break;
            
        case 4:
            //            NSLog(@"腾讯微博");
            
            break;
        case 5:
        {
            //            NSLog(@"复制链接");
            
        }
            
            break;
            
        default:
            break;
    }
}


-(void)cancelAction{
    [UIView animateWithDuration:0.33 animations:^{
        shareView.top = SCREEN_HEIGHT;
        for (UIView *view in shareView.subviews) {
            [view removeFromSuperview];
        }
        [maskView removeFromSuperview];
        maskView = nil;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
