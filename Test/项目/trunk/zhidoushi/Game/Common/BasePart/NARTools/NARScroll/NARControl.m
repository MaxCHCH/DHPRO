//
//  NARControl.m
//  zhidoushi
//
//  Created by xinglei on 14/11/24.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARControl.h"

@interface NARControl ()

@property(nonatomic,weak)UIPageControl * narPageControl;
@property NSInteger currentMaskPage;
@property CGFloat lastMaskedPercentage;

@end

@implementation NARControl

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    [self setupPageController];
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (!self) {
        return self;
    }
    [self setupPageController];
    return self;
}

-(void)setupPageController{
    
    if (!self.narPageControl) {
        UIPageControl *primaryPageControl = [[UIPageControl alloc]init];
        [primaryPageControl setUserInteractionEnabled:NO];
        [self addSubview:primaryPageControl];
        self.narPageControl = primaryPageControl;
    }
    
}

#pragma mark - Synthesis Overriding

-(void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
}

-(void)setNumberOfPages:(NSInteger)numberOfPages
{
    _numberOfPages = MAX(0, numberOfPages);
    self.currentPage = MIN(MAX(0, self.currentPage), numberOfPages);
    self.bounds = (CGRect){.size = [self sizeForNumberOfPages:numberOfPages]};
    self.hidden = self.hidensForSinglePage && self.numberOfPages <2;
}

-(void)setDefersCurrentPageDisplay:(BOOL)defersCurrentPageDisplay
{
    _defersCurrentPageDisplay = defersCurrentPageDisplay;
}

-(void)setHidensForSinglePage:(BOOL)hidensForSinglePage{

    _hidensForSinglePage = hidensForSinglePage;
}

-(void)setDataSource:(id<NARPageControlDataSource>)dataSource{
    _dataSource = dataSource;
    [self refreshCurrentPageColors];
}

#pragma mark - UIPageControl Methods

-(void)updateCurrentPageDisplay{

    [self.narPageControl updateCurrentPageDisplay];
}

-(CGSize)sizeForNumberOfPages:(NSInteger)pageCount{

    return [self.narPageControl sizeForNumberOfPages:pageCount];
}

#pragma mark - Masking

-(void)refreshCurrentPageColors{
    if (!self.dataSource) {
        return;
    }
    UIColor *primaryCurrentIndicatorTint = [self.dataSource pageControl:self currentPageIndicatorTintColorForIndex:self.currentMaskPage];
    UIColor *primaryIndicatorTint = [self.dataSource pageControl:self pageIndicatorTintColorForIndex:self.currentMaskPage];
    [self.narPageControl setCurrentPageIndicatorTintColor:primaryCurrentIndicatorTint];
    [self.narPageControl setPageIndicatorTintColor:primaryIndicatorTint];
}

-(void)maskEventWithOffset:(CGFloat)offset frame:(CGRect)frame{

    int page = floorf(offset / CGRectGetWidth(frame));

    CGFloat offsetRemainder = offset - page *CGRectGetWidth(frame);
    
    CGFloat percentage = MIN(CGRectGetWidth(frame), MAX(0, offsetRemainder-CGRectGetMinX(self.frame))) / CGRectGetWidth(self.bounds);
    
    if (self.currentMaskPage!=page) {
        self.currentMaskPage = page;
        [self refreshCurrentPageColors];
    }
    
    [self updateMaskWithPercentage:percentage];
}

- (void)updateMaskWithPercentage:(CGFloat)percentage {
    
    percentage = MIN(MAX(0, percentage), 1);
    
    if (!self.layer.mask) {
        self.narPageControl.layer.mask = [CALayer layer];
        self.narPageControl.layer.mask.backgroundColor = [[UIColor blackColor] CGColor];
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES]; // Removed implicit animation that was causing delays
    
    CGRect pageControlFrame = self.narPageControl.layer.bounds;
    pageControlFrame.origin.x = 0;
    pageControlFrame.size.width = CGRectGetWidth(pageControlFrame) * (1 - percentage);
    self.narPageControl.layer.mask.frame = pageControlFrame;
    [CATransaction commit];
    
    self.lastMaskedPercentage = percentage;
}

#pragma mark - UIControl Method

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *tap = [touches anyObject];
    CGPoint location = [tap locationInView:self];
    
    if (location.x < CGRectGetMidX(self.bounds)) {
        self.currentPage = MAX(0, self.currentPage - 1);
    } else {
        self.currentPage = MIN(self.currentPage + 1, self.numberOfPages - 1);
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
