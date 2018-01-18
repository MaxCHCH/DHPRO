//
//  DiscoverViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "DiscoverViewController.h"
#import "InterestUserViewController.h"
#import "MeViewController.h"
#import "customMyImageButton.h"
#import "StoreDetailViewController.h"
#import "DiscoverDetailViewController.h"
#import "GroupViewController.h"
#import "StoreDetailViewController.h"
#import "DiscoverTypeViewController.h"
#import "GameRuleViewController.h"
#import "WebViewController.h"
#import "MJRefresh.h"
#import "UIViewExt.h"
#import "MobClick.h"
#import "JYADView.h"
#import "DiscoverListTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import "NARShareView.h"
#import "SSLImageTool.h"
#import "DeleteShowModel.h"
#import "DeleteBarModel.h"
#import "MJExtension.h"
#import "GroupTalkTableViewCell.h"
#import "GroupTalkDetailViewController.h"
#import "MyGroupDynModel.h"
#import "DiscoverAddViewController.h"
#import "OfficialInformTableViewCell.h"
#import "ChatViewController.h"
#import "commentViewController.h"
#import "SearchResultsViewController.h"
#import "ArticleTableViewCell.h"
#import "AchieveTableViewCell.h"
#import "NewTaskTableViewCell.h"

@interface DiscoverViewController ()<UITableViewDataSource, UITableViewDelegate,CLLocationManagerDelegate,UIScrollViewDelegate,UITabBarControllerDelegate,groupTalkCellDelegate,NARShareViewDelegate,discoverReportDelegate>{
    UIActionSheet *myActionSheetView;//撒欢举报行为
    NSString *talkid;
    NSString *jubaotype;
}   

@property(nonatomic,strong)JYADView *adview;//广告视图
@property(nonatomic,strong)UIImageView *IntrHeaderImage;//感兴趣头像
@property(nonatomic,strong)UILabel *IntrHeaderName;//感兴趣人名称
@property(nonatomic,strong)UILabel *IntrMsg;//感兴趣原因
@property(nonatomic,copy)NSString *intrUserId;//感兴趣人id
@property(nonatomic,strong)UIScrollView *back;//背景图
@property(nonatomic,strong)NSMutableArray* adsData;//广告数据
//标题视图
@property(nonatomic,strong)UIButton *messBtn;//动态
@property(nonatomic,strong)UIButton *informBtn;//广场
@property(nonatomic,strong)UIView *tag;//紫色下标
//最后请求类型
@property(nonatomic,copy)NSString *lastShowKind;
@property(nonatomic,copy)NSString *lastDynKind;
//动态
@property(nonatomic,strong)UITableView *messageTable;//动态视图
@property(nonatomic,strong)UIButton *collectionBtn;
@property(nonatomic,strong)NSMutableArray* Messagedata;//数据
@property(nonatomic,strong)MJRefreshHeaderView *Messageheader;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *Messagefooter;//底部刷新
@property(nonatomic,assign)int MessagePageNum;//当前页数
@property(nonatomic,copy)NSString *messagelastid;//动态最后一条
//广场
@property(nonatomic,strong)UITableView *infomTable;//通知视图
@property(nonatomic,strong)NSMutableArray* informdata;//数据
@property(nonatomic,strong)MJRefreshHeaderView *informheader;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *informfooter;//底部刷新
@property(nonatomic,strong)UIView *tableheaderview;//table
@property(nonatomic,assign)int informPageNum;//当前页数
@property (strong, nonatomic) CLLocationManager *locationManager;//定位
//撒欢代理事件属性
@property(nonatomic,strong)NSIndexPath *currentIndexPath;//当前广场indexPath
@property(nonatomic,strong)NSIndexPath *currentMyDynIndexPath;//当前团组动态indexPath
@property(nonatomic,copy)NSString *disCoverId;//撒欢举报id
//团动态提示视图
@property(nonatomic,strong)UIImageView *tipjiantou;
@property(nonatomic,strong)UILabel *tiplbl;
@property(nonatomic,assign)NSString *isShua;//刷新
//广播视图
@property(nonatomic,strong)NSMutableArray *notifyArray;//广播数组
@property(nonatomic,strong)NSTimer *notifyHideTimer;//通知消失发射器
@end
#define firstopenstr @"diyicidakaifaxian"
@implementation DiscoverViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"撒欢页面"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.isShua = @"NO";
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"撒欢页面"];
    if (self.navigationController.tabBarController.selectedIndex != 1) {
        [MobClick event:@"DISCOVER"];
        [WWTolls zdsClick:@"shnum"];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //导航搜索
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"ss-c-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton.titleLabel.font = MyFont(16);
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"fbc-36"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(addDiscover) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.top = 20;
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.back.contentOffset.x<SCREEN_WIDTH/2) {
        // 获取当前的y轴偏移量
        CGFloat curOffsetY = self.infomTable.contentOffset.y;
        
        // 计算下与最开始的偏移量的差距
        CGFloat delta = curOffsetY - 0;
        
        // 获取当前导航条背景图片透明度，当delta=136的时候，透明图刚好为1.
        CGFloat alpha = delta * 1 / 300.0;
        if (alpha >= 1) {
            alpha = 0.99;
        }
        if (curOffsetY > 200) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }else{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
        
        // 分类：根据颜色生成一张图片
        UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:alpha] size:CGSizeMake(SCREEN_WIDTH, 100)];
        
        //    UIImage *bgImage = [UIImage imageNamed:@"123"];
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }else {
        UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:0.99] size:CGSizeMake(SCREEN_WIDTH, 100)];
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
    self.y = -50;
    self.isShua = @"YES";
    if (!self.tipjiantou.hidden) {
        self.tipjiantou.frame = CGRectMake( 10, self.messageTable.height-83, 55, 73);
        [UIView beginAnimations:@"movement" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.7f];
        [UIView setAnimationRepeatCount:MAXFLOAT];
        [UIView setAnimationRepeatAutoreverses:YES];
        CGPoint center = self.tipjiantou.center;
        if(center.y > 40.0f) {
            center.y -= 20.0f;
            self.tipjiantou.center = center;
        } else {
            center.y += 20.0f;
            self.tipjiantou.center = center;
        }
        [UIView commitAnimations];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark 跳转搜索页面
- (void)popButton {
    [MobClick event:@"HomeSearch"];
    SearchResultsViewController *search = [[SearchResultsViewController alloc]init];
    search.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:search animated:YES];
}
- (void)hideNotify{
    NSLog(@"aa");
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    [self.notifyHideTimer invalidate];
    self.notifyHideTimer = nil;
    [WWTolls setScreenHeightOffset:0];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.notifyView.top = -65;
        [UIApplication sharedApplication].keyWindow.transform = CGAffineTransformMakeTranslation(0,0);
        self.messageTable.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
        self.infomTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
        [UIApplication sharedApplication].keyWindow.height = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.notifyView removeFromSuperview];
        if(self.notifyArray.count > 0)
            [self.notifyArray removeObjectAtIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyToggle" object:nil];
        [self nextNotify];
        
    }];
}

- (void)clickNotify{
    [self hideNotify];
    if ([self.notifyArray.firstObject[@"linkurl"] rangeOfString:@"http"].length > 0 && [self.notifyArray.firstObject[@"linkurl"] rangeOfString:@"http"].location == 0) {
        WebViewController *web = [[WebViewController alloc] init];
        web.URL = self.notifyArray.firstObject[@"linkurl"];
        web.hidesBottomBarWhenPushed = YES;
        [(UINavigationController*)self.navigationController.tabBarController.selectedViewController  pushViewController:web animated:YES];
    }
}

- (void)removeNotify{
    [self.notifyArray removeAllObjects];
    [UIApplication sharedApplication].keyWindow.transform = CGAffineTransformMakeTranslation(0,-50);
    [self hideNotify];
    //    [WWTolls setScreenHeightOffset:0];
    //    [UIApplication sharedApplication].keyWindow.transform = CGAffineTransformMakeTranslation(0,0);
    //    [UIApplication sharedApplication].keyWindow.height = SCREEN_HEIGHT;
    //    [self.notifyView removeFromSuperview];
}

- (void)nextNotify{
    if (self.notifyArray.count<1) {
        return;
    }
    
    UIView *notifyBack = [[UIView alloc] init];
    self.notifyView = notifyBack;
    notifyBack.frame = CGRectMake(0, -70, SCREEN_WIDTH, 70);
    notifyBack.backgroundColor = [WWTolls colorWithHexString:@"#fdeec1"];
    //跳转
    UITapGestureRecognizer *NotifyTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickNotify)];
    [notifyBack addGestureRecognizer:NotifyTap];
    //状态栏
    UIView *statusBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    statusBack.backgroundColor = [UIColor whiteColor];
    [notifyBack addSubview:statusBack];
    
    //广播图标
    UIImageView *notifyImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 32, 30, 27)];
    notifyImage.image = [UIImage imageNamed:@"jianzhi-noti-noti"];
    [notifyBack addSubview:notifyImage];
    //广播内容
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(38, 25, SCREEN_WIDTH-68, 40)];
    if (self.notifyArray.count < 1) {
        return;
    }
    NSString * htmlString = self.notifyArray.firstObject[@"content"];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    label.attributedText = attrStr;
    label.numberOfLines = 0;
    [notifyBack addSubview:label];
    //广播关闭按钮
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-35, 22, 35, 46)];
    [btn addTarget:self action:@selector(hideNotify) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jianzhi-noti-noti-close"]];
    image.bounds = CGRectMake(0, 0, 16, 16);
    image.layer.cornerRadius = 8;
    image.clipsToBounds = YES;
    image.center = btn.center;
    image.userInteractionEnabled = NO;
    [notifyBack addSubview:image];
    [notifyBack addSubview:btn];
    
    [WWTolls setScreenHeightOffset:50];
    
    [[UIApplication sharedApplication].keyWindow addSubview:notifyBack];
    [UIApplication sharedApplication].keyWindow.clipsToBounds = NO;
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.notifyView.top = self.y;
        [UIApplication sharedApplication].keyWindow.transform = CGAffineTransformMakeTranslation(0,50);
        [UIApplication sharedApplication].keyWindow.height = SCREEN_HEIGHT;
        self.messageTable.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
        self.infomTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 113);
    } completion:^(BOOL finished) {
        //30秒后消失
        NSTimer *notifyHideTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(hideNotify) userInfo:nil repeats:NO];
        self.notifyHideTimer = notifyHideTimer;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyToggle" object:nil];
    }];
    
}

#pragma mark - 加载广播
-(void)reloadNotify{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    //发送请求
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LOAD_NOTIFY parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.notifyArray = [NSMutableArray array];
        if (((NSArray*)dic[@"bclist"]).count>0) {
            for (NSDictionary *dict in dic[@"bclist"]) {
                [weakSelf.notifyArray addObject:dict];
            }
            [self nextNotify];
        }
    }];
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.y = -50;
    [self reloadNotify];
    //
    //    [self.tabBarController setSelectedIndex:0];
    //    [self.tabBarController setSelectedIndex:1];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodDiscover:) name:@"goodyouDiscover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comDiscover:) name:@"comyouDiscover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteDiscover:) name:@"deleteDiscover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(good:) name:@"goodReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(com:) name:@"comReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sucess:) name:@"adddiscoverSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delteReply:) name:@"delteReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNotify) name:@"outLgoin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupTitleDelete:) name:@"grouptitletoggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTitleSucess) name:@"sendTitleSucess" object:nil];
    [self setupGUI];
    //读取缓存
    [self readCoache];
    //刷新数据
    [self refreshInform];
    [self loadMessageWithIsMore:NO];
    //请求定位
    [self refreshadd];
    //更新提示
    //    [self showNewMessage];
    self.tabBarController.delegate = self;
    //点击通知中心方式打开app  监听
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMygame:) name:@"myAppBeginWithTongZhi" object:nil];
    self.tabBarController.selectedIndex = 0;
}


- (void)showNewMessage{
    /**
     if (![[NSUSER_Defaults objectForKey:@"show236Message"] isEqualToString:@"YES"]) {
     // 显示新特性
     UIAlertView *NewFucAlert = [[UIAlertView alloc] initWithTitle:@"更新内容" message:@"团长可以申请解散团组;\r\n团长可以剔除团组内犯错误的团员;\r\n对部分功能和设计进行优化;" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
     
     [NewFucAlert show];
     [NSUSER_Defaults setObject:@"YES" forKey:@"show236Message"];
     
     }
     **/
}

//#pragma mark - 监听通知事件  从通知中心打开app跳转至团组通知页
//-(void)gotoMygame:(NSNotification*)noty{
//    if (noty.object != nil) {
//        if ([noty.object isEqualToString:@"1"]) {//评论
//            [self.navigationController pushViewController:[[commentViewController alloc] init] animated:YES];
//        }else{
//            ChatViewController *chat = [[ChatViewController alloc] init];
//            chat.userId = noty.object;
//            [self.navigationController pushViewController:chat animated:YES];
//        }
//    }else [self.tabBarController setSelectedIndex:2];
//}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 1) {
        [self titleBtnClick:self.messBtn];
        [self.informheader beginRefreshing];
    }
}

- (void)goTop{
    [self.infomTable setContentOffset:CGPointZero animated:YES];
    [self.messageTable setContentOffset:CGPointZero animated:YES];
}
#pragma mark - 初始化视图
-(void)setupGUI{
    // 分类：根据颜色生成一张图片
    UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:0] size:CGSizeMake(SCREEN_WIDTH, 100)];
    
    //    UIImage *bgImage = [UIImage imageNamed:@"123"];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    //头部视图
    UIView *titleBack = [[UIView alloc] init];
    titleBack.frame = CGRectMake(0, 10, 176, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTop)];
    [titleBack addGestureRecognizer:tap];
    
    self.navigationItem.titleView = titleBack;
    //头部私信按钮
    UIButton *message = [[UIButton alloc] init];
    self.messBtn = message;
    [message addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    message.frame = CGRectMake(18, 0, 67, 44);
    [message setTitle:@"广场" forState:UIControlStateNormal];
    [message setTitleColor:[WWTolls colorWithHexString:@"#a2a9b1"] forState:UIControlStateNormal];
    [message setTitleColor:[WWTolls colorWithHexString:@"#495564"] forState:UIControlStateSelected];
    [message setTitleColor:[WWTolls colorWithHexString:@"#495564"] forState:UIControlStateHighlighted];
    [titleBack addSubview:message];
    
    //头部通知按钮
    UIButton *information = [[UIButton alloc] init];
    self.informBtn = information;
    [information addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    information.frame = CGRectMake(93, 0, 67, 44);
    [information setTitle:@"动态" forState:UIControlStateNormal];
    [information setTitleColor:[WWTolls colorWithHexString:@"#a2a9b1"] forState:UIControlStateNormal];
    [information setTitleColor:[WWTolls colorWithHexString:@"#495564"] forState:UIControlStateSelected];
    [information setTitleColor:[WWTolls colorWithHexString:@"#495564"] forState:UIControlStateHighlighted];
    [titleBack addSubview:information];
    //头部紫色标签
    UIView *tag = [[UIView alloc] init];
    self.tag = tag;
    tag.frame = CGRectMake(18, 41, 66, 3);
    tag.backgroundColor = RGBCOLOR(87, 95, 214);
//    [titleBack addSubview:tag];
    
    
    CGFloat H = SCREEN_HEIGHT + 20;
    //背景视图
    UIScrollView *back = [[UIScrollView alloc] init];
//    back
    self.back = back;
    back.tag = 1;
    back.delegate = self;
    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, H - 66);
    back.showsHorizontalScrollIndicator = NO;
    back.showsVerticalScrollIndicator = NO;
    back.bounces = NO;
    back.pagingEnabled = YES;
    back.backgroundColor = ZDS_BACK_COLOR;
    back.contentSize = CGSizeMake(SCREEN_WIDTH*2, H - 299);
    [self.view addSubview:back];
    //默认选中广场
    self.informBtn.selected = YES;
    
    
    //动态视图
    UITableView *messageTable = [[UITableView alloc] init];
    self.messageTable = messageTable;
    
    //    messageTable.tableHeaderView = whriteHeader;
    messageTable.scrollsToTop = YES;
    [back addSubview:messageTable];
    UIView *whrite = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 66)];
    whrite.backgroundColor = [UIColor whiteColor];
    [back addSubview:whrite];
    messageTable.frame = CGRectMake(SCREEN_WIDTH, 66, SCREEN_WIDTH, H-132);
//    messageTable.backgroundColor = RGBCOLOR(239, 239, 239);
    messageTable.backgroundColor = ZDS_BACK_COLOR;
    messageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTable.delegate = self;
    messageTable.dataSource = self;
    messageTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.Messageheader = header;
    header.scrollView = messageTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadMessageWithIsMore:NO];
    };
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.Messagefooter = footer;
    footer.scrollView = messageTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadMessageWithIsMore:YES];
    };
    
    //通知视图
    UITableView *informTable = [[UITableView alloc] init];
    informTable.scrollsToTop = YES;
    informTable.backgroundColor = ZDS_BACK_COLOR;
    informTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.infomTable = informTable;
    [back addSubview:informTable];
    informTable.frame = CGRectMake(0, -66, SCREEN_WIDTH, H);
//    informTable.backgroundColor = RGBCOLOR(239, 239, 239);
    informTable.delegate = self;
    informTable.dataSource = self;
    informTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    //初始化刷新
    header = [MJRefreshHeaderView header];
    self.informheader = header;
    header.scrollView = informTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self refreshInform];
    };
    footer = [MJRefreshFooterView footer];
    self.informfooter = footer;
    footer.scrollView = informTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadInform];
    };
    
    //初始化数据
    self.Messagedata = [NSMutableArray array];
    self.informdata = [NSMutableArray array];
    //团动态提示
    UILabel *tiplbl = [[UILabel alloc] init];
    tiplbl.frame = CGRectMake(8, 150, SCREEN_WIDTH-16, 60);
    tiplbl.numberOfLines = 2;
    tiplbl.font = MyFont(18);
    tiplbl.textColor = [WWTolls colorWithHexString:@"#929292"];
    tiplbl.textAlignment = NSTextAlignmentCenter;
    tiplbl.text = @"/(ㄒoㄒ)/~~您当前没有加入任何团组，快去减脂吧加入一个吧！";
    [self.messageTable addSubview:tiplbl];
    UIImageView *tipjiantou = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"discover_join"]];
    tipjiantou.frame = CGRectMake( 10, self.messageTable.height-83, 55, 73);
    [self.messageTable addSubview:tipjiantou];
    self.tipjiantou = tipjiantou;
    self.tiplbl = tiplbl;
    self.tipjiantou.hidden = YES;
    self.tiplbl.hidden = YES;
    
}

#pragma mark - 读取缓存
-(void)readCoache{
    NSDictionary *dic;
    //活动
    dic = [NSUSER_Defaults objectForKey:DISCOVER_COACHE_ACTIVE];\
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSArray *arr = dic[@"adinfoList"];
    if (arr.count>0) {
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            [images addObject:dict[@"imgurl"]];
        }
        self.adsData = [NSMutableArray arrayWithArray:arr];
        self.adview.imageArray = images;
    }
    //热门标签
    dic = [NSUSER_Defaults objectForKey:@"discoverhottagcoache"];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if(dic.count>0){
        NSArray *tempArray = dic[@"taglist"];
        UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45+SCREEN_WIDTH*300.0/320.0)];
        [tableHeader addSubview:self.adview];
        
//        UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*300.0/320.0+10, SCREEN_WIDTH, 26)];
//        tagView.layer.borderColor = [[WWTolls colorWithHexString:@"#dcdcdc"] CGColor];
//        tagView.layer.borderWidth = 0.5;
//        tagView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        
//        NSString *hotTitle = @"热门标签";
//        CGFloat width = [WWTolls WidthForString:hotTitle fontSize:10 andHeight:10];
//        
//        UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake((tagView.width - width) / 2, 8, width, 10)];
//        hotLabel.font = MyFont(10.0);
//        hotLabel.text = hotTitle;
//        [tagView addSubview:hotLabel];
//        hotLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
//        
//        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(hotLabel.x - 5 - 40, hotLabel.midY - 0.4, 40, 0.8)];
//        [tagView addSubview:leftLine];
//        leftLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        
//        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(hotLabel.maxX + 5, leftLine.y, leftLine.width, leftLine.height)];
//        [tagView addSubview:rightLine];
//        rightLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        [tableHeader addSubview:tagView];
        UILabel *title = [[UILabel alloc] init];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*300.0/320.0, 15, 45)];
        view.backgroundColor = [UIColor whiteColor];
        [tableHeader addSubview:view];
        title.backgroundColor = [UIColor whiteColor];
//        title.alignmentRectInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        title.frame = CGRectMake(15, SCREEN_WIDTH*300.0/320.0, SCREEN_WIDTH, 45);
        title.font = MyFont(17);
        title.textColor = OrangeColor;
        title.text = @"热门标签";
        [tableHeader addSubview:title];
        //热门标签
        UIView *hotview  = [[UIView alloc] init];
        hotview.backgroundColor = [UIColor whiteColor];
        //阴影
//        hotview.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//        hotview.layer.borderWidth = 0.5;
        [tableHeader addSubview:hotview];
        
        
        CGFloat x = 15;
        CGFloat y = 0;
        for (int i = 0; i<tempArray.count; i++) {
            
            NSString *tag = tempArray[i];
            CGFloat width = [WWTolls WidthForString:tag fontSize:13]+30;
            if(width>SCREEN_WIDTH-30) width = SCREEN_WIDTH-30;
            if (x+width+15>SCREEN_WIDTH) {
                y += 37;
                x = 15;
            }
            if (y>55) {
                y = 55;
                break;
            }
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, 30)];
            btn.layer.cornerRadius = 15;
            btn.layer.borderWidth = 0.5;
            btn.clipsToBounds = YES;
            btn.layer.borderColor = [WWTolls colorWithHexString:@"#c5dde7"].CGColor;
            [btn setTitle:tag forState:UIControlStateNormal];
            [btn setTitleColor:[WWTolls colorWithHexString:@"#5E929B"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[WWTolls imageWithColor:OrangeColor size:CGSizeMake(width, 30)] forState:UIControlStateHighlighted];
            btn.titleLabel.font = MyFont(13);
            x += width+7;
            [hotview addSubview:btn];
            btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            btn.titleLabel.text = tag;
            [btn addTarget: self action:@selector(tagLabelAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        hotview.backgroundColor = [UIColor redColor];
        hotview.frame = CGRectMake(0, title.bottom, SCREEN_WIDTH, y+45);
        tableHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90+y+SCREEN_WIDTH*300.0/320.0);
        self.tableheaderview = tableHeader;
        self.infomTable.tableHeaderView = tableHeader;
    }
    //广场数据
    dic = [NSUSER_Defaults objectForKey:@"discoverdatacoache"];
    if (dic.count>0) {
        NSArray *tempArray = dic[@"showlist"];
        for (NSDictionary *dic in tempArray) {
            [self.informdata addObject:[DiscoverModel modelWithDic:dic]];
            self.lastId = dic[@"showid"];
            self.lastShowKind = dic[@"showkind"];
        }
        [self.infomTable reloadData];
    }
    
    //团组动态
    dic = [NSUSER_Defaults objectForKey:@"discovergroupmessagecoache"];
    if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
    }else{
        NSArray *tempArray = dic[@"dynlist"];
        if (tempArray.count>0) {
            self.tiplbl.hidden = YES;
            self.tipjiantou.hidden = YES;
        }else{
            self.tipjiantou.hidden = NO;
            self.tiplbl.hidden = NO;
        }
        for (NSDictionary *dic in tempArray) {
            [self.Messagedata addObject:[MyGroupDynModel modelWithDic:dic]];
            self.messagelastid = dic[@"dynid"];
            self.lastDynKind = dic[@"dynkind"];
        }
        [self.messageTable reloadData];
    }
    
}

#pragma mark - 广场 加载数据
-(void)refreshInform{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    __weak typeof(self)weakSelf = self;
    //构造请求参数----活动
    [dictionary setObject:@"2" forKey:@"loadtype"];//活动
    //发送请求
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (((NSArray*)dic[@"adinfoList"]).count>0) {
            [NSUSER_Defaults setObject:dic forKey:DISCOVER_COACHE_ACTIVE];
            NSMutableArray *images = [NSMutableArray array];
            for (NSDictionary *dict in dic[@"adinfoList"]) {
                [images addObject:dict[@"imgurl"]];
            }
            weakSelf.adsData = dic[@"adinfoList"];
            weakSelf.adview.imageArray = images;
        }
    }];
    
    
    //构造请求参数-----热门标签
    [dictionary setObject:@"4" forKey:@"loadtype"];
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            [NSUSER_Defaults setObject:dic forKey:@"discoverhottagcoache"];
            NSArray *tempArray = dic[@"taglist"];
            UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45+SCREEN_WIDTH*300.0/320.0)];
            [tableHeader addSubview:self.adview];
            
//            UIView *tagView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*300.0/320.0, SCREEN_WIDTH, 26)];
//            tagView.layer.borderColor = [[WWTolls colorWithHexString:@"#dcdcdc"] CGColor];
//            tagView.layer.borderWidth = 0.5;
//            tagView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
//            
//            NSString *hotTitle = @"热门标签";
//            CGFloat width = [WWTolls WidthForString:hotTitle fontSize:10 andHeight:10];
//            
//            UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake((tagView.width - width) / 2, 8, width, 10)];
//            hotLabel.font = MyFont(10.0);
//            hotLabel.text = hotTitle;
//            [tagView addSubview:hotLabel];
//            hotLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
//            
//            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(hotLabel.x - 5 - 40, hotLabel.midY - 0.4, 40, 0.8)];
//            [tagView addSubview:leftLine];
//            leftLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//            
//            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(hotLabel.maxX + 5, leftLine.y, leftLine.width, leftLine.height)];
//            [tagView addSubview:rightLine];
//            rightLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//            [tableHeader addSubview:tagView];
//            //热门标签
//            UIView *hotview  = [[UIView alloc] init];
//            hotview.backgroundColor = [UIColor whiteColor];
//            //阴影
//            hotview.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//            hotview.layer.borderWidth = 0.5;
//            [tableHeader addSubview:hotview];
//            
//            
//            CGFloat x = 10;
//            CGFloat y = 15;
//            for (int i = 0; i<tempArray.count; i++) {
//                
//                NSString *tag = tempArray[i];
//                CGFloat width = [WWTolls WidthForString:tag fontSize:14]+20;
//                if(width>SCREEN_WIDTH-20) width = SCREEN_WIDTH-20;
//                if (x+width+10>SCREEN_WIDTH) {
//                    y += 40;
//                    x = 10;
//                }
//                if (y>55) {
//                    y = 55;
//                    break;
//                }
//                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, 30)];
//                btn.layer.cornerRadius = 15;
//                btn.layer.borderWidth = 0.5;
//                btn.clipsToBounds = YES;
//                btn.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//                [btn setTitle:tag forState:UIControlStateNormal];
//                [btn setTitleColor:[WWTolls colorWithHexString:@"#ff8a01"] forState:UIControlStateNormal];
//                [btn setBackgroundImage:[WWTolls imageWithColor:[WWTolls colorWithHexString:@"#eaeaea"] size:CGSizeMake(width, 30)] forState:UIControlStateHighlighted];
//                btn.titleLabel.font = MyFont(14);
//                x += width + 10;
//                [hotview addSubview:btn];
//                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//                btn.titleLabel.text = tag;
//                [btn addTarget: self action:@selector(tagLabelAction:) forControlEvents:UIControlEventTouchUpInside];
//                
//            }
//            hotview.frame = CGRectMake(0, self.adview.bottom+25, SCREEN_WIDTH, y+45);
//            tableHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80+y+SCREEN_WIDTH*300.0/320.0);
//            self.infomTable.tableHeaderView = tableHeader;
            UILabel *title = [[UILabel alloc] init];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH*300.0/320.0, 15, 45)];
            view.backgroundColor = [UIColor whiteColor];
            [tableHeader addSubview:view];
            title.frame = CGRectMake(15, SCREEN_WIDTH*300.0/320.0, SCREEN_WIDTH, 45);
            title.font = MyFont(17);
            title.textColor = OrangeColor;
            title.text = @"热门标签";
//            [title drawTextInRect:CGRectMake(15, 0, SCREEN_WIDTH, 45)];
//            title.alignmentRectInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            title.backgroundColor = [UIColor whiteColor];
            [tableHeader addSubview:title];
            //热门标签
            UIView *hotview  = [[UIView alloc] init];
            hotview.backgroundColor = [UIColor whiteColor];
            //阴影
//            hotview.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//            hotview.layer.borderWidth = 0.5;
            [tableHeader addSubview:hotview];
            
            
            CGFloat x = 15;
            CGFloat y = 0;
            for (int i = 0; i<tempArray.count; i++) {
                
                NSString *tag = tempArray[i];
                CGFloat width = [WWTolls WidthForString:tag fontSize:13]+30;
                if(width>SCREEN_WIDTH-30) width = SCREEN_WIDTH-30;
                if (x+width+15>SCREEN_WIDTH) {
                    y += 37;
                    x = 15;
                }
                if (y>37) {
                    y = 37;
                    break;
                }
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, 30)];
                btn.layer.cornerRadius = 15;
                btn.layer.borderWidth = 0.5;
                btn.clipsToBounds = YES;
                btn.layer.borderColor = [WWTolls colorWithHexString:@"#c5dde7"].CGColor;
                [btn setTitle:tag forState:UIControlStateNormal];
                [btn setTitleColor:[WWTolls colorWithHexString:@"#5E929B"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[WWTolls imageWithColor:OrangeColor size:CGSizeMake(width, 30)] forState:UIControlStateHighlighted];
                btn.titleLabel.font = MyFont(13);
                x += width+7;
                [hotview addSubview:btn];
                btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                btn.titleLabel.text = tag;
                [btn addTarget: self action:@selector(tagLabelAction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            hotview.frame = CGRectMake(0, title.bottom, SCREEN_WIDTH, y+45);
            tableHeader.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90+y+SCREEN_WIDTH*300.0/320.0);
            self.tableheaderview = tableHeader;
            self.infomTable.tableHeaderView = tableHeader;
        }
    }];
    //构造请求参数-----撒欢
    [dictionary setObject:@"3" forKey:@"loadtype"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]){
            [NSUSER_Defaults setObject:dic forKey:@"discoverdatacoache"];
            weakSelf.informPageNum=1;
            [weakSelf.informdata removeAllObjects];
            NSArray *tempArray = dic[@"showlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.informdata addObject:[DiscoverModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"showid"];
                weakSelf.lastShowKind = dic[@"showkind"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.infomTable reloadData];
            });
        }
        [weakSelf.informheader endRefreshing];
    }];
}

-(void)sendTitleSucess{
    [self loadMessageWithIsMore:NO];
    //构造请求参数-----撒欢
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"3" forKey:@"loadtype"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]){
            [NSUSER_Defaults setObject:dic forKey:@"discoverdatacoache"];
            weakSelf.informPageNum=1;
            [weakSelf.informdata removeAllObjects];
            NSArray *tempArray = dic[@"showlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.informdata addObject:[DiscoverModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"showid"];
                weakSelf.lastShowKind = dic[@"showkind"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.infomTable reloadData];
            });
        }
        [weakSelf.informheader endRefreshing];
    }];
}

-(void)loadInform{
    if (self.informdata.count == 0 || self.informdata.count%10!=0||self.informdata.count<self.informPageNum*10) {
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.informfooter endRefreshing];
        return;
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.informPageNum+1] forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:@"3" forKey:@"loadtype"];
    if(self.lastId.length>0) [dictionary setObject:self.lastId forKey:@"lastid"];
    if(self.lastShowKind.length>0) [dictionary setObject:self.lastShowKind forKey:@"showkind"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            weakSelf.informPageNum++;
            NSArray *tempArray = dic[@"showlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.informdata addObject:[DiscoverModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"showid"];
                weakSelf.lastShowKind = dic[@"showkind"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.infomTable reloadData];
            });
        }
        [weakSelf.informfooter endRefreshing];
    }];
}

#pragma mark - 动态 加载数据
-(void)loadMessageWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.Messagedata.count == 0 || self.Messagedata.count%10!=0||self.Messagedata.count<self.MessagePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.Messagefooter endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.MessagePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(isMore && self.messagelastid) [dictionary setObject:self.messagelastid forKey:@"lastid"];
    if(isMore && self.lastDynKind) [dictionary setObject:self.lastDynKind forKey:@"dynkind"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_GROUPMESSAGE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.MessagePageNum++;
            }else{
                weakSelf.MessagePageNum = 1;
                [weakSelf.Messagedata removeAllObjects];
                [NSUSER_Defaults setObject:dic forKey:@"discovergroupmessagecoache"];
                if ([dic[@"result"] isEqualToString:@"1"]) {//未加入团组
                    self.tipjiantou.hidden = NO;
                    self.tiplbl.hidden = NO;
                }else if([dic[@"result"] isEqualToString:@"2"]){//无团组动态
                    
                }else{//成功
                    self.tiplbl.hidden = YES;
                    self.tipjiantou.hidden = YES;
                }
                [weakSelf.messageTable setContentOffset:CGPointMake(0, 0)];
                self.isShua = @"YES";
            }
            NSArray *tempArray = dic[@"dynlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.Messagedata addObject:[MyGroupDynModel modelWithDic:dic]];
                weakSelf.messagelastid = dic[@"dynid"];
                weakSelf.lastDynKind = dic[@"dynkind"];
            }
            [weakSelf.messageTable reloadData];
        }
        if (isMore) {
            [weakSelf.Messagefooter endRefreshing];
        }else{
            [weakSelf.Messageheader endRefreshing];
        }
    }];
}



#pragma mark - tableView dataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.messageTable) {
        return 2;
    }   
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.messageTable) {
        if(section == 1)
            return self.Messagedata.count;
        else return 0;
    }else if(tableView == self.infomTable){
        return self.informdata.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.messageTable) {
        MyGroupDynModel *model = self.Messagedata[indexPath.row];
        if ([model.dynkind isEqualToString:@"1"]) {//1图聊 2任务 3成就
            if (model.title && model.title.length>0) {
                if (model.talkimage && model.talkimage.length > 0) {
                    return 147;
                }
                NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
                if (heigh<55) {
                    return 97 + heigh;
                }else return 147;
            }
            CGFloat h = [GroupTalkTableViewCell getDynCellHeight:self.Messagedata[indexPath.row]]+6;
            h+=2;
            return h;
        }else if ([model.dynkind isEqualToString:@"2"]){//任务
            return 179;
        }else if ([model.dynkind isEqualToString:@"3"]){//成就
            return 195;
        }
    }else{
        DiscoverModel *model = self.informdata[indexPath.row];
        if ([model.showkind isEqualToString:@"1"]) {//1团组动态 2撒欢 3乐活吧同步
            return 197 + 2;
        }else if ([model.showkind isEqualToString:@"2"]){//撒欢
            return [model getDiscoverHeight];
        }else if ([model.showkind isEqualToString:@"3"]){//乐活吧同步
            if (model.title && model.title.length>0) {
                if (model.talkimage && model.talkimage.length > 0) {
                    return 147;
                }
                NSString *content = [[model.content stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
                CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
                if (heigh<55) {
                    return 97 + heigh;
                }else return 147;
            }
            CGFloat h = [GroupTalkTableViewCell getShowCellHeight:self.informdata[indexPath.row]]+6;
            h+=2;
            return h;
        }
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.messageTable) {
        MyGroupDynModel *model = self.Messagedata[indexPath.row];
        if ([model.dynkind isEqualToString:@"1"]) {//1团聊天 2任务 3成就
            
            if (model.title && model.title.length > 0) {
                NSString *CellIdentifier = @"ZDSGroupActicalCell";
                
                ArticleTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                   CellIdentifier];
                
                
                if (groupCell==nil) {
                    groupCell = [[[NSBundle mainBundle]loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]lastObject];
                    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [groupCell setUpWithGroupDynModel:model];
                return groupCell;
            }
            
            NSString *CellIdentifier = @"cellGroup";
            
            GroupTalkTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                 CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupTalkTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.talkCellDelegate = self;
            }
            groupCell.indexPath = indexPath;
            [groupCell initMyCellWithDynModel:model];
            return groupCell;
        }else if ([model.dynkind isEqualToString:@"2"]){//任务
            NSString *CellIdentifier = @"taskCell";
            
            NewTaskTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                      CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"NewTaskTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            groupCell.model = model;
            return groupCell;
            
        }else if ([model.dynkind isEqualToString:@"3"]){//成就
            NSString *CellIdentifier = @"achievecell";
            
            AchieveTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                      CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"AchieveTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            groupCell.model = model;
            return groupCell;
        }
    }else{
        DiscoverModel *model = self.informdata[indexPath.row];
        if ([model.showkind isEqualToString:@"1"]) {//1团组动态 2撒欢 3乐活吧同步
            NSString *CellIdentifier = @"dyncell";
            
            OfficialInformTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                      CellIdentifier];
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"OfficialInformTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            groupCell.model = model;
            return groupCell;
            
        }else if ([model.showkind isEqualToString:@"2"]){
            DiscoverListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoverListCell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"DiscoverListTableViewCell" owner:self options:nil]lastObject];
            }
            cell.delegate = self;
            cell.indexPath = indexPath;
            cell.model = model;
            return cell;
        }else if ([model.showkind isEqualToString:@"3"]){
            if (model.title && model.title.length > 0) {
                NSString *CellIdentifier = @"ZDSGroupActicalCell";
                
                ArticleTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                   CellIdentifier];
                
                if (groupCell==nil) {
                    groupCell = [[[NSBundle mainBundle]loadNibNamed:@"ArticleTableViewCell" owner:self options:nil]lastObject];
                    groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [groupCell setUpWithDiscoverModel:model];
                return groupCell;
            }
            NSString *CellIdentifier = @"cellGroup";
            
            GroupTalkTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                 CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupTalkTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.talkCellDelegate = self;
            }
            groupCell.indexPath = indexPath;
            [groupCell initMyCellWithShowModel:model];
            return groupCell;
        }
        
    }
    return [[UITableViewCell alloc] init];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.infomTable) {
        DiscoverModel *model = self.informdata[indexPath.row];
        if ([model.showkind isEqualToString:@"1"]) {//1团组动态 2撒欢 3乐活吧同步
            GroupViewController *group = [[GroupViewController alloc] init];
            group.clickevent = 7;
            group.joinClickevent = @"7";
            group.groupId = model.gameid;
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }else if ([model.showkind isEqualToString:@"2"]){//撒欢
            DiscoverDetailViewController *dd = [[DiscoverDetailViewController alloc] init];
            dd.hidesBottomBarWhenPushed = YES;
            dd.discoverId = model.showid;
            [self.navigationController pushViewController:dd animated:YES];
        }else if ([model.showkind isEqualToString:@"3"]){//乐活吧同步
            if (model.title && model.title.length > 0) {
                GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
                talk.talktype = GroupTitleTalkType;
                talk.clickevent = 1;
                talk.talkid = model.showid;
                model.pageview = [NSString stringWithFormat:@"%d",model.pageview.intValue+1];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                talk.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:talk animated:YES];
            }
            else if ([model.isparter isEqualToString:@"0"]) {
                GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
                reply.talkid = model.showid;
                reply.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:reply animated:YES];
            }else{
                GroupViewController *group = [[GroupViewController alloc] init];
                group.clickevent = 5;
                group.joinClickevent = @"5";
                group.groupId = model.gameid;
                group.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:group animated:YES];
            }
        }
        
    }else{
        MyGroupDynModel *model = self.Messagedata[indexPath.row];
        if ([model.dynkind isEqualToString:@"1"]) {//1团聊 2任务 3成就
            GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
            reply.talkid = model.dynid;
            reply.talktype = model.title&&model.title.length>0?GroupTitleTalkType:GroupSimpleTalkType;
            if(reply.talktype == GroupTitleTalkType){
                model.pageview = [NSString stringWithFormat:@"%d",model.pageview.intValue+1];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            reply.clickevent = 2;
            reply.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:reply animated:YES];
            
        }else if ([model.dynkind isEqualToString:@"2"]){
            GroupViewController *group = [[GroupViewController alloc] init];
            group.groupId = model.gameid;
            group.clickevent = 11;
            group.joinClickevent = @"11";
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }else if ([model.dynkind isEqualToString:@"3"]){
            GroupViewController *group = [[GroupViewController alloc] init];
            group.groupId = model.gameid;
            group.clickevent = 13;
            group.joinClickevent = @"13";
            group.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:group animated:YES];
        }
        
    }
}

#pragma mark - 头部按钮点击
-(void)titleBtnClick:(UIButton*)btn{
    if (btn == self.messBtn) {
        self.informBtn.selected = NO;
        self.messBtn.selected = YES;
        self.collectionBtn.hidden = YES;
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:0.2 animations:^{
            self.back.contentOffset = CGPointMake(0, 0);
        }];
        
    }else if(btn == self.informBtn){
        self.informBtn.selected = YES;
        self.messBtn.selected = NO;
        self.collectionBtn.hidden = NO;
        [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView animateWithDuration:0.2 animations:^{
            self.back.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        }];
        [self loadMessageWithIsMore:NO];
    }
}



#pragma mark - 背景视图滑动代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.tag == 1) {//背景视图
        if (scrollView.contentOffset.x<SCREEN_WIDTH/2) {
            // 获取当前的y轴偏移量
            CGFloat curOffsetY = self.infomTable.contentOffset.y;
            
            
            // 计算下与最开始的偏移量的差距
            CGFloat delta = curOffsetY - 0;
            
            // 获取当前导航条背景图片透明度，当delta=136的时候，透明图刚好为1.
            CGFloat alpha = delta * 1 / 300.0;
            if (alpha >= 1) {
                alpha = 0.99;
            }
            if (curOffsetY > 200) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }else{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }
            // 分类：根据颜色生成一张图片
            UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:alpha] size:CGSizeMake(SCREEN_WIDTH, 100)];
            
            //    UIImage *bgImage = [UIImage imageNamed:@"123"];
            [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
//            if ([self.isShua isEqualToString:@"YES"]) {
//                self.isShua = @"NO";
//                [self loadMessageWithIsMore:NO];
//            }
        }else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }
        
    }
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 1) {//背景视图
        if (scrollView.contentOffset.x>SCREEN_WIDTH/2) {
            self.informBtn.selected = YES;
            self.messBtn.selected = NO;
            CGRect myrect = self.tag.frame;
            myrect.origin.x = 93;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView animateWithDuration:0.2 animations:^{
                self.tag.frame = myrect;
            }];
        }else{
            self.informBtn.selected = NO;
            self.messBtn.selected = YES;
            CGRect myrect = self.tag.frame;
            myrect.origin.x = 18;
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView animateWithDuration:0.2 animations:^{
                self.tag.frame = myrect;
            }];
        }
    }
    if (scrollView == self.infomTable) {
        // 获取当前的y轴偏移量
        CGFloat curOffsetY = scrollView.contentOffset.y;
        
        // 计算下与最开始的偏移量的差距
        CGFloat delta = curOffsetY - 0;
        
        // 获取当前导航条背景图片透明度，当delta=136的时候，透明图刚好为1.
        CGFloat alpha = delta * 1 / 300.0;
        
        if (scrollView.contentOffset.y<-74) {
            self.informBtn.hidden = YES;
            self.messBtn.hidden = YES;
            self.tag.hidden = YES;
            if (self.navigationController.childViewControllers.lastObject == self && self.tabBarController.selectedViewController == self.navigationController) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }
        }else{
            self.informBtn.hidden = NO;
            self.messBtn.hidden = NO;
            self.tag.hidden = NO;
        }
        if (scrollView.contentOffset.y > 200) {
            if (self.navigationController.childViewControllers.lastObject == self && self.tabBarController.selectedViewController == self.navigationController) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            }
        }else if (scrollView.contentOffset.y > -74){
            if (self.navigationController.childViewControllers.lastObject == self && self.tabBarController.selectedViewController == self.navigationController) {
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            }
        }
        
        if (alpha >= 1) {
            alpha = 0.99;
        }
        
        // 分类：根据颜色生成一张图片
        UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:alpha] size:CGSizeMake(SCREEN_WIDTH, 100)];
        
        //    UIImage *bgImage = [UIImage imageNamed:@"123"];
        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }else if(scrollView == self.messageTable){
//        UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:0.99] size:CGSizeMake(SCREEN_WIDTH, 100)];
//        //    UIImage *bgImage = [UIImage imageNamed:@"123"];
//        [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - 发布
-(void)addDiscover{
    DiscoverAddViewController *add = [[DiscoverAddViewController alloc] init];
    add.clickevent = self.messBtn.selected?@"1":@"2";
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:YES];
}

#pragma mark 标签列表触发事件
- (void)tagLabelAction:(UIButton*)btn{
    DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
    typeVC.showtag = btn.titleLabel.text;
    typeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:typeVC animated:YES];
}
#pragma mark - getter
-(JYADView *)adview{
    //活动轮播图
    if (_adview == nil) {
        [JYADView setKHeight:SCREEN_WIDTH*300.0/320.0];
        _adview = [[JYADView alloc] init];
        _adview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*300.0/320.0);
        __weak __typeof(self)weakSlef = self;
        _adview.adDidClick = ^(NSInteger index){
            [MobClick event:@"DISCOVERBANNERCLICK"];
            NSDictionary *dic = weakSlef.adsData[index];
            NSString *adUrl = dic[@"adlink"];
            NSString *linktype = dic[@"linktype"];
            if (adUrl != nil && ![adUrl isEqualToString:@""]) {
                NSLog(@"广告被点击%@",adUrl);
                if (linktype.intValue == 0) {//用户ID
                    MeViewController *single = [[MeViewController alloc]init];
                    single.userID = adUrl;
                    single.otherOrMe = 1;
                    single.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:single animated:YES];
                }else if(linktype.intValue == 1){//游戏ID
                    GroupViewController *gameDetail = [[GroupViewController alloc]init];
                    gameDetail.groupId = adUrl;
                    gameDetail.clickevent = 3;
                    gameDetail.joinClickevent = @"3";
                    gameDetail.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:gameDetail animated:YES];
                }else if(linktype.intValue == 2){//商品ID
                    StoreDetailViewController *storeDetail = [[StoreDetailViewController alloc]initWithNibName:@"StoreDetailViewController" bundle:nil];
                    storeDetail.isEnoughScore  = YES;
                    storeDetail.goodsid = adUrl;
                    storeDetail.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:storeDetail animated:YES];
                }else if(linktype.intValue == 3){//URL连接
                    WebViewController *web = [[WebViewController alloc] init];
                    web.URL = adUrl;
                    web.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:web animated:YES];
                }else if(linktype.intValue == 4){//游戏攻略
                    GameRuleViewController *rule = [[GameRuleViewController alloc] initWithNibName:@"GameRuleViewController" bundle:nil];
                    rule.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:rule animated:YES];
                }else if(linktype.intValue == 5){//展示类别
                    
                }else if(linktype.intValue == 6){//展示详情
                    DiscoverDetailViewController *dd = [[DiscoverDetailViewController alloc] init];
                    dd.discoverId = adUrl;
                    dd.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:dd animated:YES];
                } else if (linktype.intValue == 7) {//展示详情
                    DiscoverTypeViewController *type = [[DiscoverTypeViewController alloc]init];
                    type.showtag = adUrl;
                    type.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:type animated:YES];
                }else if (linktype.intValue == 8) {//精华帖
                    GroupTalkDetailViewController *type = [[GroupTalkDetailViewController alloc]init];
                    type.talktype = GroupTitleTalkType;
                    type.talkid = adUrl;
                    type.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:type animated:YES];
                }else if (linktype.intValue == 9) {//乐活吧
                    GroupTalkDetailViewController *type = [[GroupTalkDetailViewController alloc]init];
                    type.talktype = GroupSimpleTalkType;
                    type.talkid = adUrl;
                    type.hidesBottomBarWhenPushed = YES;
                    [weakSlef.navigationController pushViewController:type animated:YES];
                }
            }
        };
    }
    return _adview;
}

#pragma mark - 释放
-(void)dealloc{
    [self.Messageheader free];
    [self.Messagefooter free];
    [self.informfooter free];
    [self.informheader free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark 定位代理方法

//允许定位后执行的代理方法
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             NSDictionary *placeDict = placemark.addressDictionary;
             NSLog(@"placeDict %@",placeDict);
             
             
             NSString *cityStr = [placeDict objectForKey:@"City"];
             
             //             国家
             NSString *countryStr = [placeDict objectForKey:@"Country"];
             
             //             城市
             NSString *stateStr = [placeDict objectForKey:@"State"];
             NSLog(@"%@ %@ %@",cityStr,countryStr,stateStr);
             
             //             区
             NSString *SubLocality = [placeDict objectForKey:@"SubLocality"];
             if ([SubLocality rangeOfString:@"市"].length>0) {
                 SubLocality = [SubLocality substringToIndex:SubLocality.length-1];
             }
             if ([stateStr rangeOfString:@"市"].length>0) {
                 stateStr = [stateStr substringToIndex:SubLocality.length-1];
             }
             if ([stateStr rangeOfString:@"省"].length>0) {
                 stateStr = [stateStr substringToIndex:SubLocality.length-1];
             }
             NSLog(@"%@",SubLocality);
             NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
             
             NSString * userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
             if (userID.length!=0) {
                 [dic setObject:userID forKey:@"userid"];
             }
             NSString *key = [NSString getMyKey:userID];
             [dic setObject:key forKey:@"key"];
             
             dic[@"country"] = [NSString stringWithString:countryStr];
             dic[@"province"] = [NSString stringWithString:stateStr];
             
             dic[@"city"] = [NSString stringWithString:SubLocality];
             dic[@"longitude"] = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
             dic[@"latitude"] = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
             dic[@"iscover"] = @"1";//不覆盖
             NSString * url_str = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"/user/uplocation.do"];
             [WWRequestOperationEngine operationManagerRequest_Post:url_str parameters:dic requestOperationBlock:^(NSDictionary *dic) {
                 
             }];
         }
         
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
#pragma mark - 撒欢私有方法
#pragma mark - Private Methods
//举报撒欢
- (void)shareViewDelegateReport {
    jubaotype = @"2";
    [self reportButtonSender];
}

//删除撒欢
- (void)shareViewDelegateDelete {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"是否确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    view.tag = 777;
    [view show];
}

#pragma mark discoverReportDelegate
#pragma mark - 举报
-(void)reportClick:(NSString*)discoverId{
    self.disCoverId = discoverId;
    [self shareImageAndText];
}

-(void)discoverCell:(DiscoverListTableViewCell *)discoverCell reportClick:(NSString*)discoverId {
    self.disCoverId = discoverId;
    self.currentIndexPath = discoverCell.indexPath;
    [self shareImageAndText];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 777) {//删除撒欢
        if (buttonIndex == 1) {
            if (self.currentIndexPath.section == 0) {
                DiscoverModel *model = self.informdata[self.currentIndexPath.row];
                if ([model.showkind isEqualToString:@"2"]) {
                    [self requestWithDelShowWithDeleteid:model.showid];
                }else
                    [self requestWithDeleteBarWithDeleteid:model.showid andDelType:@""];
            }else{
                MyGroupDynModel *model = self.Messagedata[self.currentIndexPath.row];
                [self requestWithDeleteDynBarWithDeleteid:model.dynid andDelType:@""];
            }
        }
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(actionSheet.tag == 123){//举报撒欢
        switch (buttonIndex) {//举报
            case 0:
                [self postReport:@"0"];
                break;
            case 1:
                [self postReport:@"1"];
                break;
            case 2:
                [self postReport:@"2"];
                break;
            case 3:
                [self postReport:@"3"];
                break;
            case 4:
                [self postReport:@"99"];
                break;
            default:
                break;
        }
    }
}

//分享图文
- (void)shareImageAndText {
    
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    
    DiscoverModel *tempModel = nil;
    int i = 0;
    for (; i < self.informdata.count; i++) {
        DiscoverModel *model = self.informdata[i];
        if ([model.showid isEqualToString:self.disCoverId]) {
            tempModel = model;
            break;
        }
    }
    
    [myshareView createView:DiscoverShareType withModel:tempModel withGroupModel:nil];
    DiscoverListTableViewCell *cell = (DiscoverListTableViewCell *)[self.infomTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
    UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.photoImage.image];
    NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
    
    [myshareView setShareImage:[UIImage imageWithData:data]];
}

#pragma mark - Request

/**
 *  删除撒欢
 *
 *  @param deleteid 撒欢ID
 *
 *  @return void
 */
- (void)requestWithDelShowWithDeleteid:(NSString *)deleteid {
    
    [self showWaitView];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Show parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        DeleteShowModel *model = [DeleteShowModel objectWithKeyValues:dic];
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            //构造请求参数-----撒欢
            [dictionary setObject:@"3" forKey:@"loadtype"];
            [dictionary setObject:@"1" forKey:@"pageNum"];
            [dictionary setObject:@"10" forKey:@"pageSize"];
            [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
                if (!dic[ERRCODE]) {
                    [NSUSER_Defaults setObject:dic forKey:@"discoverdatacoache"];
                    weakSelf.informPageNum=1;
                    [weakSelf.informdata removeAllObjects];
                    NSArray *tempArray = dic[@"showlist"];
                    for (NSDictionary *dic in tempArray) {
                        [weakSelf.informdata addObject:[DiscoverModel modelWithDic:dic]];
                        weakSelf.lastId = dic[@"showid"];
                        weakSelf.lastShowKind = dic[@"showkind"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.infomTable reloadData];
                    });
                }
            }];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
        }
    }];
}
#pragma mark - NSNotificationCenter
-(void)goodDiscover:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showid isEqualToString:dic[@"receiveid"]]) {
            model.praisestatus = dic[@"praisestatus"];
            model.praisecount =[NSString stringWithFormat:@"%d",[model.praisestatus isEqualToString:@"0"]?model.praisecount.intValue+1:model.praisecount.intValue-1];
            [self.infomTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
-(void)comDiscover:(NSNotification*)object{    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showid isEqualToString:dic[@"showid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.infomTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)deleteDiscover:(NSNotification *)object {
    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showid isEqualToString:dic[@"showid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.infomTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)removeMyActionSheet
{
    if (myActionSheetView!=nil) {
        [myActionSheetView removeFromSuperview];
    }
}

-(void)reportButtonSender
{
    NSLog(@"-------------点击了举报");
    myActionSheetView = [[UIActionSheet alloc] initWithTitle:@"选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"垃圾营销",@"淫秽信息",@"不实信息",@"敏感信息",@"其他", nil];
    myActionSheetView.tag = 123;
    [myActionSheetView showInView:self.view];
    
}

#pragma mark - 举报接口
-(void)postReport:(NSString*)ifmtype{
    DiscoverModel *model = [self.informdata objectAtIndex:self.currentIndexPath.row];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:model.showid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:[model.showkind isEqualToString:@"2"]?@"2":@"0" forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectZero];
    }];
}

#pragma mark - 乐活吧同步代理事件
#pragma mark groupTalkCellDelegate
#pragma mark - 举报
-(void)reportClick:(NSString*)discoverId AndType:(NSString*)type{
    talkid = discoverId;
    [self jubaoShare];
}

- (void)reportClick:(NSString *)talkId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath {
    talkid = talkId;
    self.currentIndexPath = indexPath;
    [self jubaoShare];
}
#pragma mark 乐活吧分享
- (void)jubaoShare {
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    GroupTalkModel *tempModel = [[GroupTalkModel alloc] init];
    GroupTalkTableViewCell *cell;
    if (self.messBtn.selected) {
        DiscoverModel*model = self.informdata[self.currentIndexPath.row];
        tempModel.content = model.content;
        tempModel.imageurl = model.talkimage;
        tempModel.userid = model.userid;
        tempModel.barid = model.showid;
        cell = (GroupTalkTableViewCell *)[self.infomTable cellForRowAtIndexPath:self.currentIndexPath];
    }else{
        MyGroupDynModel *model = self.Messagedata[self.currentIndexPath.row];
        tempModel.content = model.content;
        tempModel.imageurl = model.talkimage;
        tempModel.userid = model.userid;
        tempModel.barid = model.dynid;
        cell = (GroupTalkTableViewCell *)[self.messageTable cellForRowAtIndexPath:self.currentIndexPath];
    }   
    
    //团聊
    
    UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.contentImageView.image];
    NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
    UIImage *image = [UIImage imageWithData:data];
    GroupHeaderModel *mm = [[GroupHeaderModel alloc] init];
    [myshareView createView:SquareAndDynamicTalkShareType withModel:tempModel withGroupModel:mm];
    [myshareView setShareImage:image];
}   
#pragma mark 乐活吧删除

/**
 *  删除乐活吧请求
 *
 *  @param deleteid 团组ID、活动ID
 *  @param deltype  1 删除团聊 2 删除活动
 *
 *  @return void
 */
- (void)requestWithDeleteBarWithDeleteid:(NSString *)deleteid andDelType:(NSString *)deltype {
    
    [self showWaitView];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    [dictionary setObject:@"1" forKey:@"deltype"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Bar parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        
        if (!dic[ERRCODE]) {
            DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
            //处理成功
            if ([model.result isEqualToString:@"0"]) {
                [weakSelf refreshInform];
                [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            }
        }
    }];
}
- (void)requestWithDeleteDynBarWithDeleteid:(NSString *)deleteid andDelType:(NSString *)deltype {
    
    [self showWaitView];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    [dictionary setObject:@"1" forKey:@"deltype"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Bar parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            [weakSelf loadMessageWithIsMore:NO];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
        }
    }];
}

#pragma mark NSNotification
-(void)sucess:(NSNotification*)no{
    //构造请求参数-----撒欢
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"3" forKey:@"loadtype"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:@"0" forKey:@"isinclude"];
    [dictionary setObject:@"2" forKey:@"showkind"];
    [dictionary setObject:no.object[@"showid"] forKey:@"lastid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_DATA parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            [NSUSER_Defaults setObject:dic forKey:@"discoverdatacoache"];
            weakSelf.informPageNum=1;
            [weakSelf.informdata removeAllObjects];
            NSArray *tempArray = dic[@"showlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.informdata addObject:[DiscoverModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"showid"];
                weakSelf.lastShowKind = dic[@"showkind"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.infomTable reloadData];
                weakSelf.infomTable.contentOffset = CGPointMake(0, 0);
            });
        }
    }];
}

-(void)good:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"receiveid"]]) {
            model.praisestatus = dic[@"praisestatus"];
            model.praisecount =[NSString stringWithFormat:@"%d",[model.praisestatus isEqualToString:@"0"]?model.praisecount.intValue+1:model.praisecount.intValue-1];
            [self.infomTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    for (int i = 0;i<self.Messagedata.count;i++) {
        MyGroupDynModel *model  = self.Messagedata[i];
        if ([model.dynkind isEqualToString:@"1"]&&[model.dynid isEqualToString:dic[@"receiveid"]]) {
            model.praisestatus = dic[@"praisestatus"];
            model.praisecount =[NSString stringWithFormat:@"%d",[model.praisestatus isEqualToString:@"0"]?model.praisecount.intValue+1:model.praisecount.intValue-1];
            [self.messageTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
-(void)com:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.infomTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    for (int i = 0;i<self.Messagedata.count;i++) {
        MyGroupDynModel *model  = self.Messagedata[i];
        if ([model.dynkind isEqualToString:@"1"]&&[model.dynid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.messageTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

-(void)delteReply:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.infomTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    for (int i = 0;i<self.Messagedata.count;i++) {
        MyGroupDynModel *model  = self.Messagedata[i];
        if ([model.dynkind isEqualToString:@"1"]&&[model.dynid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.messageTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

-(void)groupTitleDelete:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.informdata.count;i++) {
        DiscoverModel *model  = self.informdata[i];
        if ([model.showkind isEqualToString:@"3"]&&[model.showid isEqualToString:dic[@"talkid"]]) {
            [self refreshInform];
            break;
        }
    }
    for (int i = 0;i<self.Messagedata.count;i++) {
        MyGroupDynModel *model  = self.Messagedata[i];
        if ([model.dynkind isEqualToString:@"1"]&&[model.dynid isEqualToString:dic[@"talkid"]]) {
            [self loadMessageWithIsMore:NO];
            break;
        }
    }
}

#pragma mark - 定位
-(void)refreshadd{
    if (![[NSUSER_Defaults objectForKey:@"openupdateweizhi"] isEqualToString:@"YES"]) {
        [NSUSER_Defaults setObject:@"YES" forKey:@"openupdateweizhi"];
        if (![CLLocationManager locationServicesEnabled]) {
            NSLog(@"定位服务当前可能尚未打开，请设置打开！");
            return;
        }
        
        if(iOS8){
            //创建CLLocationManager对象
            self.locationManager = [[CLLocationManager alloc] init];
            //设置代理为自己
            self.locationManager.delegate = self;
            
            //    请求使用期间定位
            //    [self.locationManager requestAlwaysAuthorization];
            [self.locationManager requestWhenInUseAuthorization];
            
            //    定位请求状态
            CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
            
            //    如果使用期间可以定位则定位
            
            if (status == kCLAuthorizationStatusDenied)
            {
                NSString *alertStr = @"您关闭了应用的定位请求，请选择您的所在区域";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                
                [alertView show];
                
                NSLog(@"用户需要选择区域");
            }
            else
            {
                
                [self.locationManager startUpdatingLocation];
                NSLog(@"定位");
            }
        }else{
            //创建CLLocationManager对象
            self.locationManager = [[CLLocationManager alloc] init];
            //设置代理为自己
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
            NSLog(@"定位");
        }
    }
}
@end
