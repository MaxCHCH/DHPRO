//
//  XFunnyView.m
//  zhidoushi
//
//  Created by nick on 15/4/21.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "XFunnyView.h"
#define c_width (180) //两张图片之前有10点的间隔

#define c_height (self.bounds.size.height)

@interface XFunnyView(){
NSMutableArray *_curImageArray; //当前显示的图片数组
NSInteger          _curPage;    //当前显示的图片位置
NSTimer           *_timer;      //定时器
}
@end

@implementation XFunnyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = 240;
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
        //滚动视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(85, 0, 200, height)];
        self.scrollView.clipsToBounds = NO;
        self.scrollView.contentSize = CGSizeMake(150*3, 0);
        self.scrollView.contentOffset = CGPointMake(150, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        
        
        //初始化数据，当前图片默认位置是0
        _curImageArray = [[NSMutableArray alloc] initWithCapacity:0];
        _curPage = 0;
    }
    return self;
}
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    return self.scrollView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //如果scrollView当前偏移位置x大于等于两倍scrollView宽度
    if (scrollView.contentOffset.x >= c_width*2) {
        //当前图片位置+1
        _curPage++;
        //如果当前图片位置超过数组边界，则设置为0
        if (_curPage == [self.imageArray count]) {
            _curPage = 0;
        }
        //刷新图片
        [self reloadData];
        //设置scrollView偏移位置
        [scrollView setContentOffset:CGPointMake(c_width, 0)];
    }
    
    //如果scrollView当前偏移位置x小于等于0
    else if (scrollView.contentOffset.x <= 0) {
        //当前图片位置-1
        _curPage--;
        //如果当前图片位置小于数组边界，则设置为数组最后一张图片下标
        if (_curPage == -1) {
            _curPage = [self.imageArray count]-1;
        }
        //刷新图片
        [self reloadData];
        //设置scrollView偏移位置
        [scrollView setContentOffset:CGPointMake(c_width, 0)];
    }
}



//停止滚动的时候回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //设置scrollView偏移位置
}
/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    }

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    //刷新图片
    [self reloadData];
    
}

- (void)reloadData
{
    //根据当前页取出图片
    [self getDisplayImagesWithCurpage:_curPage];
    
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if ([subViews count] > 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    //创建imageView
    for (int i = 0; i < 3; i++) {
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(c_width*i, 0, self.bounds.size.width, c_height)];
//        imageView.userInteractionEnabled = YES;
//        [self.scrollView addSubview:imageView];
//#warning 加载数据在这里
//        //          设置数据
////        NSString *imageUrl = _curImageArray[i];
//        imageView.image = [UIImage imageNamed:@"tztx_168_168"];
        UIView *view = _curImageArray[i];
        view.frame = CGRectMake(160*i, 0, 150, c_height);
        [self.scrollView addSubview:view];
        //tap手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        [view addGestureRecognizer:tap];
    }
}

- (void)getDisplayImagesWithCurpage:(NSInteger)page
{
    //取出开头和末尾图片在图片数组里的下标
    NSInteger front = page - 1;
    NSInteger last = page + 1;
    
    //如果当前图片下标是0，则开头图片设置为图片数组的最后一个元素
    if (page == 0) {
        front = [self.imageArray count]-1;
    }
    
    //如果当前图片下标是图片数组最后一个元素，则设置末尾图片为图片数组的第一个元素
    if (page == [self.imageArray count]-1) {
        last = 0;
    }
    
    //如果当前图片数组不为空，则移除所有元素
    if ([_curImageArray count] > 0) {
        [_curImageArray removeAllObjects];
    }
    
    //当前图片数组添加图片
    [_curImageArray addObject:self.imageArray[front]];
    [_curImageArray addObject:self.imageArray[page]];
    [_curImageArray addObject:self.imageArray[last]];
}

- (void)timerScrollImage
{
    //刷新图片
    [self reloadData];
    
    //设置scrollView偏移位置
    [self.scrollView setContentOffset:CGPointMake(c_width*2, 0) animated:YES];
}

#warning 响应事件在这里
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    
    if (_adDidClick) {
        _adDidClick(_curPage);
    }
    
}

- (void)dealloc
{
    //代理指向nil，关闭定时器
    self.scrollView.delegate = nil;
}

@end
