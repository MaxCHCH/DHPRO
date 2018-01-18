//
//  PageScrollLine.h
//  PageScrollLine
//
//  Created by licy on 14-9-23.
//  Copyright (c) 2014年 licy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PageScrollLine;

@protocol PageScrollLineDelegate <NSObject>

@optional
- (void)scrollDidSelected:(PageScrollLine *)PageScrollSegment withIndex:(NSInteger)index;

@end    

@interface PageScrollLine : UIView <UIScrollViewDelegate>

//设置顶部view属性
- (void)setTopViewWithHeight:(CGFloat)topViewHeight topViewColor:(UIColor *)topViewColor lineEdgeSpace:(CGFloat)lineEdgeSpace lineHeight:(CGFloat)lineHeight lineWidth:(CGFloat)lineWidth titleSelectColor:(UIColor *)titleSelectColor titleNormalColor:(UIColor *)titleNormalColor titleArray:(NSArray *)titleArray titleFont:(UIFont *)titleFont;

//设置底部view属性
- (void)setBottomViewWithViewArray:(NSArray *)viewArray;

@property (nonatomic,strong) UIView *topView;//顶部view

- (void)loadView;

@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,assign)id<PageScrollLineDelegate> delegate;

@end










