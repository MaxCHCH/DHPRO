//
//  UserSearchAlertView.h
//  zhidoushi
//
//  Created by licy on 15/8/7.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SSLAlertViewTap.h"

@class UserSearchAlertView;

@protocol UserSearchAlertViewDelegate <NSObject>

@required

//搜索回调
- (void)userSearchAlertView:(UserSearchAlertView *)userSearchAlertView searchWithText:(NSString *)searchText;

//输入值改变回调
- (void)userSearchAlertView:(UserSearchAlertView *)userSearchAlertView textDidChange:(NSString *)searchText;

@end

@interface UserSearchAlertView : UIView

@property (nonatomic,weak) id <UserSearchAlertViewDelegate> delegate;

- (void)setDelegate:(id <UserSearchAlertViewDelegate>)delegate andSearchText:(NSString *)searchText;


@end
