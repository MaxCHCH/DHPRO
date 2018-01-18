//
//  discussAlertView.h
//  zhidoushi
//
//  Created by nick on 15/9/17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverReplyModel.h"

@class discussAlertView;

@protocol DiscussAlertDelegate <NSObject>

@required

- (void)JuBaoAlertConfirmClick:(discussAlertView *)discussAlert;
- (void)copyAlertConfirmClick:(discussAlertView *)discussAlert;

- (void)JuBaoContentAlertConfirmClick:(discussAlertView *)discussAlert;
- (void)copyContentAlertConfirmClick:(discussAlertView *)discussAlert;

@end

@interface discussAlertView : UIView


- (instancetype)initWithFrame:(CGRect)frame delegate:(id <DiscussAlertDelegate>)delegate;

@property (nonatomic,weak) id <DiscussAlertDelegate> delegate;

//创建UI 并传如评论
- (void)createViewWithModel:(DiscoverReplyModel*)model;
- (void)createViewWithContentUserId:(NSString*)userid;

@end
