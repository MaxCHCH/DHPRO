//
//  CalendarDetailViewController.m
//  zhidoushi
//
//  Created by nick on 15/10/22.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CalendarDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MJPhoto.h"
#import "SDWebImageManager+MJ.h"
#import "MJPhotoView.h"
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "PushCardViewController.h"
#import "iCarousel.h"

#define kPadding 7
#define kPhotoViewTagOffset 1000
#define kPhotoViewIndex(photoView) ([photoView tag] - kPhotoViewTagOffset)

@interface CalendarDetailViewController ()<MJPhotoViewDelegate>
{
    // 滚动的view
//    UIScrollView *_photoScrollView;
//    // 所有的图片view
//    NSMutableSet *_visiblePhotoViews;
//    NSMutableSet *_reusablePhotoViews;
//    // 一开始的状态栏
//    BOOL _statusBarHiddenInited;
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;

}
@property(nonatomic,strong)iCarousel *funView;//滚动视图
@property(nonatomic,strong)UIButton *againBtn;//重发
@property(nonatomic,strong)UIView *lastHotView;//上一个视图
//@property(nonatomic,strong)UIImageView *descBk;//话术背景
//@property(nonatomic,strong)UILabel *descLbl;//话术
//@property(nonatomic,strong)UILabel *titleLbl;//titlelabel
//@property(nonatomic,strong)UIButton *rightBtn;//替换按钮

@end

@implementation CalendarDetailViewController
//- (void)loadView
//{
//    _statusBarHiddenInited = [UIApplication sharedApplication].isStatusBarHidden;
//    self.view = [[UIView alloc] init];
//    self.view.frame = [UIScreen mainScreen].bounds;
//    self.view.backgroundColor = [UIColor blackColor];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [MobClick endLogPageView:@"打卡记录"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.view.backgroundColor = ZDS_BACK_COLOR;
    //友盟打点
    [MobClick beginLogPageView:@"打卡记录"];
//    UIView *titleViews = [[UIView alloc] init];
//    UIButton *leftBtn = [[UIButton alloc] init];
//    UIButton *rightBtn = [[UIButton alloc] init];
//    [titleViews addSubview:leftBtn];
//    [titleViews addSubview:rightBtn];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
//    self.rightBtn = rightBtn;
//    self.rightBtn.hidden = YES;
//    titleViews.frame = CGRectMake(0, 0, 120, 44);
//    titleViews.backgroundColor = [UIColor blackColor];

//    [self.navigationController.navigationBar setBackgroundImage:[WWTolls imageWithColor:[UIColor blackColor] size:CGSizeMake(SCREEN_WIDTH, 44)] forBarMetrics:UIBarMetricsDefault];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    self.leftButton.frame = CGRectMake(10, 14, 18, 18);
    
//    rightBtn.frame = CGRectMake(SCREEN_WIDTH - 78, 15, 68, 14);
//    [rightBtn setBackgroundImage:[UIImage imageNamed:@"cxfb-136-28"] forState:UIControlStateNormal];
//    [rightBtn addTarget:self action:@selector(again) forControlEvents:UIControlEventTouchUpInside];
    
    //导航栏标题
//    UILabel *title = [[UILabel alloc] init];
//    title.text = @"打卡详情";
//    title.textColor = [UIColor whiteColor];
//    title.font = MyFont(18);
//    title.textAlignment = NSTextAlignmentCenter;
//    title.frame = CGRectMake(20, 0, 80, 44);
//    self.titleLabel = title;
//    self.navigationItem.titleView = title;
//    if (self.photos && _photoScrollView) {
//        [self updateTollbarState];
//    }
    //导航栏标题
//    self.titleLabel.text = @"10月15日";
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.font = MyFont(18);
//    //隐藏底部导航栏
//    self.navigationController.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = YES;
//    //导航栏背景
//    [self.navigationController.navigationBar setBackgroundImage:[WWTolls imageWithColor:[UIColor blackColor] size:CGSizeMake(SCREEN_WIDTH, 44)] forBarMetrics:UIBarMetricsDefault];
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//
//    //导航栏返回
//    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
//    
//    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.leftButton.titleLabel.font = MyFont(13);
//    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
//    CGRect labelRect = self.leftButton.frame;
//    labelRect.size.width = 16;
//    labelRect.size.height = 16;
//    self.leftButton.frame = labelRect;
//    //导航栏发布
//    [self.rightButton setTitle:@"周记" forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font = MyFont(16);
//    [self.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
//    //    [self.rightButton addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
//    self.rightButton.width = 40;
//    self.rightButton.height = 16;
    
}

-(void)loadData{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.dakaId forKey:@"punchid"];
    [self showWaitView];
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:@"/game/punchinfo.do" parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [self removeWaitView];
        if (dic[ERRCODE]) {
            [self popButton];
        }else{
            MJPhoto *photo = self.photos[0];
            photo.punchdate = [dic[@"punchdate"] stringByReplacingOccurrencesOfString:@"-" withString:@""];
            photo.desc = dic[@"punchcontent"];
            [self setUpGUI];
//            if (_currentPhotoIndex == 0) {
//                [self showPhotos];
//            }
        }
        
    }];
    
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - again 重新发布
- (void)again{
    // 创建选择tup控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    [NSUSER_Defaults setObject:@"打卡只能添加1张图片" forKey:@"zdsselectphotoTip"];
    //    pickerVc.selectPickers = self.assets;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 1;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        PushCardViewController *punch = [[PushCardViewController alloc] init];
        punch.gameid = weakSelf.gameId;
        UIImage *image;
        if ([assets[0] isKindOfClass:[MLSelectPhotoAssets class]]) {
            image = ((MLSelectPhotoAssets*)assets[0]).originImage;
        }else image = assets[0];
        
        _photoEditMultipleComponent =
        [TuSDKGeeV1 photoEditMultipleWithController:self
                                      callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
         {
             if (controller) {
                 [controller popViewControllerAnimated:YES];
             }
             punch.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:result.imagePath]];
             [weakSelf.navigationController pushViewController:punch animated:YES];
         }];
        // 设置图片
        _photoEditMultipleComponent.inputImage = image;
        //    _photoEditMultipleComponent.inputTempFilePath = result.imagePath;
        //    _photoEditMultipleComponent.inputAsset = result.imageAsset;
        // 是否在组件执行完成后自动关闭组件 (默认:NO)
        _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
        [_photoEditMultipleComponent showComponent];
        
    };

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.currentPhotoIndex) {
        [self.funView scrollToItemAtIndex:self.currentPhotoIndex animated:YES];
    }
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if(!self.dakaId || self.dakaId.length < 1){
        [self setUpGUI];
//        if (_currentPhotoIndex == 0) {
//            [self showPhotos];
//        }
    }
    if (self.dakaId.length > 0) {
        [self loadData];
    }
}


- (void)setUpGUI{
    //初始化热门团组
    iCarousel *fun = [[iCarousel alloc] init];
    self.view.clipsToBounds = YES;
    fun.frame = CGRectMake(0, 30, SCREEN_WIDTH, 450*SCREEN_WIDTH/375);
    fun.delegate = self;
    fun.dataSource = self;
    fun.type = iCarouselTypeRotary;
    fun.scrollSpeed = 0.85;
    self.funView = fun;
    if (self.photos.count <= 1) {
        fun.scrollEnabled = NO;
    }
    [self.view addSubview:fun];
    
    
    UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_MIDDLE(140), fun.bottom + (SCREEN_HEIGHT - fun.bottom)/2 - 55, 140, 44)];
    [footerBtn setTitle:@"重新发布" forState:UIControlStateNormal];
    [footerBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
    footerBtn.titleLabel.font = MyFont(15);
    footerBtn.clipsToBounds = YES;
    footerBtn.layer.cornerRadius = 22;
    footerBtn.layer.borderColor = OrangeColor.CGColor;
    footerBtn.layer.borderWidth = 1;
    [footerBtn addTarget:self action:@selector(again) forControlEvents:UIControlEventTouchUpInside];
    self.againBtn = footerBtn;
    self.againBtn.hidden = YES;
    [self.view addSubview:footerBtn];
}


#pragma mark - icaldelegate

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.photos.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index{
//    homeHotCell *temp = [[homeHotCell alloc]init];
//    temp.frame = CGRectMake(69, 10, 200, 260);
//    temp.contentView.clipsToBounds = YES;
//    temp.clipsToBounds = YES;
//    temp.layer.cornerRadius = 5;
//    temp.contentView.layer.cornerRadius = 5;
//    temp.model = [self.hotData objectAtIndex:index];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClick:)];;
//    [temp addGestureRecognizer:tap];
    UIView *back = [[UIView alloc] init];
    back.frame =CGRectMake(69, 10, 315*SCREEN_WIDTH/375 + 30, 450*SCREEN_WIDTH/375);
    UIView *temp = [[UIView alloc] init];
    [back addSubview:temp];
    temp.frame = CGRectMake(15, 0, 315*SCREEN_WIDTH/375, 450*SCREEN_WIDTH/375);
    temp.backgroundColor = [UIColor whiteColor];
    temp.layer.shadowColor = [UIColor blackColor].CGColor;
    temp.layer.shadowOffset = CGSizeMake(0, 2);
    temp.layer.shadowOpacity = 0.4;
    
    UIImageView *imge = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 315*SCREEN_WIDTH/375 - 30, 315*SCREEN_WIDTH/375 - 30)];
    imge.clipsToBounds = YES;
    imge.contentMode = UIViewContentModeScaleAspectFill;
    MJPhoto *photo = self.photos[index];
    [imge sd_setImageWithURL:photo.url placeholderImage:photo.srcImageView.image];
    [temp addSubview:imge];
    
    //内容
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(15, imge.bottom + 15, 315*SCREEN_WIDTH/375 - 30, [WWTolls heightForString:photo.desc fontSize:13 andWidth:315*SCREEN_WIDTH/375 - 30])];
    text.textColor = ContentColor;
    text.font = MyFont(13);
    text.text = photo.desc;
    text.numberOfLines = 0;
    [temp addSubview:text];
    
    //时间
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(15, temp.bottom - 15 -13, 315*SCREEN_WIDTH/375 - 30, 12)];
    time.textColor = ContentColor;
    time.font = MyFont(10);
    time.textAlignment = NSTextAlignmentRight;
    time.text = [NSString stringWithFormat:@"%@/%@/%@",[photo.punchdate substringToIndex:3],[photo.punchdate substringWithRange:NSMakeRange(4, 2)],[photo.punchdate substringWithRange:NSMakeRange(6, 2)]];
    [temp addSubview:time];
    
    return back;
}

-(void)didClick:(UITapGestureRecognizer*)tap{
//    homeHotCell *cell = (homeHotCell*)tap.view;
//    HomeGroupModel *model = cell.model;
//    GroupViewController *gameDetail = [[GroupViewController alloc]init];
//    gameDetail.groupId = model.gameid;
//    if (model.gameid.length == 0) {
//        return;
//    }
//    [self.navigationController pushViewController:gameDetail animated:YES];
}

-(void)carouselDidScroll:(iCarousel *)carousel{
    if (self.lastHotView) {
        self.lastHotView.alpha = 0.4;
    }
//    carousel.currentItemView.layer.shadowColor = [UIColor blackColor].CGColor;
//    carousel.currentItemView.layer.shadowOffset = CGSizeMake(0, 2);
//    carousel.currentItemView.layer.shadowOpacity = 0.4;
//    carousel.currentItemView.layer.shadowRadius = 2;
//    self.lastHotView = carousel.currentItemView;
    //是否重发
    MJPhoto *p = self.photos[carousel.currentItemIndex];
    if([self.today isEqualToString:p.punchdate]){
        self.againBtn.hidden = NO;
    }else self.againBtn.hidden = YES;
    carousel.currentItemView.alpha = 1;
    self.lastHotView = carousel.currentItemView;
    
}

- (NSUInteger)numberOfPlaceholdersInCarousel:(iCarousel *)carousel{
    return 0;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel{
    return 100;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel{
    return 315*SCREEN_WIDTH/375 + 30;
}

- (CATransform3D)carousel:(iCarousel *)_carousel transformForItemView:(UIView *)view withOffset:(CGFloat)offset{
    view.alpha = 1.0 - fminf(fmaxf(offset, 0.0), 1.0);
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = self.funView.perspective;
    transform = CATransform3DRotate(transform, M_PI / 8.0, 0, 1.0, 0);
    return CATransform3DTranslate(transform, 0.0, 0.0, offset * _carousel.itemWidth);
}

- (BOOL)carouselShouldWrap:(iCarousel *)carousel{
    return YES;
}












//- (void)setUpGUI{
//    self.view.backgroundColor = [UIColor blackColor];
//    // 1.创建UIScrollView
//    [self createScrollView];
//    //创建label
//    UIImageView *lblbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yy-640-770"]];
//    self.descBk = lblbg;
//    [self.view addSubview:lblbg];
//    UILabel *lbl = [[UILabel alloc] init];
//    self.descLbl = lbl;
//    NSString *desc = @"";
//    CGFloat h =[WWTolls heightForString:desc fontSize:12 andWidth:SCREEN_WIDTH - 18];
//    lbl.frame = CGRectMake(9, SCREEN_HEIGHT - h - 12 - 66, SCREEN_WIDTH - 18 , h + 12);
//    lblbg.frame = CGRectMake(0, SCREEN_HEIGHT - h - 12 - 66 - 20, SCREEN_WIDTH, h + 40);
//    lbl.font = MyFont(12);
//    lbl.numberOfLines = 0;
//    lbl.text = desc;
//    lbl.textColor = [UIColor whiteColor];
//    [self.view addSubview:lbl];
//    if (self.photos.count == 1) {
//        [self updateTollbarState];
//    }
//
//}
//#pragma mark 创建UIScrollView
//- (void)createScrollView
//{
//    CGRect frame = self.view.bounds;
//    frame.origin.x -= kPadding;
//    frame.size.width += (2 * kPadding);
//    frame.size.height -= 66;
//    _photoScrollView = [[UIScrollView alloc] initWithFrame:frame];
//    _photoScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    _photoScrollView.pagingEnabled = YES;
//    _photoScrollView.delegate = self;
//    _photoScrollView.showsHorizontalScrollIndicator = NO;
//    _photoScrollView.showsVerticalScrollIndicator = NO;
//    _photoScrollView.backgroundColor = [UIColor clearColor];
//    _photoScrollView.contentSize = CGSizeMake(frame.size.width * _photos.count, 0);
//    [self.view addSubview:_photoScrollView];
//    _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * frame.size.width, 0);
//    [self showPhotos];
//}
//
//- (void)setPhotos:(NSArray *)photos
//{
//    _photos = photos;
//    
//    if (photos.count > 1) {
//        _visiblePhotoViews = [NSMutableSet set];
//        _reusablePhotoViews = [NSMutableSet set];
//    }
//    
//    for (int i = 0; i<_photos.count; i++) {
//        MJPhoto *photo = _photos[i];
//        photo.index = i;
//        photo.firstShow = i == _currentPhotoIndex;
//    }
//}
//
//#pragma mark 设置选中的图片
//- (void)setCurrentPhotoIndex:(NSUInteger)currentPhotoIndex
//{
//    _currentPhotoIndex = currentPhotoIndex;
//    
//    for (int i = 0; i<_photos.count; i++) {
//        MJPhoto *photo = _photos[i];
//        photo.firstShow = i == currentPhotoIndex;
//    }
//    
//    if ([self isViewLoaded]) {
//        _photoScrollView.contentOffset = CGPointMake(_currentPhotoIndex * _photoScrollView.frame.size.width, 0);
//        
//        // 显示所有的相片
//        [self showPhotos];
//    }
//}
//
//#pragma mark - MJPhotoView代理
//- (void)photoViewSingleTap:(MJPhotoView *)photoView
//{
//}
//
//- (void)photoViewDidEndZoom:(MJPhotoView *)photoView
//{
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//}
//
//- (void)photoViewImageFinishLoad:(MJPhotoView *)photoView
//{
//}
//
//#pragma mark 显示照片
//- (void)showPhotos
//{
//    // 只有一张图片
//    if (_photos.count == 1) {
//        [self showPhotoViewAtIndex:0];
//        return;
//    }
//    
//    CGRect visibleBounds = _photoScrollView.bounds;
//    int firstIndex = (int)floorf((CGRectGetMinX(visibleBounds)+kPadding*2) / CGRectGetWidth(visibleBounds));
//    int lastIndex  = (int)floorf((CGRectGetMaxX(visibleBounds)-kPadding*2-1) / CGRectGetWidth(visibleBounds));
//    if (firstIndex < 0) firstIndex = 0;
//    if (firstIndex >= _photos.count) firstIndex = _photos.count - 1;
//    if (lastIndex < 0) lastIndex = 0;
//    if (lastIndex >= _photos.count) lastIndex = _photos.count - 1;
//    
//    // 回收不再显示的ImageView
//    NSInteger photoViewIndex;
//    for (MJPhotoView *photoView in _visiblePhotoViews) {
//        photoViewIndex = kPhotoViewIndex(photoView);
//        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
//            [_reusablePhotoViews addObject:photoView];
//            [photoView removeFromSuperview];
//        }
//    }
//    
//    [_visiblePhotoViews minusSet:_reusablePhotoViews];
//    while (_reusablePhotoViews.count > 2) {
//        [_reusablePhotoViews removeObject:[_reusablePhotoViews anyObject]];
//    }
//    
//    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
//        if (![self isShowingPhotoViewAtIndex:index]) {
//            [self showPhotoViewAtIndex:index];
//        }
//    }
//}
//
//#pragma mark 显示一个图片view
//- (void)showPhotoViewAtIndex:(int)index
//{
//    MJPhotoView *photoView = [self dequeueReusablePhotoView];
//    if (!photoView) { // 添加新的图片view
//        photoView = [[MJPhotoView alloc] init];
//        photoView.photoViewDelegate = self;
//    }
//    for (UIGestureRecognizer *tap in photoView.gestureRecognizers) {
//        if ([tap isKindOfClass:[UITapGestureRecognizer class]]) {
//            [photoView removeGestureRecognizer:tap];
//        }
//    }
//    // 调整当期页的frame
//    CGRect bounds = _photoScrollView.bounds;
//    CGRect photoViewFrame = bounds;
//    photoViewFrame.size.width -= (4 * kPadding);
//    photoViewFrame.origin.x = (bounds.size.width * index) + 2*kPadding;
//    photoView.tag = kPhotoViewTagOffset + index;
//    
//    MJPhoto *photo = _photos[index];
//    photoView.frame = photoViewFrame;
//    photoView.photo = photo;
//    
//    [_visiblePhotoViews addObject:photoView];
//    [_photoScrollView addSubview:photoView];
//    
//    [self loadImageNearIndex:index];
//}
//
//#pragma mark 加载index附近的图片
//- (void)loadImageNearIndex:(int)index
//{
//    if (index > 0) {
//        MJPhoto *photo = _photos[index - 1];
//        [SDWebImageManager downloadWithURL:photo.url];
//    }
//    
//    if (index < _photos.count - 1) {
//        MJPhoto *photo = _photos[index + 1];
//        [SDWebImageManager downloadWithURL:photo.url];
//    }
//}
//
//#pragma mark index这页是否正在显示
//- (BOOL)isShowingPhotoViewAtIndex:(NSUInteger)index {
//    for (MJPhotoView *photoView in _visiblePhotoViews) {
//        if (kPhotoViewIndex(photoView) == index) {
//            return YES;
//        }
//    }
//    return  NO;
//}
//
//#pragma mark 循环利用某个view
//- (MJPhotoView *)dequeueReusablePhotoView
//{
//    MJPhotoView *photoView = [_reusablePhotoViews anyObject];
//    if (photoView) {
//        [_reusablePhotoViews removeObject:photoView];
//    }
//    return photoView;
//}
//
//#pragma mark 更新toolbar状态
//- (void)updateTollbarState
//{
//    _currentPhotoIndex = (_photoScrollView.contentOffset.x + _photoScrollView.frame.size.width/2) / _photoScrollView.frame.size.width;
//    //这里设置title
//    MJPhoto *photo = self.photos[_currentPhotoIndex];
//    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
//    [inputFormatter setDateFormat:@"yyyyMMdd"];
//    NSDate* inputDate = [inputFormatter dateFromString:photo.punchdate];
//    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
//    [outputFormatter setDateFormat:@"M月d日"];
//    NSString *str = [outputFormatter stringFromDate:inputDate];
//    self.titleLabel.text = str;
//    //是否重发
//    if([self.today isEqualToString:photo.punchdate]){
//        self.rightBtn.hidden = NO;
//    }else self.rightBtn.hidden = YES;
//    //描述文字
//    NSString *desc = photo.desc;
//    self.descLbl.text = [[desc stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//    CGFloat h =[WWTolls heightForString:desc fontSize:12 andWidth:SCREEN_WIDTH - 18];
//    self.descLbl.frame = CGRectMake(9, SCREEN_HEIGHT - h - 12 - 66, SCREEN_WIDTH - 18 , h + 12);
//    self.descBk.frame = CGRectMake(0, SCREEN_HEIGHT - h - 12 - 66 - 20, SCREEN_WIDTH, h + 40);
//    if(desc.length < 1) self.descBk.height = 0;
//}
//
//#pragma mark - UIScrollView Delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self showPhotos];
//    [self updateTollbarState];
//}

@end
