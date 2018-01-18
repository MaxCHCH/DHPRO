//
//  FinishAlertView.h
//  zhidoushi
//
//  Created by licy on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SSLAlertViewTap.h"
@class FinishAlertView;

@protocol FinishAlertViewDelegate <NSObject>

- (void)finishAlertView:(FinishAlertView *)alertViewWithfinishButtonClick;

@end

@interface FinishAlertView : UIView

@property (nonatomic,weak) id <FinishAlertViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)message delegate:(id <FinishAlertViewDelegate>)delegate;

@end
