//
//  NARControl.h
//  zhidoushi
//
//  Created by xinglei on 14/11/24.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NARPageControlDataSource;

@interface NARControl : UIControl

@property(nonatomic)NSInteger currentPage;
@property(nonatomic)NSInteger numberOfPages;
@property(nonatomic)BOOL hidensForSinglePage;
@property(nonatomic)BOOL defersCurrentPageDisplay;
@property(nonatomic,weak)id <NARPageControlDataSource> dataSource;
/**
 *  Description pageControl的方法:(执行完操作之后才更新当前指示器)
 */
-(void)updateCurrentPageDisplay;
/**
 *  Description 可以根据具体有几页来设置大小
 *
 *  @param pageCount pageCount:有几页
 *
 *  @return return value description:传出一个CGSize的值
 */
-(CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
/**
 *  Description:改变page点的颜色
 */
-(void)refreshCurrentPageColors;
/**
 *  Description 根据坐标和偏移量计算页数
 *
 *  @param offset offset 偏移量
 *  @param frame  frame 坐标
 */
-(void)maskEventWithOffset:(CGFloat)offset frame:(CGRect)frame;
/**
 *  Description:调整pageControl的位置
 *
 *  @param percentage :百分比
 */
-(void)updateMaskWithPercentage:(CGFloat)percentage;

@end

@protocol NARPageControlDataSource <NSObject>

@required
/**
 *  Description 根据外界Index变化来改变当前pageControl的颜色
 *
 *  @param control 父类
 *  @param index   下标
 *
 *  @return return 返回的颜色,外界赋予
 */
- (UIColor *)pageControl:(NARControl *)control pageIndicatorTintColorForIndex:(NSInteger)index;
/**
 *  Description 根据外界变化改变下一个pageController的颜色
 *
 *  @param control 父类
 *  @param index   下标
 *
 *  @return        返回的颜色,外界赋予
 */
- (UIColor *)pageControl:(NARControl *)control currentPageIndicatorTintColorForIndex:(NSInteger)index;

@end