//
//  AddView.m
//  zhidoushi
//
//  Created by xiang on 15-1-23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "AddView.h"
#import "AddModel.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "NSURL+MyImageURL.h"
#define color(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
@interface AddView ()<UIScrollViewDelegate>


@property(nonatomic,strong)NSTimer   *timer;
@property(nonatomic,weak) UIPageControl *pageControl;
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,assign)int adTotal;;

@property(nonatomic,strong)NSArray *ads;//AddModel
@end

@implementation AddView

- (void)setAds:(NSArray *)ads {
    
    _ads = ads;
    if (ads == nil||ads.count == 0) {
        return;
    }
    self.adTotal = (int)ads.count;
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width *(ads.count+1), self.scrollView.bounds.size.height);
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height =  self.scrollView.bounds.size.height;
    
    //    在scrollView上添加广告图片
    for (int i = 0; i<ads.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat x = i*self.scrollView.bounds.size.width;
        CGFloat y = 0;
        imageView.frame = CGRectMake(x, y, width, height);
        imageView.backgroundColor = [UIColor whiteColor];
        //          设置数据
        
        AddModel *ad = [ads objectAtIndex:i];
        NSString *urlstr = ad.imageUrl;
        
        [imageView sd_setImageWithURL:[NSURL URLWithImageString:urlstr Size:0]];
        
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        
        
        [imageView addGestureRecognizer:  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)]];
        [self.scrollView addSubview:imageView];
        
    }
    if (ads.count>=2) {
        //加载第一张图片用于向后无线循环
        UIImageView *imageView = [[UIImageView alloc] init];
        CGFloat x = ads.count*self.scrollView.bounds.size.width;
        CGFloat y = 0;
        imageView.frame = CGRectMake(x, y, width, height);
        imageView.backgroundColor = [UIColor whiteColor];
        //          设置数据
        
        AddModel *ad = [ads objectAtIndex:0];
        NSString *urlstr = ad.imageUrl;
        [imageView sd_cancelCurrentImageLoad];
        [imageView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
        
        
        imageView.tag = 0;
        imageView.userInteractionEnabled = YES;
        
        
        [imageView addGestureRecognizer:  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)]];
        [self.scrollView addSubview:imageView];
    }
    
    self.pageControl.numberOfPages = ads.count;
    if(ads.count < 2)self.pageControl.hidden = YES;
    else self.pageControl.hidden = NO;
    CGFloat pageWidth = self.frame.size.width*0.25;
    CGFloat pageHieght = 20;
    CGFloat pageX = (self.frame.size.width - pageWidth)-12;
    CGFloat pageY = self.frame.size.height - 25;
    
    self.pageControl.enabled = NO;
    self.pageControl.pageIndicatorTintColor = color(200, 200, 200, 0.8);//白色半透明
    self.pageControl.currentPageIndicatorTintColor = color(45, 45, 45, 0.8);//灰色半透明
    self.pageControl.frame = CGRectMake(pageX, pageY, pageWidth, pageHieght);
    
    if (self.adTotal < 2) {
        self.scrollView.contentSize =CGSizeMake(320, 150);
        return;
    }
    //        添加图片轮播定时器
    if (!self.timer) {
        [self addTimer];
    }
    
}

-(instancetype)initWithAds:(NSArray *)ads
{
    if (self = [super init]) {
        
        NSUInteger num = _ads.count;
        
        self.adTotal = (int)num;
        self.ads = _ads;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = KADViewheight ;
        self.frame = CGRectMake(0, 0, width, height);
        
        UIScrollView *adView = [[UIScrollView alloc] init];
        adView.frame = self.bounds;
        
        adView.contentSize = CGSizeMake(width *(num+1), height);
        self.scrollView = adView;
        [self addSubview:adView];
        //    在scrollView上添加广告图片
        for (int i = 0; i<num; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            CGFloat x = i*self.scrollView.bounds.size.width;
            CGFloat y = 0;
            imageView.frame = CGRectMake(x, y, width, height);
            imageView.backgroundColor = [UIColor whiteColor];
            AddModel *ad = [_ads objectAtIndex:i];
            NSString *imagURL = ad.imageUrl;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imagURL]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)]];
            [self.scrollView addSubview:imageView];
        }
        if (ads.count>=2) {
            [self.scrollView setContentInset:UIEdgeInsetsMake(0, self.frame.size.width, 0, 0)];
            //加载第一张图片用于向后无线循环
            UIImageView *imageView = [[UIImageView alloc] init];
            CGFloat x = ads.count*self.scrollView.bounds.size.width;
            CGFloat y = 0;
            imageView.frame = CGRectMake(x, y, width, height);
            imageView.backgroundColor = [UIColor whiteColor];
            AddModel *ad = [ads objectAtIndex:0];
            NSString *urlstr = ad.imageUrl;
            //[imageView sd_setImageWithURL:[NSURL URLWithString:urlstr] placeholderImage:nil options:SDWebImageRefreshCached];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlstr]];
            imageView.tag = 0;
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgClick:)]];
            [self.scrollView addSubview:imageView];
        }
        adView.pagingEnabled = YES;
        adView.showsHorizontalScrollIndicator = NO;
        adView.showsVerticalScrollIndicator = NO;
        adView.delegate = self;
        UIPageControl *page = [[UIPageControl alloc] init];
        page.numberOfPages = num;
        
        CGFloat pageWidth = self.frame.size.width*0.25;
        CGFloat pageHieght = 20;
        CGFloat pageX = (self.frame.size.width - pageWidth)-10;
        CGFloat pageY = self.frame.size.height - 30;
        page.enabled = NO;
        page.frame = CGRectMake(pageX, pageY, pageWidth, pageHieght);
        
        
        [self addSubview:page];
        self.backgroundColor = [UIColor whiteColor];
        
        self.pageControl = page;
    }
    if (self.adTotal < 2) {
        self.scrollView.contentSize =CGSizeMake(320, 150);
    }
    return self;
}


/**
 *  添加定时器
 */
-(void)addTimer

{
    
    if (self.adTotal<2) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(next) userInfo:nil repeats:YES];
    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}
/**
 *  移除定时器
 */
- (void)removeTimer
{
    if (self.adTotal<2) {
        return;
    }
    [self.timer invalidate];
    self.timer = nil;
}

- (void)next
{

    long page = 0;
    page = self.pageControl.currentPage + 1;

    CGFloat offsetX = page * self.scrollView.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
    if (page == self.adTotal) {
        self.pageControl.currentPage = 0;
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.scrollView setContentOffset:CGPointZero animated:NO];
        });
        
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    if (page>=self.adTotal) {
        self.pageControl.currentPage = 0;
        __weak typeof(self) weakself = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.scrollView setContentOffset:CGPointZero animated:NO];
        });
    }
    else self.pageControl.currentPage = page;
}


/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}
/**
 *  点击广告
 *
 *  @param sender
 */
- (void)imgClick:(UITapGestureRecognizer *)tap
{
    
    AddModel *ad = self.ads[tap.view.tag];
    NSLog(@"%@",ad);
    
    if (self.adDidClick) {
        self.adDidClick(ad);
    }
    
}

@end
