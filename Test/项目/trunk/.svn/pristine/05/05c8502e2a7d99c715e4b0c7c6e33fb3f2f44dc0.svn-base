//
//  StoreViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/11/22.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "StoreViewController.h"

#import "GlobalUse.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "MyGoalViewController.h"
#import "StoreDetailViewController.h"
#import "ExchangeRecordViewController.h"
//..netWork..//
#import "WWRequestOperationEngine.h"
#import "WWTolls.h"
#import "JSONKit.h"
//..private..//
#import "UIViewExt.h"
#import "Define.h"
//..gateGory..//
#import "NSString+NARSafeString.h"
#import "StoreCollectionViewController.h"
#import "StoreModel.h"
//广告
#import "AddModel.h"
#import "JYADView.h"
//跳转视图
#import "MeViewController.h"
#import "GroupViewController.h"
#import "DiscoverTypeViewController.h"
#import "GameRuleViewController.h"
#import "WebViewController.h"
#import "MJExtension.h"
#import "MobClick.h"
#import "DiscoverDetailViewController.h"

@interface StoreViewController ()
{
    NSString *pageSizeNumber;//每页条数
    NSInteger arrayCount;//数组里有多少内容
    NSMutableArray *modelArray;//存放model的数组
    UIButton *historyButton;//兑换记录按钮
    UIButton *numButton;//我的积分按钮
    StoreCollectionViewController *narController;
}
@property(strong,nonatomic) NSArray* ads;//广告
@property(nonatomic,weak)JYADView *adsView;//广告轮播图
@end

static     NSInteger pageNumber;//页数

@implementation StoreViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"兑奖页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"兑奖页面"];
    [MobClick event:@"AWARD"];
    _storeTableView.bounces = NO;
    [super viewWillAppear:animated];
    self.titleLabel.text = [NSString stringWithFormat:@"兑换奖品"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    //    [self.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;
    [self getNum];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    modelArray = [[NSMutableArray array]init];
    
    UIView *headerView = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 189)];
    
    //广告轮播图
    [JYADView setKHeight:SCREEN_WIDTH*150/320];
    JYADView *adsview = [[JYADView alloc] init];
    self.adsView = adsview;
    adsview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*150/320);
    [headerView addSubview:adsview];
    WEAKSELF_SS
    adsview.adDidClick = ^(NSInteger index){
        AddModel *ad = weakSelf.ads[index];
        if (ad.adUrl != nil && ![ad.adUrl isEqualToString:@""]) {
            NSLog(@"广告被点击%@",ad.adUrl);
            if (ad.linktype.intValue == 0) {//用户ID
                MeViewController *single = [[MeViewController alloc]init];
                single.userID = ad.adUrl;
                single.otherOrMe = 1;
                [weakSelf.navigationController pushViewController:single animated:YES];
            }else if(ad.linktype.intValue == 1){//游戏ID
                GroupViewController *gameDetail = [[GroupViewController alloc]init];
                gameDetail.clickevent = 3;
                gameDetail.joinClickevent = @"3";
                gameDetail.groupId = ad.adUrl;
                [weakSelf.navigationController pushViewController:gameDetail animated:YES];
            }else if(ad.linktype.intValue == 2){//商品ID
                StoreDetailViewController *storeDetail = [[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
                storeDetail.isEnoughScore  = YES;
                storeDetail.goodsid = ad.adUrl;
                [weakSelf.navigationController pushViewController:storeDetail animated:YES];
            }else if(ad.linktype.intValue == 3){//URL连接
                WebViewController *web = [[WebViewController alloc] init];
                web.URL = ad.adUrl;
                [weakSelf.navigationController pushViewController:web animated:YES];
            }else if(ad.linktype.intValue == 4){//游戏攻略
                GameRuleViewController *rule = [[GameRuleViewController alloc] initWithNibName:@"GameRuleViewController" bundle:nil];
                [weakSelf.navigationController pushViewController:rule animated:YES];
            }else if(ad.linktype.intValue == 5){//展示类别
                DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc]init];
                type.typeId = ad.adUrl;
                type.showtag = @"活动";
                [weakSelf.navigationController pushViewController:type animated:YES];
            } else if(ad.linktype.intValue == 6){//展示详情
                DiscoverDetailViewController *dd = [[DiscoverDetailViewController alloc] init];
                dd.discoverId = ad.adUrl;
                [weakSelf.navigationController pushViewController:dd animated:YES];
            } else if (ad.linktype.intValue == 7) {//展示详情
                DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc]init];
                type.showtag = ad.adUrl;
                [weakSelf.navigationController pushViewController:type animated:YES];
            }
        }
    };

//    
//    //..滑动广告..//
//    AddView *advertisement = [[AddView alloc]initWithAds:self.ads];
//    [advertisement setAds:[NSArray arrayWithContentsOfFile:STORE_AD_CACHE_PATH]];
//    advertisement.adDidClick = ^(AddModel *ad){
//        if (ad.adUrl != nil && ![ad.adUrl isEqualToString:@""]) {
//            NSLog(@"广告被点击%@",ad.adUrl);
//            if (ad.linktype.intValue == 0) {//用户ID
//                SingleUserViewController *single = [[SingleUserViewController alloc]initWithNibName:@"SingleUserViewController" bundle:nil];
//                single.seeuserid = ad.adUrl;
//                [self.navigationController pushViewController:single animated:YES];
//            }else if(ad.linktype.intValue == 1){//游戏ID
//                GameDetail_ViewController *gameDetail = [[GameDetail_ViewController alloc]initWithNibName:@"GameDetail_ViewController" bundle:nil];
//                gameDetail.gameid = ad.adUrl;
//                [self.navigationController pushViewController:gameDetail animated:YES];
//            }else if(ad.linktype.intValue == 2){//商品ID
//                StoreDetailViewController *storeDetail = [[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
//                storeDetail.isEnoughScore  = YES;
//                storeDetail.goodsid = ad.adUrl;
//                [self.navigationController pushViewController:storeDetail animated:YES];
//            }else if(ad.linktype.intValue == 3){//URL连接
//                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:ad.adUrl]];
//            }
//        }
//        
//    };
//    self.adview = advertisement;
//    
//    advertisement.frame = CGRectMake(0, 0, self.view.size.width, 150);
//    [headerView addSubview:advertisement];
    
    UIView *whiteMiddleView = [[UIView alloc]initWithFrame:CGRectMake(0, adsview.bottom, SCREEN_WIDTH, 38)];
    [headerView addSubview:whiteMiddleView];
    
    numButton = [UIButton buttonWithType:UIButtonTypeCustom];
    numButton.frame = CGRectMake((((SCREEN_WIDTH/2)-120)/2), 10, 100, 20);
    //获取我的积分
    [numButton setTitle:@"我的斗币" forState:UIControlStateNormal];
    numButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [numButton setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    numButton.titleLabel.font = MyFont(14);
    [whiteMiddleView addSubview:numButton];
    [numButton addTarget:self action:@selector(numButtonSender) forControlEvents:UIControlEventTouchUpInside];
    //积分
    UILabel *lbl = [[UILabel alloc] init];
    self.lblNum = lbl;
    
    self.lblNum.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numButtonSender)];
    [self.lblNum addGestureRecognizer:tap];
    self.lblNum.frame = numButton.frame;
    self.lblNum.frame = CGRectMake(numButton.frame.origin.x+80, 10, 100, 20);
    self.lblNum.text = @"0";
    self.lblNum.textColor = [WWTolls colorWithHexString:@"#ea5b57"];
    self.lblNum.font = MyFont(14);
    [whiteMiddleView addSubview:self.lblNum];
    [self getNum];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_MIDDLE(0.5), 0, 0.5, 38)];
    lineView.backgroundColor = [WWTolls colorWithHexString:@"#cccccc"];
    [whiteMiddleView addSubview:lineView];
    
    historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    historyButton.frame = CGRectMake(lineView.right+(((SCREEN_WIDTH/2)-100)/2),10, 100, 20);
    [historyButton setTitle:@"兑换记录" forState:UIControlStateNormal];
    historyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [historyButton setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    historyButton.titleLabel.font = MyFont(14);
    [whiteMiddleView addSubview:historyButton];
    [historyButton addTarget:self action:@selector(historyButtonSender:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 0.5)];
    lineView1.backgroundColor = [WWTolls colorWithHexString:@"#cccccc"];
    [whiteMiddleView addSubview:lineView1];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100,100)]; //设置每个cell显示数据的宽和高必须
    flowLayout.sectionInset = UIEdgeInsetsMake(SCREEN_WIDTH*150/320+40, 0, 0, 0);//整体偏移
    flowLayout.minimumInteritemSpacing = 0;//列间距
    flowLayout.minimumLineSpacing = 0;//行间距
    narController = [[StoreCollectionViewController alloc]initWithCollectionViewLayout:flowLayout];
    [narController.collectionView addSubview:headerView];
    narController.hotGameListArray = [[NSMutableArray alloc]init];
    narController.imagewidth = ZDS_FISTPAGE_BEGINMODLE_WIDTH;
    narController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-67);
    narController.del = self;
//    if (iPhone4) {
//        narController.view.height = narController.view.height - 90;
//    }
    [self.view addSubview:narController.view];
    [self readCoache];
    pageNumber = 1;
    pageSizeNumber = [NSString stringWithFormat:@"%d",10];
    [self uploadAwardData:pageNumber pageSizeFor:pageSizeNumber];
    [self uploadAdvertisementData:0 pageSizeFor:@"10"];
    
    
}

-(void)readCoache{
    //加载商品缓存
    NSArray *replayListArray = [NSMutableArray arrayWithContentsOfFile:STORE_GOODS_CACHE_PATH];
    if (replayListArray.count > 0) {
        [self reloadMyData:replayListArray];
    }
    //读取广告缓存
    NSArray *tempArray = [NSKeyedUnarchiver unarchiveObjectWithFile:STORE_AD_CACHE_PATH];
    if (tempArray.count > 0) {
        self.ads = tempArray;
        NSMutableArray *imageArray = [NSMutableArray array];
        for (AddModel *model in self.ads) {
            [imageArray addObject:model.imageUrl];
        }
        [self.adsView setImageArray:imageArray];
    }
}

#pragma mark - Table view data source

-(void)numButtonSender
{
    MyGoalViewController *myGoal = [[MyGoalViewController alloc]initWithNibName:@"MyGoalViewController" bundle:nil];
    [self.navigationController pushViewController:myGoal animated:YES];
}

-(void)historyButtonSender:(UIButton*)sender
{
    ExchangeRecordViewController * introduce = [[ExchangeRecordViewController alloc]initWithNibName:@"ExchangeRecordViewController" bundle:nil];
    [self.navigationController pushViewController:introduce animated:YES];
}

#pragma mark - 获取广告数据
-(void)uploadAdvertisementData:(NSInteger)page pageSizeFor:(NSString*)pageSize{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:pageSize forKey:@"adcount"];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LOADSORE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            NSArray *adsdic = dic[@"adinfoList"];
            NSMutableArray *tempArray = [NSMutableArray array];
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int i=0; i<adsdic.count; i++) {
                NSDictionary *dic = adsdic[i];
                AddModel *ad = [[AddModel alloc] init];
                ad.adId = dic[@"adid"];
                ad.adUrl = dic[@"adlink"];
                ad.adType = @"2";
                ad.linktype = dic[@"linktype"];
                ad.imageUrl =dic[@"imgurl"];
                [tempArray addObject:ad];
                [imageArray addObject:ad.imageUrl];
            }
            weakSelf.ads = tempArray;
            weakSelf.adsView.imageArray = imageArray;
            [NSKeyedArchiver archiveRootObject:tempArray toFile:STORE_AD_CACHE_PATH];
        }
    }];
    
}


#pragma mark - 获取我的积分
-(void)getNum{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:@1 forKey:@"pageNum"];
    [dictionary setObject:@1 forKey:@"pageSize"];
        __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETMYSCORE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        NSString *score = 0;
        if (dic[ERRCODE]) {//失败
            score = [[NSUserDefaults standardUserDefaults] stringForKey:@"MYSCORECACHE"];
        }else{
            score = [dic objectForKey:@"mytotalscore"];
            [[NSUserDefaults standardUserDefaults] setValue:score forKey:@"MYSCORECACHE"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.lblNum.text = score;
        });
        
    }];
}

#pragma mark - 获取可兑换奖品数据
-(void)uploadAwardData:(NSInteger)page pageSizeFor:(NSString*)pageSize{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:[NSString stringWithFormat:@"%ld",(long)page]forKey:@"pageNum"];
    [dictionary setObject:pageSize forKey:@"pageSize"];
    [dictionary setObject:pageSize forKey:@"adcount"];
    
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETGOODSLIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (page == 1) {
            if (modelArray.count!=0) {
                //..首先移除数组中数据..//
                [modelArray removeAllObjects];
            }
        }
        NSMutableArray *replayListArray = [NSMutableArray array];
        if (page>1) {
            [replayListArray addObjectsFromArray:modelArray];
        }
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if (dic[ERRCODE]) {
            NSLog(@"获取可兑换奖品信息失败");
            replayListArray = [NSMutableArray arrayWithContentsOfFile:STORE_GOODS_CACHE_PATH];
        }else{
            NSArray *newarray = [dic objectForKey:@"goodslist"];
            [replayListArray addObjectsFromArray:newarray];
            
            if (replayListArray.count!=0) {
                
                [replayListArray writeToFile:STORE_GOODS_CACHE_PATH atomically:YES];
            }
        }
        [strongSelf reloadMyData:replayListArray];
        NSLog(@"获取可兑换奖品*********%@", dic);
    }];
}

#pragma mark --加载
- (void)loadMoreData{
    NSLog(@"*******我加载了*********");
    if (arrayCount%10==0&&arrayCount>=pageNumber*10) {
        pageNumber++;
        NSLog(@"加载的序列号*******%ld",(long)pageNumber);
        [self uploadAwardData:pageNumber pageSizeFor:pageSizeNumber];
    }
}

#pragma mark --刷新
- (void)doneLoadingTableViewData{
    NSLog(@"******我刷新了******");
    pageNumber = 1;
    [self uploadAdvertisementData:1 pageSizeFor:@"10"];
    [self uploadAwardData:1 pageSizeFor:@"10"];
}

#pragma mark - 装载数据
-(void)reloadMyData:(NSArray*)replayListArray
{
    NSLog(@"装载数据");
    if (replayListArray.count == 0) {
        return;
    }
    [modelArray removeAllObjects];
    for (int i=0; i<replayListArray.count; i++) {
        
        StoreModel *myReplyModel = [[StoreModel alloc]init];
        NSDictionary *myReplyDictionary = [replayListArray objectAtIndex:i];
        if ([myReplyDictionary isKindOfClass:[StoreModel class]]) {
            myReplyModel = [replayListArray objectAtIndex:i];
            [modelArray addObject:myReplyModel];
            continue;
        }
        myReplyModel.goodsidleft = [myReplyDictionary objectForKey:@"goodsid"];
        myReplyModel.gsnameleft = [myReplyDictionary objectForKey:@"gsname"];
        myReplyModel.gsintroleft = [myReplyDictionary objectForKey:@"gsintro"];
        myReplyModel.exchscoreleft = [myReplyDictionary objectForKey:@"exchscore"];
        myReplyModel.imageurlleft = [myReplyDictionary objectForKey:@"imageurl3"];
        myReplyModel.gsstatusleft = [myReplyDictionary objectForKey:@"gsstatus"];
        myReplyModel.scoreEnoughleft =  [myReplyDictionary objectForKey:@"scoreEnough"];
        
        
        
        
        NSLog(@"modelArrayImage*******%@",myReplyModel.imageurlleft);
        
        [modelArray addObject:myReplyModel];
    }
    NSLog(@"modelArray*******%@",modelArray);
    
    arrayCount = modelArray.count;
    
    narController.hotGameListArray = modelArray;
    [narController.collectionView reloadData];
    [narController.header endRefreshing];
    [narController.footer endRefreshing];
//    
//    if (arrayCount<10) {
//        self.freshFooterView.hidden = YES;
//    }else{
//        self.freshFooterView.hidden = NO;
//    }
//    [self initFooterViewFrame:CGRectMake(0,self.storeTableView .contentSize.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
