//
//  CommanderMoreAlertView.h
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SSLAlertViewTap.h"

@class CommanderMoreAlertView;

@protocol CommanderMoreAlertViewDelegate <NSObject>

@required

- (void)commanderMoreAlertView:(CommanderMoreAlertView *)moreAlertView buttonClickWithIndex:(NSInteger)index;

@end

@interface CommanderMoreAlertView : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <CommanderMoreAlertViewDelegate>)delegate;

@property (nonatomic,weak) id <CommanderMoreAlertViewDelegate> delegate;

/**
 *  创建UI
 *
 *  @param hasPassword 是否显示修改密码按钮
 */
- (void)createViewWithHasPassword:(BOOL)hasPassword;

@end
