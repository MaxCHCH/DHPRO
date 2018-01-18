//  github: https://github.com/MakeZL/MLSelectPhoto
//  author: @email <120886865@qq.com>
//
//  MLSelectPhotoBrowserViewController.m
//  MLSelectPhoto
//
//  Created by 张磊 on 15/4/23.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "MLSelectPhotoBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIView+MLExtension.h"
#import "MLSelectPhotoPickerBrowserPhotoScrollView.h"
#import "MLSelectPhotoCommon.h"
#import "UIImage+MLTint.h"

// 分页控制器的高度
static NSInteger ZLPickerColletionViewPadding = 20;
static NSString *_cellIdentifier = @"collectionViewCell";

@interface MLSelectPhotoBrowserViewController () <UIScrollViewDelegate,ZLPhotoPickerPhotoScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

// 控件
@property (strong,nonatomic)    UIButton         *deleleBtn;
@property (weak,nonatomic)      UIButton         *backBtn;
@property (weak,nonatomic)      UICollectionView *collectionView;

// 标记View
@property (strong,nonatomic)    UIToolbar *toolBar;
@property (weak,nonatomic)      UILabel *makeView;
@property (strong,nonatomic)    UIButton *doneBtn;

/**
 *  替换按钮
 */
@property (strong,nonatomic)    UIButton *replaceBtn;

/**
 *  页码
 */
@property (strong,nonatomic)    UILabel *pageLabel;


@property (strong,nonatomic)    NSMutableDictionary *deleteAssets;
@property (strong,nonatomic)    NSMutableArray *doneAssets;

// 是否是编辑模式
@property (assign,nonatomic) BOOL isEditing;

@property (assign,nonatomic) BOOL isShowShowSheet;
@end

@implementation MLSelectPhotoBrowserViewController

#pragma mark - getter
#pragma mark collectionView
-(NSMutableDictionary *)deleteAssets{
    if (!_deleteAssets) {
        _deleteAssets = [NSMutableDictionary dictionary];
    }
    return _deleteAssets;
}

- (NSMutableArray *)doneAssets{
    if (!_doneAssets) {
        _doneAssets = [NSMutableArray array];
    }
    return _doneAssets;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = ZLPickerColletionViewPadding;
//        flowLayout.itemSize = self.view.ml_size;
        flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        flowLayout.minimumLineSpacing = 20;
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.ml_width,self.view.ml_height - 64) collectionViewLayout:flowLayout];
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.bounces = YES;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_cellIdentifier];
        
        [self.view addSubview:collectionView];
        self.collectionView = collectionView;
        
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_collectionView]-x-|" options:0 metrics:@{@"x":@(-20)} views:@{@"_collectionView":_collectionView}]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-x-[_collectionView]-44-|" options:0 metrics:@{@"x":@(0)} views:@{@"_collectionView":_collectionView}]];
        
        if (self.isEditing) {
            self.makeView.hidden = !(self.photos.count && self.isEditing);
            // 初始化底部ToorBar
            [self setupToorBar];
        }
    }
    return _collectionView;
}

#pragma mark Get View
#pragma mark makeView 红点标记View
- (UILabel *)makeView{
    if (!_makeView) {
        UILabel *makeView = [[UILabel alloc] init];
        makeView.textColor = [UIColor whiteColor];
        makeView.textAlignment = NSTextAlignmentCenter;
        makeView.font = [UIFont systemFontOfSize:13];
        makeView.frame = CGRectMake(-5, -5, 20, 20);
        makeView.hidden = YES;
        makeView.layer.cornerRadius = makeView.frame.size.height / 2.0;
        makeView.clipsToBounds = YES;
        makeView.backgroundColor = [UIColor redColor];
        [self.view addSubview:makeView];
        self.makeView = makeView;
        
    }
    return _makeView;
}

- (UIButton *)doneBtn{
    if (!_doneBtn) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.enabled = YES;
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        rightBtn.frame = CGRectMake(0, 0, 23, 23);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"sc-244"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(removePhoto) forControlEvents:UIControlEventTouchUpInside];
        self.doneBtn = rightBtn;
    }
    return _doneBtn;
}

- (UIButton *)replaceBtn{
    if (!_replaceBtn) {
        UIButton *replaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [replaceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        replaceBtn.enabled = YES;
        replaceBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        replaceBtn.frame = CGRectMake(0, 0, 23, 23);
        [replaceBtn addTarget:self action:@selector(replacePhoto) forControlEvents:UIControlEventTouchUpInside];
        [replaceBtn setBackgroundImage:[UIImage imageNamed:@"thzp-46"] forState:UIControlStateNormal];
        self.replaceBtn = replaceBtn;
    }
    return _replaceBtn;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        UILabel *pageLabel = [[UILabel alloc] init];

        pageLabel.textColor = [WWTolls colorWithHexString:@"#ff723e"];
        pageLabel.font = [UIFont systemFontOfSize:17];
        pageLabel.frame = CGRectMake(0, 0, 45, 45);

        pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentPage+1,self.photos.count];
  
        self.pageLabel = pageLabel;
    }
    return _pageLabel;
}

#pragma mark deleleBtn
- (UIButton *)deleleBtn{
    if (!_deleleBtn) {
        UIButton *deleleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleleBtn setImage:[UIImage imageNamed:@"dh-42"] forState:UIControlStateNormal];
        deleleBtn.frame = CGRectMake(0, 0, 30, 30);
        [deleleBtn addTarget:self action:@selector(deleteAsset) forControlEvents:UIControlEventTouchUpInside];
        self.deleleBtn = deleleBtn;
    }
    return _deleleBtn;
}

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    _doneAssets = [NSMutableArray arrayWithArray:photos];
    
    [self reloadData];
    self.makeView.text = [NSString stringWithFormat:@"%ld",self.photos.count];
}

- (void)setSheet:(UIActionSheet *)sheet{
    _sheet = sheet;
    if (!sheet) {
        self.isShowShowSheet = NO;
    }
}

#pragma mark - Life cycle
- (void)dealloc{
    self.isShowShowSheet = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)viewDidAppear:(BOOL)animated{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
//}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.automaticallyAdjustsScrollViewInsets = NO;
//
//    [self.navigationController.navigationBar setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#ffffff"] size:CGSizeMake(SCREEN_WIDTH, 44)] forBarMetrics:UIBarMetricsDefault];
    //广场标题
//    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentPage+1,self.photos.count];
//    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19];
//    self.titleLabel.textColor = [UIColor whiteColor];
    
    
    
    //导航取消
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
  
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    //导航条替换删除
//    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"sc-40"] forState:UIControlStateNormal];
//    [self.rightButton addTarget:self action:@selector(removePhoto) forControlEvents:UIControlEventTouchUpInside];
////    self.rightButton.bounds = CGRectMake(0, 0, 20, 20);
//    self.rightButton.frame = CGRectMake(20, 0, 20, 20);
//    UIView *rightBg = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 35, 20)];
//    [rightBg addSubview:self.rightButton];
//    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBg];
//    UIButton *changeBtn = [[UIButton alloc] init];
//    [changeBtn addTarget:self action:@selector(replacePhoto) forControlEvents:UIControlEventTouchUpInside];
//    [changeBtn setBackgroundImage:[UIImage imageNamed:@"thtp-40"] forState:UIControlStateNormal];
//    changeBtn.bounds = CGRectMake(0, 0, 20, 20);
//    UIBarButtonItem *cheBtn = [[UIBarButtonItem alloc] initWithCustomView:changeBtn];
//    [self.navigationItem setRightBarButtonItems:@[rightBtn,cheBtn]];
//    [self.navigationItem setRightBarButtonItem:rightBtn];
    
}

- (void)viewDidAppear:(BOOL)animated{
    //初始化图片
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsCompact];
////    [bar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forBarMetrics:UIBarMetricsCompact];
////    self.navigationController.navigationBar.backgroundColor = [[UIColor alloc] init];
    
    /**
     *  修复导航栏的透明效果带来的影响
     */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBar.hidden = NO;
    self.toolBar.hidden = NO;
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];  
}

- (void)removePhoto{
    [self.photos removeObjectAtIndex:self.currentPage];
    if(self.currentPage > self.photos.count-1) self.currentPage --;
    [_collectionView reloadData];
    [self setPageLabelPage:self.currentPage];
    if (self.photos.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)replacePhoto{
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    //    pickerVc.selectPickers = self.assets;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 1;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        if (assets.count > 0) {
            [weakSelf.photos replaceObjectAtIndex:weakSelf.currentPage withObject:assets[0]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
//        [weakSelf.collectionView reloadData];
    };
}

- (void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self setupToorBar];
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark -初始化底部ToorBar
- (void) setupToorBar{
    UIToolbar *toorBar = [[UIToolbar alloc] init];
    toorBar.barTintColor = [UIColor whiteColor];
    toorBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:toorBar];
    self.toolBar = toorBar;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(toorBar);
    NSString *widthVfl =  @"H:|-0-[toorBar]-0-|";
    NSString *heightVfl = @"V:[toorBar(44)]-0-|";
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:widthVfl options:0 metrics:0 views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:heightVfl options:0 metrics:0 views:views]];
    
    

    
    
    
    // 左视图 中间距 右视图

    /**
     * 中间的弹簧
     */
    UIBarButtonItem *fiexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    /**
     * 左侧替换按钮
     */
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.replaceBtn];
    
    /**
     * 中间的按钮
     */
    UIBarButtonItem *pageItem = [[UIBarButtonItem alloc] initWithCustomView:self.pageLabel];
    

    /**
     * 右侧按钮
     */
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.doneBtn];
    
    toorBar.items = @[leftItem,fiexItem,pageItem,fiexItem,rightItem];
}

- (void)deleteAsset{
    NSString *currentPage = [NSString stringWithFormat:@"%ld",self.currentPage];
    if ([_deleteAssets valueForKeyPath:currentPage] == nil) {
        [self.deleteAssets setObject:@YES forKey:currentPage];
        [self.deleleBtn setImage:[[UIImage imageNamed:@"dh-42" ] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
        
        if ([self.doneAssets containsObject:[self.photos objectAtIndex:self.currentPage]]) {
            [self.doneAssets removeObject:[self.photos objectAtIndex:self.currentPage]];
        }
    }else{
        if (![self.doneAssets containsObject:[self.photos objectAtIndex:self.currentPage]]) {
            [self.doneAssets addObject:[self.photos objectAtIndex:self.currentPage]];
        }
        [self.deleteAssets removeObjectForKey:currentPage];
        [self.deleleBtn setImage:[UIImage imageNamed:@"dh-42" ] forState:UIControlStateNormal];
    }
    
    self.makeView.text = [NSString stringWithFormat:@"%ld",self.doneAssets.count];
}

#pragma mark - reloadData
- (void) reloadData{
    
    [self.collectionView reloadData];
    
    if (self.currentPage >= 0) {
        CGFloat attachVal = 0;
        if (self.currentPage == self.photos.count - 1 && self.currentPage > 0) {
            attachVal = ZLPickerColletionViewPadding;
        }
        
        self.collectionView.ml_x = -attachVal;
        self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, 0);
        
        if (self.currentPage == self.photos.count - 1 && self.photos.count > 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(00.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.collectionView.contentOffset = CGPointMake(self.currentPage * self.collectionView.ml_width, self.collectionView.contentOffset.y);
            });
        }
    }
    
    // 添加自定义View
    [self setPageLabelPage:self.currentPage];
}

- (void)setIsEditing:(BOOL)isEditing{
    _isEditing = isEditing;
    
    if (isEditing) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.deleleBtn];
    }
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
    
    if (self.photos.count) {
        cell.backgroundColor = [UIColor clearColor];
        MLSelectPhotoAssets *photo = self.photos[indexPath.item]; //[self.dataSource photoBrowser:self photoAtIndex:indexPath.item];
        
        if([[cell.contentView.subviews lastObject] isKindOfClass:[UIView class]]){
            [[cell.contentView.subviews lastObject] removeFromSuperview];
        }
        
        UIView *scrollBoxView = [[UIView alloc] init];
        scrollBoxView.frame = cell.bounds;
//        scrollBoxView.ml_y = cell.ml_y;
        [cell.contentView addSubview:scrollBoxView];
        
        MLSelectPhotoPickerBrowserPhotoScrollView *scrollView =  [[MLSelectPhotoPickerBrowserPhotoScrollView alloc] init];
        if (self.sheet || self.isShowShowSheet == YES) {
            scrollView.sheet = self.sheet;
        }
        scrollView.backgroundColor = [UIColor clearColor];
        // 为了监听单击photoView事件
        scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        scrollView.photoScrollViewDelegate = self;
        scrollView.photo = photo;
        
        [scrollBoxView addSubview:scrollView];
//        scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return cell;
}
// 单击调用
- (void) pickerPhotoScrollViewDidSingleClick:(MLSelectPhotoPickerBrowserPhotoScrollView *)photoScrollView{
//    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.isHidden;
//    
//    [UIApplication sharedApplication].statusBarHidden = ![UIApplication sharedApplication].isStatusBarHidden;
//    self.toolBar.hidden = !self.toolBar.isHidden;
//    if (self.isEditing) {
//        self.toolBar.hidden = !self.toolBar.isHidden;
//    }
    
    
//    [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBar.isHidden animated:YES];
    
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect tempF = self.collectionView.frame;
    NSInteger currentPage = (NSInteger)((scrollView.contentOffset.x / scrollView.ml_width) + 0.5);
    if (tempF.size.width < [UIScreen mainScreen].bounds.size.width){
        tempF.size.width = [UIScreen mainScreen].bounds.size.width;
    }
    
    if ((currentPage < self.photos.count -1) || self.photos.count == 1) {
        tempF.origin.x = 0;
    }else if(scrollView.isDragging){
        tempF.origin.x = -ZLPickerColletionViewPadding;
    }
    
    if([[self.deleteAssets allValues] count] == 0 || [self.deleteAssets valueForKeyPath:[NSString stringWithFormat:@"%ld",(currentPage)]] == nil){
        [self.deleleBtn setImage:[UIImage imageNamed:@"dh-42" ] forState:UIControlStateNormal];
    }else{
        [self.deleleBtn setImage:[[UIImage imageNamed:@"dh-42" ] imageWithTintColor:[UIColor grayColor]] forState:UIControlStateNormal];
    }
    
    self.collectionView.frame = tempF;
}

- (void)done{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:PICKER_TAKE_DONE object:nil userInfo:@{@"selectAssets":self.doneAssets}];
    });
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPageLabelPage:(NSInteger)page{
    self.pageLabel.text = [NSString stringWithFormat:@"%ld / %ld",page + 1, self.photos.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = (NSInteger)scrollView.contentOffset.x / (scrollView.ml_width - ZLPickerColletionViewPadding);
    if (currentPage == self.photos.count - 1 && currentPage != self.currentPage && [[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0) {
        self.collectionView.contentOffset = CGPointMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y);
    }
    self.currentPage = currentPage;
    [self setPageLabelPage:currentPage];
}

@end