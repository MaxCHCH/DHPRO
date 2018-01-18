//
//  GameViewController.m
//  zhidoushi
//
//  Created by Nick on 15-3-17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GameViewController.h"
#import "SearchResultsViewController.h"
#import "WWTolls.h"
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"
#import "UIViewExt.h"
#import "NSString+NARSafeString.h"
#import "UIViewController+ShowAlert.h"
#import "GroupViewController.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "customMyImageButton.h"
#import "JYGroupView.h"
#import "SelectTagsViewController.h"
#import "MeViewController.h"
#import "StoreDetailViewController.h"
#import "WebViewController.h"
#import "DiscoverDetailViewController.h"
#import "DiscoverTypeViewController.h"
#import "GameRuleViewController.h"
#import "HomeGroupModel.h"
#import "SearchResultTableViewCell.h"
#import "AllGroupViewController.h"
#import "ChatListViewController.h"
#import "commentViewController.h"
#import "CreateGroupTwoViewController.h"
#import "GroupTalkDetailViewController.h"
#import "YCHomePageHeaderView.h"
#import "WWTolls.h"

#import "YCCircleModel.h"

#define ZDS_QUANZI          @"/game/circle.do"//获取圈子图片资源

@interface GameViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)MJRefreshHeaderView *timeHeader;//时间头部刷新
@property(nonatomic,strong)NSMutableArray* timeData;//按时间团组
@property(nonatomic,strong)NSMutableArray* hotData;//按热门团组
@property(nonatomic,strong)UITableView *table;//上一个热门
@property(nonatomic,strong)JYGroupView *adview;//轮播图片
@property(nonatomic,strong)UIView *mengceng;//引导

/** 头部view */
@property (nonatomic, strong)YCHomePageHeaderView *heaView;

@property(nonatomic,strong)NSMutableArray *circleData;//圈子
@end

@implementation GameViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //友盟统计--结束
    [MobClick endLogPageView:@"减脂吧页面"];
    
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (![[NSUSER_Defaults objectForKey:@"2.3.18meng"] isEqualToString:@"YES"]) {
        //背景
        UIView *mengceng = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 50)];
        mengceng.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDaka)];
//        [mengceng addGestureRecognizer:tap];
        self.mengceng = mengceng;
        //打卡按钮
        UIButton *daka = [[UIButton alloc] init];
        [daka setBackgroundImage:[UIImage imageNamed:@"yd1-500-600"] forState:UIControlStateNormal];
        [daka addTarget:self action:@selector(cancelMeng) forControlEvents:UIControlEventTouchUpInside];
        daka.frame = CGRectMake(SCREEN_MIDDLE(250), SCREEN_HEIGHT_MIDDLE(300), 250, 300);
        [mengceng addSubview:daka];
        [[UIApplication sharedApplication].keyWindow addSubview:mengceng];
        [NSUSER_Defaults setObject:@"YES" forKey:@"2.3.18meng"];
    }
}

-(void)cancelMeng{
    [self.mengceng removeFromSuperview];
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
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
    //导航搜索
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"home_searchIcon_36_36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    //导航创建团组按钮
    [self.rightButton setTitle:@"创建" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    self.rightButton.titleLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    [self.rightButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 44, 28);
    
    self.table.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-70);
    
    
}


-(NSMutableArray *)hotData{
    if (_hotData == nil) {
        _hotData = [NSMutableArray array];
    }
    return _hotData;
}
-(NSMutableArray *)timeData{
    if (_timeData == nil) {
        _timeData = [NSMutableArray array];
    }
    return _timeData;
}

// circleData
-(NSMutableArray *)circleData{
    if (_circleData == nil) {
        _circleData = [NSMutableArray array];
    }
    return _circleData;
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
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_HOT_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            [weakSelf.hotData removeAllObjects];
            NSArray *tempArray = dic[@"hotgamelist"];
            for (int i = 0;i<tempArray.count;i++) {
                NSDictionary *dic = tempArray[i];
                HomeGroupModel *model = [HomeGroupModel modelWithDic:dic];
                [weakSelf.hotData addObject:model];
            }
            [weakSelf.table reloadData];
            //缓存
            [NSUSER_Defaults setValue:dic forKey:GAME_HOTGAME_CACHE_PATH];
            [NSUSER_Defaults synchronize];
        }
        [weakSelf.timeHeader endRefreshing];
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
            //缓存
            [NSUSER_Defaults setValue:dic forKey:@"quanzichoche"];
            [NSUSER_Defaults synchronize];
            self.heaView.circleArr = self.circleData;
        }
        [weakSelf.timeHeader endRefreshing];
    }];
    
//    //构造请求参数----官方团
//    dictionary = [NSMutableDictionary dictionary];
//    //发送请求
//    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_HOME_GFTLIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
//        
//        if (!dic[ERRCODE]) {
//            if (((NSArray*)dic[@"gamelist"]).count>0) {
//                [NSUSER_Defaults setObject:dic forKey:GAME_RIGHTNOW_CACHE_PATH];
//                [NSUSER_Defaults synchronize];
//                NSMutableArray *images = [NSMutableArray array];
//                for (NSDictionary *dict in dic[@"gamelist"]) {
//                    [images addObject:dict[@"imgurl"]];
//                }
//                weakSelf.adview.imageArray = images;
//                weakSelf.timeData = dic[@"gamelist"];
//            }
//        }
//        [weakSelf.timeHeader endRefreshing];
//    }];
}

#pragma mark - 热门View
- (void)viewDidLoad{
    
    [super viewDidLoad];
    //初始化视图
    [self setUpGUI];
    //添加视图
    [self readCoache];
    
    [self.timeHeader beginRefreshing];
    //点击通知中心方式打开app  监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMygame:) name:@"myAppBeginWithTongZhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
    
    
    
    
    
    
    // ////////////////////////////////////////////////////////////////////
    
    
}
- (void)notifyHiden{
    self.table.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-70);
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
#pragma mark - 初始化UI
-(void)setUpGUI{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.scrollsToTop = YES;
    tableView.dataSource = self;
    tableView.backgroundColor = ZDS_BACK_COLOR;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-70);
    [self.view addSubview:tableView];
    self.table = tableView;
    
    //tableView头视图
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 155)];
    JYGroupView *adView = [[JYGroupView alloc] init];
    self.adview = adView;
    [header addSubview:adView];
//    self.table.tableHeaderView = header;
    WEAKSELF_SS
    adView.adDidClick = ^(NSInteger index){
        NSDictionary *dic = self.timeData[index];
        NSString *adUrl = dic[@"adlink"];
        NSString *linktype = dic[@"linktype"];
        if (adUrl != nil && ![adUrl isEqualToString:@""]) {
            NSLog(@"广告被点击%@",adUrl);
            if (linktype.intValue == 0) {//用户ID
                MeViewController *single = [[MeViewController alloc]init];
                single.userID = adUrl;
                single.otherOrMe = 1;
                [weakSelf.navigationController pushViewController:single animated:YES];
            }else if(linktype.intValue == 1){//游戏ID
                GroupViewController *gameDetail = [[GroupViewController alloc]init];
                gameDetail.clickevent = 3;
                gameDetail.joinClickevent = @"3";
                gameDetail.groupId = adUrl;
                gameDetail.ispwd = dic[@"ispwd"];
                [weakSelf.navigationController pushViewController:gameDetail animated:YES];
            }else if(linktype.intValue == 2){//商品ID
                StoreDetailViewController *storeDetail = [[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
                storeDetail.isEnoughScore  = YES;
                storeDetail.goodsid = adUrl;
                [weakSelf.navigationController pushViewController:storeDetail animated:YES];
            }else if(linktype.intValue == 3){//URL连接
                WebViewController *web = [[WebViewController alloc] init];
                web.URL = adUrl;
                [weakSelf.navigationController pushViewController:web animated:YES];
            }else if(linktype.intValue == 4){//游戏攻略
                GameRuleViewController *rule = [[GameRuleViewController alloc] initWithNibName:@"GameRuleViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:rule animated:YES];
            }else if(linktype.intValue == 5){
                
            }else if(linktype.intValue == 6){//展示详情
                DiscoverDetailViewController *dd = [[DiscoverDetailViewController alloc] init];
                dd.discoverId = adUrl;
                [weakSelf.navigationController pushViewController:dd animated:YES];
            }else if (linktype.intValue == 7) {//展示详情
                DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc]init];
                type.showtag = adUrl;
                [weakSelf.navigationController pushViewController:type animated:YES];
            }else if (linktype.intValue == 8) {//精华帖
                GroupTalkDetailViewController *type = [[GroupTalkDetailViewController alloc]init];
                type.talktype = GroupTitleTalkType;
                type.talkid = adUrl;
                [weakSelf.navigationController pushViewController:type animated:YES];
            }else if (linktype.intValue == 9) {//乐活吧
                GroupTalkDetailViewController *type = [[GroupTalkDetailViewController alloc]init];
                type.talktype = GroupSimpleTalkType;
                type.talkid = adUrl;
                [weakSelf.navigationController pushViewController:type animated:YES];
            }
        }
    };
    
    /********************[ V2.3.20减脂吧Headerview ]******************/
    YCHomePageHeaderView *headerV = [[YCHomePageHeaderView alloc] init];
    
    self.heaView = headerV;
    
    // 一行最多4列
    int maxCols = 4;
    
    // 边间距
    CGFloat marginLR = 23;
    CGFloat marginTB = 15;
    
    // 中间间隙
    CGFloat marginX = 25;
    
    // 中间间隙
    CGFloat marginY = 10;
    
    // 宽度和高度
    CGFloat buttonW = ( SCREEN_WIDTH - marginLR * 2 - marginX * (maxCols - 1) )/ maxCols;
    
    CGFloat buttonH = buttonW + 10 + [WWTolls heightForString:@"瘦成女神" fontSize:12];

    CGFloat headerViewH = marginTB * 2 + buttonH * 2 + marginY + 24 * 2;
    
    NSLog(@"%f", headerViewH);
    
    headerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, headerViewH);
    
    self.table.tableHeaderView = headerV;

    //tableView脚视图
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    
    //更多团组
    UILabel *lbl = [[UILabel alloc] init];
    lbl.backgroundColor = [UIColor whiteColor];
    lbl.frame = CGRectMake(-1, 0, SCREEN_WIDTH+2, 45);
//    lbl.layer.borderWidth = 0.5;
//    lbl.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    lbl.text = @"更多减脂团";
    lbl.font = MyFont(14);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    [footer addSubview:lbl];
    
    //更多
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTap:)];
    [footer addGestureRecognizer:tap];
    UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
    more.frame = CGRectMake(lbl.width/2+43, 16, 13, 13);
    UIView *lastline = [[UIView alloc] initWithFrame:CGRectMake(0, lbl.bottom, SCREEN_WIDTH, 0.5)];
    lastline.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [footer addSubview:lastline];
    [footer addSubview:more];
    self.table.tableFooterView = footer;
    
    //初始化刷新
    MJRefreshHeaderView *head = [MJRefreshHeaderView header];
    self.timeHeader = head;
    head.scrollView = tableView;
    head.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [weakSelf refreshData];
    };
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
        [self.table reloadData];
    }
    
    //读取时间开团
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
    self.heaView.circleArr = self.circleData;
    
}



#pragma UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.hotData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 111;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"groupcell";
    
    SearchResultTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil]lastObject];
    }
    NSUInteger row = [indexPath row];
    searchCell.searchModel = [self.hotData objectAtIndex:row];
    return searchCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeGroupModel *myReplyModel = self.hotData[indexPath.row];
    GroupViewController *gameDetail = [[GroupViewController alloc]init];
    gameDetail.clickevent = 1;
    gameDetail.joinClickevent = @"1";
    gameDetail.groupId = myReplyModel.gameid;
    gameDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gameDetail animated:YES];
}



#pragma mark - 跳转到创建游戏界面
-(void)createGame{
    [MobClick event:@"HomeCreate"];
    self.rightButton.userInteractionEnabled = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATECHK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if (!dic[ERRCODE]) {
            CreateGroupTwoViewController * create = [[CreateGroupTwoViewController alloc]init];
            create.isPassWordGrouper = [dic[@"ispasswd"] isEqualToString:@"0"];
            create.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:create animated:YES];
        }
        weakSelf.rightButton.userInteractionEnabled = YES;
    }];
}

-(void)moreTap:(UIGestureRecognizer*)tap{
    AllGroupViewController *all = [[AllGroupViewController alloc] init];
    all.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:all animated:YES];
}

#pragma mark - 跳转搜索页面
-(void)popButton{
    [MobClick event:@"HomeSearch"];
    SearchResultsViewController *search = [[SearchResultsViewController alloc]init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}

-(void)dealloc{
    [self.timeHeader free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
