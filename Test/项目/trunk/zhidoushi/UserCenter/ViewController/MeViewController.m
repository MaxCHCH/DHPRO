//
//  MeViewController.m
//  zhidoushi
//
//  Created by Kenshin on 15/4/22.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MeViewController.h"
#import "SetupGameViewController.h"
#import "MyLibraryViewController.h"
#import "NSString+NARSafeString.h"
#import "MyFriendViewController.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSURL+MyImageURL.h"
#import "XimageView.h"
#import "XTabBar.h"
#import "HomeGroupCollectionViewCell.h"
#import "StoreViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "UserAblumViewController.h"
#import "ChatViewController.h"
#import "GroupViewController.h"
#import "HomeGroupModel.h"
#import "CreateGroupOneViewController.h"
#import "DAProgressOverlayView.h"
#import "SelectTagsViewController.h"
#import "CreateGroupTwoViewController.h"
#import "ZDSPhotosViewController.h"
#import "YCMeInfoView.h"
#import "ReusableView.h"
#import "XLPlainFlowLayout.h"
#import "MyActivesViewController.h"
//#import "MyLibraryViewController2.h"
#import "MyLibraryViewController2.h"


#import "SnapViewController.h"

#import "UserFunsListViewController.h"
#import "UserFollowListViewController.h"
#import "CreateGroupTwoNewViewController.h"
#import "PingTransition.h"
#import "NewFViewController.h"

#import "YCGroupCollectionViewCell.h"


#define BLANK_WIDTH 7
#define BLANK_HEIGHT 0

//个人主页
@interface MeViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString * usertype;
    NSString *praisestatus;//当前用户的点赞状态
}
@property(nonatomic,copy)NSString *totalscore;//总分
@property(strong,nonatomic) MJRefreshHeaderView* header;
@property(strong,nonatomic) MJRefreshFooterView* footer;
@property(copy,nonatomic) NSString* headerImageURLStr;
@property(nonatomic,assign)int page;//页号
@property(nonatomic,copy)NSString *flwstatus;//关注状态
@property(nonatomic,copy)NSString *areaTitle;//地址
@property(nonatomic,strong)UICollectionView *timeCollection;//成就视图
@property(nonatomic,copy)NSString *NOSHUJU;//是否显示空
@property(nonatomic,assign)BOOL noBulid;//创建
@property(nonatomic,strong)NSTimer *pressingTimer;//冷却时间定时器
@property (strong, nonatomic) DAProgressOverlayView *progressOverlayView;

/** 用户体重按钮 */
@property (nonatomic, strong)YCMeInfoView *userweightView;

/** 用户动态按钮 */
@property (nonatomic, strong)YCMeInfoView *dyncountView;

/** 用户关注按钮 */
@property (nonatomic, strong)YCMeInfoView *flwcountView;

/** 用户粉丝按钮 */
@property (nonatomic, strong)YCMeInfoView *fanscountView;


/** 蒙层 */
@property (nonatomic, strong)UIView *mengcengView;

/** 记录下最开始的Y轴偏移量 */
@property (nonatomic, assign) CGFloat oriOffsetY;


/** <#属性名称#> */
@property (nonatomic, assign)CGFloat tableViewCurOffsetY;

/** <#属性名称#> */
@property (nonatomic, assign)CGFloat collectionViewCurOffsetY;


/** 所有数据模型 */
@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation MeViewController
{
    //    整体tableview
    UITableView *_fullTableV;
    
    //    数据源, 这里的数据源值得是获取到的团组的个数（）
    //    NSMutableArray *self.dataArray;
    
    //    所有我创建的团组模型数据
    NSMutableArray *_meGroupDataArray;
    
    
    //    所有我加入的团组模型数据
    NSMutableArray *_joinGroupDataArray;
    
    
    
    //    标记判断选中的是活动还是成就
    NSInteger _btnFlag;
}

static NSString *headerID = @"headerID";
//static NSString *footerID = @"footerID";
//
//- (NSMutableArray *)dataArray {
//
//    if (self.dataArray == nil) {
//        self.dataArray = [[NSMutableArray alloc] init];
//    }
//    return self.dataArray;
//}

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    [_meGroupDataArray removeAllObjects];
    [_joinGroupDataArray removeAllObjects];
    
    for (HomeGroupModel *model in dataArray) {
        
        if ([model.partype isEqualToString:@"0"] || [model.partype isEqualToString:@"1"]) { // 自己创建的团组
            
            // 加到我创建的团组模型数据源中
            [_meGroupDataArray addObject:model];
            
        } else {
            
            
            // 加到我加入的团组模型数据源中
            [_joinGroupDataArray addObject:model];
        }
    }
    
    [_fullTableV reloadData];
    [self.timeCollection reloadData];
}

- (UICollectionView *)timeCollection {
    
    if (_timeCollection == nil) {
        _timeCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _timeCollection.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100 + 25);
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize=CGSizeMake(150,200);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//整体偏移
        //        flowLayout.minimumInteritemSpacing = 5;//列间距
        flowLayout.minimumLineSpacing = 10;//行间距
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        //            _timeCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-100) collectionViewLayout:flowLayout];
        _timeCollection.collectionViewLayout = flowLayout;
        
        _timeCollection.tag = 0;
        _timeCollection.backgroundColor = [UIColor whiteColor];
        _timeCollection.showsVerticalScrollIndicator = NO;
        [_timeCollection setCollectionViewLayout:flowLayout];
//        [_timeCollection registerClass:[YCGroupCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
        
        [_timeCollection registerNib:[UINib nibWithNibName:NSStringFromClass([YCGroupCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"CollectionViewIdentifier"];
        
        
        _timeCollection.delegate = self;
        _timeCollection.dataSource = self;
        _timeCollection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _timeCollection.backgroundColor = RGBCOLOR(239, 239, 239);
    }
    return _timeCollection;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    self.navigationController.delegate = nil;
    
    /**
     *  修复导航栏的透明效果带来的影响
     */
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.hidden = NO;
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    
    
    [MobClick endLogPageView:@"我页面"];
}

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"%p",self.tabBarController);
    
    
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.titleLabel.textColor = [UIColor clearColor];
    if(self.otherOrMe == 0)
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    else self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if (!iOS8) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    self.timeCollection.contentOffset = CGPointZero;
    
    _fullTableV.contentOffset = CGPointZero;
    
    NSString * userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_LOADME];
    
    [self reloadMyInformationView:userID seeuserid:nil andUrl:urlString];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
   
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.titleLabel.hidden = YES;

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self receiveNewFriendsMessage];
    [MobClick beginLogPageView:@"我页面"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    
    //    /**
    //     *  修复导航栏的透明效果带来的影响
    //     */
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    //    自己
    if (self.navigationController.viewControllers.firstObject == self) {
        if (self.navigationController.tabBarController.selectedIndex != 3) {
            [MobClick event:@"ME"];
            [WWTolls zdsClick:@"zwnum"];
        }
    }
    if (self.otherOrMe == 0) // 自己
    {
        //        self.tabBarController.tabBar.hidden = NO;
        
        self.leftButton.titleLabel.font = MyFont(16);
        self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"sz-36"] forState:UIControlStateNormal];
        [self.leftButton addTarget:self action:@selector(SetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //导航相册
        //        [self.rightButton setTitle:@"朋友" forState:UIControlStateNormal];
        self.rightButton.bounds = CGRectMake(0, 0, 18, 18);
        [self.rightButton setBackgroundImage:[UIImage imageNamed:@"jhy-36"] forState:UIControlStateNormal];
        
        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
        self.rightButton.titleLabel.font = MyFont(17);
        [self.rightButton addTarget:self action:@selector(rightHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        _fullTableV.height = SCREEN_HEIGHT - 44; //112   64+44
        
        _fullTableV.backgroundColor = RGBCOLOR(239, 239, 239);
        
        //        _fullTableV.height = SCREEN_HEIGHT;
        
    }
    //    别人，别人和自己的布局区别在于别人看不到朋友，右上角是点赞，个人宣言下面有私信和关注按钮；自己看得到朋友，右上角是编辑个人信息
    
    else { // 别人
        //导航返回
        self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
        //    [self.leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.leftButton.titleLabel.font = MyFont(11);
        [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
        CGRect labelRect = self.leftButton.frame;
        labelRect.size.width = 16;
        labelRect.size.height = 16;
        labelRect.origin.x = 0;
        self.leftButton.frame = labelRect;
        self.rightButton.bounds = CGRectMake(0, 0, 16, 16);
        //隐藏底部导航栏
        //        self.navigationController.tabBarController.tabBar.hidden = YES;
        //        self.tabBarController.tabBar.hidden = YES;
        
        //        _fullTableV.height = SCREEN_HEIGHT - 63;
        _fullTableV.height = SCREEN_HEIGHT;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsNotificationFriend) name:@"newFriendPhones" object:nil];
    
    //    [[XTabBar shareXTabBar] removeRedSpotImage];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_LOADME];
    //    加载个人数据
    if ([[NSUSER_Defaults objectForKey:@"xiugaiziliao"] isEqualToString:@"YES"]&&self.otherOrMe == 0) {
        [self reloadMyInformationView:self.userID seeuserid:nil andUrl:urlString];
        [NSUSER_Defaults setValue:@"NO" forKey:@"xiugaiziliao"];
    }
    //加载活动数据
    if ([[NSUSER_Defaults objectForKey:@"tuanzubianhua"] isEqualToString:@"YES"]&&self.otherOrMe == 0) {
        [self loadGroup];
        [NSUSER_Defaults setValue:@"NO" forKey:@"tuanzubianhua"];
        
        //加入成功的情况
    }
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    // 注册header和footer
    [self.timeCollection registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    //    [self.timeCollection registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
    
    self.timeCollection.scrollEnabled = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //显示导航栏
    self.navigationController.navigationBar.hidden = NO;
    
    //广场标题
    //    self.titleLabel.text = @"个人主页";
    self.titleLabel.hidden = YES;
    self.titleLabel.font = MyFont(17);
    self.page = 1;
    //    初始化tableview
    _fullTableV = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    if (self.otherOrMe == 0) {//自己
        _fullTableV.height -= 64;
    }else{//他人
        //        _fullTableV.height -= 63;
    }
    _fullTableV.dataSource = self;
    _fullTableV.delegate = self;
    _fullTableV.backgroundColor = RGBCOLOR(239, 239, 239);
    _fullTableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    // 初始化模型数据
    _dataArray = [[NSMutableArray alloc] init];
    _meGroupDataArray = [[NSMutableArray alloc] init];
    _joinGroupDataArray = [[NSMutableArray alloc] init];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_LOADME];
    
    
    //添加左右滑动手势
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    //    [_fullTableV addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    
    //    [_fullTableV addGestureRecognizer:recognizer];
    
    //    初始化数据源
    
    //    0活动，1成就
    _btnFlag = 0;
    
    //加载缓存
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    self.header.scrollView = _fullTableV;
    __weak typeof(self) weakself = self;
    self.header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        NSString * userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_LOADME];
        
        [weakself reloadMyInformationView:userID seeuserid:nil andUrl:urlString];
        
        [weakself.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [weakself.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
        
        //加载活动数据
        [weakself loadGroup];
        //加载积分数量
        [weakself loadJiFen];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    self.footer.scrollView = _fullTableV;
    self.footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        //加载活动数据
        [weakself loadMoreGroup];
    };
    
    
    //  头像iv初始化
    self.headImageView = [[XimageView alloc] init];
    self.headImageView.layer.cornerRadius = 30;
    self.headImageView.clipsToBounds = YES;
    self.nameLabel = [[UILabel alloc] init];
    //    地区label初始化
    self.areaLabel = [[UILabel alloc] init];
    
    //    星座label初始化
    self.starLabel = [[UILabel alloc] init];
    
    //    点赞label
    self.praiseLabel = [[UILabel alloc] init];
    
    //  性别
    self.sexImage = [[UIImageView alloc] init];
    
    self.headerBGView = [[UIImageView alloc] init];
    
    self.mengcengView = [[UIView alloc] init];
    
    //    个人宣言
    self.declareLabel = [[UILabel alloc] init];
    
    //     关注按钮
    self.focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //    私信按钮
    self.pmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    //    创建团组按钮
    self.creatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //    点赞按钮
    self.goodButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-57, 17, 40, 30)];
    // id
    self.usercodeLbl = [[UILabel alloc] init];
    //    self.goodButton.layer.cornerRadius = 5;
    //    self.goodButton.clipsToBounds = YES;
    [self.goodButton setBackgroundImage:[UIImage imageNamed:@"nieyixia-80-60"] forState:UIControlStateNormal];
    self.goodButton.layer.masksToBounds = YES;
    self.progressOverlayView = [[DAProgressOverlayView alloc] initWithFrame:self.goodButton.bounds];
    self.progressOverlayView.stateChangeAnimationDuration = 0.5;
    self.progressOverlayView.layer.cornerRadius = 15.6;
    self.progressOverlayView.clipsToBounds = YES;
    self.progressOverlayView.width = 30.5;
    self.progressOverlayView.top -= 0.2;
    self.progressOverlayView.height=30.5;
    self.progressOverlayView.left += 4.6;
    
    [self.goodButton addSubview:self.progressOverlayView];
    [self.goodButton addTarget:self action:@selector(goodButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_fullTableV];
    
    //读取缓存
    if (self.otherOrMe == 0) {
        [self readCoche];
    }
    
    [self.header beginRefreshing];
    //    //    加载个人数据
    //    [self reloadMyInformationView:self.userID seeuserid:nil andUrl:urlString];
    //    //加载活动数据
    //    [self loadGroup];
    //    //加载积分数量
    //    [self loadJiFen];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
    YCMeInfoView *menu1 = [[YCMeInfoView alloc] init];
    menu1.tagBtn.tag = 1000;
    [menu1.tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userweightView = menu1;
    YCMeInfoView *menu2 = [[YCMeInfoView alloc] init];
    menu2.tagBtn.tag = 1001;
    [menu2.tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.dyncountView = menu2;
    
    YCMeInfoView *menu3 = [[YCMeInfoView alloc] init];
    menu3.tagBtn.tag = 1002;
    [menu3.tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.flwcountView = menu3;
    
    YCMeInfoView *menu4 = [[YCMeInfoView alloc] init];
    menu4.tagBtn.tag = 1003;
    [menu4.tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.fanscountView = menu4;
}
- (void)notifyHiden{
    if (self.otherOrMe == 0){
        _fullTableV.height = SCREEN_HEIGHT - 64; // 112
        //        _fullTableV.height = SCREEN_HEIGHT;
    }else{
        //        _fullTableV.height = SCREEN_HEIGHT - 63;
        _fullTableV.height = SCREEN_HEIGHT;
    }
}
#pragma mark - 冷却时间定时器
- (void) createTimer
{
    if(self.progressOverlayView.progress<1){
        [self bian];
        if(!self.pressingTimer){
            self.pressingTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                  target:self
                                                                selector:@selector(bian)
                                                                userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.pressingTimer forMode:NSRunLoopCommonModes];
        }
    }else{
        if(self.pressingTimer){
            [self.pressingTimer invalidate];
            self.pressingTimer = nil;
        }
        
    }
    
}
-(void)bian{
    CGFloat progress = self.progressOverlayView.progress + 1/120.0;
    if (progress >= 1) {
        [self.progressOverlayView displayOperationDidFinishAnimation];
        __weak typeof(self) weakself = self;
        double delayInSeconds = self.progressOverlayView.stateChangeAnimationDuration-0.4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //            self.progressOverlayView.progress = 0.;
            weakself.progressOverlayView.hidden = YES;
        });
    } else {
        self.progressOverlayView.hidden = NO;
        self.progressOverlayView.progress = progress;
    }
}
//copy
#pragma mark - 读取缓存
-(void)readCoche{
    NSDictionary *dic = [NSUSER_Defaults objectForKey:ME_COACHE_MESSAGE];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.nameLabel.text = [dic objectForKey:@"username"];
    
    NSString *weightStr = [NSString stringWithFormat:@"%@kg", [dic objectForKey:@"userweight"]];
    self.userweightView.infoLabel.text = weightStr;
    self.dyncountView.infoLabel.text = [dic objectForKey:@"dyncount"];
    self.flwcountView.infoLabel.text = [dic objectForKey:@"flwcount"];
    self.fanscountView.infoLabel.text = [dic objectForKey:@"fanscount"];
    
    self.usercodeLbl.text = [NSString stringWithFormat:@"%@",dic[@"username"]];
    
    [self.usercodeLbl sizeToFit];
    
    self.usercodeLbl.width = [WWTolls WidthForString:dic[@"username"] fontSize:18];
    self.titleLabel.text = dic[@"username"];
    //关注状态
    self.flwstatus = dic[@"flwstatus"];
    if ([self.flwstatus isEqualToString:@"0"]) {
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"me_yiguanzhu"] forState:UIControlStateNormal];
    }else{
        [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"me_guanzhu"] forState:UIControlStateNormal];
    }
    NSString *country = dic[@"country"];
    NSString *province = dic[@"province"];
    NSString *city = dic[@"city"];
    self.areaTitle = country.length==0?@"":province.length==0?country:[NSString stringWithFormat:@"%@ %@",province,city];
    self.areaLabel.text = country.length==0?@"":province.length==0?country:[NSString stringWithFormat:@"%@ %@",province,city];
    self.praiseLabel.text = dic[@"praisecount"];
    self.contentLabel.text = [dic objectForKey:@"usersign"];
    self.headerImageURLStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imageurl"]];
    self.declareLabel.text = dic[@"usersign"];
    NSString *birth = dic[@"birthday"];
    if (birth.length>9) {
        int month = [[birth substringWithRange:NSMakeRange(5, 2)] intValue];
        int day = [[birth substringWithRange:NSMakeRange(8, 2)] intValue];
        self.starLabel.text = [NSString stringWithFormat:@"%@",[WWTolls getAstroWithMonth:month day:day]];
        
    }else{
        self.starLabel.text = @"";
    }
    
    //性别
    if ([dic[@"usersex"] isEqualToString:@"1"]) {//男
        self.sexImage.image = [UIImage imageNamed:@"nan-26"];
        
        self.headerBGView.image = [UIImage imageNamed:@"grzy-man-750-600.png"];
    }else{//女
        self.sexImage.image = [UIImage imageNamed:@"nv-26"];
        self.headerBGView.image = [UIImage imageNamed:@"grzy-woman-750-600.jpg"];
    }
    NSURL *imageUrl = [NSURL URLWithImageString:self.headerImageURLStr Size:98];
    [self.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    self.goodLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"popularity"]];
    
    
    /**
     *  团组信息缓存
     */
    dic = [NSUSER_Defaults objectForKey:ME_COACHE_GROUP];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.page = 1;
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *curGame in dic[@"gamelist"]) {
        HomeGroupModel *model = [HomeGroupModel modelWithDic:curGame];
        self.lastId = model.gameid;
        [temp addObject:model];
    }
    if (temp.count == 0) {
        self.NOSHUJU = @"YES";
    }else self.NOSHUJU = @"NO";
    self.dataArray = temp;
    
    [_fullTableV reloadData];
}

#pragma mark - 加载活动请求
-(void)loadGroup{
    //构造请求参数
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    if (self.userID.length>0) {
        [dictionary setObject:self.userID forKey:@"seeuserid"];
    }else [dictionary setObject:userID forKey:@"seeuserid"];
    
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_GROUP parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakself.page = 1;
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *curGame in dic[@"gamelist"]) {
                HomeGroupModel *model = [HomeGroupModel modelWithDic:curGame];
                weakself.lastId = model.gameid;
                [temp addObject:model];
            }
            if (temp.count == 0) {
                weakself.NOSHUJU = @"YES";
            }else weakself.NOSHUJU = @"NO";
            self.dataArray = temp;
            [NSUSER_Defaults setObject:dic forKey:ME_COACHE_GROUP];
            [NSUSER_Defaults synchronize];
            
            [_fullTableV reloadData];
        }
        [weakself.header endRefreshing];
    }];
}
#pragma mark - 加载更多活动
-(void)loadMoreGroup{
    
    //构造请求参数
    if (_btnFlag != 0) {
        [self.footer endRefreshing];
        return;
    }
    if (self.dataArray.count == 0 || self.dataArray.count%10!=0||self.dataArray.count<self.page*10) {
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.footer endRefreshing];
        return;
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    if (self.userID.length>0) {
        [dictionary setObject:self.userID forKey:@"seeuserid"];
    }else [dictionary setObject:[NSUSER_Defaults objectForKey:ZDS_USERID] forKey:@"seeuserid"];
    
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.page+1] forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_GROUP parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            weakself.page++;
            // 我创建的团组(上拉更多临时存放)
            NSMutableArray *temp = [NSMutableArray array];
            // 我加入的团组(上拉更多临时存放)
            //            NSMutableArray *tempJoin = [NSMutableArray array];
            
            for (NSDictionary *curGame in dic[@"gamelist"]) {
                HomeGroupModel *model = [HomeGroupModel modelWithDic:curGame];
                weakself.lastId = model.gameid;
                
                // 如果是我创建的团组  加入到我创建的团组数据源中
                if ([model.partype isEqualToString:@"0"] || [model.partype isEqualToString:@"1"]) {
                    
                    [_meGroupDataArray addObject:model];
                } else if ([model.partype isEqualToString:@"2"]) {
                    
                    [_joinGroupDataArray addObject:model];
                }
                
                
                [temp addObject:model];
            }
            [self.dataArray addObjectsFromArray:temp];
            [_fullTableV reloadData];
            [self.timeCollection reloadData];
        }
        [weakself.footer endRefreshing];
    }];
}

#pragma mark - 加载积分
-(void)loadJiFen{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (self.userID.length>0) {
        [dictionary setObject:self.userID forKey:@"seeuserid"];
    }else [dictionary setObject:[NSUSER_Defaults objectForKey:ZDS_USERID] forKey:@"seeuserid"];
    
    //发送请求即将开团
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_JIFEN parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakself.totalscore = dic[@"totalscore"];
            [_fullTableV reloadData];
        }
    }];
}

#pragma mark - 滑动手势响应
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        if (_btnFlag == 0) {
            [self midHBtnClick:nil];
        }
    }
    
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        if (_btnFlag == 1) {
            [self leftHBtnClick:nil];
        }
    }
}

#pragma mark - 打招呼
- (void)goodButton:(UIButton *)goodBtn
{
    if (!self.progressOverlayView.hidden) {
        NSLog(@"冷却中");
        return;
    }
    NSLog(@"打招呼");
    self.progressOverlayView.hidden = NO;
    self.progressOverlayView.progress = 0;
    
    [self createTimer];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.userID forKey:@"rcvuserid"];//被赞人的用户ID当点赞类型为人时必输
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_SAYHELLO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakself showAlertMsg:@"成功挑斗" yOffset:0];
        }else{
            weakself.progressOverlayView.progress = 1;
        }
    }];
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 收到新朋友
-(void)receiveNewFriendsMessage
{
    //如果有电话号码的话
    self.dianPeopleImageView.hidden = YES;
    NSString *myString = [NSUSER_Defaults objectForKey:@"newFriendPhones"];
    if(myString.length!=0 && [myString isKindOfClass:[NSString class]])
    {
        self.dianPeopleImageView.hidden = NO;
        self.tabBarItem.badgeValue = @"";
    }
    NSString *myString2 = [NSUSER_Defaults objectForKey:@"newFriendSina"];
    if(myString2.length!=0 && [myString2 isKindOfClass:[NSString class]])
    {
        self.dianPeopleImageView.hidden = NO;
        self.tabBarItem.badgeValue = @"";
    }
}


#pragma mark - 请求数据
-(void)reloadMyInformationView:(NSString*)user_id seeuserid:(NSString*)seeuser_id andUrl:(NSString*)URL_String{
    
    
    /**
     请求参数
     */
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (self.otherOrMe == 0) {
        self.userID = [NSUSER_Defaults objectForKey:ZDS_USERID];
    }
    [dictionary setObject:self.userID forKey:@"seeuserid"];
    NSLog(@"——————————————%@",dictionary);
    __weak typeof(self)weakself = self;
    //*****************当自己进入此页面时调用********************//
    [WWRequestOperationEngine operationManagerRequest_Post:URL_String parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (!dic[ERRCODE]) {
            if (weakself.otherOrMe == 0) {
                [NSUSER_Defaults setObject:dic forKey:ME_COACHE_MESSAGE];
                [NSUSER_Defaults setObject:dic[@"username"] forKey:ZDS_USERNAME];
                [NSUSER_Defaults synchronize];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.nameLabel.text = [dic objectForKey:@"username"];
                weakself.titleLabel.text = dic[@"username"];
                //关注状态
                weakself.flwstatus = dic[@"flwstatus"];
                if ([weakself.flwstatus isEqualToString:@"0"]) {
                    [weakself.focusBtn setBackgroundImage:[UIImage imageNamed:@"me_yiguanzhu"] forState:UIControlStateNormal];
                }else{
                    [weakself.focusBtn setBackgroundImage:[UIImage imageNamed:@"me_guanzhu"] forState:UIControlStateNormal];
                }
                CGFloat waittime = [dic[@"waittime"] floatValue];
                waittime++;
                weakself.progressOverlayView.progress = (120-waittime)/120.0;
                weakself.progressOverlayView.hidden = NO;
                [weakself createTimer];
                NSString *country = dic[@"country"];
                NSString *province = dic[@"province"];
                NSString *city = dic[@"city"];
                weakself.areaTitle = country.length==0?@"":province.length==0?country:[NSString stringWithFormat:@"%@ %@",province,city];
                weakself.areaLabel.text = country.length==0?@"":province.length==0?country:[NSString stringWithFormat:@"%@ %@",province,city];
                weakself.praiseLabel.text = dic[@"popularity"];
                weakself.contentLabel.text = [dic objectForKey:@"usersign"];
                weakself.headerImageURLStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"imageurl"]];
                weakself.declareLabel.text = dic[@"usersign"];
                NSString *birth = dic[@"birthday"];
                if (birth.length>9) {
                    int month = [[birth substringWithRange:NSMakeRange(5, 2)] intValue];
                    int day = [[birth substringWithRange:NSMakeRange(8, 2)] intValue];
                    NSString *star = [WWTolls getAstroWithMonth:month day:day];
                    weakself.starLabel.text = [NSString stringWithFormat:@"%@",star];
                }else{
                    weakself.starLabel.text = @"";
                }
                
                //性别
                if ([dic[@"usersex"] isEqualToString:@"1"]) {//男
                    weakself.sexImage.image = [UIImage imageNamed:@"nan-26"];
                    
                    weakself.headerBGView.image = [UIImage imageNamed:@"grzy-man-750-600.png"];
                }else{//女
                    weakself.sexImage.image = [UIImage imageNamed:@"nv-26"];
                    weakself.headerBGView.image = [UIImage imageNamed:@"grzy-woman-750-600.jpg"];
                }
                NSURL *imageUrl = [NSURL URLWithImageString:weakself.headerImageURLStr Size:98];
                [weakself.headImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
                //                weakself.usercodeLbl.text = [NSString stringWithFormat:@"ID: %@",dic[@"usercode"]];
                weakself.goodLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"praiseCount"]];
                
                // 昵称
                weakself.usercodeLbl.text = [NSString stringWithFormat:@"%@",dic[@"username"]];
                
                [weakself.usercodeLbl sizeToFit];
                
                weakself.usercodeLbl.width = [WWTolls WidthForString:dic[@"username"] fontSize:18] + 5;
                
                
                //
                //                weakself.sexImage.center = CGPointMake(self.usercodeLbl.maxX, self.usercodeLbl.y);
                
                
                
                // 体重
                NSString *weightStr = [NSString stringWithFormat:@"%@kg", dic[@"userweight"]];
                weakself.userweightView.infoLabel.text = weightStr;
                
                
                // 动态
                NSString *dyncountStr = [NSString stringWithFormat:@"%@", dic[@"dyncount"]];
                weakself.dyncountView.infoLabel.text = dyncountStr;
                
                
                // 关注
                NSString *flwcountStr = [NSString stringWithFormat:@"%@", dic[@"flwcount"]];
                weakself.flwcountView.infoLabel.text = flwcountStr;
                
                
                // 粉丝
                NSString *fanscountStr = [NSString stringWithFormat:@"%@", dic[@"fanscount"]];
                weakself.fanscountView.infoLabel.text = fanscountStr;
                
                [_timeCollection reloadData];
                
                [_fullTableV reloadData];
            });
            
            [weakself removeWaitView];
            //************保存用户数据**************//
            if(dic) [WWTolls setLocalPlistInfo:(NSMutableDictionary*)dic Key:MYINFORMATIN];
            
        }
    }];
    
}

#pragma mark 通知
-(void)apnsNotification
{
    self.dianInformationImageView.hidden = NO;
    [[XTabBar shareXTabBar] imageState];
}

-(void)apnsNotificationFriend
{
    self.dianPeopleImageView.hidden = NO;
    [[XTabBar shareXTabBar] friendDian];
    
}


//copy end

//两组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//分组设置高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    第一组
    if (indexPath.section == 0)
    {
        //        他人视角
        if (self.otherOrMe == 1)
        {
            if ([self.userID isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
                return 300;
            }
            return 300; // 自己看自己
        }
        else
        {
            return 300;
        }
        
    }
    //    第二组
    else
    {
        //        后面根据后台数据判断是活动cell还是成就cell
        //       活动
        if (_btnFlag == 0)
        {
            if (self.dataArray.count == 0) {
                return 150;
            }
            
            if (_otherOrMe == 0) { // 自己的视角
                
                // 只有创建的团组
                if (_meGroupDataArray.count != 0 && +_joinGroupDataArray.count == 0) {
                    
                    return (_meGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30) / 2 + 10) + 44;
                }
                
                // 只有我加入的团组
                if (_joinGroupDataArray.count != 0 && +_meGroupDataArray.count == 0) {
                    
                    return (_joinGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30) / 2 + 10) + 44;
                } else {
                    
                    return (_meGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30) / 2 + 10) + (_joinGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30) / 2 + 10)  + 88;
                }
                
                
            } else { // 他人视角
                
                return (_dataArray.count + 1) / 2 *((SCREEN_WIDTH-30)/2+10)+10 + 44;
                
            }
            
            //FIXME: 这里还要修复高度(动态计算)
            //            return (self.dataArray.count+1)*((SCREEN_WIDTH-30)/2+54)+150;
            
        }
        //        成就
        else
        {
            return 300 +BLANK_HEIGHT*2;
            
            //            return SCREEN_HEIGHT - 300 - 44;
        }
    }
    
}

//分组设置cell数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    第一组，展示基本信息的cell
    if (indexPath.section == 0)
    {
        static NSString *firCellID = @"FIRCELLID";
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firCellID];
        //        if (nil == cell)
        //        {
        //
        //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firCellID];
        //
        //        }
        cell.backgroundColor = [UIColor clearColor];
        
        //       容器视图
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, BLANK_HEIGHT, SCREEN_WIDTH, 300)];
        if (self.otherOrMe == 1)
        {
            backView.frame =CGRectMake(0, BLANK_HEIGHT, SCREEN_WIDTH, 300);
        }else{
            cell.contentView.height = 300;
            cell.contentView.width = SCREEN_WIDTH;
        }
        // 个人信息地板灰色图片
//        UIImage *bkimage = [UIImage imageNamed:@"grzy-woman-750-600.jpg"];
//        UIImageView *bkview = [[UIImageView alloc] init];

        self.headerBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
        self.mengcengView.frame = self.headerBGView.bounds;
        
        self.mengcengView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
        [self.headerBGView addSubview:self.mengcengView];
        
        //        bkview.frame = cell.contentView.bounds;
        [backView addSubview:self.headerBGView];
        [cell.contentView addSubview:backView];
        
        
        
        if (self.nameLabel.text.length>0) {
            //            填充cell
            
            //            头像
            self.headImageView.frame = CGRectMake(0, 75, 64, 64);
            self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
            self.headImageView.layer.cornerRadius = self.headImageView.width * 0.5;
            self.headImageView.clipsToBounds = YES;
            self.headImageView.userInteractionEnabled = YES;
            //            self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
            //            self.headImageView.layer.borderWidth = 3;
            self.headImageView.center = CGPointMake(backView.center.x, 75 + 30);
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
            [tapRecognizer addTarget:self action:@selector(big)];
            [self.headImageView addGestureRecognizer:tapRecognizer];
            
            [backView addSubview:self.headImageView];
            
            
            
            // *******************编号文字变成昵称即可******************
            //编号
            //            self.usercodeLbl.frame = CGRectMake(0, 0, 100, [WWTolls heightForString:@"昵称" fontSize:18]);
            self.usercodeLbl.height = [WWTolls heightForString:@"昵称" fontSize:18];
            self.usercodeLbl.textColor = [UIColor whiteColor];
            self.usercodeLbl.textAlignment = NSTextAlignmentCenter;
            self.usercodeLbl.font = [UIFont systemFontOfSize:18];
            self.usercodeLbl.numberOfLines = 1;
            [self.areaLabel sizeToFit];
            self.usercodeLbl.center = CGPointMake(backView.center.x,self.headImageView.maxY + 15);
            [backView addSubview:self.usercodeLbl];
            
            
            //        区域label，中
            self.areaLabel.frame = CGRectMake(0, 0, 80, 20);
            self.areaLabel.textColor = [WWTolls colorWithHexString:@"#ffffff" AndAlpha:0.7];
            self.areaLabel.textAlignment = NSTextAlignmentCenter;
            self.areaLabel.font = [UIFont systemFontOfSize:13];
            self.areaLabel.numberOfLines = 1;
            self.areaLabel.text = self.areaTitle;
            [self.areaLabel sizeToFit];
            self.areaLabel.center = CGPointMake(backView.center.x,self.usercodeLbl.maxY + 10);
            [backView addSubview:self.areaLabel];
            
            
            //        星座label，左
            self.starLabel.frame = CGRectMake(self.areaLabel.frame.origin.x -BLANK_WIDTH -35, 100, 40, 12);
            self.starLabel.textColor = [UIColor whiteColor];
            self.starLabel.textAlignment = NSTextAlignmentCenter;
            self.starLabel.font = [UIFont systemFontOfSize:12];
            self.starLabel.numberOfLines = 0;
            // *******************不要星座了******************
            //            [backView addSubview:self.starLabel];
            
            if (self.starLabel.text.length<1) {
                self.starLabel.left = self.areaLabel.left;
            }
            
            //        性别imgview，最左
            self.sexImage.frame = CGRectMake(self.usercodeLbl.maxX + 5, self.usercodeLbl.y + 5, 12, 12);
            [backView addSubview:_sexImage];
            
            
            //        眼睛imgview，右
            UIImageView *heartIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.areaLabel.frame.origin.x +self.areaLabel.frame.size.width +BLANK_WIDTH, 100, 12, 12)];
            [heartIV setImage:[UIImage imageNamed:@"renqi_22_22.png"]];
            //            [backView addSubview:heartIV];
            
            //        赞label,用于显示而不是点，→_→
            self.praiseLabel.frame = CGRectMake(heartIV.frame.origin.x +heartIV.frame.size.width +2, 100, 60, 12);
            self.praiseLabel.textColor = [UIColor whiteColor];
            self.praiseLabel.textAlignment = NSTextAlignmentLeft;
            self.praiseLabel.font = [UIFont systemFontOfSize:14];
            self.praiseLabel.numberOfLines = 1;
            //            [backView addSubview:self.praiseLabel];
            
            //签名label，下
            self.declareLabel.frame = CGRectMake(10, self.starLabel.frame.origin.y +self.starLabel.frame.size.height +BLANK_HEIGHT + 2, SCREEN_WIDTH - 20, 30);
            //declareLabel.text = @"你就是你";
            self.declareLabel.textColor = [UIColor whiteColor];
            self.declareLabel.textAlignment = NSTextAlignmentCenter;
            self.declareLabel.font = [UIFont systemFontOfSize:11];
            self.declareLabel.numberOfLines = 0;
            if (self.declareLabel.text.length<27) {
                self.declareLabel.height = 16;
            }
            // *******************不要签名了******************
            //            [backView addSubview:self.declareLabel];
            
            if (_otherOrMe == 0) { // 自己的视角显示四个菜单
                
                // *******************添加菜单(体重)******************
                
                self.userweightView.menuLabel.text = @"体重";
                self.userweightView.frame = CGRectMake(30, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 30 * 2) / 4, 40);
                [backView addSubview:self.userweightView];
                
                
                
                
                // *******************添加菜单(动态)******************
                
                self.dyncountView.menuLabel.text = @"动态";
                self.dyncountView.frame = CGRectMake(self.userweightView.maxX, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 30 * 2) / 4, 40);
                [backView addSubview:self.dyncountView];
                
                
                // *******************添加菜单(关注)******************
                
                self.flwcountView.menuLabel.text = @"关注";
                self.flwcountView.frame = CGRectMake(self.dyncountView.maxX, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 30 * 2) / 4, 40);
                [backView addSubview:self.flwcountView];
                
                // *******************添加菜单(粉丝)******************
                self.fanscountView.menuLabel.text = @"粉丝";
                self.fanscountView.frame = CGRectMake(self.flwcountView.maxX, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 30 * 2) / 4, 40);
                [backView addSubview:self.fanscountView];
                
                
                // 圆形创建按钮
                
                
                
//                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//                self.creatBtn = btn;
//                
//                if (self.creatBtn.superview) {
//                    [self.creatBtn removeFromSuperview];
//                }
                
                [self.creatBtn addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
                
                self.creatBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, 300 - 30, 60, 60);
                
                self.creatBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
                
                [self.creatBtn setBackgroundImage:[UIImage imageNamed:@"cj-118"] forState:UIControlStateNormal];
                
                [_fullTableV addSubview:self.creatBtn];
                
                
                
            } else { // 他人视角显示三个
                
                // *******************添加菜单(动态)******************
                self.dyncountView.menuLabel.text = @"动态";
                self.dyncountView.frame = CGRectMake(50, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 50 * 2) / 3, 40);
                [backView addSubview:self.dyncountView];
                
                
                
                // *******************添加菜单(关注)******************
                self.flwcountView.menuLabel.text = @"关注";
                self.flwcountView.frame = CGRectMake(self.dyncountView.maxX, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 50 * 2) / 3, 40);
                [backView addSubview:self.flwcountView];
                
                
                
                // *******************添加菜单(粉丝)******************
                self.fanscountView.menuLabel.text = @"粉丝";
                self.fanscountView.frame = CGRectMake(self.flwcountView.maxX, self.areaLabel.maxY + 40, (SCREEN_WIDTH - 50 * 2) / 3, 40);
                [backView addSubview:self.fanscountView];
                
                
                
            }
            
            
#pragma mark - 他人视角的关注和私信按钮
            //他人视角
            if (self.otherOrMe == 1)
            {
                backView.height = 300;
                //最下
                CGFloat xx = (SCREEN_WIDTH - 2*85 -1*BLANK_WIDTH)/2;
                
                //私信按钮
                if (self.declareLabel.text.length<1) {
                    self.declareLabel.height = 15;
                }
                
                UIButton *pmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                //                [pmBtn setFrame:CGRectMake(xx, self.declareLabel.frame.origin.y +self.declareLabel.frame.size.height +BLANK_HEIGHT+5, 85, 33)];
                
                [pmBtn setFrame:CGRectMake(70, _headImageView.centerY - 10, 24, 24)];
                
                
                [pmBtn setBackgroundImage:[UIImage imageNamed:@"sx-48"] forState:UIControlStateNormal];
                [pmBtn addTarget:self action:@selector(pmBtnClick:) forControlEvents:UIControlEventTouchUpInside
                 ];
                [backView addSubview:pmBtn];
                
                //        关注按钮
                UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.focusBtn = focusBtn;
                
                // 暂时用不到圆角
                
                //                focusBtn.clipsToBounds = YES;
                //                focusBtn.layer.cornerRadius = 20;
                
                //                [focusBtn setFrame:CGRectMake(xx +85+BLANK_WIDTH+10, self.declareLabel.frame.origin.y +self.declareLabel.frame.size.height +BLANK_HEIGHT+5, 85, 33)];
                
                [focusBtn setFrame:CGRectMake(SCREEN_WIDTH - 70 - 24, _headImageView.centerY - 10, 24, 24)];
                
                
                if ([self.flwstatus isEqualToString:@"0"]) { // 有关注人数的话显示已关注按钮
                    [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"ygz-48"] forState:UIControlStateNormal];
                }else{ // 否则显示关注按钮
                    [self.focusBtn setBackgroundImage:[UIImage imageNamed:@"jgz-48"] forState:UIControlStateNormal];
                };
                [focusBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside
                 ];
                [backView addSubview:focusBtn];
                
                if ([self.userID isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
                    self.focusBtn.hidden = YES;
                    pmBtn.hidden = YES;
                }
                
            }
            
            //         他人
            if (self.otherOrMe == 1)
            {
                //                [backView addSubview:self.goodButton];
                if ([self.userID isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
                    self.goodButton.hidden = YES;
                }
            }
            else
            {
                //        修改个人信息按钮，此位置在他人视角是点赞按钮
                UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [modifyBtn setFrame:CGRectMake(SCREEN_WIDTH -29, 15, 14, 14)];
                [modifyBtn setBackgroundImage:[UIImage imageNamed:@"me_editor_28_28"] forState:UIControlStateNormal];
                
                
                // *******************不要修改资料的铅笔按钮了**************
                
                //                [backView addSubview:modifyBtn];
                //            modifyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                //        [modifyBtn setBackgroundColor:[UIColor lightGrayColor]];
                UIButton *bigBtn = [[UIButton alloc] init];
                bigBtn.frame = CGRectMake(SCREEN_WIDTH -50, 10, 44, 44);
                
                [backView addSubview:bigBtn];
                [bigBtn addTarget:self action:@selector(modifyBtnClick) forControlEvents:UIControlEventTouchDown];
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return cell;
    }
    //    *****************第二组，展示列表************************
    else
    {
        
        
        //        根据数据内容决定显示内容，活动或者成就
        //        活动
        if (_btnFlag == 0)
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            if (self.dataArray.count == 0&&[self.NOSHUJU isEqualToString:@"YES"]) {
                //                cell.contentView.backgroundColor = ZDS_BACK_COLOR;
                cell.contentView.backgroundColor = RGBCOLOR(239, 239, 239);
                if (self.otherOrMe == 0) {
                    
                    // 顶部的提示信息
                    UILabel *infoLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, [WWTolls heightForString:@"提示信息" fontSize:13])];
                    
                    infoLable.text = @"你没有创建或者加入任何团组";
                    infoLable.textColor = [WWTolls colorWithHexString:@"#A7A7A7"];
                    
                    infoLable.textAlignment = NSTextAlignmentCenter;
                    
                    UIButton *create = [[UIButton alloc] init];
                    [create addTarget:self action:@selector(joinGroup:) forControlEvents:UIControlEventTouchUpInside];
                    CGFloat w = (SCREEN_WIDTH - 44 * 2 - 15 )/2;
                    create.frame = CGRectMake(44, infoLable.maxY + 30, w, 44);
                    //                    [create setBackgroundImage:[UIImage imageNamed:@"build_276_276"] forState:UIControlStateNormal];
                    [create setTitle:@"加入团组" forState:UIControlStateNormal];
                    
                    [create setTitleColor:[WWTolls colorWithHexString:@"ff723e"] forState:UIControlStateNormal];
                    
                    create.clipsToBounds = YES;
                    create.layer.cornerRadius = 22;
                    create.layer.borderColor = [WWTolls colorWithHexString:@"ff723e"].CGColor;
                    create.layer.borderWidth = 1;
                    
                    
                    
                    // 右边的创建团组按钮
                    UIButton *join= [[UIButton alloc] init];
                    join.frame = CGRectMake(create.right+15, infoLable.maxY + 30, w, 44);
                    //                    [join setBackgroundImage:[UIImage imageNamed:@"join_276_276"] forState:UIControlStateNormal];
                    
                    
                    [join setTitle:@"创建团组" forState:UIControlStateNormal];
                    
                    [join setTitleColor:[WWTolls colorWithHexString:@"ff723e"] forState:UIControlStateNormal];
                    
                    join.clipsToBounds = YES;
                    join.layer.cornerRadius = 22;
                    join.layer.borderColor = [WWTolls colorWithHexString:@"ff723e"].CGColor;
                    join.layer.borderWidth = 1;
                    
                    [join addTarget:self action:@selector(createGroup:) forControlEvents:UIControlEventTouchUpInside];
                    
                    //                    NSLog(@"%@", NSStringFromCGRect(infoLable.frame));
                    
                    [cell.contentView addSubview:infoLable];
                    [cell.contentView addSubview:create];
                    [cell.contentView addSubview:join];
                    
                    return cell;
                    
                }else{ // 他人视角
                    
                    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, SCREEN_WIDTH-50, 50)];
                    lbl.textAlignment = NSTextAlignmentCenter;
                    lbl.font = MyFont(14);
                    lbl.textColor = [WWTolls colorWithHexString:@"#ff723e"];
                    lbl.text = @"TA还没有留下自己的足迹哦╮(╯▽╰)╭";
                    [cell.contentView addSubview:lbl];
                    
                    return cell;
                }
                
                return cell;
            }
            //布局
            //            XLPlainFlowLayout *flowLayout = [XLPlainFlowLayout new];
            //            flowLayout.itemSize = CGSizeMake(150, 200);
            //            flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, -10, 10);
            //            flowLayout.naviHeight = 0;
            
            
            if (self.timeCollection.superview) {
                [self.timeCollection removeFromSuperview];
            }
            [self.timeCollection reloadData];
            cell.contentView.backgroundColor = RGBCOLOR(239, 239, 239);
            
            [cell.contentView addSubview:self.timeCollection];
            return cell;
            
        }
        //        成就
        else
        {
            static NSString *thiCellID = @"THICELLID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thiCellID];
            if (nil == cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:thiCellID];
            }
            cell.backgroundColor = RGBCOLOR(239, 239, 239);
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(7, 7, SCREEN_WIDTH -2*7, 172)];
            backView.backgroundColor = [UIColor clearColor];
            backView.layer.cornerRadius = 10;
            backView.clipsToBounds = YES;
            
            UIImageView *scoreIV = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH -2*7-100)/2, 10, 100, 124)];
            scoreIV.image = [UIImage imageNamed:@"me_score-200-248"];
            scoreIV.userInteractionEnabled = YES;
            [backView addSubview:scoreIV];
            
            //分数lbl
            UILabel *scorelbl = [[UILabel alloc] init];
            scorelbl.bounds = CGRectMake(0, 0, 70, 22);
            scorelbl.textAlignment = NSTextAlignmentCenter;
            scorelbl.center = scoreIV.center;
            scorelbl.top -= 10;
            scorelbl.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            //
            if (self.totalscore.length>0) {
                scorelbl.text = self.totalscore;
            }else scorelbl.text = @"0";
            scorelbl.textColor = RGBCOLOR(179, 225, 88);
            [backView addSubview:scorelbl];
            
            if (self.otherOrMe == 0) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-20, 15)];
                label.text = @"走，用斗币消费去 ";
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [WWTolls colorWithHexString:@"6b6b6b"];
                label.textAlignment = NSTextAlignmentCenter;
                label.center = CGPointMake(label.center.x, backView.frame.size.height -BLANK_HEIGHT -label.frame.size.height);
                [backView addSubview:label];
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
                image.frame = CGRectMake(0, 0, 13, 13);
                image.center = label.center;
                image.left += 55;
                [backView addSubview:image];
            }
            
            
            backView.layer.cornerRadius = 5;
            backView.clipsToBounds = YES;
            UITapGestureRecognizer *scoreTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scoreTap:)];
            [backView addGestureRecognizer:scoreTapGR];
            
            [cell.contentView addSubview:backView];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            
        }
    }
}

#pragma mark - 跳转到创建游戏界面
-(void)createGame{
    [MobClick event:@"HomeCreate"];
    
    // 设置转场的代理
    self.navigationController.delegate = self;
    
    self.rightButton.userInteractionEnabled = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATECHK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if (!dic[ERRCODE]) {
            CreateGroupTwoNewViewController * create = [[CreateGroupTwoNewViewController alloc]init];
            create.isPassWordGrouper = [dic[@"ispasswd"] isEqualToString:@"0"];
            create.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:create animated:YES];
        }
        weakSelf.rightButton.userInteractionEnabled = YES;
    }];
}

#pragma mark - 体重/关注/粉丝/动态跳转
- (void)tagBtnClick:(UIButton *)btn {
    
    if (btn.tag == 1000) { // 跳到体重
        
        NSLog(@"跳转到体重");
        
        SnapViewController *uc= [[SnapViewController alloc]init];
        uc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:uc animated:YES];
        
    } else if (btn.tag == 1001) {// 跳到动态
        NSLog(@"跳转到动态");
        MyActivesViewController *ac = [[MyActivesViewController alloc] init];
        ac.seeUserID = self.userID;
        [self.navigationController pushViewController:ac animated:YES];
        
    } else if (btn.tag == 1002) { // 跳到关注
        NSLog(@"跳转到关注");
        
        UserFollowListViewController *flowVc = [[UserFollowListViewController alloc] init];
        flowVc.seeuserId = self.userID;
        [self.navigationController pushViewController:flowVc animated:YES];
        
    } else if (btn.tag == 1003) { // 跳到粉丝
        NSLog(@"跳转到粉丝");
        
        UserFunsListViewController *funsVc = [[UserFunsListViewController alloc] init];
        funsVc.seeuserId = self.userID;
        [self.navigationController pushViewController:funsVc animated:YES];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        //        return 44.0;
        return 0;
        
    }
}

// 头部view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        //        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        //        return view;
        return nil;
    }
    else
    {
        
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        //        填充headerview
        
        UIColor *normalColor = RGBCOLOR(107, 107, 107);
        UIColor *selectedColor = RGBCOLOR(87, 95, 214);
        UIFont *normalFont = MyFont(14);
        //         活动按钮
        UIButton *leftHBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftHBtn.frame = CGRectMake(0, 5, SCREEN_WIDTH/3, 30);
        [leftHBtn setTitle:@"足迹" forState:UIControlStateNormal];
        leftHBtn.titleLabel.font = normalFont;
        
        //活动底色
        UILabel *leftLbl = [[UILabel alloc] init];
        leftLbl.bounds = CGRectMake(0, 0, 50, 3);
        leftLbl.backgroundColor = selectedColor;
        leftLbl.center = CGPointMake(leftHBtn.center.x+1, 39);
        [view addSubview:leftLbl];
        
        //        选中活动
        if (0 == _btnFlag)
        {
            [leftHBtn setTitleColor:selectedColor forState:UIControlStateNormal];
            leftLbl.hidden = NO;
        }
        else
        {
            leftLbl.hidden = YES;
            [leftHBtn setTitleColor:normalColor forState:UIControlStateNormal];
        }
        [leftHBtn addTarget:self action:@selector(leftHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:leftHBtn];
        
        //        成就按钮
        UIButton *midHBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        midHBtn.frame = CGRectMake(SCREEN_WIDTH/3, 5, SCREEN_WIDTH/3, 30);
        midHBtn.titleLabel.font = normalFont;
        [midHBtn setTitle:@"成就" forState:UIControlStateNormal];
        //成就底色
        UILabel *midLbl = [[UILabel alloc] init];
        midLbl.bounds = CGRectMake(0, 0, 50, 3);
        midLbl.backgroundColor = selectedColor;
        midLbl.center = CGPointMake(midHBtn.center.x+1, 39);
        [view addSubview:midLbl];
        
        if (1 == _btnFlag)
        {
            midLbl.hidden = NO;
            [midHBtn setTitleColor:selectedColor forState:UIControlStateNormal];
        }
        else
        {
            midLbl.hidden = YES;
            [midHBtn setTitleColor:normalColor forState:UIControlStateNormal];
        }
        [midHBtn addTarget:self action:@selector(midHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:midHBtn];
        
        
        //       朋友按钮
        UIButton *rightHBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightHBtn.frame = CGRectMake(SCREEN_WIDTH/3*2, 5, SCREEN_WIDTH/3, 30);
        rightHBtn.titleLabel.font = normalFont;
        [rightHBtn setTitle:@"朋友" forState:UIControlStateNormal];
        
        [rightHBtn setTitleColor:normalColor forState:UIControlStateNormal];
        [rightHBtn addTarget:self action:@selector(rightHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rightHBtn];
        
        self.dianPeopleImageView = [[UIButton alloc] init];
        self.dianPeopleImageView.userInteractionEnabled = NO;
        self.dianPeopleImageView.clipsToBounds = YES;
        self.dianPeopleImageView.layer.cornerRadius = 5;
        self.dianPeopleImageView.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
        self.dianPeopleImageView.frame = CGRectMake(SCREEN_WIDTH-36, 7, 10, 10);
        self.dianPeopleImageView.hidden = YES;
        [view addSubview:self.dianPeopleImageView];
        if (self.otherOrMe == 0) {
            //如果有电话号码的话
            NSString *myString = [NSUSER_Defaults objectForKey:@"newFriendPhones"];
            if(myString.length!=0 && [myString isKindOfClass:[NSString class]])
            {
                self.dianPeopleImageView.hidden = NO;
            }
            NSString *myString2 = [NSUSER_Defaults objectForKey:@"newFriendSina"];
            if(myString2.length!=0 && [myString2 isKindOfClass:[NSString class]])
            {
                self.dianPeopleImageView.hidden = NO;
            }
        }
        
        if (self.otherOrMe == 1)
        {
            self.dianPeopleImageView.hidden = YES;
            self.dianPeopleImageView = [[UIImageView alloc] init];
            rightHBtn.hidden = YES;
            leftHBtn.width = SCREEN_WIDTH/2;
            leftLbl.center = CGPointMake(leftHBtn.center.x+1, leftLbl.center.y) ;
            midHBtn.left = SCREEN_WIDTH/2;
            midHBtn.width = SCREEN_WIDTH/2;
            midLbl.center = CGPointMake(midHBtn.center.x+1, midLbl.center.y) ;
            //            leftHBtn.frame = CGRectMake(0, 10, SCREEN_WIDTH/2, 30);
            //            midHBtn.frame = CGRectMake(SCREEN_WIDTH/2, 10, SCREEN_WIDTH/2, 30);
        }
        //        return view;
        return nil;
        
    }
    return nil;
}


-(void)big{
#pragma mark - 点击大图
    
    //    MJPhoto *photo = [[MJPhoto alloc] init];
    //    photo.url =self.headImageView.sd_imageURL; // 图片路径
    //    photo.srcImageView = self.headImageView; // 来源于哪个UIImageView
    //    NSArray *photos = [NSArray arrayWithObject:photo];
    //    // 2.显示相册
    //    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    //    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    //    browser.photos = photos; // 设置所有的图片
    //    [browser show];
    
    
    MyLibraryViewController2 *libratyVc = [[MyLibraryViewController2 alloc] init];
    
    libratyVc.seeuserid = self.userID;
    
    libratyVc.headImage = self.headImageView.image;
    
    [self.navigationController pushViewController:libratyVc animated:YES];
}


#pragma mark - 去往兑奖页面
-(void)scoreTap:(UITapGestureRecognizer *)scoreTapGR
{
    NSLog(@"兑奖页面");
    if (self.otherOrMe == 0) {
        StoreViewController *store = [[StoreViewController alloc]initWithNibName:@"StoreViewController" bundle:nil];
        store.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:store animated:YES];
    }
}

-(void)firTapGR:(UITapGestureRecognizer *)firTap
{
    GroupViewController *group = [[GroupViewController alloc] init];
    group.groupId = ((YCGroupCollectionViewCell*)firTap.view).model.gameid;
    group.clickevent = 8;
    group.joinClickevent = @"8";
    group.ispwd = ((YCGroupCollectionViewCell*)firTap.view).model.ispwd;
    group.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:group animated:YES];
}

-(void)secTapGR:(UITapGestureRecognizer *)secTap
{
    GroupViewController *group = [[GroupViewController alloc] init];
    group.groupId = ((YCGroupCollectionViewCell*)secTap.view).model.gameid;
    group.clickevent = 8;
    group.joinClickevent = @"8";
    group.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:group animated:YES];
}

-(void)focusBtnClick:(UIButton *)focusBtn
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.userID forKey:@"rcvuserid"];
    [dictionary setObject:[self.flwstatus isEqualToString:@"0"]?@"1":@"0" forKey:@"flwstatus"];
    NSLog(@"——————————————%@",dictionary);
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_INERACTUPFLWSTS parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if ([weakSelf.flwstatus isEqualToString:@"1"]) {
                [weakSelf.focusBtn setBackgroundImage:[UIImage imageNamed:@"ygz-48"] forState:UIControlStateNormal];
                weakSelf.flwstatus = @"0";//已关注
                [[NSNotificationCenter defaultCenter] postNotificationName:@"meViewFocus" object:[NSDictionary dictionaryWithObjectsAndKeys:self.userID,@"userid",weakSelf.flwstatus,@"flwstatus", nil]];
                [weakSelf showAlertMsg:@"已关注" andFrame:CGRectMake(70,100,200,60)];
            }else{
                [weakSelf.focusBtn setBackgroundImage:[UIImage imageNamed:@"jgz-48"] forState:UIControlStateNormal];
                weakSelf.flwstatus = @"1";//未关注
                [[NSNotificationCenter defaultCenter] postNotificationName:@"meViewFocus" object:[NSDictionary dictionaryWithObjectsAndKeys:self.userID,@"userid",weakSelf.flwstatus,@"flwstatus", nil]];
                [weakSelf showAlertMsg:@"取消关注" andFrame:CGRectMake(70,100,200,60)];
                
            }
        }
    }];
}

#pragma mark - 去往私信
-(void)pmBtnClick:(UIButton *)msgBtn
{
    NSLog(@"私信");
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.userId = self.userID;
    chat.title = self.titleLabel.text;
    chat.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chat animated:YES];
}


-(void)modifyBtnClick
{
    NSLog(@"弹出个人信息修改视图，已有");
    MyLibraryViewController *myLibrary = [[MyLibraryViewController alloc]
                                          initWithNibName:@"MyLibraryViewController" bundle:nil];
    myLibrary.headImage = self.headImageView.image;
    myLibrary.image_URL = self.headerImageURLStr;
    myLibrary.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:myLibrary animated:YES];
}

-(void)inBtnClick:(UIButton *)inBtn
{
    NSLog(@"点击加入团组按钮，弹出团组详情页面，已有，链接");
}



-(void)leftHBtnClick:(UIButton *)leftHBtn
{
    MyActivesViewController *ac = [[MyActivesViewController alloc] init];
    ac.seeUserID = self.userID;
    ac.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ac animated:YES];
    //    NSLog(@"左 活动");
    //    _btnFlag = 0;
    //    [_fullTableV reloadData];
    
}

-(void)midHBtnClick:(UIButton *)midHBtn
{
    NSLog(@"中 成就");
    
    //加载积分数量
    [self loadJiFen];
    _btnFlag = 1;
    [_fullTableV reloadData];
    
}

-(void)rightHBtnClick:(UIButton *)rightHBtn
{
    NSLog(@"右 朋友");
    NSLog(@"此处是弹出朋友页面");
//    MyFriendViewController *friend = [[MyFriendViewController alloc]initWithNibName:@"MyFriendViewController" bundle:nil];
//    friend.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:friend animated:YES];

    NewFViewController *friendVc = [[NewFViewController alloc] init];
    friendVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:friendVc animated:YES];

}

#pragma mark - 去往设置界面
-(void)SetBtnClick:(UIButton *)leftBtn
{
    NSLog(@"设置界面");
    
    SetupGameViewController *game = [[SetupGameViewController alloc]initWithNibName:@"SetupGameViewController" bundle:nil];
    game.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:game animated:YES];
}

#pragma 加入减脂团
- (void)joinGroup:(id)sender {
    [MobClick event:@"MyGroupJoin"];
    [self.tabBarController setSelectedIndex:0];
}
#pragma 创建减脂团
- (void)createGroup:(UIButton*)sender {
    [MobClick event:@"MyGroupCreate"];
    sender.userInteractionEnabled = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATECHK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if (!dic[ERRCODE]) {
            CreateGroupTwoNewViewController * create = [[CreateGroupTwoNewViewController alloc]init];
            create.isPassWordGrouper = [dic[@"ispasswd"] isEqualToString:@"0"];
            create.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:create animated:YES];
        }
        weakSelf.rightButton.userInteractionEnabled = YES;
    }];
    
    
}

#pragma mark - 去往相册页面
-(void)photosBtnClick:(UIButton *)rightBtn
{
    NSLog(@"相册界面");
    
    //    UserAblumViewController *ablum = [[UserAblumViewController alloc] init];
    ZDSPhotosViewController*ablum = [[ZDSPhotosViewController alloc] init];
    ablum.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ablum animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self.footer free];
    [self.header free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 去除headerView贴服
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    if (scrollView == _fullTableV)
    //    {
    //        if ([self.header isRefreshing]) {
    //            CGFloat sectionHeaderHeight = 40;
    //            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
    //                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    //            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
    //                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    //            }
    //        }
    //
    //    }
    
    // 获取当前的y轴偏移量
    CGFloat curOffsetY = scrollView.contentOffset.y;
    
    
    //    NSLog(@"------%f", curOffsetY);
    
    
    if (curOffsetY > 10) {
        self.titleLabel.hidden = NO;
    }
    
    
    if (curOffsetY < 0) {
        
        // 不让刷新控件能看见
        //        self.header.alpha = 0;
    }
    
        if (curOffsetY <= 900 && curOffsetY > 850) {
            
            [self.timeCollection reloadData];
        }
    
    
    if (_otherOrMe == 0) { // 自我视角
        
        if (curOffsetY >= 110) {
            
            self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
            
//            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
            
        } else {
            
            self.titleLabel.textColor = [UIColor clearColor];
            
//            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
            
        }
    } else {
    
        if (curOffsetY >= 110) {
            
            self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
            
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
            
        } else {
            
            self.titleLabel.textColor = [UIColor clearColor];
            
            [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
            
        }
    }
    
    
    
    // 计算下与最开始的偏移量的差距
    CGFloat delta = curOffsetY - _oriOffsetY;
    
    // 获取当前导航条背景图片透明度，当delta=300 - 64的时候，透明图刚好为1.
    CGFloat alpha = delta * 1 / (300 - 64);
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    // 分类：根据颜色生成一张图片
    UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    
    //    UIImage *bgImage = [UIImage imageNamed:@"123"];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
}

#pragma mark - collectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    NSLog(@"%ld--------%ld", (long)indexPath.section, (long)indexPath.row);
    
    HomeGroupModel *model = [[HomeGroupModel alloc] init];
    
    if (_otherOrMe == 0) {
        
        // 既没有自己创建的团组 也没有加入团组
        if (_joinGroupDataArray.count == 0 && _meGroupDataArray.count == 0) {
            
        }
        
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count != 0) {
            
            if (indexPath.section == 0) {
                
                model = _meGroupDataArray[indexPath.row];
                
                
            } else if (indexPath.section == 1) {
                
                model = _joinGroupDataArray[indexPath.row];
            }
            
        }
        
        if (_joinGroupDataArray.count != 0 && _meGroupDataArray.count == 0) {
            model = _joinGroupDataArray[indexPath.row];
        }
        
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count == 0) {
            model = _meGroupDataArray[indexPath.row];
        }
        
    } else { // 他人视角
        
        if (_dataArray.count != 0) {
            model = _dataArray[indexPath.row];
        }
    }
    
    
    
    GroupViewController *gameDetail = [[GroupViewController alloc]init];
    gameDetail.clickevent = 8;
    gameDetail.joinClickevent = @"8";
    gameDetail.groupId = model.gameid;
    if (model.gameid.length == 0) {
        return;
    }
    gameDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gameDetail animated:YES];
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    HomeGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewIdentifier" forIndexPath:indexPath];
    
    YCGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewIdentifier" forIndexPath:indexPath];
    
    
    
    //    NSLog(@"%ld - ---------%ld", (long)indexPath.section, (long)indexPath.row);
    
    
    
    if (_otherOrMe == 0) { // 自己视角
        
        // 1.什么团组都没有
        // 既没有自己创建的团组 也没有加入团组
        if (_joinGroupDataArray.count == 0 && _meGroupDataArray.count == 0) {
            return nil;
        }
        
        
        // 2.既有我创建的团组还有我加入的团组
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count != 0) {
            
            if (indexPath.section == 0) {
                cell.model =  _meGroupDataArray[indexPath.row];
            } else if (indexPath.section == 1) {
                
                cell.model =  _joinGroupDataArray[indexPath.row];
            }
            
        }
        
        
        // 3.只有我加入的团组
        if (_joinGroupDataArray.count != 0 && _meGroupDataArray.count == 0) {
            cell.model = _joinGroupDataArray[indexPath.row];
        }
        
        // 4.只有我创建的团组
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count == 0) {
            cell.model =  _meGroupDataArray[indexPath.row];
        }
        
        return cell;
        
    } else { // 他人视角
        
        if (_dataArray.count != 0) {
            cell.model = _dataArray[indexPath.row];
        }
    }
    
    return cell;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    if (_otherOrMe == 0) {
        
        NSLog(@"我的视角");
        
        // 1.既没有自己创建的团组 也没有加入团组
        if (_joinGroupDataArray.count == 0 && _meGroupDataArray.count == 0) {
            return 0;
        }
        
        // 2.我创建的团组和加入的团组都有
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count != 0) {
            
            if (section == 0) { // 我创建的团组
                return _meGroupDataArray.count;
                
            } else if (section == 1) { // 我加入的团组
                return _joinGroupDataArray.count;
            }
            
        }
        
        // 3.只有我加入的团组,没有我创建的团组
        if (_joinGroupDataArray.count != 0 && _meGroupDataArray.count == 0) {
            return _joinGroupDataArray.count;
        }
        
        // 4.只有我创建的团组没有我加入的团组
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count == 0) {
            return _meGroupDataArray.count;
        }
        
    } else { // 他人视角
        
        NSLog(@"他人的视角");
        
        if (_dataArray.count != 0) {
            return _dataArray.count;
        }
        
        return 0;
    }
    
    return 0;
}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    //FIXME: 这里还要修复高度(动态计算)
    //    collectionView.height = (self.dataArray.count+1)*((SCREEN_WIDTH-30)/2+54)+150;
    
    
    if (_otherOrMe == 0) { // 自己的视角
        
        // 只有创建的团组
        if (_meGroupDataArray.count != 0 && +_joinGroupDataArray.count == 0) {
            
            collectionView.height = (_meGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30)/2+10) + 44;
        }
        
        // 只有我加入的团组
        if (_joinGroupDataArray.count != 0 && +_meGroupDataArray.count == 0) {
            
            collectionView.height = (_joinGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30)/2+10) + 44;
        } else {
            
            collectionView.height = (_meGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30) / 2 + 10) + (_joinGroupDataArray.count + 1) / 2 *((SCREEN_WIDTH-30) / 2 + 10)  + 88;
        }
        
        
    } else { // 他人视角
        
        collectionView.height = (_dataArray.count + 1) / 2 *((SCREEN_WIDTH-30)/2+10) + 44;
        
    }
    
    
    
    
    if (_otherOrMe == 0) {
        
        // 既有创建的还有加入的返回2组
        if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count != 0) {
            return 2;
        }
        
        // 什么都没有返回0
        if (_joinGroupDataArray.count == 0 && _meGroupDataArray.count == 0) {
            return 0;
        }
        
        // 其他返回1
        return 1;
    } else { // 他人视角
        
        // 如果他人有加入的团组返回1组
        if (_dataArray.count != 0) {
            
            return 1;
        }
        
        // 否则返回0组
        return 0;
    }
    
    return 0;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return CGSizeMake((SCREEN_WIDTH-30)/2, (SCREEN_WIDTH-30)/2);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section >= 0) {
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        
        header.x = 15;
        
        if (_otherOrMe == 0) { // 我的视角
            
            if (indexPath.section == 0) { // 第0组
            
                if (_joinGroupDataArray.count != 0 && _meGroupDataArray.count == 0) { // 1.只有我加入的团组
                    header.text = @"我加入的团组";
                } else if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count == 0) { // 2.只有我创建的团组
                
                    header.text = @"我创建的团组";
                } else if (_meGroupDataArray.count != 0 && _joinGroupDataArray.count != 0) {
                
                    header.text = @"我创建的团组";
                }
            } else if (indexPath.section == 1) { // 第1组
            
                header.text = @"我加入的团组";
            }
            
            
        } else { // 他人视角
            
            header.text = @"我加入的团组";
        }
        
        if (_dataArray.count == 0) {
                header.text = @"";
                header.height = 0;
        }
        
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section >= 0) {
        return CGSizeMake(0, 44);
    }
    return CGSizeZero;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

//-(BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [PingTransition new];
        return ping;
    }else{
        return nil;
    }
}

@end
