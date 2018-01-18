//
//  YCGameViewController.m
//  zhidoushi
//
//  Created by Sunshine on 15/11/9.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "YCGameViewController.h"
#import "YCSquareButton.h"
#import "YCGroupCollectionViewCell.h"
#import "WWRequestOperationEngine.h"

#import "YCCircleModel.h"

#import "GroupTypeViewController.h"

#import "YCTopScrollView.h"

#import "AllGroupViewController.h"
#import "CreateGroupTwoNewViewController.h"
#import "SearchResultsViewController.h"
#import "commentViewController.h"
#import "ChatListViewController.h"
#import "GroupViewController.h"

#define ZDS_QUANZI          @"/game/circle.do"//获取圈子图片资源

@interface YCGameViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewH;

@property(nonatomic,strong)MJRefreshHeaderView *timeHeader;//时间头部刷新
/**
 *  顶部的view
 */
@property (weak, nonatomic) IBOutlet YCTopScrollView *scrollView;

/**
 *  底部的collectionView
 */
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


/** 加载更多团组按钮 */
@property (nonatomic, strong)UIButton *moreBtn;

/**
 *  所有圈子模型数据
 */
@property(nonatomic,strong)NSMutableArray *circleData;

/**
 *  按热门团组
 */
@property(nonatomic,strong)NSMutableArray* hotData;
@end

static NSString * const YCGroupID = @"GroupCell";

static NSString * const kTopicHeaderIdentifier = @"HeaderID";

@implementation YCGameViewController

// circleData
-(NSMutableArray *)circleData{
    if (_circleData == nil) {
        _circleData = [NSMutableArray array];
    }
    return _circleData;
}

-(NSMutableArray *)hotData{
    if (_hotData == nil) {
        _hotData = [NSMutableArray array];
    }
    return _hotData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self setupUI];
    
    //添加视图
    [self readCoache];
    
//    [self refreshData];
    
    [self.timeHeader beginRefreshing];
    
    
    //点击通知中心方式打开app  监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMygame:) name:@"myAppBeginWithTongZhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];

}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //友盟统计--结束
    [MobClick endLogPageView:@"减脂吧页面"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟统计--开始
    [MobClick beginLogPageView:@"减脂吧页面"];
    if (self.navigationController.tabBarController.selectedIndex != 0) {
        [MobClick event:@"HOME"];
        [WWTolls zdsClick:@"jznum"];
    }
    
    //广场标题
    self.titleLabel.text = @"减脂吧";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = [WWTolls colorWithHexString:@"#475564"];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    //导航搜索
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"ss-c-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    //导航创建团组按钮
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"cj-36"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);

    [self.rightButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 18, 18);
}

/**
 *  初始化UI
 */
- (void)setupUI {
    
    /** 左右边距*/
    CGFloat marginLR = 15;
    
    /** 上下边距*/
    CGFloat marginTB = 15;
    
    /** X方向的边距*/
    CGFloat marginX = 15;
    
    /** 按钮的宽度*/
    CGFloat btnW = 70;
//    /** 按钮的高度*/
    CGFloat btnH = btnW + 7.5 + [WWTolls heightForString:@"哈哈" fontSize:13];
  
    // 1. 初始化顶部的scrollview
    WEAKSELF_SS
    self.scrollViewH.constant = marginTB * 2 + btnH;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    // item的尺寸
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 45) * 0.5, (SCREEN_WIDTH - 45) * 0.5);
    
    // 中间的间隙
    layout.minimumLineSpacing = 15;
    
    layout.sectionInset = UIEdgeInsetsMake([WWTolls heightForString:@"哈哈" fontSize:17] + marginTB *2, 0, 70, 0);
    
    // 滚动方向
    layout.scrollDirection = UICollectionViewScrollPositionCenteredHorizontally;
//    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 50);
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    // 注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YCGroupCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:YCGroupID];
    
    // 顶部标签
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * marginLR, [WWTolls heightForString:@"哈哈" fontSize:17] + marginTB * 2)];
    
//    topLabel.backgroundColor = [UIColor redColor];
    topLabel.font = MyFont(17);
    topLabel.text = @"热门团组";
    topLabel.textColor = [WWTolls colorWithHexString:@"#ff5304"];
    [self.collectionView addSubview:topLabel];
    
    
    // 底部跟多团组按钮
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];

    self.moreBtn = moreBtn;
    
    [moreBtn addTarget:self action:@selector(moreTap) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.backgroundColor = [UIColor whiteColor];
    
    [moreBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    
    [moreBtn setTitleColor:[WWTolls colorWithHexString:@"ff5304"] forState:UIControlStateNormal];
    
    moreBtn.frame = CGRectMake(0, self.hotData.count * ((SCREEN_WIDTH - 45) * 0.5 + marginX ) + [WWTolls heightForString:@"哈哈" fontSize:17] + marginTB *2,  SCREEN_WIDTH - 30, 44);
    
    moreBtn.clipsToBounds = YES;
    moreBtn.layer.cornerRadius = 22;
    moreBtn.layer.borderColor = [WWTolls colorWithHexString:@"ff5304"].CGColor;
    moreBtn.layer.borderWidth = 1;
    
    [self.collectionView addSubview:moreBtn];
    
    //初始化刷新
    MJRefreshHeaderView *head = [MJRefreshHeaderView header];
    self.timeHeader = head;
    head.scrollView = self.collectionView;
    head.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [weakSelf refreshData];
    };
    
}

#pragma mark - 刷新
-(void)refreshData{
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"99" forKey:@"pageSize"];
    //
    //    //发送请求
    WEAKSELF_SS
    
    // 发送请求获取热门团组等资源
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_HOT_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            [weakSelf.hotData removeAllObjects];
            NSArray *tempArray = dic[@"hotgamelist"];
            for (int i = 0;i<tempArray.count;i++) {
                NSDictionary *dic = tempArray[i];
                HomeGroupModel *model = [HomeGroupModel modelWithDic:dic];
                [weakSelf.hotData addObject:model];
            }
            
//            NSLog(@"%@", self.hotData);

            [weakSelf.collectionView reloadData];
            //缓存
            [NSUSER_Defaults setValue:dic forKey:GAME_HOTGAME_CACHE_PATH];
            [NSUSER_Defaults synchronize];
            
            [weakSelf.timeHeader endRefreshing];
        }
    }];
    // ////////////////////////////////////////////////////////////////////
    // 发送请求获取圈子的图片等资源
    //构造请求参数
    NSMutableDictionary *dictionaryQZ = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionaryQZ setObject:@"1" forKey:@"clickevent"];
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_QUANZI parameters:dictionaryQZ requestOperationBlock:^(NSDictionary *dic) {
        
        NSLog(@"%@", dic);
        
        
        if (!dic[ERRCODE]) {
            [weakSelf.circleData removeAllObjects];
            
            NSArray *parterList = dic[@"circlelist"];
            
            for (NSDictionary *dict in parterList) {
                YCCircleModel *model = [[YCCircleModel alloc] initWithDic:dict];
                NSLog(@"%@", model);
                [weakSelf.circleData addObject:model];
            }
            
            // 刷新圈子图标
            weakSelf.scrollView.circleArr = self.circleData;
            
            //缓存
            [NSUSER_Defaults setValue:dic forKey:@"quanzichoche"];
            [NSUSER_Defaults synchronize];
            
            [weakSelf.timeHeader endRefreshing];
            
        }
    }];
}

#pragma mark - 跳转搜索页面
-(void)popButton{
    [MobClick event:@"HomeSearch"];
    SearchResultsViewController *search = [[SearchResultsViewController alloc]init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - 跳转到创建游戏界面
-(void)createGame{
    
    WEAKSELF_SS
    CreateGroupTwoNewViewController * create = [[CreateGroupTwoNewViewController alloc]init];
    create.isPassWordGrouper = YES;
    create.hidesBottomBarWhenPushed = YES;
    [weakSelf.navigationController pushViewController:create animated:YES];
    
    
    
//    [MobClick event:@"HomeCreate"];
//    self.rightButton.userInteractionEnabled = YES;
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
//    
//    WEAKSELF_SS
//    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATECHK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
//        weakSelf.rightButton.userInteractionEnabled = YES;
//        
//        if (!dic[ERRCODE]) {
//            CreateGroupTwoNewViewController * create = [[CreateGroupTwoNewViewController alloc]init];
//            create.isPassWordGrouper = [dic[@"ispasswd"] isEqualToString:@"0"];
//            create.hidesBottomBarWhenPushed = YES;
//            [weakSelf.navigationController pushViewController:create animated:YES];
//        }
//        weakSelf.rightButton.userInteractionEnabled = YES;
//    }];
}

-(void)moreTap {
    AllGroupViewController *all = [[AllGroupViewController alloc] init];
    all.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:all animated:YES];
}

#pragma mark - 监听通知事件  从通知中心打开app跳转至团组通知页
-(void)gotoMygame:(NSNotification*)noty{
    if (noty.object != nil) {
        if ([noty.object isEqualToString:@"1"]) {//评论
            commentViewController *cc = [[commentViewController alloc] init];
            cc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:cc animated:YES];
        }else if ([noty.object isEqualToString:@"2"]){
            ChatListViewController *chat = [[ChatListViewController alloc] init];
            chat.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chat animated:YES];
        }
    }else [self.tabBarController setSelectedIndex:2];
}

- (void)notifyHiden{
//    self.table.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-70);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    self.moreBtn.y = (self.hotData.count + 1 ) / 2 * ((SCREEN_WIDTH - 45) * 0.5 + 15) + [WWTolls heightForString:@"哈哈" fontSize:17] + 15 * 2;
    
    return self.hotData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YCGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YCGroupID forIndexPath:indexPath];
    
    HomeGroupModel *model = self.hotData[indexPath.row];
    
    cell.model = model;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    HomeGroupModel *myReplyModel = self.hotData[indexPath.row];
    GroupViewController *gameDetail = [[GroupViewController alloc]init];
    gameDetail.clickevent = 1;
    gameDetail.joinClickevent = @"1";
    gameDetail.groupId = myReplyModel.gameid;
    gameDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gameDetail animated:YES];
}

#pragma mark - 读取缓存
-(void)readCoache{
    //读取热门团组
    NSDictionary *dic = [NSUSER_Defaults objectForKey:GAME_HOTGAME_CACHE_PATH];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *tempArray = dic[@"hotgamelist"];
    if (tempArray.count>0) {
        for (NSDictionary *dic in tempArray) {
            [self.hotData addObject:[HomeGroupModel modelWithDic:dic]];
        }
        [self.collectionView reloadData];
    }
    
    dic = [NSUSER_Defaults objectForKey:@"quanzichoche"];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [self.circleData removeAllObjects];
    
    NSArray *parterList = dic[@"circlelist"];
    
    for (NSDictionary *dict in parterList) {
        YCCircleModel *model = [[YCCircleModel alloc] initWithDic:dict];
        
        NSLog(@"%@", model);
        [self.circleData addObject:model];
    }
    self.scrollView.circleArr = self.circleData;
    
}

-(void)dealloc{
    [self.timeHeader free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
