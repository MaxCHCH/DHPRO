//
//  MoreAlertView.h
//  zhidoushi
//
//  Created by licy on 15/6/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SSLAlertViewTap.h"

@class MoreAlertView;

@protocol MoreAlertViewDelegate <NSObject>

@required

- (void)moreAlertView:(MoreAlertView *)moreAlertView buttonClickWithIndex:(NSInteger)index;

@end

@interface MoreAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <MoreAlertViewDelegate>)delegate;

@property (nonatomic,weak) id <MoreAlertViewDelegate> delegate;

@end
