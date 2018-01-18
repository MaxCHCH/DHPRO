//
//  HotTagView.h
//  zhidoushi
//
//  Created by licy on 15/7/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HotTagView;

@protocol HotTagViewDelegate <NSObject>

/**
 *  选择某个热门标签的回调
 *
 *  @param hotTagView 本类
 *  @param title      button 的title值
 */
- (void)hotTagView:(HotTagView *)hotTagView selectButtonWithTitle:(NSString *)title;

@end

@interface HotTagView : UIView

- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSMutableArray *)tagArray;

@property (nonatomic,weak) id <HotTagViewDelegate> delegate;

@end
