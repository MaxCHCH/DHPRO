//
//  RemoveAlert.h
//  zhidoushi
//
//  Created by licy on 15/8/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RemoveAlert;

@protocol RemoveAlertDelegate <NSObject>

@required

- (void)removeAlertConfirmClick:(RemoveAlert *)removeAlert;

@end

@interface RemoveAlert : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <RemoveAlertDelegate>)delegate;

@property (nonatomic,weak) id <RemoveAlertDelegate> delegate;

//创建UI 并传值删除人数
- (void)createViewWithNumber:(int)number;

@end
