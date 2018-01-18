//
//  NARShareView.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARShareView.h"
#import "WWTolls.h"
#import "ShareGameSubClassView.h"
#import <TencentOpenAPI/QQApiInterface.h>

@interface NARShareView () <ShareGameSubClassViewDelegate>

@property (nonatomic,strong) ShareGameSubClassView *shareView;

@end

@implementation NARShareView

-(void)createView:(ShareGameSubClassViewType)my_Type withModel:(NSObject *)model withGroupModel:(GroupHeaderModel *)groupModel {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self addGestureRecognizer:singleTap];
    
    self.shareView = [ShareGameSubClassView initViewWithShareGameSubClassViewType:my_Type andModel:model];
    self.shareView.groupModel = groupModel;
    self.shareView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    CGFloat shareViewHeight = [self.shareView createView];
    self.shareView.shareGameDelegate = self;
    [self addSubview:self.shareView];
//    self.shareView.alpha = 0;
//    [UIView animateWithDuration:0.6 animations:^{
//        self.shareView.alpha = 1;
//    }];
//    [UIView animateWithDuration:0.5 animations:^{
       self.shareView.top = SCREEN_HEIGHT - shareViewHeight;
//    }];
}

- (void)setShareImage:(UIImage *)image {
    self.shareView.image = image;
}   

-(void)cancelAction{
    [self.shareView cancelAnimal];
    [UIView animateWithDuration:0.4 animations:^{
        self.shareView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        
        for (UIView *view in self.shareView.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
    
    [NSUSER_Defaults setObject:nil forKey:ZDS_WEIXINJUDGE];
    [NSUSER_Defaults synchronize];
}

#pragma mark ShareGameSubClassViewDelegate

//取消
-(void)cancelButtonSender{
    [self cancelAction];
}   

//邀请粉丝
-(void)invitationButton
{   
    if ([self.narDelegate respondsToSelector:@selector(clickInvitationButton)]) {
        [self.narDelegate clickInvitationButton];
        [self cancelAction];
    }
}

//举报
- (void)shareGameSubClassViewDelegateReport {
    if ([self.narDelegate respondsToSelector:@selector(shareViewDelegateReport)]) {
        [self.narDelegate shareViewDelegateReport];
        [self cancelAction];
    }
}   

//删除
- (void)shareGameSubClassViewDelegateDelete {
    if ([self.narDelegate respondsToSelector:@selector(shareViewDelegateDelete)]) {
        [self.narDelegate shareViewDelegateDelete];
        [self cancelAction];
    }
}

//收藏
- (void)shareGameSubClassViewDelegateCollect {
    if ([self.narDelegate respondsToSelector:@selector(shareViewDelegateCollect)]) {
        [self.narDelegate shareViewDelegateCollect];
        [self cancelAction];
    }
}


//置顶
- (void)shareGameSubClassViewDelegateTop {
    if ([self.narDelegate respondsToSelector:@selector(shareViewDelegateSetTop)]) {
        [self.narDelegate shareViewDelegateSetTop];
        [self cancelAction];
    }
}

//取消置顶
- (void)shareGameSubClassViewDelegateCancelTop {
    if ([self.narDelegate respondsToSelector:@selector(shareViewDelegateCancelTop)]) {
        [self.narDelegate shareViewDelegateCancelTop];
        [self cancelAction];
    }   
}

@end
