//
//  GroupCommanderMore28View.h
//  zhidoushi
//
//  Created by licy on 15/8/6.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupCommanderMore28View;

@protocol GroupCommanderMore28ViewDelegate <NSObject>

@required

- (void)groupCommanderMore28View:(GroupCommanderMore28View *)commanderMore28View buttonClickWithIndex:(NSInteger)index;

@end

@interface GroupCommanderMore28View : UIView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id <GroupCommanderMore28ViewDelegate>)delegate;

@property (nonatomic,weak) id <GroupCommanderMore28ViewDelegate> delegate;

/**
 *  创建view
 *
 *  @param isBreakUp   是否解散团组
 *  @param hasPassword 是否修改密码
 */
- (void)createViewWithIsBreakUp:(BOOL)isBreakUp andHasPassword:(BOOL)hasPassword;

@end
