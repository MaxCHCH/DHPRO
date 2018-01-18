//
//  PageScrollLine.m
//  PageScrollLine
//
//  Created by licy on 14-9-23.
//  Copyright (c) 2014年 licy. All rights reserved.
//

#import "PageScrollLine.h"

#define kSSWidth [UIScreen mainScreen].bounds.size.width
#define kSSHeight [UIScreen mainScreen].bounds.size.height

@interface PageScrollLine ()

@property (nonatomic) int lineWidth;

@property (nonatomic,strong) UIView *lineView;


@property (nonatomic,strong) UIScrollView *rootScrollView;// 底部view

@property (nonatomic,strong) NSArray *viewArray;

//line
@property (nonatomic,assign) CGFloat topViewHeight;
@property (nonatomic,strong) UIColor *topViewColor;

//line到边缘距离  这里line和title宽度相等
@property (nonatomic,assign) CGFloat lineEdgeSpace;
@property (nonatomic,assign) CGFloat lineHeight;

@property (nonatomic,strong) UIColor *titleSelectColor;
@property (nonatomic,strong) UIColor *titleNormalColor;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) UIFont *titleFont;

@end    

@implementation PageScrollLine

#pragma mark - Initialize

//设置顶部view属性
/**
 *  <#Description#>
 *
 *  @param topViewHeight    <#topViewHeight description#>
 *  @param topViewColor     <#topViewColor description#>
 *  @param lineEdgeSpace    <#lineEdgeSpace description#>
 *  @param lineHeight       <#lineHeight description#>
 *  @param titleColor       <#titleColor description#>
 *  @param titleNormalColor <#titleNormalColor description#>
 *  @param titleArray       titleArray description
 *  @param titleFont        <#titleFont description#>
 */
- (void)setTopViewWithHeight:(CGFloat)topViewHeight topViewColor:(UIColor *)topViewColor lineEdgeSpace:(CGFloat)lineEdgeSpace lineHeight:(CGFloat)lineHeight lineWidth:(CGFloat)lineWidth titleSelectColor:(UIColor *)titleSelectColor titleNormalColor:(UIColor *)titleNormalColor titleArray:(NSArray *)titleArray titleFont:(UIFont *)titleFont {
    self.backgroundColor = [UIColor clearColor];
    
    self.topViewHeight = topViewHeight;
    self.topViewColor = topViewColor;
    self.lineEdgeSpace = lineEdgeSpace;
    self.lineHeight = lineHeight;
    self.lineWidth = lineWidth;
    self.titleSelectColor = titleSelectColor;
    self.titleNormalColor = titleNormalColor;
    self.titleArray = titleArray;
    self.titleFont = titleFont;
}

- (void)setBottomViewWithViewArray:(NSArray *)viewArray {
    
    self.viewArray = viewArray;
}

- (void)loadView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self createLineView];
    [self createRootScrollView];
}

#pragma mark - UI

//设置顶部view
- (void)createLineView {
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.topViewHeight)];
    [self addSubview:_topView];
    _topView.backgroundColor = self.topViewColor;
    
    NSInteger buttonCount = [self p_titleCount];
    
    CGFloat buttonX = [self titleLeadingX];
    CGFloat space = [self titleSpace];
    
    for (int i = 0; i < buttonCount; i++) {
        
        CGFloat x = buttonX + (space + self.lineWidth) * i;
        
        UIButton *label = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, self.lineWidth, self.topViewHeight - self.lineHeight)];
        label.tag = i;
        [label setTitle:self.titleArray[i] forState:UIControlStateNormal];
        label.titleLabel.font = self.titleFont;
        [_topView addSubview:label];
        [label setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        
        [label addTarget:self action:@selector(lineButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(label.frame.origin.x, _topView.height - self.lineHeight, label.frame.size.width, self.lineHeight)];
            lineView.backgroundColor = self.titleSelectColor;
//            [_topView addSubview:lineView];
            
            [label setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
            
            self.lineView = lineView;
            
            self.selectIndex = i;
        }
    }
}

//设置底部view
- (void)createRootScrollView
{
    NSLog(@"self.lineHeight:%f",self.lineHeight);
    _rootScrollView = [[UIScrollView alloc]init];
    
    //button先相应touch，否则没有点击效果
    _rootScrollView.delaysContentTouches = NO;
    _rootScrollView.frame = CGRectMake(0, self.topViewHeight, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - self.topViewHeight);
    _rootScrollView.showsHorizontalScrollIndicator = NO;
    _rootScrollView.showsVerticalScrollIndicator = NO;
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = NO;
    _rootScrollView.delegate = self;
    [self addSubview:_rootScrollView];
    
    // 设置滚动范围
    _rootScrollView.contentSize = CGSizeMake(_viewArray.count * CGRectGetWidth(_rootScrollView.frame), CGRectGetHeight(_rootScrollView.frame));
    
    for (int i = 0; i < _viewArray.count; i++) {
        
        UIView *view = _viewArray[i];
        view.frame = CGRectMake(i * kSSWidth, 0, CGRectGetWidth(_rootScrollView.frame), CGRectGetHeight(_rootScrollView.frame));
        [_rootScrollView addSubview:view];
    }
}

#pragma mark - Delegate
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int index = (int)scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if([_delegate respondsToSelector:@selector(scrollDidSelected:withIndex:)])
    {
        [_delegate scrollDidSelected:self withIndex:index];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.x > (self.frame.size.width * 3/2)) {
        
        [self p_setTopViewSelect:2];
    } else if (scrollView.contentOffset.x < (self.frame.size.width) * 1/2) {

        [self p_setTopViewSelect:0];
    } else {
        
        [self p_setTopViewSelect:1];
    }
}

#pragma mark - Event Response

//title点击事件
- (void)lineButtonClick:(UIButton *)button {
    
    if (self.selectIndex == button.tag) {
        return;
    }
    
    [self p_scrollViewSelect:button.tag];
    [self p_setTopViewSelect:button.tag];
    
    if ([_delegate respondsToSelector:@selector(scrollDidSelected:withIndex:)]) {
        [_delegate scrollDidSelected:self withIndex:button.tag];
    }
}

#pragma mark - Private Methods

//title数量
- (NSInteger)p_titleCount {
    return self.titleArray.count;
}

//title到边缘距离
- (CGFloat)titleLeadingX {
    return self.lineEdgeSpace;
}

//title之间的间距
- (CGFloat)titleSpace {
    
    CGFloat titleX = [self titleLeadingX];
    CGFloat space = (self.frame.size.width - titleX * 2 - self.lineWidth * [self p_titleCount]) / ([self p_titleCount] - 1);
    return space;
}

//每个title的x值
- (CGFloat)p_xWithIndex:(CGFloat)index {
    
    CGFloat space = [self titleSpace];
    
    CGFloat x = [self titleLeadingX] + (space + self.lineWidth) * index;
    return x;
}

//改变title颜色和line位置
- (void)p_setTopViewSelect:(NSInteger)index {
    
    self.selectIndex = index;
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.lineView.frame;
        rect.origin.x = [self p_xWithIndex:index];
        self.lineView.frame = rect;
    }];
    
    [_topView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            
            UIButton *label = (UIButton *)obj;
            
            if (label.tag == index) {
                [label setTitleColor:self.titleSelectColor forState:UIControlStateNormal];
            } else {
                [label setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
            }
        }
    }];
}

//改变scrollView的offset
- (void)p_scrollViewSelect:(NSInteger)index {
    
    _rootScrollView.contentOffset = CGPointMake(index * kSSWidth,0);
}



@end










