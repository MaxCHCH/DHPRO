//
//  GroupViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupViewController.h"
//分享相关
#import "InitShareButton.h"
#import "InitShareView.h"
#import "InitShareWeightView.h"
#import "ShareGameSubClassView.h"
#import "NARShareView.h"
#import "InvitationViewController.h"
#import "PlanViewController.h"
#import "GroupHeaderModel.h"
#import "MCFireworksButton.h"
#import "GroupTalkModel.h"
#import "PICircularProgressView.h"
#import "TalkAboutViewController.h"
#import "GroupEditorViewController.h"
#import "GroupTeamViewController.h"
#import "GroupTalkDetailViewController.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "GameRuleViewController.h"
#import "ZDSPublishActivityViewController.h"

#import "ZDSGroupActCell.h"
#import "ZDSGroupBubbleCell.h"
#import "ZDSActDetailViewController.h"
#import "ZDSGroupBubbleModel.h"
#import "MJExtension.h"
#import "DeleteBarModel.h"
#import "SSLImageTool.h"
#import "MoreAlertView.h"
#import "FinishAlertView.h"
#import "MemberLoseWeightViewController.h"
#import "PublicTaskViewController.h"
#import "CommanderMoreAlertView.h"
#import "SendAllMessageViewController.h"
#import "MemberLoseWeightViewController.h"
#import "GroupMessageViewController.h"
#import "TalkBarViewController.h"
#import "RankListViewController.h"
#import "intrestUserModel.h"
#import "SavewegModel.h"
#import "UrgettaskModel.h"
#import "RequestBackModel.h"
#import "UITableViewCell+SSLSelect.h"
#import "DiscoverViewController.h"
#import "BreakUpViewController.h"
#import "GroupVisitorMore28View.h"
#import "GroupCommanderMore28View.h"
#import "GroupMemberMore28View.h"
#import "UpdatePasswordOriginalViewController.h"
#import "InputAlertView.h"
#import "CreateArticleViewController.h"
#import "ArticleTableViewCell.h"
#import "ArticleListViewController.h"
#import "submitTaskViewController.h"
#import "TaskDoneListViewController.h"
#import "taskDetailViewController.h"

#import "DXAlertView.h"

static NSString *UrgeMessage = @"催促消息已经发出，团长很快就会发布任务啦！这段时间可不要懈怠哦~";
static NSString *NoPubTaskMessage = @"团长大人还没有发布任务";
static NSString *ToUrgeMessage = @"这个团长很懒，居然没有留下任务，团员们快去催催他！";

//内容颜色
static NSString *TextColor = @"#999999";

//图片
//冒泡
static NSString *MaoPaoImage = @"maopao-72-60.png";
//说点啥
static NSString *ShuoDianShaImage = @"shuodiansha-72-60.png";
//约活动
static NSString *YueHuoDongImage = @"yuehuodong-72-60.png";
//上传体重
static NSString *UploadWeightImage = @"sctz-80-612.png";

@interface GroupViewController ()<NARShareViewDelegate,InitShareViewDelegate,InitShareDelegate,
UITableViewDelegate,UITableViewDataSource,groupTalkCellDelegate,sendMessageDelegate,ZDSGroupActCellDelegate,ZDSGroupBubbleCellDelegate,MoreAlertViewDelegate,FinishAlertViewDelegate,CommanderMoreAlertViewDelegate,PublicTaskViewControllerDelegate,GroupVisitorMore28ViewDelegate,GroupCommanderMore28ViewDelegate,GroupMemberMore28ViewDelegate,InputAlertViewDelegate>
{
    int topNumber;
    int topUpper;
    UIActionSheet *myActionSheetView;
    NSString *talkid;
    //举报类型
    NSString *repotType;
    NSString *talkResult;
    NSString *stopResult;
}   

@property (nonatomic,strong) NSString *topType;

@property (nonatomic,strong) NSMutableArray *userArray;

/**
    未读消息
 *  团长或团员查看游戏详细页时返回，超过99返回“99+”
 */
@property (nonatomic,strong) NSString *notreadct;
@property (nonatomic,strong) UILabel *notreadctLabel;
@property (nonatomic,strong) NSMutableArray *m_DataArr;
@property (nonatomic,strong) UIButton *joinButton;
@property (nonatomic,strong) UIButton *uploadWeightButton;
@property (nonatomic,strong) UIView *userView;


@property (nonatomic,assign) BOOL isHiddenNav;

//上传体重弹框
@property(nonatomic,strong)InitShareWeightView *shareWeightView;

//团长任务内容label
@property(nonatomic,strong)UILabel *taskContentLabel;

//完成任务按钮
@property(nonatomic,strong)UIButton *finishTaskButton;
//发布新任务按钮
@property(nonatomic,strong)UIButton *pubNewTaskbutton;


@property(nonatomic,strong)UIImageView *imageView;//封面
@property(nonatomic,strong)UIScrollView *back;//

@property (nonatomic,strong) InitShareView * shareView;

//倒计时label
@property (nonatomic,strong) UILabel *countDownLabel;
@property (nonatomic,strong) NSTimer *countDownTimer;
@property (nonatomic) long countDown;

@property (nonatomic,strong) UIImage *shareImage;

@property (nonatomic,strong) NSIndexPath *currentIndexPath;

@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)NSMutableArray* ArticleData;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@property(nonatomic,strong)GroupHeaderModel *model;//团组头部模型
//更多菜单栏
@property(strong,nonatomic) UIButton* jindu;//进度按钮
@property(strong,nonatomic) UIButton* homeBtn;//返回首页按钮
@property(nonatomic,strong) UIButton* ruleBtn;//规则
@property(strong,nonatomic) UIButton* fenxiangBtn;//分享按钮
@property(nonatomic,strong) UIButton* delBtn;//退出按钮
@property(strong,nonatomic) UIView* menuView;//选择菜单
//介绍类别视图
@property(nonatomic,strong)UIView *typeIntro;//介绍类别视图
//点赞状态
@property(nonatomic,copy)NSString *praisestatus;//点赞状态
@property(nonatomic,strong)MCFireworksButton *goodButton;//点赞按钮
@property(nonatomic,strong)UILabel *googLabel;//点赞数量

@property(nonatomic,copy)NSString *parterid;//上传体重id

@property(nonatomic,strong)UIImage *image;//分享用的图片
@property(nonatomic,strong)UIView *footerView;//底部视图
@property(nonatomic,strong)UIView *talkView;//说点啥选择视图
@property(nonatomic,assign)BOOL talkBarLoadDone;//乐活吧加载成功标示
@end

@implementation GroupViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"团组详情页面"];
    
    self.navigationController.navigationBarHidden = NO;
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    if (CGAffineTransformEqualToTransform([UIApplication sharedApplication].keyWindow.transform, CGAffineTransformMakeTranslation(0,50))) {
//        self.navigationController.navigationBar.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 20);
//    }else self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -50;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -50;
    self.navigationController.navigationBar.top = 20;
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.httpOpt cancel];
    [self createTimerWith:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    //友盟打点
    [MobClick beginLogPageView:@"团组详情页面"];
    
    
    if (!self.isHiddenNav) {
        [self setNav];
    } else {
        self.navigationController.navigationBarHidden = YES;
        if(self.navigationController)
//        [UIApplication sharedApplication].statusBarHidden = YES;
        self.isHiddenNav = YES;
    }
    
    [self.table reloadData];
    self.navigationController.navigationBar.top = 20;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.gameangle) {
        [self reloadGroupData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, 100, SCREEN_WIDTH, 50);
    lbl.text = @"加载中...";
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.view addSubview:lbl];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [MobClick event:@"GROUPOPENSUM"];
    
    self.isHiddenNav = NO;
    
    self.countDown = 0;
    self.data = [NSMutableArray array];
    self.ArticleData = [NSMutableArray array];
    self.model = [[GroupHeaderModel alloc] init];
    
    [self.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(good:) name:@"goodReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(com:) name:@"comReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinAct:) name:@"joinAct" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delteReply:) name:@"delteReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(breakUpGroupNoti) name:@"breakUpGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleArticle) name:@"grouptitletoggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleArticle) name:@"sendTitleSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleArticle) name:@"grouptitletop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitTaskSucess) name:@"submitTaskSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTaskSucessNotify) name:@"endTaskSucess" object:nil];
    
    
    
}

- (void)notifyHiden{
    self.table.frame = CGRectMake(0, [self scroY], SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight);
    self.back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight);
    if ([self.gameangle isEqualToString:@"3"]) {
        self.back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

- (void)dealloc {
    
    [self.view removeObserver:self forKeyPath:@"frame" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.header free];
    [self.footer free];
    
    NSLog(@"团组详情页面释放");
}

#pragma mark - UI

//设置导航条
- (void)setNav {
    
    self.navigationController.navigationBarHidden = NO;
//    [UIApplication sharedApplication].statusBarHidden = NO;
    
    //导航栏标题
    self.titleLabel.text = self.model.groupName.length<1?@"":self.model.groupName;
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    //导航栏更多
    [self.rightButton setTitle:@"  ···" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(30);
    [self.rightButton addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.bounds = CGRectMake(0, 0, 44, 28);
    
    [self viewOffsetMoveSubView];
}

#pragma mark 说点啥吧view
- (UIView *)_taleAboutView {
    
    //脚视图
    UIView *talkView = [[UIView alloc] init];
    [self.view addSubview:talkView];
    talkView.frame = CGRectMake(0, SCREEN_HEIGHT - 47 - NavHeight, SCREEN_WIDTH, 47);
    talkView.clipsToBounds = YES;
//    talkView.backgroundColor = ZDS_BACK_COLOR;
    talkView.userInteractionEnabled = YES;
    
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[talkView bounds]];
//    [bar setBarTintColor:[UIColor colorWithWhite:1 alpha:1]];
    bar.barStyle = UIBarStyleDefault;
    bar.alpha = 0.9;
    bar.translucent = YES;
    [talkView addSubview:bar];
//    [self setToolbar:[[UIToolbar alloc] initWithFrame:[self bounds]]];
//    [talkView.layer insertSublayer:[bar layer] atIndex:0];
//    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:talkView.bounds];
//    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [talkView insertSubview:toolbar atIndex:0];
//    UIView *lineView = [[UIView alloc] init];
//    lineView.backgroundColor = [WWTolls colorWithHexString:@"#999999"];
//    lineView.frame = CGRectMake(0, 0, talkView.width, 0.5);
//    [talkView addSubview:lineView];
    
    //说点啥按钮
    UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 40)/2 ,5, 40, 40)];
    [talkView addSubview:tempButton];
    
    [tempButton setImage:[UIImage imageNamed:ShuoDianShaImage] forState:UIControlStateNormal];
    [tempButton addTarget:self action:@selector(groupTalkButton) forControlEvents:UIControlEventTouchUpInside];
    
    return talkView;
}

#pragma mark 初始化UI
-(void)setUpGUI{
    self.isHiddenNav = NO;
    [self setNav];
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -50;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -50;
    //初始化tableview
    self.table = [[UITableView alloc] init];
    self.table.dataSource = self;
    self.table.delegate = self;
//    self.table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.table.separatorColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    self.table.frame = CGRectMake(0, [self scroY], SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight);
    self.table.scrollsToTop = YES;
    [self.view addSubview:self.table];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    self.table.backgroundColor = ZDS_BACK_COLOR;
    self.groupCell = [[GroupTalkTableViewCell alloc] init];
    
//    WEAKSELF_SS
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self reloadGroupData];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadData];
    };
    
    //说点啥吧view
    self.footerView = [self _taleAboutView];
}

#pragma mark 普通团访客UI
- (void)setUpGeneralGroupVistiUI {
    
    NSLog(@"创建普通团访客UI");
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -70;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -70;
    self.navigationController.navigationBarHidden = YES;
    if(self.navigationController)
//    [UIApplication sharedApplication].statusBarHidden = YES;
    
    self.isHiddenNav = YES;
    
    [self.view setNeedsDisplay];
    
    if (self.back) {
        [self.back.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.back = nil;
    }
    
    //背景
    self.view.backgroundColor = ZDS_BACK_COLOR;
    
    UIScrollView *back = [[UIScrollView alloc] init];
    back.delaysContentTouches = NO;
    back.showsVerticalScrollIndicator = NO;
    back.delegate = self;
    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:back];
    
    self.back = back;
    
//    self.view.backgroundColor = [UIColor redColor];
//    self.back.backgroundColor = [UIColor yellowColor];
    
    for (UIView *view in back.subviews) {
        [view removeFromSuperview];
    }
    
    //团组封面
    UIImageView *header = [[UIImageView alloc] init];
    self.imageView = header;
    header.frame = CGRectMake(0, -60, SCREEN_WIDTH, SCREEN_WIDTH);
    header.backgroundColor = [UIColor whiteColor];
    [header sd_setImageWithURL:[NSURL URLWithString:self.model.groupImage]];
    [back addSubview:header];
    //黑色贴图
    UIImageView *backHead = [[UIImageView alloc] init];
    backHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    backHead.image = [UIImage imageNamed:@"zz-640"];
    [header addSubview:backHead];
    
    UIView *bb = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 60, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bb.backgroundColor = ZDS_BACK_COLOR;
    [back addSubview:bb];
    
    //返回按钮
    UIButton *lastBtn = [[UIButton alloc] init];
    lastBtn.frame = CGRectMake(12, 12, 30, 30);
    [lastBtn setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:lastBtn];
    //标签
    UILabel *tag = [[UILabel alloc] init];
    [back addSubview:tag];
    tag.hidden = NO;
    tag.textColor = [UIColor whiteColor];
    tag.font = MyFont(10);
    tag.textAlignment = NSTextAlignmentCenter;
    tag.layer.cornerRadius = 10;
    tag.clipsToBounds = YES;
    tag.frame = CGRectMake(12, 171, 44, 20);
    if([self.model.desctag isEqualToString:@"1"]){
        tag.text = @"官方团";
        tag.backgroundColor = [WWTolls colorWithHexString:@"#565bd9"];
    }else if([self.model.desctag isEqualToString:@"2"]){
        tag.text = @"已爆满!";
        tag.backgroundColor = [WWTolls colorWithHexString:@"#e99312"];
    }else if([self.model.desctag isEqualToString:@"3"]){
        tag.text = @"HOT!";
        tag.font = MyFont(11);
        tag.backgroundColor = [WWTolls colorWithHexString:@"#ea5041"];
    }else if([self.model.desctag isEqualToString:@"4"]){
        tag.text = @"NEW!";
        tag.font = MyFont(11);
        tag.backgroundColor = [WWTolls colorWithHexString:@"#da4a94"];
    }else if([self.model.isfull isEqualToString:@"0"]){
        tag.text = @"已爆满!";
        tag.backgroundColor = [WWTolls colorWithHexString:@"#e99312"];
    }else{
        tag.hidden = YES;
    }
    // 团组名称
    UILabel *namelbl = [[UILabel alloc] init];
    namelbl.frame = CGRectMake(12, 167, 320, 23);
    if (!tag.hidden) {
        namelbl.left = tag.right + 3;
    }
    namelbl.font = MyFont(23);
    namelbl.textColor = [UIColor whiteColor];
    namelbl.text = self.model.groupName;
    [namelbl sizeToFit];
    [back addSubview:namelbl];
        //人数
    UIImageView *renshu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renshu2_32_32"]];
    renshu.frame = CGRectMake(12, namelbl.bottom+10, 16, 16);
    [back addSubview:renshu];
    UILabel *renshu2 = [[UILabel alloc] init];
    renshu2.frame = CGRectMake(35, namelbl.bottom+10, 70, 16);
    renshu2.font = MyFont(14);
    renshu2.textColor = [UIColor whiteColor];
    renshu2.text = [NSString stringWithFormat:@"人数 %@",self.model.userSum];
    
    //标签
    UILabel *taglbl = [[UILabel alloc] init];
    taglbl.frame = CGRectMake(renshu2.right - 33 + self.model.userSum.length*10  , namelbl.bottom + 6, 43, 23);
    taglbl.font = MyFont(10);
    taglbl.textAlignment = NSTextAlignmentCenter;
    taglbl.textColor = [UIColor whiteColor];
    taglbl.text = [self.model.groupTags componentsSeparatedByString:@","][0];
    if (taglbl.text.length<1) {
        taglbl.hidden = YES;
    }
    taglbl.layer.cornerRadius = 9;
    taglbl.clipsToBounds = YES;
    taglbl.layer.borderWidth = 0.5;
    taglbl.layer.borderColor = [UIColor whiteColor].CGColor;
    [back addSubview:taglbl];

    
    [back addSubview:renshu2];
    //团组减重
    UIImageView *tuanzu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gjz-32-32"]];
    tuanzu.frame = CGRectMake(12, renshu2.bottom+9, 16, 16);
    [back addSubview:tuanzu];
    UILabel *tuanzu2 = [[UILabel alloc] init];
    tuanzu2.frame = CGRectMake(35, renshu2.bottom+9, 200, 16);
    tuanzu2.font = MyFont(14);
    tuanzu2.textColor = [UIColor whiteColor];
    tuanzu2.text = [NSString stringWithFormat:@"团组共减重 %@kg",self.model.gtotallose];
    [back addSubview:tuanzu2];
    
    //动态
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(back.width - 12 - 38, tuanzu.maxY - 10, 38, 12)];
    [back addSubview:dynamicLabel];
//    dynamicLabel.backgroundColor = [UIColor redColor];
    dynamicLabel.text = @"条动态";
    dynamicLabel.font = MyFont(12.0);
    dynamicLabel.textColor = [WWTolls colorWithHexString:@"#ffffff"];
    
    UILabel *dynamicCount = [[UILabel alloc] initWithFrame:CGRectMake(dynamicLabel.x - 6 - 100, dynamicLabel.y, 100, 12)];
    [back addSubview:dynamicCount];
    dynamicCount.text = [NSString stringWithFormat:@"%@",self.model.dyncount];
    dynamicCount.textColor = [WWTolls colorWithHexString:@"#ffffff"];
    dynamicCount.font = MyFont(12.0);
    dynamicCount.textAlignment = NSTextAlignmentRight;
    
    //团长介绍
    UIView *taskView = [[UIView alloc] initWithFrame:CGRectMake(7.5, header.bottom + 10, SCREEN_WIDTH-15, 0)];
    taskView.backgroundColor = [UIColor whiteColor];
    [taskView makeCorner:5.0];
    [back addSubview:taskView];
    
    UIImageView *taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 18, 18)];
    [taskImageView setImage:[UIImage imageNamed:@"tzjs-36-36"]];
    [taskView addSubview:taskImageView];
    
    UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskImageView.maxX + 12, taskImageView.midY - 7.5, 80, 15)];
    taskLabel.text = @"团长介绍";
    taskLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [taskView addSubview:taskLabel];
    
    UILabel *taskLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, taskImageView.maxY + 11, taskView.width, 0.5)];
    taskLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [taskView addSubview:taskLineLabel];
    //团长
    //头像
    UIButton *headerView = [[UIButton alloc] init];
    [taskView addSubview:headerView];
    [headerView sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.headerImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    headerView.titleLabel.text = self.model.gamecrtor;
    [headerView addTarget:self action:@selector(clickPater:) forControlEvents:UIControlEventTouchUpInside];
    headerView.frame = CGRectMake(12, taskLineLabel.bottom+15, 40, 40);
    headerView.layer.cornerRadius = 20;
    headerView.clipsToBounds = YES;
    
    //昵称
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(6, headerView.bottom+8,52, 40);
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    lbl.text = self.model.username;
    CGFloat h = [WWTolls heightForString:lbl.text fontSize:13 andWidth:52];
    lbl.height=h+1;
    lbl.numberOfLines = 0;
    lbl.font = MyFont(13);
    lbl.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:lbl];
    //团长介绍内容
    UILabel *introlbl = [[UILabel alloc] init];
    introlbl.font = MyFont(14);
    introlbl.numberOfLines = 0;
    introlbl.textColor = [WWTolls colorWithHexString:@"#959595"];
//    introlbl.text = @"手臂和胸-俯卧撑和引体向上运动，如果觉得难度太高，可以每天都坚持做一段时间的扩胸运动（就是假装在用健身房里那种专门用来扩胸的器械做的运动）这些都是可以在学习的同时进行的（比如站着看书的时候抬腿运动，睡觉前边记单词边仰卧起坐等等）并且终身受用的。胸-俯卧撑和引体向上运动，如果觉得难度太高，可以每天都坚持做一段时间的扩胸运动（就是假装在用健身房里那种专门用来扩胸的器械做的运动）这些都是可以在学习的同时进行的（比如站着看书的时候抬腿运动，睡觉前边记单词边仰卧起坐等等）并且终身受用的。";
    introlbl.text = self.model.crtorintro;
    h = [WWTolls heightForString:introlbl.text fontSize:14 andWidth:228];
    introlbl.frame = CGRectMake(headerView.right+13, taskLineLabel.bottom+19, 228, h+1);
    [taskView addSubview:introlbl];
    //团长介绍高度
    taskView.height = introlbl.bottom+15>150?introlbl.bottom+15:150;
    
    //减脂方法
    taskView = [[UIView alloc] initWithFrame:CGRectMake(7.5, taskView.bottom + 10, SCREEN_WIDTH-15, 0)];
    taskView.backgroundColor = [UIColor whiteColor];
    [taskView makeCorner:5.0];
    [back addSubview:taskView];
    
    taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 18, 18)];
    [taskImageView setImage:[UIImage imageNamed:@"rw-36"]];
    [taskView addSubview:taskImageView];
    
    taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskImageView.maxX + 12, taskImageView.midY - 7.5, 80, 15)];
    taskLabel.text = @"减脂方法";
    taskLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [taskView addSubview:taskLabel];
    
    taskLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, taskImageView.maxY + 11, taskView.width, 0.5)];
    taskLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [taskView addSubview:taskLineLabel];
    //图片
    UIImageView *fangfa = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jzff-234-140"]];
    fangfa.frame = CGRectMake(94, taskLineLabel.bottom+16, 117, 70);
    [taskView addSubview:fangfa];
    
    //减脂方法内容
    introlbl = [[UILabel alloc] init];
    introlbl.font = MyFont(14);
    introlbl.numberOfLines = 0;
    introlbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    introlbl.text = self.model.loseway;
    h = [WWTolls heightForString:introlbl.text fontSize:14 andWidth:285];
    introlbl.frame = CGRectMake(10, taskLineLabel.bottom+96, 285, h+1);
    [taskView addSubview:introlbl];
    //团长介绍高度
    taskView.height = introlbl.bottom+15;
    
    //-----------------------------团组成员-----------------------------
    UIView *memberView = [[UIView alloc] initWithFrame:CGRectMake(taskView.x, taskView.maxY + 10, taskView.width, 200)];
    memberView.backgroundColor = [UIColor whiteColor];
    [memberView makeCorner:5.0];
    [back addSubview:memberView];
    
    UIImageView *memberFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 18, 18)];
    [memberFlagView setImage:[UIImage imageNamed:@"rs-32-32"]];
    [memberView addSubview:memberFlagView];
    
    UILabel *memberLabel = [[UILabel alloc] initWithFrame:CGRectMake(memberFlagView.maxX + 12, memberFlagView.midY - 7.5, 80, 15)];
    memberLabel.text = @"团组成员";
    memberLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [memberView addSubview:memberLabel];
    
    //查看团组成员
    UIButton *memberButton = [[UIButton alloc] initWithFrame:CGRectMake(memberView.width - 10 - 16, memberFlagView.midY - 8, 16, 16)];
    [memberView addSubview:memberButton];
    [memberButton setImage:[UIImage imageNamed:@"ckgd-32"] forState:UIControlStateNormal];
    [memberButton addTarget:self action:@selector(memberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *memberLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, memberFlagView.maxY + 11, memberView.width, 0.8)];
    memberLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [memberView addSubview:memberLineLabel];
    
    UIView *userView = [[UIView alloc] initWithFrame:CGRectMake(0, memberLineLabel.maxY, memberView.width, 40 + 19 + 19)];
    userView.backgroundColor = [UIColor clearColor];
    [memberView addSubview:userView];
    self.userView = userView;
    
    //
    [self setUserView];
    
    memberView.height = memberLineLabel.maxY + 19 + 19 + 40;
    
    //-----------------------------加入团组-----------------------------
    UIButton *joinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, memberView.maxY + 10, SCREEN_WIDTH, 50)];
    [back addSubview:joinButton];
    [joinButton setImage:[UIImage imageNamed:@"jrtz-640-100"] forState:UIControlStateNormal];
    [joinButton addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.joinButton = joinButton;
    
    //背景大小
    back.contentSize = CGSizeMake(SCREEN_WIDTH, joinButton.bottom);
    NSLog(@"back.frame:%@ self.view.frame:%@",[NSValue valueWithCGRect:self.back.frame],[NSValue valueWithCGRect:self.view.frame]);
    
}

- (void)setUserView {
    
    [self.userView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    [self.userView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.userArray.count; i++) {
        
        CGFloat memberUserButtonX = 10 + (40 + 9) * i;
        UIButton *memberUserButton = [[UIButton alloc] initWithFrame:CGRectMake(memberUserButtonX, 19, 40, 40)];
        [self.userView addSubview:memberUserButton];
        memberUserButton.tag = i;
        intrestUserModel *model = self.userArray[i];
        [memberUserButton makeCorner:20];
        [memberUserButton sd_setImageWithURL:[NSURL URLWithString:model.imageurl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98.png"]];
        [memberUserButton addTarget:self action:@selector(memberUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            UIImageView *tuanzhang = [[UIImageView alloc] init];
            tuanzhang.image = [UIImage imageNamed:@"tuanzhang_40"];
            tuanzhang.frame = CGRectMake(memberUserButton.maxX - 15, memberUserButton.maxY - 15, 15, 15);
            [self.userView addSubview:tuanzhang];
        }
    }
}

#pragma mark 普通团团长UI
- (UIView*)setUpGeneralGroupCommanderUI {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, [self scroY], SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    bgView.backgroundColor = COLOR_NORMAL_CELL_BG;
//    bgView.delaysContentTouches = NO;
    
    //-----------------------------团组动态-----------------------------
    UIView *dynamicView = [[UIView alloc] initWithFrame:CGRectMake(0, 10,SCREEN_WIDTH, 281)];
    dynamicView.layer.borderWidth = 0.5;
    dynamicView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    [bgView addSubview:dynamicView];
    dynamicView.backgroundColor = [UIColor whiteColor];
//    [dynamicView makeCorner:5.0];
    
    UIImageView *dynamicFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 18, 18)];
    [dynamicView addSubview:dynamicFlagView];
    [dynamicFlagView setImage:[UIImage imageNamed:@"group_dynamic"]];
    
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(dynamicFlagView.maxX + 12, dynamicFlagView.midY - 7.5, 80, 15)];
    dynamicLabel.text = @"团组动态";
    dynamicLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [dynamicView addSubview:dynamicLabel];
    
    //团员减重
    UIButton *dynamicImageView = [[UIButton alloc] initWithFrame:CGRectMake(dynamicView.width - 10 - 16, dynamicFlagView.midY - 8, 16, 16)];
    [dynamicView addSubview:dynamicImageView];
    [dynamicImageView setImage:[UIImage imageNamed:@"ckgd-32"] forState:UIControlStateNormal];
    
    UILabel *memberReduceLabel = [[UILabel alloc] initWithFrame:CGRectMake(dynamicImageView.x - 6 - 60, dynamicImageView.midY - 6, 60, 12)];
    [dynamicView addSubview:memberReduceLabel];
    memberReduceLabel.text = @"团员减重";
    memberReduceLabel.font = MyFont(12.0);
    memberReduceLabel.textAlignment = NSTextAlignmentRight;
    memberReduceLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    
//    UIImageView *dynFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(memberReduceLabel.x - 7 - 10, memberReduceLabel.midY - 7.5, 12, 15)];
//    [dynamicView addSubview:dynFlagView];
//    [dynFlagView setImage:[UIImage imageNamed:@"group_reduce_member"]];
    
    UILabel *dynLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, dynamicFlagView.maxY + 11, dynamicView.width - 28, 0.8)];
    dynLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [dynamicView addSubview:dynLineLabel];
    
    //团员减重按钮
    UIButton *dynamicButton = [[UIButton alloc] initWithFrame:CGRectMake(memberReduceLabel.left, 0, dynamicView.width - memberReduceLabel.left, dynLineLabel.maxY)];
    [dynamicView addSubview:dynamicButton];
    dynamicButton.backgroundColor = [UIColor clearColor];
    [dynamicButton addTarget:self action:@selector(dynamicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bgYellowView = [[UIView alloc] initWithFrame:CGRectMake(12, dynLineLabel.maxY + 12, dynamicView.width - 24, 75)];
    [dynamicView addSubview:bgYellowView];
    bgYellowView.backgroundColor = [WWTolls colorWithHexString:@"#fff0d8"];
    
    NSArray *imageArray = @[@"group_current_member",@"group_today_add",@"group_today_upload",@"group_finish_task"];
    NSArray *textArray = @[@"当前团员",@"今日新增",@"今日传体重",@"任务完成"];
    
    CGFloat perWidth = (dynamicView.width - 24) / 4;
    
    for (int i = 0; i < imageArray.count; i++) {
        
        float weightImageX = (perWidth - 23) / 2 + perWidth*i + 12;
        float weightLabelX = perWidth * i + 12;
        float weightCountLabelX = perWidth * i + 12;
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(weightImageX, dynLineLabel.maxY + 22, 23, 18)];
        [tempImageView setImage:[UIImage imageNamed:imageArray[i]]];
        [dynamicView addSubview:tempImageView];
        
        UILabel *tempDynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLabelX, tempImageView.maxY + 5, perWidth, 12)];
        tempDynamicLabel.text = textArray[i];
        tempDynamicLabel.font = MyFont(12.0);
        tempDynamicLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        tempDynamicLabel.textAlignment = NSTextAlignmentCenter;
        [dynamicView addSubview:tempDynamicLabel];
        
        UILabel *dynamicCountLable = [[UILabel alloc] initWithFrame:CGRectMake(weightCountLabelX, tempDynamicLabel.maxY + 5, perWidth, 14)];
        dynamicCountLable.font = MyFont(13.0);
        dynamicCountLable.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        dynamicCountLable.text = @"0kg";
        dynamicCountLable.textAlignment = NSTextAlignmentCenter;
        [dynamicView addSubview:dynamicCountLable];
        switch (i) {
            case 0:
                dynamicCountLable.text = [NSString stringWithFormat:@"%@人",self.model.partercount];
                break;
            case 1:
                dynamicCountLable.text = [NSString stringWithFormat:@"%@人",self.model.todayaddct];
                break;
            case 2:
                dynamicCountLable.text = [NSString stringWithFormat:@"%@人",self.model.todayupwgct];
                break;
            case 3:
                dynamicCountLable.text = [NSString stringWithFormat:@"%@次",self.model.fstaskpct];
                break;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        CGFloat tempLineX = 12 + perWidth * (i + 1);
        UILabel *tempLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempLineX, dynLineLabel.maxY + 12, 1, 75)];
        tempLineLabel.backgroundColor = [UIColor whiteColor];
        [dynamicView addSubview:tempLineLabel];
        
    }
    
    dynamicView.height = bgYellowView.maxY + 15;
    
    //-----------------------------我的成长-----------------------------
    
    UIView *coGrowView = [[UIView alloc] initWithFrame:CGRectMake(dynamicView.x, dynamicView.maxY + 10, dynamicView.width, 200)];
    coGrowView.backgroundColor = [UIColor whiteColor];
    coGrowView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    coGrowView.layer.borderWidth = 0.5;
    [bgView addSubview:coGrowView];
    
    //图标
    UIImageView *coGrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 18, 18)];
    [coGrowImageView setImage:[UIImage imageNamed:@"my_growup"]];
    [coGrowView addSubview:coGrowImageView];
    
    UILabel *coGrowLabel = [[UILabel alloc] initWithFrame:CGRectMake(coGrowImageView.maxX + 12, coGrowImageView.midY - 7.5, 80, 15)];
    coGrowLabel.text = @"我的成长";
    coGrowLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [coGrowView addSubview:coGrowLabel];
    
    UILabel *coGrowLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, coGrowImageView.maxY + 11, coGrowView.width - 28, 0.8)];
    coGrowLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [coGrowView addSubview:coGrowLineLabel];
    
    NSArray *imageArray2 = @[@"cstz-42",@"dqtz-42",@"bfb-42",@"ljjz-42"];
    NSArray *textArray2 = @[@"初始体重",@"当前体重",@"减重百分比",@"累计减重"];
    NSArray *colorArray2 = @[@"#eb5b9f",@"#ffb65e",@"#805efb",@"#ff4f4e"];
    
    perWidth = (dynamicView.width - 24) / 4;
    
    for (int i = 0; i < imageArray.count; i++) {
        
        float weightImageX = (perWidth - 21) / 2 + perWidth*i + 12;
        float weightLabelX = perWidth * i + 12;
        float weightCountLabelX = perWidth * i + 12;
        
        UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(weightImageX, coGrowLineLabel.maxY + 15, 21, 21)];
        [weightImageView setImage:[UIImage imageNamed:imageArray2[i]]];
        [coGrowView addSubview:weightImageView];
        
        UILabel *weightLable = [[UILabel alloc] initWithFrame:CGRectMake(weightLabelX, weightImageView.maxY + 5, perWidth, 12)];
        weightLable.text = textArray2[i];
        weightLable.font = MyFont(12.0);
        weightLable.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        weightLable.textAlignment = NSTextAlignmentCenter;
        [coGrowView addSubview:weightLable];
        
        UILabel *weightCountLable = [[UILabel alloc] initWithFrame:CGRectMake(weightCountLabelX, weightLable.maxY + 5, perWidth, 14)];
        weightCountLable.font = MyFont(13.0);
        weightCountLable.textColor = [WWTolls colorWithHexString:colorArray2[i]];
        weightCountLable.text = @"0kg";
        weightCountLable.textAlignment = NSTextAlignmentCenter;
        [coGrowView addSubview:weightCountLable];
        switch (i) {
            case 0:
                weightCountLable.text = [NSString stringWithFormat:@"%@kg",self.model.initialweg];
                break;
            case 1:
                weightCountLable.text = [NSString stringWithFormat:@"%@kg",self.model.latestweg];
                break;
            case 2:         
                weightCountLable.text = [NSString stringWithFormat:@"%@%%",self.model.losepercent];
                break;
            case 3: 
                weightCountLable.text = [NSString stringWithFormat:@"%@kg",self.model.ptotallose];
                break;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        CGFloat weightLineLabelX = 12 + perWidth * (i + 1);
        UILabel *weightLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLineLabelX, coGrowLineLabel.maxY + 10, 1, 69)];
        weightLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [coGrowView addSubview:weightLineLabel];
    }   
    
    CGFloat tempHeight = coGrowLineLabel.maxY + 10 + 69;
    
    //上传体重按钮
    UIButton *uploadWeightButton = [[UIButton alloc] initWithFrame:CGRectMake((coGrowView.width - 238) / 2, tempHeight + 10, 238, 41)];
    [uploadWeightButton setImage:[UIImage imageNamed:@"sctz-476-82"] forState:UIControlStateNormal];
    [uploadWeightButton addTarget:self action:@selector(uploadWeightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [coGrowView addSubview:uploadWeightButton];
    
    coGrowView.height = uploadWeightButton.maxY + 10;
    
    //-----------------------------团长任务-----------------------------
    
    UIView *pubTaskView = [self getAndSetTaskViewWithFrame:CGRectMake(coGrowView.x, coGrowView.maxY + 10, coGrowView.width, 200)];
    [bgView addSubview:pubTaskView];
    
    //-----------------------------乐活吧-----------------------------
//    UIView *playBarView = [self getAndSetGeneralGourpPlayBarUIWithFrame:CGRectMake(pubTaskView.x, pubTaskView.maxY + 10, pubTaskView.width, 0)];
//    [bgView addSubview:playBarView];
    
//    bgView.contentSize = CGSizeMake(SCREEN_WIDTH, playBarView.maxY + 13);
//    UIView *playBar = [[UIView alloc] initWithFrame:CGRectMake(0, pubTaskView.maxY, SCREEN_WIDTH, 35)];
//    playBar.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
//    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 77)/2, 9, 18, 18)];
//    [barImageView setImage:[UIImage imageNamed:@"lhb-36"]];
//    [playBar addSubview:barImageView];
//    
//    UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 5, 10, 80, 15)];
//    barLabel.font = MyFont(17);
//    barLabel.text = @"乐活吧";
//    barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
//    [playBar addSubview:barLabel];
//    [bgView addSubview:playBar];
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, pubTaskView.maxY, SCREEN_WIDTH, 10);
    line.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    [bgView addSubview:line];
    bgView.height = line.maxY;
    return bgView;
}



#pragma mark 普通团成员UI
- (UIView*)setUpGeneralGroupMemberUI {
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, [self scroY], SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    bgView.backgroundColor = COLOR_NORMAL_CELL_BG;
//    bgView.delaysContentTouches = NO;
//    self.back = bgView;
    
    //-----------------------------我的成长-----------------------------
    UIView *myGrowUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 10,SCREEN_WIDTH, 281)];
    myGrowUpView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    myGrowUpView.layer.borderWidth = 0.5;
    [bgView addSubview:myGrowUpView];
    myGrowUpView.backgroundColor = [UIColor whiteColor];
//    [myGrowUpView makeCorner:5.0];
    
    UIImageView *wdczImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 18, 18)];
    [wdczImageView setImage:[UIImage imageNamed:@"wdcz-36"]];
    [myGrowUpView addSubview:wdczImageView];
    
    UILabel *wdczLabel = [[UILabel alloc] initWithFrame:CGRectMake(wdczImageView.maxX + 12, wdczImageView.midY - 7.5, 80, 15)];
    wdczLabel.text = @"我的成长";
    wdczLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [myGrowUpView addSubview:wdczLabel];
    
    UIImageView *grbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myGrowUpView.width - 10 - 16 - 8 - 30, wdczLabel.midY - 15, 30, 30)];
    [myGrowUpView addSubview:grbImageView];
    [grbImageView setImage:[UIImage imageNamed:@"grb-60.png"]];
    
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(myGrowUpView.width - 10 - 16, grbImageView.midY - 8, 16, 16)];
    [myGrowUpView addSubview:nextImageView];
    [nextImageView setImage:[UIImage imageNamed:@"ckgd-32"]];
    
    UILabel *firstLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, wdczImageView.maxY + 11, myGrowUpView.width - 28, 0.5)];
    firstLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [myGrowUpView addSubview:firstLineLabel];
    
    //光荣榜按钮
    UIButton *grbButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, firstLineLabel.width, firstLineLabel.maxY)];
    [myGrowUpView addSubview:grbButton];
    grbButton.backgroundColor = [UIColor clearColor];
    [grbButton addTarget:self action:@selector(grbButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *yellowBgView = [[UIView alloc] initWithFrame:CGRectMake(7.5, firstLineLabel.maxY + 7.5, myGrowUpView.width - 15, 93)];
    yellowBgView.backgroundColor = [WWTolls colorWithHexString:@"#fff0d8"];
    [myGrowUpView addSubview:yellowBgView];
    
    CGFloat pWidth = (yellowBgView.width - 15) / 2;
    
    UILabel *secondLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(7.5 + pWidth, 0, 0.8, 93)];
    secondLineLabel.backgroundColor = [WWTolls colorWithHexString:@"ffffff"];
    [yellowBgView addSubview:secondLineLabel];
    
    UIImageView *yctImageView = [[UIImageView alloc] initWithFrame:CGRectMake((pWidth - 23)/2, 14, 23, 23)];
    [yctImageView setImage:[UIImage imageNamed:@"yct-46.png"]];
    [yellowBgView addSubview:yctImageView];
    
    UILabel *yctLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yctImageView.maxY + 10, pWidth, 14)];
    yctLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    yctLabel.textAlignment = NSTextAlignmentCenter;
    yctLabel.text = @"已参团";
    [yellowBgView addSubview:yctLabel];
    
    UILabel *yctCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, yctLabel.maxY + 10, pWidth, 15)];
    yctCountLabel.textColor = [WWTolls colorWithHexString:@"#45bb62"];
    yctCountLabel.text = [NSString stringWithFormat:@"%@天",self.model.indays];
    yctCountLabel.textAlignment = NSTextAlignmentCenter;
    [yellowBgView addSubview:yctCountLabel];
    
    UIImageView *rwImageView = [[UIImageView alloc] initWithFrame:CGRectMake(secondLineLabel.maxX + (pWidth + 1 - 23)/2, yctImageView.y, 23, 23)];
    [rwImageView setImage:[UIImage imageNamed:@"wcrw-46"]];
    [yellowBgView addSubview:rwImageView];
    
    UILabel *rwLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondLineLabel.maxX, yctLabel.y, pWidth + 1, 14)];
    rwLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    rwLabel.text = @"完成任务";
    rwLabel.textAlignment = NSTextAlignmentCenter;
    [yellowBgView addSubview:rwLabel];
    
    UILabel *rwCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(secondLineLabel.maxX, yctCountLabel.y, pWidth + 1, 15)];
    rwCountLabel.textColor = [WWTolls colorWithHexString:@"#91c7f1"];
    rwCountLabel.text = [NSString stringWithFormat:@"%@次",self.model.fstaskcount];
    rwCountLabel.textAlignment = NSTextAlignmentCenter;
    [yellowBgView addSubview:rwCountLabel];
    
    NSArray *imageArray = @[@"cstz-42",@"dqtz-42",@"bfb-42",@"ljjz-42"];
    NSArray *textArray = @[@"初始体重",@"当前体重",@"减重百分比",@"累计减重"];
    NSArray *colorArray = @[@"#eb5b9f",@"#ffb65e",@"#805efb",@"#ff4f4e"];
    
    CGFloat perWidth = (myGrowUpView.width - 15) / 4;
    
    for (int i = 0; i < imageArray.count; i++) {
        
        float weightImageX = (perWidth - 21) / 2 + perWidth*i + 7.5;
        float weightLabelX = perWidth * i + 7.5;
        float weightCountLabelX = perWidth * i + 7.5;
        
        UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(weightImageX, yellowBgView.maxY + 15, 21, 21)];
        [weightImageView setImage:[UIImage imageNamed:imageArray[i]]];
        [myGrowUpView addSubview:weightImageView];
        
        UILabel *weightLable = [[UILabel alloc] initWithFrame:CGRectMake(weightLabelX, weightImageView.maxY + 5, perWidth, 12)];
        weightLable.text = textArray[i];
        weightLable.font = MyFont(12.0);
        weightLable.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        weightLable.textAlignment = NSTextAlignmentCenter;
        [myGrowUpView addSubview:weightLable];
        
        UILabel *weightCountLable = [[UILabel alloc] initWithFrame:CGRectMake(weightCountLabelX, weightLable.maxY + 5, perWidth, 14)];
        weightCountLable.font = MyFont(13.0);
        weightCountLable.textColor = [WWTolls colorWithHexString:colorArray[i]];
        weightCountLable.text = @"0kg";
        weightCountLable.textAlignment = NSTextAlignmentCenter;
        [myGrowUpView addSubview:weightCountLable];
        
        switch (i) {
            case 0:
                weightCountLable.text = [NSString stringWithFormat:@"%@kg",self.model.initialweg];
                break;
            case 1:
                weightCountLable.text = [NSString stringWithFormat:@"%@kg",self.model.latestweg];
                break;
            case 2:
                weightCountLable.text = [NSString stringWithFormat:@"%@%%",self.model.losepercent];
                break;
            case 3:
                weightCountLable.text = [NSString stringWithFormat:@"%@kg",self.model.ptotallose];
                break;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        CGFloat weightLineLabelX = 7.5 + perWidth * (i + 1);
        UILabel *weightLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLineLabelX, yellowBgView.maxY + 10, 1, 69)];
        weightLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [myGrowUpView addSubview:weightLineLabel];
    }
    
    CGFloat tempHeight = yellowBgView.maxY + 10 + 69;
    
    //上传体重按钮
    UIButton *uploadWeightButton = [[UIButton alloc] initWithFrame:CGRectMake((myGrowUpView.width - 238) / 2, tempHeight + 10, 238, 41)];
    [uploadWeightButton setImage:[UIImage imageNamed:@"sctz-476-82"] forState:UIControlStateNormal];
    [uploadWeightButton addTarget:self action:@selector(uploadWeightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [myGrowUpView addSubview:uploadWeightButton];
    
    //团长任务
    UIView *taskView = [self getAndSetTaskViewWithFrame:CGRectMake(myGrowUpView.x, myGrowUpView.maxY + 10, myGrowUpView.width, 0)];
    [bgView addSubview:taskView];
    
//    UIView *playBar = [[UIView alloc] initWithFrame:CGRectMake(0, taskView.maxY, SCREEN_WIDTH, 35)];
//    playBar.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
//    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 77)/2, 9, 18, 18)];
//    [barImageView setImage:[UIImage imageNamed:@"lhb-36"]];
//    [playBar addSubview:barImageView];
//    
//    UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 5, 10, 80, 15)];
//    barLabel.font = MyFont(17);
//    barLabel.text = @"乐活吧";
//    barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
//    [playBar addSubview:barLabel];
//    [bgView addSubview:playBar];

    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, taskView.maxY, SCREEN_WIDTH, 10);
    line.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    [bgView addSubview:line];
    bgView.height = line.maxY;
    return bgView;
}

#pragma mark 布置并获取普通团团长任务UI
- (UIView *)getAndSetTaskViewWithFrame:(CGRect)frame {
    
    UIView *taskView = [[UIView alloc] initWithFrame:frame];
    taskView.layer.borderWidth = 0.5;
    taskView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    taskView.backgroundColor = [UIColor whiteColor];
//    [taskView makeCorner:5.0];
    
    UIImageView *taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 18, 18)];
    [taskImageView setImage:[UIImage imageNamed:@"rw-36"]];
    [taskView addSubview:taskImageView];
    
    UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskImageView.maxX + 10, taskImageView.midY - 7.5, 80, 15)];
    taskLabel.text = @"团长任务";
    taskLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [taskView addSubview:taskLabel];
    
    UILabel *taskLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, taskImageView.maxY + 11, taskView.width-28, 0.5)];
    taskLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [taskView addSubview:taskLineLabel];
    
    //普通团
    if ([self.model.gamemode isEqualToString:@"3"]) {
        
        //如果任务内容为空时
        if ([WWTolls isNull:self.model.taskcontent]) {
            //团长
            if ([self.gameangle isEqualToString:@"1"]) {
                self.model.taskcontent = NoPubTaskMessage;
                
                //团员
            } else if ([self.gameangle isEqualToString:@"2"]) {
                if (self.model.urgecount.intValue > 0) {
                    self.model.taskcontent = UrgeMessage;
                } else {    
                    self.model.taskcontent = ToUrgeMessage;
                }
            }
        }else{
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToTaskDetail)];
            [taskView addGestureRecognizer:tap];
        }
    }
    CGFloat taskContentHeight = [WWTolls zdsHeigthForString:self.model.taskcontent fontSize:14 andWidth:taskView.width - 15*2];
    UILabel *taskContentLabel = [[UILabel alloc] init];
    //任务有图片
    if(self.model.taskimage && self.model.taskimage.length > 0){
        UIImageView *taskImage = [[UIImageView alloc] init];
        taskImage.frame = CGRectMake(15, taskLineLabel.bottom + 15, 84, 84);
        taskImage.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
        taskImage.contentMode = UIViewContentModeScaleAspectFill;
        taskImage.clipsToBounds = YES;
        [taskImage sd_setImageWithURL:[NSURL URLWithString:self.model.taskimage]];
        [taskView addSubview:taskImage];
        NSString *taskcontent = [[self.model.taskcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
//        taskcontent = taskcontent.length>102?[NSString stringWithFormat:@"%@...",[taskcontent substringToIndex:101]]:taskcontent;
        taskContentHeight = [WWTolls zdsHeigthForString:taskcontent fontSize:14 andWidth:taskView.width - 30 - 84 - 15];
        taskContentLabel.frame = CGRectMake(taskImage.right + 20, taskLineLabel.maxY + 15, taskView.width - 30 - 84 - 15, 74);
//        NSAttributedString *as = [[NSAttributedString alloc] initWithString:taskcontent];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
//        [paragraphStyle setLineSpacing:1.25];//调整行间距
//        [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [taskcontent length])];
//        taskContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        taskContentLabel.attributedText = aas;
        taskContentLabel.text = taskcontent;

    }else{
        NSString *taskcontent = [[self.model.taskcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        taskcontent = taskcontent.length>192?[NSString stringWithFormat:@"%@...",[taskcontent substringToIndex:191]]:taskcontent;
        taskContentHeight = [WWTolls zdsHeigthForString:taskcontent fontSize:14 andWidth:taskView.width - 30];
//        NSAttributedString *as = [[NSAttributedString alloc] initWithString:taskcontent];
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
//        [paragraphStyle setLineSpacing:1.25];//调整行间距
//        [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [taskcontent length])];
//        taskContentLabel.attributedText = aas;
        taskContentLabel.text = taskcontent;
        taskContentLabel.frame = CGRectMake(15, taskLineLabel.maxY + 15, taskView.width - 15 * 2, taskContentHeight);
    }
    
    if ([self.gameangle isEqualToString:@"1"]&&[WWTolls isNull:self.model.taskcontent]) {
        taskContentHeight =42;
        taskContentLabel.height = 42;
    }
    
    taskContentLabel.numberOfLines = 0;
    taskContentLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    taskContentLabel.font = MyFont(14);
    [taskView addSubview:taskContentLabel];
    self.taskContentLabel = taskContentLabel;
    
//    if ([self.gameangle isEqualToString:@"2"]&&self.model.urgecount.intValue > 0) {
//        taskView.height = taskContentLabel.maxY + 13;
//        return taskView;
//    }
    
    UILabel *taskFinishLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, taskContentLabel.maxY + 12, taskContentLabel.width, 11)];
    if(self.model.taskimage && self.model.taskimage.length > 0) taskFinishLabel.top = taskContentLabel.maxY + 20;
    taskFinishLabel.font = MyFont(11);
    taskFinishLabel.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    [taskView addSubview:taskFinishLabel];
    if ([WWTolls isNull:self.model.tasksts]) {
        taskFinishLabel.hidden = YES;
        taskFinishLabel.frame = taskContentLabel.frame;
    }else if([self.model.fstaskpct isEqualToString:@"0"]){
        taskFinishLabel.hidden = YES;
        taskFinishLabel.frame = taskContentLabel.frame;
        taskFinishLabel.height += 10;
    } else {
        taskFinishLabel.text = [NSString stringWithFormat:@"累计完成%@人次",self.model.fstaskpct];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoDoneList)];
        taskFinishLabel.userInteractionEnabled = YES;
        [taskFinishLabel addGestureRecognizer:tap];
    }
    
    //完成任务状态
    UIImageView *finishStateImageView = [[UIImageView alloc] init];
    finishStateImageView.frame = CGRectMake(taskView.width - 15 - 46,4, 46, 31);
    [taskView addSubview:finishStateImageView];

    //任务完成状态
    //已结束
    if ([self.model.taskcmpl isEqualToString:@"0"]) {
        finishStateImageView.image = [UIImage imageNamed:@"game_workEnd-62-92"];
    }
    //催促次数大于0
    //未完成
    else if ([self.model.tasksts isEqualToString:@"1"]) {
        finishStateImageView.hidden = YES;
        //已完成
    } else if ([self.model.tasksts isEqualToString:@"0"]) {
        finishStateImageView.image = [UIImage imageNamed:@"game_workDone-62-92"];
//
//        //改变内容宽度 与完成图片相差30像素
//        taskContentLabel.width = finishStateImageView.left - taskContentLabel.left - 30;
//        
//        //团员
//        if ([self.gameangle isEqualToString:@"2"]) {
//            CGFloat height = taskFinishLabel.maxY > finishStateImageView.maxY ? taskFinishLabel.maxY : finishStateImageView.maxY;
//            taskView.height = height + 13;
//            return taskView;
//        }
        
    }else if (self.model.urgecount.intValue > 0) {
        finishStateImageView.hidden = YES;
        //没有发布任务
    } else if ([WWTolls isNull:self.model.tasksts]) {
        finishStateImageView.hidden = YES;
    }
    
    UIButton *finishTaskButton = [[UIButton alloc] init];
    UIButton *pubNewTaskbutton = [[UIButton alloc] init];
    
    //团长
    if ([self.gameangle isEqualToString:@"1"]) {
        
        //任务结束
        if ([self.model.taskcmpl isEqualToString:@"0"]) {
            pubNewTaskbutton.frame = CGRectMake((taskView.width - 238) / 2, taskFinishLabel.maxY + 12, 238, 41);
            [pubNewTaskbutton addTarget:self action:@selector(pubNewTaskbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            //发布新任务按钮
            [pubNewTaskbutton setImage:[UIImage imageNamed:@"group_pub_new_task"] forState:UIControlStateNormal];
            [taskView addSubview:pubNewTaskbutton];
        //未完成 已完成
        }else if ([self.model.tasksts isEqualToString:@"1"] || [self.model.tasksts isEqualToString:@"0"]) {
            finishTaskButton.frame = CGRectMake(15, taskFinishLabel.maxY + 12, 137, 41);
            [taskView addSubview:finishTaskButton];
            //提交成绩按钮
            [finishTaskButton setImage:[UIImage imageNamed:@"game_submitChengji-270-82"] forState:UIControlStateNormal];
            [finishTaskButton addTarget:self action:@selector(finishTaskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            pubNewTaskbutton.frame = CGRectMake(taskView.width - 15 - 137, taskFinishLabel.maxY + 12, 137, 41);
            [taskView addSubview:pubNewTaskbutton];
            //结束任务按钮
            [pubNewTaskbutton setImage:[UIImage imageNamed:@"game_jsrw-274-82"] forState:UIControlStateNormal];
            [pubNewTaskbutton addTarget:self action:@selector(endTask) forControlEvents:UIControlEventTouchUpInside];
            //已完成
//        } else if ([self.model.tasksts isEqualToString:@"0"]) {
            
//            CGFloat height = taskFinishLabel.maxY > finishStateImageView.maxY ? taskFinishLabel.maxY : finishStateImageView.maxY;
//            //发布新任务按钮
//            pubNewTaskbutton.frame = CGRectMake((taskView.width - 238) / 2, height + 12, 238, 41);
//            [pubNewTaskbutton addTarget:self action:@selector(pubNewTaskbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
//            [pubNewTaskbutton setImage:[UIImage imageNamed:@"group_pub_new_task"] forState:UIControlStateNormal];
//            [taskView addSubview:pubNewTaskbutton];
            //没有发任务
        } else if ([WWTolls isNull:self.model.tasksts] || self.model.urgecount.intValue > 0) {
            taskContentLabel.textAlignment = NSTextAlignmentCenter;
            pubNewTaskbutton.frame = CGRectMake((taskView.width - 238) / 2, taskFinishLabel.maxY + 12, 238, 41);
            [pubNewTaskbutton addTarget:self action:@selector(pubNewTaskbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
            //发布新任务按钮
            [pubNewTaskbutton setImage:[UIImage imageNamed:@"group_pub_new_task"] forState:UIControlStateNormal];
            [taskView addSubview:pubNewTaskbutton];
        }
        //团员
    } else if ([self.gameangle isEqualToString:@"2"]) {
        if ([self.model.taskcmpl isEqualToString:@"0"]){
            taskView.height = taskFinishLabel.maxY + 15;
            return taskView;
        }
        finishTaskButton.frame = CGRectMake((taskView.width - 239) / 2, taskFinishLabel.maxY + 12, 239, 41);
        [taskView addSubview:finishTaskButton];
        
        //未完成 已完成
        if ([self.model.tasksts isEqualToString:@"1"] || [self.model.tasksts isEqualToString:@"0"]) {
            //提交成绩按钮
            [finishTaskButton setImage:[UIImage imageNamed:@"game_submitChengji-478-82"] forState:UIControlStateNormal];
            [finishTaskButton addTarget:self action:@selector(finishTaskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            //已完成
//        } else if ([self.model.tasksts isEqualToString:@"0"]) {
//            //提交成绩按钮
//            [finishTaskButton setImage:[UIImage imageNamed:@"game_submitChengji-270-82"] forState:UIControlStateNormal];
//            [finishTaskButton addTarget:self action:@selector(finishTaskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//            //已完成任务按钮
//            [finishTaskButton setImage:[UIImage imageNamed:@"rwwc-476-82"] forState:UIControlStateNormal];
            //没有发任务
        } else if (self.model.urgecount.intValue > 0) {
            finishTaskButton.hidden = YES;
            taskView.height = taskFinishLabel.maxY + 15;
            return taskView;
        }   
        else if ([WWTolls isNull:self.model.tasksts]) {
            //催团长发任务按钮
            [finishTaskButton setImage:[UIImage imageNamed:@"crw-476-82"] forState:UIControlStateNormal];
            [finishTaskButton addTarget:self action:@selector(promptTaskButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    self.finishTaskButton = finishTaskButton;
    self.pubNewTaskbutton = pubNewTaskbutton;
    
    CGFloat tempHeight = taskFinishLabel.maxY > finishStateImageView.maxY ? taskFinishLabel.maxY : finishStateImageView.maxY;
    
    taskView.height = tempHeight + 12 + 41 + 12;
    
    
    return taskView;
}

#pragma mark 布置并获取普通团活动吧UI
- (UIView *)getAndSetGeneralGourpPlayBarUIWithFrame:(CGRect)frame {
    
    UIView *playBarView = [[UIView alloc] initWithFrame:frame];
//    UIView *playBarView = [[UIView alloc] initWithFrame:CGRectMake(taskView.x, taskView.maxY + 10, taskView.width, 0)];
    playBarView.backgroundColor = [UIColor whiteColor];
//    [playBarView makeCorner:5.0];
    
    UITapGestureRecognizer *barTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intoBarTap)];
    [playBarView addGestureRecognizer:barTap];
    
    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 11, 18, 18)];
    [barImageView setImage:[UIImage imageNamed:@"lhb-36"]];
    [playBarView addSubview:barImageView];
    
    UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 12, barImageView.midY - 7.5, 80, 15)];
    barLabel.text = @"乐活吧";
    barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [playBarView addSubview:barLabel];
    
    UIImageView *nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(playBarView.width - 10 - 16, barImageView.midY - 8, 16, 16)];
    [playBarView addSubview:nextImageView];
    [nextImageView setImage:[UIImage imageNamed:@"ckgd-32"]];
    
    UILabel *barLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, nextImageView.maxY + 11, playBarView.width, 0.8)];
    barLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [playBarView addSubview:barLineLabel];
    
    UILabel *newMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, barLineLabel.maxY + 13, 100, 12)];
    newMessageLabel.font = MyFont(12.0);
    newMessageLabel.textColor = [WWTolls colorWithHexString:@"#7ad3fa"];
    newMessageLabel.text = @"最新消息";
    [playBarView addSubview:newMessageLabel];
    
    UIImageView *unreadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(playBarView.width - 12 - 105, barLineLabel.maxY + 5, 105, 30)];
    [playBarView addSubview:unreadImageView];
    [unreadImageView setImage:[UIImage imageNamed:@"wdxx-210-76"]];
    
    UILabel *unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, (30 - 11)/2, 80, 11)];
    [unreadImageView addSubview:unreadLabel];
    unreadLabel.text = [NSString stringWithFormat:@"%@条未读消息",self.notreadct];
    unreadLabel.textColor = [UIColor whiteColor];
    unreadLabel.font = MyFont(11.0);
    self.notreadctLabel = unreadLabel;
    
    GroupTalkModel *talkModel = nil;
    if (self.data.count > 0) {
        talkModel = self.data[0];
    } else {
        playBarView.height = unreadImageView.maxY + 6;
        return playBarView;
    }
    
    //团聊
    if ([talkModel.bartype isEqualToString:@"0"]) {
        
        UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, newMessageLabel.maxY + 13, 84, 84)];
        [playBarView addSubview:coverImageView];
        coverImageView.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
        [coverImageView sd_setImageWithURL:[NSURL URLWithString:talkModel.imageurl]];
        if ([WWTolls isNull:talkModel.imageurl]) {
            coverImageView.frame = CGRectZero;
        }
        //    [coverImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
        //    coverImageView.frame = CGRectZero;
        
        CGFloat nameLableX = coverImageView.maxX > 0 ? (coverImageView.maxX + 9) : 12;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLableX, newMessageLabel.maxY + 15, 150, 16)];
        [playBarView addSubview:nameLabel];
        nameLabel.font = MyFont(14.0);
        nameLabel.text = talkModel.username;
        nameLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, nameLabel.maxY + 5, 150, 10)];
        [playBarView addSubview:timeLable];
        timeLable.text = [WWTolls timeString22:[NSString stringWithFormat:@"%@",talkModel.createtime]];
        timeLable.font = MyFont(10.0);
        timeLable.textColor = [WWTolls colorWithHexString:@"#959595"];
        
        CGFloat contentWidth = playBarView.width - 12 - timeLable.x;
        NSString *contentTest = talkModel.content;
        CGFloat contentHeight = [WWTolls zdsHeigthForString:contentTest fontSize:14 andWidth:contentWidth];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeLable.x, timeLable.maxY + 6, contentWidth,contentHeight)];
        [playBarView addSubview:contentLabel];
        contentLabel.numberOfLines = 0;
        contentLabel.text = contentTest;
        contentLabel.font = MyFont(14.0);
        contentLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        
        CGFloat bottomY = coverImageView.maxY > contentLabel.maxY ? coverImageView.maxY : contentLabel.maxY;
        playBarView.height = bottomY + 13;
//        bgView.contentSize = CGSizeMake(SCREEN_WIDTH, playBarView.maxY + 13);
        //活动
    } else if ([talkModel.bartype isEqualToString:@"1"]){
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, newMessageLabel.maxY + 13, 40, 40)];
        [playBarView addSubview:headImageView];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"mrtx_98_98.png"]];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.maxX + 10, newMessageLabel.maxY + 18, 150, 14)];
        [playBarView addSubview:nameLabel];
        nameLabel.font = MyFont(14.0);
        nameLabel.text = talkModel.username;
        nameLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.x, nameLabel.maxY + 5, 150, 10)];
        [playBarView addSubview:timeLable];
        timeLable.text =
        timeLable.text = [WWTolls timeString22:[NSString stringWithFormat:@"%@",talkModel.createtime]];
        timeLable.font = MyFont(10.0);
        timeLable.textColor = [WWTolls colorWithHexString:@"#959595"];
        
        UIImageView *flagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headImageView.x + 2, headImageView.maxY + 10, 21, 21)];
        [playBarView addSubview:flagImageView];
        [flagImageView setImage:[UIImage imageNamed:@"huodong-42-42.png"]];
        
        NSString *contentTest = [NSString stringWithFormat:@"      %@",talkModel.content];
        CGFloat contentWidth = playBarView.width - 12 * 2;
        CGFloat contentHeight = [WWTolls zdsHeigthForString:contentTest fontSize:14.0 andWidth:contentWidth];
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.x, flagImageView.midY - 7, contentWidth, contentHeight)];
        [playBarView addSubview:contentLabel];
        contentLabel.text = contentTest;
        contentLabel.numberOfLines = 0;
        contentLabel.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
        contentLabel.font = MyFont(14.0);
        
        CGFloat bottomY = contentLabel.maxY > flagImageView.maxY ? contentLabel.maxY :flagImageView.maxY;
        playBarView.height = bottomY + 13;
//        bgView.contentSize = CGSizeMake(SCREEN_WIDTH, playBarView.maxY + 13);
    } else {
        playBarView.height = unreadImageView.maxY + 6;
    }
    
    return playBarView;
}

#pragma mark - Delegate

#pragma mark SSLAlertViewTapDelegate
- (void)sslCancelTapClick {
    self.joinButton.userInteractionEnabled = YES;
}

#pragma mark InputAlertViewDelegate
- (void)inputAlertViewFinishInput:(InputAlertView *)removeAlert withPassword:(NSString *)password {
    
    NSString *newPwd = [WWTolls encodePwd:password];
    NSString *truePwd = self.model.gmpassword;
    
    if (![newPwd isEqualToString:truePwd]) {
        [removeAlert ssl_hidden];
        [self showAlertMsg:@"密码不正确" andFrame:CGRectZero];
        self.joinButton.userInteractionEnabled = YES;
        return;
    }
    
    [self joinMyGameWithPassword:password];
    [removeAlert ssl_hidden];
}

- (void)inputAlertViewCancel:(InputAlertView *)removeAlert {
    self.joinButton.userInteractionEnabled = YES;
}

#pragma mark PublicTaskViewControllerDelegate
- (void)pubTaskSuccess {
    [self reloadGroupData];
}   

#pragma mark InitShareDelegate
-(void)confirmShare
{
    self.uploadWeightButton.userInteractionEnabled = YES;
    //    [self doneLoadingTableViewData];
    [self reloadGroupData];
}

#pragma mark GroupVisitorMore28ViewDelegate 28天团访客视角更多弹窗
- (void)groupVisitorMore28View:(GroupVisitorMore28View *)visitorMore28View buttonClickWithIndex:(NSInteger)index {
    
    //分享团组
    if (index == 0) {
        [self createGame];
    }
    //回减脂吧
    else {
        [self goHome];
    }
}

#pragma mark GroupCommanderMore28ViewDelegate  28天团团长更多弹窗
- (void)groupCommanderMore28View:(GroupCommanderMore28View *)commanderMore28View buttonClickWithIndex:(NSInteger)index {
    
    //--减脂进度
    if (index == 0) {
        [self planButton];
    }
    //--分享团组
    else if (index == 1) {
        
        [self createGame];
    }   
    //--回减脂吧
    else if (index == 2) {
        [self goHome];
    }
    //--解散团组 或 修改密码
    else if (index == 3) {
        //未开始 （28天团未开始时可以解散团组）
        if ([self.gamests isEqualToString:@"0"]) {
            
            //已提交
            if ([self.model.dissolvesub isEqualToString:@"0"]) {
                [self showAlertMsg:@"该团组解散申请已提交\n请耐心等待" andFrame:CGRectZero];
                [commanderMore28View ssl_hidden];
                return;
            }
            
            //解散团组
            [self breakUpGroup];
        } else {
            //修改密码
            [self goToUpdatePassword];
        }
    }
    //--修改密码
    else if (index == 4) {
        //修改密码
        [self goToUpdatePassword];
    }
}

#pragma mark GroupMemberMore28ViewDelegate  28天团团员更多弹窗
- (void)groupMemberMore28View:(GroupMemberMore28View *)memberMore28View buttonClickWithIndex:(NSInteger)index {
    //减脂进度
    if (index == 0) {
        [self planButton];
    }
    //分享团组
    else if (index == 1) {
        
        [self createGame];
    }
    //退出团组
    else if (index == 2) {
        [self deleteBtn:nil];
    }
    //回减脂吧
    else if (index == 3) {
        [self goHome];
    }
    
}

#pragma mark CommanderMoreAlertViewDelegate 普通团 团长更多回调
- (void)commanderMoreAlertView:(CommanderMoreAlertView *)moreAlertView buttonClickWithIndex:(NSInteger)index {
    
    //团组成员
    if (index == 0) {
        [self goToGroupUser];
    }
    //邀请好友
    else if (index == 1) {
        
        [self createShareView:GeneralGroupShareType];
    }
    //团组信息
    else if (index == 2) {
        [self goToGroupMessage];
    }
    //群发通知
    else if (index == 3) {
        SendAllMessageViewController *send = [[SendAllMessageViewController alloc] init];
        send.gameId = self.groupId;
        send.gameName = self.model.groupName;
        [self.navigationController pushViewController:send animated:YES];
    }   
    //解散团组
    else if (index == 4) {
        
        //已提交
        if ([self.model.dissolvesub isEqualToString:@"0"]) {
            [self showAlertMsg:@"该团组解散申请已提交\n请耐心等待" andFrame:CGRectZero];
            [moreAlertView ssl_hidden];
            return;
        }
        
        [self breakUpGroup];
    }
    //修改密码
    else if (index == 5) {
        //修改密码
        [self goToUpdatePassword];
    }
}

#pragma mark MoreAlertViewDelegate 普通团 团员更多回调
- (void)moreAlertView:(MoreAlertView *)moreAlertView buttonClickWithIndex:(NSInteger)index {
    
    //团组成员
    if (index == 0) {
        [self goToGroupUser];
    }
    //邀请团员
    else if (index == 1) {
        [self createShareView:GeneralGroupShareType];
    }
    //团组介绍
    else if (index == 2) {
        //页面没有写
        [self goToGroupMessage];
    }
    //退出团组
    else if (index == 3) {
        [self deleteBtn:nil];
    }
}

#pragma mark FinishAlertViewDelegate
- (void)finishAlertView:(FinishAlertView *)alertViewWithfinishButtonClick {
    [self requestWithFinishTask];
}

#pragma mark NARShareViewDelegate
#pragma mark 邀请
-(void)clickInvitationButton
{
    InvitationViewController *invitation = [[InvitationViewController alloc]initWithNibName:@"InvitationViewController" bundle:nil];
    invitation.gameid = self.groupId;
    invitation.userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    [self.navigationController pushViewController:invitation animated:YES];
}

#pragma mark 举报
- (void)shareViewDelegateReport {
    [self reportButtonSender];
}

#pragma mark 删除
- (void)shareViewDelegateDelete {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"是否确认删除？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    view.tag = 777;
    [view show];
}

#pragma mark 置顶回调
- (void)shareViewDelegateSetTop {
    
    [self topBar];
}

#pragma mark 取消置顶回调
- (void)shareViewDelegateCancelTop {
    
    [self topBar];
}   

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 888) {//加入弾框
        
        if (buttonIndex == 1) {
            //是否私密团
            if (self.model.gmpassword.length > 0) {
                
                InputAlertView *inputAlertView = [[InputAlertView alloc] initWithFrame:self.view.bounds];
                inputAlertView.delegate = self;
//                inputAlertView.sslDelegate = self;
                [inputAlertView createView];
                [self.view.window addSubview:inputAlertView];
                [inputAlertView ssl_show];
            } else {
                [self joinMyGameWithPassword:nil];
            }
            
        } else {
            self.joinButton.userInteractionEnabled = YES;
        }
    }
    else if(alertView.tag == 999){//退出弾框
        
        if (buttonIndex == 1) {
            [self ExitMyGame];
        }
    }
    else if (alertView.tag == 777) {//删除
        
        if (buttonIndex == 1) {
            
            GroupTalkModel *model = self.data[self.currentIndexPath.row];
            NSString *type = nil;
            
            if ([model.bartype isEqualToString:@"0"]) {
                type = @"1";
            } else if ([model.bartype isEqualToString:@"1"]) {
                type = @"2";
            }
            
            [self requestWithDeleteBarWithDeleteid:model.barid andDelType:type];
        }
    }
    else if (alertView.tag == 123) {
        if (buttonIndex == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"是否需要生成任务报告？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
            alert.tag = 456;
            [alert show];
        }
    }else if(alertView.tag == 456){
        if (buttonIndex == 1) {
            [self endTaskRequest:YES];
        }else if(buttonIndex == 0){
            [self endTaskRequest:NO];
        }
    }else if(alertView.tag == 124){
        if (buttonIndex == 1) {
            [self endTaskRequest:YES];
        }
    }else if(alertView.tag == 126){
        if (buttonIndex == 1){
            [self goToSubmitTask];
        }
    }
}

#pragma mark groupTalkCellDelegate
#pragma mark 举报
-(void)reportClick:(NSString*)discoverId AndType:(NSString*)type{
    talkid = discoverId;
    repotType = type;
    [self jubaoShare];
}

- (void)reportClick:(NSString *)talkId andType:(NSString *)type andIndexPath:(NSIndexPath *)indexPath {
    talkid = talkId;
    repotType = type;
    self.currentIndexPath = indexPath;
    [self jubaoShare];
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
    [myActionSheetView showInView:self.view];
    
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    
    [self hideMenu];
    self.typeIntro.hidden = YES;
    
    [self scrollViewDidScrollWithOffset:scrollView.contentOffset.y + 60];
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset {
    
    if (scrollOffset < 0)
        self.imageView.transform = CGAffineTransformMakeScale(1 - (scrollOffset / 100), 1 - (scrollOffset / 100));
    else
        self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

#pragma mark - actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
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

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.model.gamemode isEqualToString:@"3"]) {//欢乐团组
        return 3;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (section == 1 && [self.model.gamemode isEqualToString:@"3"]) {
        return self.ArticleData.count;
    }
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && [self.model.gamemode isEqualToString:@"3"]) {
        GroupTalkModel *model = self.ArticleData[indexPath.row];
        if (!model.imageurl || model.imageurl.length<1) {
            NSString *content = [[model.talkcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            CGFloat heigh = [WWTolls heightForString:content fontSize:14 andWidth:SCREEN_WIDTH - 30];
            if (heigh<72) {
                return 68 + heigh;
            }
        }
        return 136;
    }
    GroupTalkModel *model = self.data[indexPath.row];

    
    //活动
    if ([model.bartype isEqualToString:@"1"]) {
        return [ZDSGroupActCell getMyCellHeightWithModel:self.data[indexPath.row]];
    }
    
    //冒泡
    if ([model.bartype isEqualToString:@"2"]) {
        return 60;
    }   
    
    CGFloat h = [self.groupCell getMyCellHeight:self.data[indexPath.row]] + 6;
    h+=2;
    if (indexPath.row == 0) {
        h -= 10;
    }
    return h;
}

#pragma mark - 脚视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ([self.model.gamemode isEqualToString:@"3"] && section == 1 && self.ArticleData.count>0) {
        return 45;
    }
    if (section == 2 || (section == 1 && ![self.model.gamemode isEqualToString:@"3"])) {
        if (![self.gameangle isEqualToString:@"3"]) {//创建仅指导
            return 47;
        }else{
            self.footerView.height = 0;
            return 0;
        }
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([self.model.gamemode isEqualToString:@"3"] && section == 1 && self.ArticleData.count>0) {
        //tableView脚视图
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        
        //更多团组
        UILabel *lbl = [[UILabel alloc] init];
        lbl.backgroundColor = [UIColor whiteColor];
        lbl.frame = CGRectMake(-1, 0, SCREEN_WIDTH+2, 40);
        lbl.text = @"查看更多";
        lbl.font = MyFont(14);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
        lbl.layer.borderWidth = 0.5;
        lbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        [footer addSubview:lbl];
        lbl.userInteractionEnabled = YES;
        //更多
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMoreArticle)];
        [lbl addGestureRecognizer:tap];
        UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ckgd-32"]];
        more.frame = CGRectMake(lbl.width/2+30, 12.5, 14, 14);
        UIView *lastline = [[UIView alloc] initWithFrame:CGRectMake(0, lbl.bottom, SCREEN_WIDTH, 10)];
        lastline.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        [footer addSubview:lastline];
        [footer addSubview:more];
        return footer;
    }
    UIView *foot = [[UIView alloc] init];
    foot.userInteractionEnabled = NO;
    return foot;
}

#pragma mark - 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        if ([self.model.gamemode isEqualToString:@"3"] && self.data.count>0) {
            
            UIView *playBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            playBar.backgroundColor = [UIColor whiteColor];
//            playBar.layer.borderWidth = 0.5;
//            playBar.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 39.5, SCREEN_WIDTH - 28, 0.5)];
            line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
            [playBar addSubview:line];
            UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,11, 18, 18)];
            [barImageView setImage:[UIImage imageNamed:@"lhb-36"]];
            [playBar addSubview:barImageView];
            
            UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 10, 13, 80, 15)];
            barLabel.font = MyFont(15);
            barLabel.text = @"乐活吧";
            barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
            [playBar addSubview:barLabel];
            return playBar;
        }
    }
    
    if (section == 1) {
        
        if(self.data.count == 0 && self.ArticleData.count == 0){
            
            UIView *back = [[UIView alloc] init];
            back.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
            
            CGFloat h = 5;
            if (![self.model.gamemode isEqualToString:@"3"]) {
                h = 40;
                UIView *playBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
                [back addSubview:playBar];
                UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 77)/2, 9, 18, 18)];
                [barImageView setImage:[UIImage imageNamed:@"lhb-36"]];
                [playBar addSubview:barImageView];
                UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 5, 10, 80, 15)];
                barLabel.font = MyFont(17);
                barLabel.text = @"乐活吧";
                barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
                [playBar addSubview:barLabel];

            }
            
            UILabel *huashu = [[UILabel alloc] init];
            huashu.backgroundColor = [UIColor clearColor];
            huashu.text = @"还没有人发言，求破冰~(●'◡'●)ﾉ♥";
            if ([self.gameangle isEqualToString:@"3"]) {
                huashu.text = @"还没有人发言哦~(●'◡'●)ﾉ♥";
            }
            if (!self.talkBarLoadDone) {
                huashu.text = @"加载中...";
            }
            huashu.textColor = [WWTolls colorWithHexString:@"#959595"];
            huashu.textAlignment = NSTextAlignmentCenter;
            huashu.font = MyFont(14);
            huashu.frame= CGRectMake(0, h, SCREEN_WIDTH, 22);
            [back addSubview:huashu];
            
            return back;
        }
        UIView *playBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        playBar.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
        UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 77)/2, 9, 18, 18)];
        [barImageView setImage:[UIImage imageNamed:@"lhb-36"]];
        [playBar addSubview:barImageView];
        
        UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 5, 10, 80, 15)];
        barLabel.font = MyFont(17);
        barLabel.text = @"乐活吧";
        barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
        [playBar addSubview:barLabel];
        if ([self.model.gamemode isEqualToString:@"3"]) {
            
            playBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
            playBar.backgroundColor = [UIColor whiteColor];
//            playBar.layer.borderWidth = 0.8;
//            playBar.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;

            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 39.5, SCREEN_WIDTH - 28, 0.5)];
            line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
            [playBar addSubview:line];
            
            UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,11, 18, 18)];
            [barImageView setImage:[UIImage imageNamed:@"game_playbar_titleIcon"]];
            [playBar addSubview:barImageView];
        
            UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 10, 12, 80, 17)];
            barLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
            barLabel.text = @"精华帖";
            barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
            [playBar addSubview:barLabel];
            UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ckgd-32"]];
            img.frame = CGRectMake(SCREEN_WIDTH - 31, 12, 16, 16);
            [playBar addSubview:img];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMoreArticle)];
            [playBar addGestureRecognizer:tap];
        }
        return playBar;
    }
    if ([self.model.gamemode isEqualToString:@"3"]) {//欢乐团
        if (section == 0) {
            //团长
            if ([self.gameangle isEqualToString:@"1"]) {
                return [self setUpGeneralGroupCommanderUI];
            }
            //团员
            if ([self.gameangle isEqualToString:@"2"]) {
                return [self setUpGeneralGroupMemberUI];
            }
        }        return [[UIView alloc] init];
    }else{
        
        UIView *headView = [[UIView alloc] init];
        
        if (self.model.groupName.length > 0 || self.model.username.length > 0) {
            
            //标题
            self.titleLabel.text = self.model.groupName.length <  1? @"" : self.model.groupName;
            
            //背景视图
            headView.backgroundColor = RGBCOLOR(239, 239, 239);
            
            //团长视图背景
            UIView *xuanback = [[UIView alloc] init];
            xuanback.frame = CGRectMake(0, 0, SCREEN_WIDTH, 77);
            xuanback.backgroundColor = [UIColor whiteColor];
            [headView addSubview:xuanback];
            
            //头像
            UIButton *headerView = [[UIButton alloc] init];
            [xuanback addSubview:headerView];
            [headerView sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.headerImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
            [headerView setBackgroundImage:nil forState:UIControlStateHighlighted];
            headerView.titleLabel.text = self.model.gamecrtor;
            [headerView addTarget:self action:@selector(clickPater:) forControlEvents:UIControlEventTouchUpInside];
            headerView.frame = CGRectMake(7, 7, 40, 40);
            headerView.layer.cornerRadius = 20;
            headerView.clipsToBounds = YES;
            
            //昵称
            UILabel *lbl = [[UILabel alloc] init];
            lbl.frame = CGRectMake(7, 45,40, 28);
            lbl.textColor = RGBCOLOR(78, 78, 78);
            //    lbl.adjustsFontSizeToFitWidth = YES;
            lbl.text = self.model.username;
            if (lbl.text.length<4) {
                lbl.font = MyFont(13);
            }else if(lbl.text.length <7){
                lbl.font = MyFont(9);
            }else{
                lbl.font = MyFont(8);
            }
            lbl.numberOfLines = 3;
            lbl.textAlignment = NSTextAlignmentCenter;
            [xuanback addSubview:lbl];
            
            //团组宣言
            UILabel *msg = [[UILabel alloc] init];
            msg.frame = CGRectMake(54, 4, SCREEN_WIDTH-68, 50);
            msg.font = MyFont(12);
            msg.numberOfLines = 0;
            msg.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
            msg.textAlignment = NSTextAlignmentLeft&&NSTextAlignmentCenter;
            msg.text = self.model.xuanyan;
            [xuanback addSubview:msg];
            
            //团长编辑按钮
            if ([self.gameangle isEqualToString:@"0"]||[self.gameangle isEqualToString:@"1"]) {
                
                UIButton *btn = [[UIButton alloc] init];
                btn.frame = CGRectMake(SCREEN_WIDTH - 30 - 8, 50, 30, 20);
                btn.titleLabel.font = MyFont(10);
                [btn setTitle:@"编辑" forState:UIControlStateNormal];
                [btn setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
                [xuanback addSubview:btn];
                
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
                image.center = btn.center;
                image.bounds = CGRectMake(0, 0, 10, 10);
                image.left+=15;
                [xuanback addSubview:image];
                [btn addTarget:self action:@selector(EditorXuanyan) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //团组封面
            XimageView *showImage = [[XimageView alloc] init];
            showImage.backgroundColor = [UIColor whiteColor];
            [headView addSubview:showImage];
            [showImage sd_setImageWithURL:[NSURL URLWithString:self.model.groupImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.image = image;
            }];
            
            showImage.frame = CGRectMake(7, 83, SCREEN_WIDTH - 14, SCREEN_WIDTH - 14);
            
            //介绍类别视图
            UIView *big = [[UIView alloc] init];
            big.hidden = YES;
            big.frame = self.view.bounds;
            big.backgroundColor = [UIColor clearColor];
            [headView addSubview:big];
            
            UIView *back = [[UIView alloc] init];
            back.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
            back.layer.borderWidth = 0.5;
            self.typeIntro = big;
            back.frame = CGRectMake((SCREEN_WIDTH-278)/2, 137, 278, 145);
            [big addSubview:back];
            back.layer.cornerRadius = 5;
            back.clipsToBounds = YES;
            back.backgroundColor = [UIColor whiteColor];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideType:)];
            [big addGestureRecognizer:tap];
            
            //类别标签
            UIButton *typeBtn = [[UIButton alloc] init];
            
            //欢乐
            if ([self.model.groupType isEqualToString:@"2"]) {
                
                [typeBtn setBackgroundImage:[UIImage imageNamed:@"group_huanle_tip"] forState:UIControlStateNormal];
                
                //介绍类别标题
                UILabel *title = [[UILabel alloc] init];
                title.text = @"欢乐模式";
                title.font = MyFont(18);
                title.textColor = ZDS_DHL_TITLE_COLOR;
                title.textAlignment = NSTextAlignmentCenter;
                title.frame = CGRectMake(0, 0, 278, 40);
                [back addSubview:title];
                
                //介绍类别线
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
                line.frame = CGRectMake(0, 40, 278, 0.5);
                [back addSubview:line];
                
                //介绍类别文字
                UILabel *intrLbl1 = [[UILabel alloc] init];
                intrLbl1.frame = CGRectMake(15, 62, 246, 13);
                intrLbl1.font = MyFont(12);
                intrLbl1.text = @"（1）完成28天减重4%的目标";
                intrLbl1.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                [back addSubview:intrLbl1];
                
                UILabel *intrLbl2 = [[UILabel alloc] init];
                intrLbl2.frame = CGRectMake(15, intrLbl1.bottom+7, 246, 13);
                intrLbl2.font = MyFont(12);
                intrLbl2.text = @"（2）随时上传体重，记录体重变化";
                intrLbl2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                [back addSubview:intrLbl2];
                
                UILabel *intrLbl3 = [[UILabel alloc] init];
                intrLbl3.frame = CGRectMake(15, intrLbl2.bottom+7, 246, 13);
                intrLbl3.font = MyFont(12);
                intrLbl3.text = @"（3）与团组成员们多交流，互相监督、鼓励~";
                intrLbl3.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                
                [back addSubview:intrLbl3];
                
                typeBtn.frame = CGRectMake(SCREEN_WIDTH - 75, 0, 61, 20);
                
                //闯关
            }else if ([self.model.groupType isEqualToString:@"1"]){
                
                [typeBtn setBackgroundImage:[UIImage imageNamed:@"group_chuangguan_tip"] forState:UIControlStateNormal];
                //介绍类别标题
                UILabel *title = [[UILabel alloc] init];
                title.text = @"28天瘦4%";
                title.font = MyFont(18);
                title.textColor = ZDS_DHL_TITLE_COLOR;
                title.textAlignment = NSTextAlignmentCenter;
                title.frame = CGRectMake(0, 0, 278, 40);
                [back addSubview:title];
                //介绍类别线
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
                line.frame = CGRectMake(0, 40, 278, 0.5);
                [back addSubview:line];
                //介绍类别文字
                UILabel *intrLbl1 = [[UILabel alloc] init];
                intrLbl1.frame = CGRectMake(11, 52, 246, 13);
                intrLbl1.font = MyFont(12);
                intrLbl1.text = @"（1）4周减重4%，";
                intrLbl1.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                [back addSubview:intrLbl1];
                intrLbl1 = [[UILabel alloc] init];
                intrLbl1.frame = CGRectMake(41, 72, 266, 13);
                intrLbl1.font = MyFont(12);
                intrLbl1.text = @"每周减重目标：0.5%、0.5%、1%、2%";
                intrLbl1.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                [back addSubview:intrLbl1];
                UILabel *intrLbl2 = [[UILabel alloc] init];
                intrLbl2.frame = CGRectMake(11, intrLbl1.bottom+7, 246, 13);
                intrLbl2.font = MyFont(12);
                intrLbl2.text = @"（2）开团前2天及每周结束时，上传体重照片";
                intrLbl2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                [back addSubview:intrLbl2];
                UILabel *intrLbl3 = [[UILabel alloc] init];
                intrLbl3.frame = CGRectMake(11, intrLbl2.bottom+7, 246, 13);
                intrLbl3.font = MyFont(12);
                intrLbl3.text = @"（3）脂斗士审核通过体重照片后，即可过关";
                intrLbl3.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
                [back addSubview:intrLbl3];
                typeBtn.frame = CGRectMake(SCREEN_WIDTH - 82, 0, 68, 20);
            }
            
            [typeBtn addTarget:self action:@selector(clickType) forControlEvents:UIControlEventTouchUpInside];
            
            [showImage addSubview:typeBtn];
            
            
            //团组标签
            //左标签
            UILabel *bottomLbl = [[UILabel alloc] init];
            bottomLbl.font = MyFont(13);
            bottomLbl.textColor = [UIColor whiteColor];
            bottomLbl.textAlignment = NSTextAlignmentRight;
            bottomLbl.frame = CGRectMake(SCREEN_WIDTH - 114, showImage.height-68, 93, 20);
            //左标签背景
            UIImageView *bottomBkView = [[UIImageView alloc] init];
            bottomBkView.frame = CGRectMake(SCREEN_WIDTH - 114, showImage.height-68, 100, 20);
            bottomBkView.image = [UIImage imageNamed:@"tagright"];
            [showImage addSubview:bottomBkView];
            [showImage addSubview:bottomLbl];
            
            //右标签
            UILabel *topLbl = [[UILabel alloc] init];
            topLbl.font = MyFont(13);
            topLbl.textColor = [UIColor whiteColor];
            topLbl.frame = CGRectMake(7, 0, 100, 20);
            topLbl.textAlignment = NSTextAlignmentLeft;
            //右标签背景
            UIImageView *topBkView = [[UIImageView alloc] init];
            topBkView.frame = CGRectMake(0, 0, 100, 20);
            topBkView.image = [UIImage imageNamed:@"tagleft"];
            [showImage addSubview:topBkView];
            [showImage addSubview:topLbl];
            NSArray *tags = [self.model.groupTags componentsSeparatedByString:@","];
            //隐藏标签
            bottomLbl.hidden = YES;
            bottomBkView.hidden = YES;
            topLbl.hidden = YES;
            topBkView.hidden = YES;
            if (self.model.groupTags.length == 0 || self.model.groupTags == nil || [self.model.groupTags isEqualToString:@"null"]) {
            }else{
                if ([self.model.groupTags rangeOfString:@","].length==0) {
                    bottomLbl.hidden = YES;
                    bottomBkView.hidden = YES;
                    topLbl.hidden = YES;
                    topBkView.hidden = YES;
                    if (self.model.groupTags.length>0&&![self.model.groupTags isEqualToString:@"null"]) {
                        topLbl.text = self.model.groupTags;
                        topLbl.hidden = NO;
                        topBkView.hidden = NO;
                    }
                }else{
                    NSString *sn = (NSString*)tags[0];
                    if(sn.length>0){//瘦哪里标签
                        topLbl.hidden = NO;
                        topBkView.hidden = NO;
                        topLbl.text = [sn componentsSeparatedByString:@"|"][0];
                        
                    }
                    NSString *zms = (NSString*)tags[1];
                    if(zms.length>0){//怎么瘦标签
                        bottomLbl.hidden = NO;
                        bottomBkView.hidden = NO;
                        bottomLbl.text = [zms componentsSeparatedByString:@"|"][0];
                    }
                }
            }
            //概述视图
            //概述背景
            UIView *msgBack = [[UIView alloc] init];
            msgBack.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
            msgBack.frame = CGRectMake(7,showImage.bottom - 48,SCREEN_WIDTH - 14,48);
            [headView addSubview:msgBack];
            
            //人数
            UIImageView *personSumimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_renshu-32-32"]];
            personSumimage.frame = CGRectMake(20*SCREEN_WIDTH/320.0, 8, 16, 16);
            [msgBack addSubview:personSumimage];
            
            UILabel *lbl1 = [[UILabel alloc] init];
            lbl1.font = MyFont(12);
            lbl1.text = @"参与减脂";
            lbl1.textColor = [UIColor whiteColor];
            lbl1.frame = CGRectMake(personSumimage.right + 2, 8, 64, 16);
            [msgBack addSubview:lbl1];
            
            UILabel *personSum = [[UILabel alloc] init];
            personSum.frame = CGRectMake(personSumimage.left + 8, 26, 53, 14);
            personSum.textColor = [UIColor whiteColor];
            personSum.font = MyFont(14);
            personSum.textAlignment = NSTextAlignmentCenter;
            if ([self.model.isfull isEqualToString:@"0"]) {
                personSum.text = [NSString stringWithFormat:@"%@(满)",self.model.userSum];
            } else{
                personSum.text = [NSString stringWithFormat:@"%@人",self.model.userSum];
            }
            
            [msgBack addSubview:personSum];
            //时间
            UIImageView *timeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_time-32-32"]];
            timeImage.frame = CGRectMake(128*SCREEN_WIDTH/320.0, 8, 16, 16);
            [msgBack addSubview:timeImage];
            UILabel *lbl2 = [[UILabel alloc] init];
            lbl2.font = MyFont(12);
            lbl2.text = @"起止时间";
            lbl2.textColor = [UIColor whiteColor];
            lbl2.frame = CGRectMake(timeImage.right + 2, 8, 64, 16);
            [msgBack addSubview:lbl2];
            UILabel *time = [[UILabel alloc] init];
            time.frame = CGRectMake(timeImage.left - 10, 26, 88, 15);
            time.textColor = [UIColor whiteColor];
            time.font = MyFont(14);
            time.textAlignment = NSTextAlignmentCenter;
            time.text = [NSString stringWithFormat:@"%@-%@",
                         [WWTolls configureTimeString:self.model.beginTime andStringType:@"M.d"],[WWTolls configureTimeString:self.model.endTime andStringType:@"M.d"]];
            [msgBack addSubview:time];
            if (![self.gameangle isEqualToString:@"3"]&&[self.model.groupType isEqualToString:@"1"]) {//参与者--上传人数
                UIImageView *upweightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_uploadPersonSum-32-32"]];
                upweightImage.frame = CGRectMake(214*SCREEN_WIDTH/320.0, 8, 16, 16);
                [msgBack addSubview:upweightImage];
                UILabel *lbl3 = [[UILabel alloc] init];
                lbl3.font = MyFont(12);
                if([self.model.passtype isEqualToString:@"1"]) lbl3.text = @"初审通过";
                else if([self.model.passtype isEqualToString:@"3"]){
                    lbl3.text = @"通关";
                    upweightImage.left+=9;
                }
                else if([self.model.passtype isEqualToString:@"2"]) lbl3.text = @"本周过关";
                lbl3.textAlignment = NSTextAlignmentCenter;
                lbl3.textColor = [UIColor whiteColor];
                lbl3.frame = CGRectMake(upweightImage.right + 2, 8, 50, 16);
                [msgBack addSubview:lbl3];
                UILabel *upweightLbl = [[UILabel alloc] init];
                upweightLbl.frame = CGRectMake(upweightImage.left + 3, 26, 70, 14);
                upweightLbl.textColor = [UIColor whiteColor];
                upweightLbl.font = MyFont(14);
                upweightLbl.textAlignment = NSTextAlignmentCenter;
                upweightLbl.text = [NSString stringWithFormat:@"%@人",self.model.upWeightUserSum];
                [msgBack addSubview:upweightLbl];
            }else{//访客目标
                UIImageView *upweightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_uploadPersonSum-32-32"]];
                upweightImage.frame = CGRectMake(237*SCREEN_WIDTH/320.0, 8, 16, 16);
                [msgBack addSubview:upweightImage];
                UILabel *lbl3 = [[UILabel alloc] init];
                lbl3.font = MyFont(12);
                lbl3.text = @"目标";
                lbl3.textColor = [UIColor whiteColor];
                lbl3.frame = CGRectMake(upweightImage.right + 2, 8, 32, 16);
                [msgBack addSubview:lbl3];
                UILabel *upweightLbl = [[UILabel alloc] init];
                upweightLbl.frame = CGRectMake(upweightImage.left - 10, 26, 68, 14);
                upweightLbl.textColor = [UIColor whiteColor];
                upweightLbl.font = MyFont(12);
                upweightLbl.textAlignment = NSTextAlignmentCenter;
                upweightLbl.text = [NSString stringWithFormat:@"减重%@%%",self.model.gametask];
                [msgBack addSubview:upweightLbl];
            }
            
            UIView *mbBack = [[UIView alloc] init];
            mbBack.frame = CGRectMake(7, SCREEN_WIDTH - 14 + 83 , SCREEN_WIDTH - 14, 0);
            [headView addSubview:mbBack];
            if ([self.gameangle isEqualToString:@"0"]|| [self.gameangle isEqualToString:@"2"]) {//参与者，创建并参与  目标视图164
                mbBack.backgroundColor = [UIColor whiteColor];
                mbBack.height = 160;
                PICircularProgressView *pic = [[PICircularProgressView alloc] init];
                pic.roundedHead = 0;
                
                //        pic.outerBackgroundColor = [UIColor whiteColor];
                pic.outerBackgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
                pic.innerBackgroundColor = [UIColor whiteColor];
                pic.progressFillColor =[WWTolls colorWithHexString:@"#9f87cb"];
                pic.showShadow = 0;
                pic.thicknessRatio = 0.27;
                pic.frame = CGRectMake(18, 20, 130, 130);
                [mbBack addSubview:pic];
                pic.progress = [self.model.mecomplete floatValue]/100.0;
                //贴图
                UIImageView *tip = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_jianzhijindu"]];
                tip.frame = CGRectMake(126, 27, 71, 20);
                [mbBack addSubview:tip];
                //目标 2o762
                UILabel *l2,*l1;
                if ([self.model.gamests isEqualToString:@"5"]) {
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 78, 62, 14);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(14);
                    [mbBack addSubview:l2];
                    l2.text = @"已结束";
                }else{
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 15, 62, 17);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#535353"];
                    l1.font = MyFont(17);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"%@天",self.model.disendtime];
                    UILabel *l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 32, 62, 14);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(14);
                    [mbBack addSubview:l2];
                    if([self.gamests isEqualToString:@"0"]){
                        l2.text = @"距离开始";
                        l1.text = [NSString stringWithFormat:@"%@天",self.model.disstrtime];
                    }
                    else l2.text = @"距离结束";
                    
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 62, 62, 19);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#535353"];
                    l1.font = MyFont(17);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"%@Kg",self.model.nowWeight];
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 81, 62, 15);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(14);
                    [mbBack addSubview:l2];
                    l2.text = @"当前体重";
                    
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 109, 62, 19);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#535353"];
                    l1.font = MyFont(17);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"%@Kg",self.model.needlose];
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(207*SCREEN_WIDTH/320.0, 128, 62, 14);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(14);
                    [mbBack addSubview:l2];
                    l2.text = @"还需减重";
                }
                
                
                
                
                if (![self.gamests isEqualToString:@"5"]&&[self.model.groupType isEqualToString:@"1"]) {//不是已结束
                    mbBack.height = 250;
                    //目标标题
                    UIView *backview = [[UIView alloc] init];
                    backview.backgroundColor = RGBCOLOR(239, 239, 239);
                    backview.frame = CGRectMake(0, 164, SCREEN_WIDTH - 14, 21);
                    [mbBack addSubview:backview];
                    UIImageView *image = [[UIImageView alloc] init];
                    image.frame = CGRectMake(0, 5, SCREEN_WIDTH - 14, 11*SCREEN_WIDTH/320.0);
                    image.image = [UIImage imageNamed:@"group_tag610-22"];
                    [backview addSubview:image];
                    
                    //周目标
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(0, 196, 76*SCREEN_WIDTH/320.0, 15);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#565bd9"];
                    l1.font = MyFont(14);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"第%@周",self.model.whichweek];
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(0, 219, 76*SCREEN_WIDTH/320.0, 15);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(12);
                    [mbBack addSubview:l2];
                    l2.text = [NSString stringWithFormat:@"%@-%@",[WWTolls configureTimeString:self.model.psbegintime andStringType:@"M.d"],[WWTolls configureTimeString:self.model.psendtime andStringType:@"M.d"]];
                    UIView *line = [[UIView alloc] init];
                    line.backgroundColor = [WWTolls colorWithHexString:@"#959595"];
                    line.frame = CGRectMake(77*SCREEN_WIDTH/320.0, 192, 0.5, 53);
                    [mbBack addSubview:line];
                    
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(77*SCREEN_WIDTH/320.0, 196, 76*SCREEN_WIDTH/320.0, 15);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#565bd9"];
                    l1.font = MyFont(14);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"任务"];
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(77*SCREEN_WIDTH/320.0, 219, 76*SCREEN_WIDTH/320.0, 15);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(12);
                    [mbBack addSubview:l2];
                    l2.text = [NSString stringWithFormat:@"减重%@%%",self.model.pstask];
                    line = [[UIView alloc] init];
                    line.backgroundColor = [WWTolls colorWithHexString:@"#959595"];
                    line.frame = CGRectMake(155*SCREEN_WIDTH/320.0, 192, 0.5, 53);
                    [mbBack addSubview:line];
                    
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(155*SCREEN_WIDTH/320.0, 196, 77*SCREEN_WIDTH/320.0, 15);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#565bd9"];
                    l1.font = MyFont(14);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"目标体重"];
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(155*SCREEN_WIDTH/320.0, 219, 77*SCREEN_WIDTH/320.0, 15);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(12);
                    [mbBack addSubview:l2];
                    l2.text = [NSString stringWithFormat:@"%@kg",self.model.phgoalweg];
                    line = [[UIView alloc] init];
                    line.backgroundColor = [WWTolls colorWithHexString:@"#959595"];
                    line.frame = CGRectMake(232*SCREEN_WIDTH/320.0, 192, 0.5, 53);
                    [mbBack addSubview:line];
                    
                    l1 = [[UILabel alloc] init];
                    l1.frame = CGRectMake(232*SCREEN_WIDTH/320.0, 196, 77*SCREEN_WIDTH/320.0, 15);
                    l1.textAlignment = NSTextAlignmentCenter;
                    l1.textColor = [WWTolls colorWithHexString:@"#565bd9"];
                    l1.font = MyFont(14);
                    [mbBack addSubview:l1];
                    l1.text = [NSString stringWithFormat:@"斗币奖励"];
                    l2 = [[UILabel alloc] init];
                    l2.frame = CGRectMake(232*SCREEN_WIDTH/320.0, 219, 77*SCREEN_WIDTH/320.0, 15);
                    l2.textAlignment = NSTextAlignmentCenter;
                    l2.textColor = [WWTolls colorWithHexString:@"#959595"];
                    l2.font = MyFont(12);
                    [mbBack addSubview:l2];
                    l2.text = [NSString stringWithFormat:@"%@",self.model.score];
                }
                
                
            }
            if ([self.gameangle isEqualToString:@"1"]) {//仅指导
                mbBack.backgroundColor = [UIColor clearColor];
                mbBack.height = 20;
                UILabel *jujieshu = [[UILabel alloc] init];
                jujieshu.frame = mbBack.bounds;
                jujieshu.textAlignment = NSTextAlignmentCenter;
                jujieshu.font = MyFont(12);
                jujieshu.textColor = [WWTolls colorWithHexString:@"#80cafb"];
                jujieshu.top += 2;
                [mbBack addSubview:jujieshu];
                if ([self.gamests isEqualToString:@"5"]) {
                    jujieshu.text = @"已结束";
                }else if([self.gamests isEqualToString:@"0"]){
                    jujieshu.text = [NSString stringWithFormat:@"距开始还有%@天",self.model.disstrtime];
                }else{
                    jujieshu.text = [NSString stringWithFormat:@"距结束还有%@天",self.model.disendtime];
                }
            }
            
            UIButton *joinBtn = [[UIButton alloc] init];
            joinBtn.frame = CGRectMake(7, mbBack.bottom, SCREEN_WIDTH - 14, 0);
            
            //显示上传按钮
            if ([self.model.showupload isEqualToString:@"0"]) {
                joinBtn.height = 40*SCREEN_WIDTH/320.0;
                [joinBtn setBackgroundImage:[UIImage imageNamed:UploadWeightImage] forState:UIControlStateNormal];
                [joinBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
                //        joinBtn.backgroundColor = [UIColor redColor];
                [joinBtn addTarget:self action:@selector(postWeightButton:) forControlEvents:UIControlEventTouchUpInside];
                
            } else {
                //游客身份 团组阶段为未开始
                if ([self.gameangle isEqualToString:@"3"] && [self.gamests isEqualToString:@"0"]) {
                    joinBtn.height = 40;
                    [joinBtn setBackgroundImage:[UIImage imageNamed:@"group_join-612-80"] forState:UIControlStateNormal];
                    [joinBtn addTarget:self action:@selector(joinButton:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            [headView addSubview:joinBtn];
            
            UIView *groupBack = [[UIView alloc] init];
            groupBack.backgroundColor = [UIColor whiteColor];
            groupBack.clipsToBounds = YES;
            groupBack.layer.cornerRadius = 4;
            groupBack.frame = CGRectMake(7, joinBtn.bottom+6, SCREEN_WIDTH - 14, 60);
            [headView addSubview:groupBack];
            //团组成员头像
            CGFloat margin = 9;
            CGFloat width = 40;
            CGFloat x = 9;
            for (int i = 0; i<self.model.userArray.count; i++) {
                UIButton *head = [[UIButton alloc] init];
                head.frame = CGRectMake(x, 10, width, width);
                head.clipsToBounds = YES;
                head.layer.cornerRadius = width/2;
                head.titleLabel.text = self.model.userArray[i][@"userid"];
                [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.userArray[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
                [head addTarget:self action:@selector(clickPater:) forControlEvents:UIControlEventTouchUpInside];
                [groupBack addSubview:head];
                if (i == 0) {
                    UIImageView *tuanzhang = [[UIImageView alloc] init];
                    tuanzhang.image = [UIImage imageNamed:@"tuanzhang_40"];
                    tuanzhang.frame = CGRectMake(x+25, 35, 15, 15);
                    [groupBack addSubview:tuanzhang];
                }
                x+=margin+width;
                if(SCREEN_WIDTH == 320){
                    if (i==3&&![self.gameangle isEqualToString:@"3"]&&[self.gamests isEqualToString:@"0"]) {//参与者创建并参与
                        break;
                    }
                    if(i==4){
                        break;
                    }
                }else{
                    if (i==4&&![self.gameangle isEqualToString:@"3"]&&[self.gamests isEqualToString:@"0"]) {//参与者创建并参与
                        break;
                    }
                    if(i==5){
                        break;
                    }
                    
                }
            }
            
            //人数按钮
            UIButton *moreBtn = [[UIButton alloc] init];
            moreBtn.frame = CGRectMake(x, 10, width, width);
            [groupBack addSubview:moreBtn];
            moreBtn.layer.cornerRadius = width/2;
            moreBtn.clipsToBounds = YES;
            [moreBtn setBackgroundImage:[UIImage imageNamed:@"group_personSum-80-80"] forState:UIControlStateNormal];
            [moreBtn setTitle:self.model.userSum forState:UIControlStateNormal];
            [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            moreBtn.titleLabel.font = MyFont(12);
            [moreBtn addTarget:self action:@selector(goToGroupUser) forControlEvents:UIControlEventTouchUpInside];
            x+=margin+width;
            //邀请按钮
            if(![self.gameangle isEqualToString:@"3"]&&[self.gamests isEqualToString:@"0"]){//参与者
                UIButton *moreBtn = [[UIButton alloc] init];
                moreBtn.frame = CGRectMake(x, 10, width, width);
                [groupBack addSubview:moreBtn];
                moreBtn.layer.cornerRadius = width/2;
                moreBtn.clipsToBounds = YES;
                [moreBtn setBackgroundImage:[UIImage imageNamed:@"group_yaoqing-80-80"] forState:UIControlStateNormal];
                [moreBtn addTarget:self action:@selector(invitationButton:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return headView;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        if([self.model.gamemode isEqualToString:@"3"] && self.data.count>0){
            return 40;
        }
    }
    
    if ([self.model.gamemode isEqualToString:@"3"]) {//欢乐团
        if (section == 0) {
            //团长
            if ([self.gameangle isEqualToString:@"1"]) {
                return [self setUpGeneralGroupCommanderUI].height;
            }
            //团员
            if ([self.gameangle isEqualToString:@"2"]) {
                return [self setUpGeneralGroupMemberUI].height;
            }
        }
        if (section == 1) {
            if(self.data.count == 0 && self.ArticleData.count == 0) return 15;
            if (self.ArticleData.count == 0) {
                return 0;
            }
            return 40;
        }
        return 0;
    }
    
    if (section == 1) {
        if(self.data.count == 0) return 50;
        return 39;
    }
    
    CGFloat h = 0;
    
    //是否显示上传体重按钮

    if ([self.model.showupload isEqualToString:@"0"]) {
        h = 40 * SCREEN_WIDTH/320.0;
    }
    
    if([self.gameangle isEqualToString:@"0"]||[self.gameangle isEqualToString:@"2"]){//参与者，创建并参与
        if (![self.gamests isEqualToString:@"5"]&&[self.model.groupType isEqualToString:@"1"]){//;闯关
            return 711 - 306 + SCREEN_WIDTH - 14 + h -10 + 10*SCREEN_WIDTH/320.0;
        }
        return 621 - 306 + SCREEN_WIDTH - 14 + h;
    }else if([self.gameangle isEqualToString:@"1"]){//创建仅指导
        return 480 - 306 + SCREEN_WIDTH - 14 + h;
    }else if([self.gameangle isEqualToString:@"3"]&&[self.gamests isEqualToString:@"0"]){//游客
        return 500 - 306 + SCREEN_WIDTH - 14 + h;
    }else if([self.gameangle isEqualToString:@"3"]){
        return 460 - 306 + SCREEN_WIDTH - 14 + h;
    }
    //    h += [WWTolls heightForString:self.content fontSize:14 andWidth:306];
    return 455 - 306 + SCREEN_WIDTH - 14 + h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && [self.model.gamemode isEqualToString:@"3"]){//精华帖子
        static NSString *CellIdentifier = @"ZDSGroupActicalCell";
        ArticleTableViewCell *articleCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (articleCell == nil) {
            articleCell = [ArticleTableViewCell loadNib];
        }
        [articleCell setUpWithTalkModel:self.ArticleData[indexPath.row]];
        if (indexPath.row == 0) {
            articleCell.separLine.hidden = YES;
        }else articleCell.separLine.hidden = NO;
        return articleCell;
    }
    if (indexPath.section == 1 || indexPath.section == 2) {
        
        GroupTalkModel *model = self.data[indexPath.row];
        UITableViewCell *cell = nil;
        
        //活动
        if ([model.bartype isEqualToString:@"1"]) {
            
            //            NSLog(@"model:%@",[model logClassData]);
            
            static NSString *CellIdentifier = @"ZDSGroupActCell";
            ZDSGroupActCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (groupCell == nil) {
                
                groupCell = [ZDSGroupActCell loadNib];
                groupCell.delegate = self;
                [groupCell setButtonClickEffectWithTableView:tableView];
            }
            
            groupCell.topupper = topNumber;
            groupCell.indexPath = indexPath;
            [groupCell initMyCellWithModel:model];
            cell = groupCell;
        }   
        //冒泡
        else if ([model.bartype isEqualToString:@"2"]) {
            
            static NSString *CellIdentifier = @"ZDSGroupBubbleCell";
            ZDSGroupBubbleCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (groupCell == nil) {
                
                groupCell = [ZDSGroupBubbleCell loadNib];
                groupCell.delegate = self;
            }
            groupCell.topupper = topNumber;
            [groupCell initMyCellWithModel:model];
            cell = groupCell;
        }
        //团聊
        else if ([model.bartype isEqualToString:@"0"]) {
            
            NSString *CellIdentifier = @"GroupTalkTableViewCell";
            
            GroupTalkTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                 CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupTalkTableViewCell" owner:self options:nil]lastObject];
                groupCell.talkCellDelegate = self;
                [groupCell setButtonClickEffectWithTableView:tableView];
            }
            groupCell.topupper = topNumber;
            groupCell.indexPath = indexPath;
            [groupCell initMyCellWithModel:model];
            if(indexPath.row == 0){
                groupCell.consLineHeight.constant = 0;
                groupCell.smallLine.top = 0;
                groupCell.line.height = 0;
            }
            cell = groupCell;
        }   
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.model.gamemode isEqualToString:@"3"] && indexPath.section == 1) {
        GroupTalkModel *model = [self.ArticleData objectAtIndex:indexPath.row];
        GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
        reply.talkid = model.talkid;
        reply.talktype = GroupTitleTalkType;
        reply.clickevent = 4;
        reply.isShowTopBtn = YES;
        reply.groupId = self.groupId;
        [self.navigationController pushViewController:reply animated:YES];
    }else{
        GroupTalkModel *model = [self.data objectAtIndex:indexPath.row];
        if ([model.bartype isEqualToString:@"1"]) {
            ZDSActDetailViewController *vc = [[ZDSActDetailViewController alloc] init];
            vc.activityid = model.barid;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.bartype isEqualToString:@"2"]) {
            GroupTalkModel *model = self.data[indexPath.row];
            MeViewController *single = [[MeViewController alloc]init];
            single.userID = model.userid;
            single.otherOrMe = 1;
            [self.navigationController pushViewController:single animated:YES];
        } else if ([model.bartype isEqualToString:@"0"]) {
            GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
            reply.talkid = model.barid;
            [self.navigationController pushViewController:reply animated:YES];
        }
    }
}

#pragma mark - Event Response

#pragma mark 进入修改密码页面
- (void)goToUpdatePassword {
    UpdatePasswordOriginalViewController *vc = [[UpdatePasswordOriginalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 菜单栏事件
-(void)menu {
    
    //普通团
    if ([self.model.gamemode isEqualToString:@"3"]) {
        
        //团长
        if ([self.gameangle isEqualToString:@"1"]) {
            CommanderMoreAlertView *coView = [[CommanderMoreAlertView alloc] initWithFrame:self.view.window.bounds delegate:self];
            [coView createViewWithHasPassword:self.model.gmpassword.length > 0];
            [self.view.window addSubview:coView];
            [coView ssl_show];
        }   
        //团员
        if ([self.gameangle isEqualToString:@"2"]) {
            MoreAlertView *moreView = [[MoreAlertView alloc] initWithFrame:self.view.window.bounds delegate:self];
            [self.view.window addSubview:moreView];
            [moreView ssl_show];
        }
        //访客
        if ([self.gameangle isEqualToString:@"3"]) {
            
        }
        
    } else {//闯关团
        
        //团长
        if ([self.gameangle isEqualToString:@"1"]|| [self.gameangle isEqualToString:@"0"]) {
            
            GroupCommanderMore28View *commanderView = [[GroupCommanderMore28View alloc] initWithFrame:self.view.window.bounds delegate:self];
            
            //未开始
            if ([self.gamests isEqualToString:@"0"]) {
                
                [commanderView createViewWithIsBreakUp:YES andHasPassword:self.model.gmpassword.length > 0];
            } else {
                [commanderView createViewWithIsBreakUp:NO andHasPassword:self.model.gmpassword.length > 0];
            }   
            [self.view.window addSubview:commanderView];
            [commanderView ssl_show];
        }   
        //团员
        if ([self.gameangle isEqualToString:@"2"]) {
            
            GroupMemberMore28View *memberView = [[GroupMemberMore28View alloc] initWithFrame:self.view.window.bounds delegate:self];
            [self.view.window addSubview:memberView];
            [memberView ssl_show];
        }   
        //访客
        if ([self.gameangle isEqualToString:@"3"]) {
            GroupVisitorMore28View *visitorView = [[GroupVisitorMore28View alloc] initWithFrame:self.view.window.bounds delegate:self];
            [self.view.window addSubview:visitorView];
            [visitorView ssl_show];
        }
    }
}

#pragma mark 催团长发任务成功
- (void)getTaskSuccess {
    [self reloadGroupData];
}

#pragma mark 普通团上传体重
- (void)uploadWeightButtonClick:(UIButton *)button {
    
    self.uploadWeightButton.userInteractionEnabled = NO;
    
    [NSUSER_Defaults setObject:self.model.nowWeight forKey:@"xianzaidetizhong"];
    [NSUSER_Defaults setObject:self.model.groupType forKey:@"xianzaidetype"];
    
    self.shareWeightView = [[InitShareWeightView alloc]initWithFrame:self.view.window.bounds];
    self.shareWeightView.scroY = [self scroY];
    self.shareWeightView.initShareDelegate = self;
    self.shareWeightView.initShareType = myWeightType;
    self.shareWeightView.parterid = self.parterid;
    self.shareWeightView.gameModel = self.model.gamemode;
    
    [self.shareWeightView createView];
    
    [self.view addSubview:self.shareWeightView];
}

#pragma mark 上传体重按钮
- (void)postWeightButton:(id)sender {
    
    [MobClick event:@"GroupUpWeightClick"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:self.parterid forKey:@"parterid"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GAMESELGAME parameters:dic requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            
            NSString * selgamests = [dic objectForKey:@"selgamests"];
            NSString * islastupload = [dic objectForKey:@"islastupload"];
            
            [NSUSER_Defaults setObject:weakSelf.model.nowWeight forKey:@"xianzaidetizhong"];
            [NSUSER_Defaults setObject:weakSelf.model.groupType forKey:@"xianzaidetype"];
            
//            if ([selgamests isEqualToString:@"2"]) {//
//                [weakSelf showAlertMsg:@"减脂团已结束" andFrame:CGRectMake(60, 100, 200, 50)];
//            }else
            if ([selgamests isEqualToString:@"0"]){//弹出仅上传体重页面
                
                self.shareWeightView = [[InitShareWeightView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
                self.shareWeightView.scroY = [self scroY];
                self.shareWeightView.initShareDelegate = weakSelf;
                self.shareWeightView.initShareDelegate = weakSelf;
                self.shareWeightView.initShareType = myWeightType;
                self.shareWeightView.parterid = weakSelf.parterid;
                [self.shareWeightView createView];
                
                [self.view addSubview:self.shareWeightView];
            }   
            
            else if([selgamests isEqualToString:@"1"]) {//上传体重和照片页面
                
                self.shareView = [[InitShareView alloc]initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT)];
                
                if([islastupload isEqualToString:@"0"]){
                    
                    [weakSelf showAlertMsg:@"仅剩一次上传机会" andFrame:CGRectMake(70,100,200,60)];
                }
                
                if (dic[@"phgoalweg"]) {
                    self.shareView.phgoalweg = [NSString stringWithFormat:@"%@",dic[@"phgoalweg"]];
                }
                
                [weakSelf postPicture:weakSelf.parterid];
                [weakSelf weightAddNew];
            }
//            else if([selgamests isEqualToString:@"3"]) {
//                if([weakSelf.model.groupType isEqualToString:@"1"])
//                    [weakSelf showAlertMsg:@"团组任务开始前2天才能上传照片哦，请耐心等待" andFrame:CGRectMake(60, 100, 200, 50)];
//                else if([weakSelf.model.groupType isEqualToString:@"2"])
//                    [weakSelf showAlertMsg:@"团组任务开始前2天才能上传体重哦，请耐心等待" andFrame:CGRectMake(60, 100, 200, 50)];
//            }
        }
    }];
}

#pragma mark 进入乐活吧
- (void)intoBarTap {
    self.notreadctLabel.text = @"0条未读消息";
    
    TalkBarViewController *talkBar = [[TalkBarViewController alloc] init];
    talkBar.groupId = self.groupId;
    talkBar.model = self.model;
    talkBar.gmpassword = self.model.gmpassword;
    talkBar.gameangle = self.gameangle;
    [self.navigationController pushViewController:talkBar animated:YES];
}   

#pragma mark 进入团员减重榜
- (void)dynamicButtonClick:(UIButton *)button {
    MemberLoseWeightViewController *loseVC = [[MemberLoseWeightViewController alloc] init];
    loseVC.gameId = self.groupId;
    loseVC.gameName = self.model.groupName;
    [self.navigationController pushViewController:loseVC animated:YES];
}

#pragma mark 普通团访客点击用户头像
- (void)memberUserButtonClick:(UIButton *)button {
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    intrestUserModel *model = self.userArray[button.tag];
    me.userID = model.userid;
    [self.navigationController pushViewController:me animated:YES];
}

#pragma mark - 前往完成列表
- (void)gotoDoneList{
    TaskDoneListViewController *list = [[TaskDoneListViewController alloc] init];
    list.groupId = self.groupId;
    list.taskId = self.model.taskid;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - 前往任务详情页
- (void)goToTaskDetail{
    taskDetailViewController *task = [[taskDetailViewController alloc] init];
    task.gameId = self.groupId;
    task.taskId = self.model.taskid;
    if(task.taskId && task.taskId.length>0)
    [self.navigationController pushViewController:task animated:YES];
}

#pragma mark 提交成绩
- (void)finishTaskButtonClick:(UIButton *)button {
    if([self.model.tasksts isEqualToString:@"0"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"已提交过成绩，需要再次提交刷新成绩吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"需要", nil];
        alert.tag = 126;
        [alert show];
    }else{
        [self goToSubmitTask];
    }
    
}

#pragma mark - 去往提交成绩页面
- (void)goToSubmitTask{
    submitTaskViewController *submit = [[submitTaskViewController alloc] init];
    submit.gameId = self.groupId;
    submit.taskId = self.model.taskid;
    submit.password = self.model.gmpassword;
    submit.clickevent = @"1";
    [self.navigationController pushViewController:submit animated:YES];
}

#pragma mark - 结束任务
- (void)endTask{
    if([self.model.fstaskpct isEqualToString:@"0"]){
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"目前还没有人完成任务，就这样结束任务了吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是", nil];
//        alert.tag = 123;
//        [alert show];
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"目前还没有任何人完成任务\n就这样结束任务了吗?" leftButtonTitle:nil rightButtonTitle:@"确认"];
        [alert show];
        alert.rightBlock = ^() {
            NSLog(@"点击了确定");
            
            DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"是否需要生成任务报告?" leftButtonTitle:@"取消" rightButtonTitle:@"确认"];
            [alert show];
            
            alert.leftBlock = ^() { // 取消按钮
                
                [self endTaskRequest:NO];
            };
            alert.rightBlock = ^() { // 确认按钮
                NSLog(@"点击了确定");
                [self endTaskRequest:YES];
                
            };
            alert.dismissBlock = ^() {
                NSLog(@"点击了右上角的叉");
            };
            
        };
        
        alert.dismissBlock = ^() {
            NSLog(@"点击了右上角的叉");
            
        };
        
        
    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认提示" message:@"是否结束任务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//        alert.tag = 124;
//        [alert show];
        
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"" contentText:@"是否结束任务?" leftButtonTitle:nil rightButtonTitle:@"确认"];
        [alert show];
        alert.rightBlock = ^() { // 点击了确认按钮
            
            [self endTaskRequest:YES];
            
        };
        
        alert.dismissBlock = ^() { // 叉叉按钮
            
        };
    }
}
- (void)endTaskRequest:(BOOL)isWithDiscover{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.model.taskid] forKey:@"taskid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    
    [dictionary setObject:[NSString stringWithFormat:@"%@",isWithDiscover?@"0":@"1"] forKey:@"syntitle"];
    [dictionary setObject:@"1" forKey:@"clickevent"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_ENDTASK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if([dic[@"result"] isEqualToString:@"0"]){
            if(isWithDiscover) [weakSelf showAlertMsg:@"已自动生成任务报告，请到团组精华帖中查看！" yOffset:0];
            else [weakSelf showAlertMsg:@"结束成功" yOffset:0];
            weakSelf.model.taskcmpl = @"0";
            [weakSelf.table reloadData];
            if(isWithDiscover){
                [weakSelf reloadTitleArticle];
                if(dic[@"talkid"] && [dic[@"talkid"] length] > 0){
                    GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
                    reply.talkid = dic[@"talkid"];
                    reply.talktype = GroupTitleTalkType;
                    reply.clickevent = 4;
                    reply.isShowTopBtn = YES;
                    reply.groupId = self.groupId;
                    [self.navigationController pushViewController:reply animated:YES];
                }
            }
            
        }
    }];
}

- (void)endTaskSucessNotify{
    self.model.taskcmpl = @"0";
    [self.table reloadData];
}

#pragma mark - 提交成绩成功监听
-(void)submitTaskSucess{
    self.model.fstaskpct = [NSString stringWithFormat:@"%d",self.model.fstaskpct.intValue+1];
    self.model.tasksts = @"0";
    [self.table reloadData];
    [self refresh];
}

#pragma mark 发布新任务
- (void)pubNewTaskbuttonClick:(UIButton *)button {
    PublicTaskViewController *pubTask = [[PublicTaskViewController alloc] init];
    pubTask.delegate = self;
    pubTask.password = self.model.gmpassword;
    pubTask.gameId = self.groupId;
    pubTask.gameName = self.model.groupName;
    pubTask.taskNum = self.model.taskNum;
    pubTask.taskMonth = self.model.taskMonth;
    [self.navigationController pushViewController:pubTask animated:YES];
}   

#pragma mark 解散团组
- (void)breakUpGroup {
    
    BreakUpViewController *breaUp = [[BreakUpViewController alloc] init];
    breaUp.gameId = self.groupId;
    [self.navigationController pushViewController:breaUp animated:YES];
}

#pragma mark 催团长发任务
- (void)promptTaskButtonClick:(UIButton *)button {
    self.finishTaskButton.userInteractionEnabled = NO;
    [self requestWithUrgetask];
}

#pragma mark 普通团访客时团组成员
- (void)memberButtonClick:(UIButton *)button {
    [self goToGroupUser];
}

#pragma mark 加入团组按钮点击事件
- (void)joinButtonClick:(UIButton *)button {
        if (self.model.gmpassword.length>0) {//密码团
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定加入吗?" message:@"加入私密团，需要密码验证哦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
        alert.tag = 888;
        [alert show];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定加入吗?" message:@"欢乐团可以随意加入哦！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
        alert.tag = 888;
        [alert show];

    }
}

#pragma mark 去光荣榜页面
- (void)grbButtonClick:(UIButton *)button {
    RankListViewController *rank = [[RankListViewController alloc] init];
    rank.groupId = self.groupId;
    rank.groupName = self.model.groupName;
    [self.navigationController pushViewController:rank animated:YES];
}

#pragma mark 冒泡 点击
- (void)grougBubbleClick:(UIButton*)btn {
    
    btn.userInteractionEnabled = NO;
    if (self.countDown > 0) {
        btn.userInteractionEnabled = YES;
        [self showAlertMsg:@"现在还不能冒泡" andFrame:CGRectZero];
    } else {
        NSLog(@"冒泡");
        [self requestWithBubble:(UIButton*)btn];
    }
}   

#pragma mark 活动 点击
- (void)groupActivityClick {
    //    TestViewController *activityVC = [[TestViewController alloc] init];
    ZDSPublishActivityViewController *activityVC = [[ZDSPublishActivityViewController alloc] init];
    activityVC.delegate = self;
    activityVC.groupId = self.groupId;
    [self.navigationController pushViewController:activityVC animated:YES];
}

#pragma mark 加入减脂团
- (IBAction)joinButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定加入吗?" message:@"在28天里，你只能加入一个减脂团哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
    alert.tag = 888;
    [alert show];
}

#pragma mark 团长跳转
-(void)clickPater:(UIButton*)btn{
    if(btn.titleLabel.text.length<1) return;
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = btn.titleLabel.text;
    [self.navigationController pushViewController:me animated:YES];
}   

#pragma mark 分享
-(void)createGame {
    [MobClick event:@"GroupShareClick"];//分享点击次数
    [self hideMenu];
    [self.shareView removeFromSuperview];
    [self createShareView:outType];
}

#pragma mark 冒泡定时器
- (void)countDown:(NSTimer *)timer {
    
    if (self.countDown > 0) {
        self.countDownLabel.hidden = NO;
        self.countDown--;
        self.countDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",self.countDown/60,self.countDown%60];
    } else {
        [self createTimerWith:NO];
        self.countDownLabel.hidden = YES;
    }
}

#pragma mark - Private Methods

#pragma mark 导航条隐藏状态改变时
- (void)navHiddenChange {
    if (!([self.model.gamemode isEqualToString:@"3"] && [self.gameangle isEqualToString:@"3"])) {
        [self viewOffsetMoveSubView];
    }
}

#pragma mark 下载图片
- (void)downloadGroupImage {
    
    self.image = [UIImage imageNamed:@"ICON_120.png"];
}

#pragma mark view偏移时移动子类
- (void)viewOffsetMoveSubView {
    self.back.top = [self scroY];
    self.table.top = [self scroY];
    self.footerView.top = self.view.height - 47;
}


//当显示导航条时，scrollView的y值
- (CGFloat)scroY {
    
    if (self.view.top == 0) {
        return 64;
    }
    
    if (self.view.top == 64) {
        return 0;
    }
    return 0;
}

//创建定时器
- (void)createTimerWith:(BOOL)create {
    
    if (create) {
        [self createTimerWith:NO];
        self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
    } else {
        if (self.countDownTimer) {
            [self.countDownTimer invalidate];
            self.countDownTimer = nil;
        }
    }
}

#pragma mark 乐活吧分享
- (void)jubaoShare {
    
    [self hideMenu];
    
    [self.shareView removeFromSuperview];
    
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    
    GroupTalkModel *tempModel = nil;
    
    int i = 0;
    for (; i < self.data.count; i++) {
        GroupTalkModel *model = self.data[i];
        if ([model.barid isEqualToString:talkid]) {
            tempModel = model;
            break;
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.gameangle forKey:@"shareGroupGameAngle"];
    [[NSUserDefaults standardUserDefaults] setObject:tempModel.userid forKey:@"shareGroupUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.model.gamecrtor forKey:@"shareGroupUserId"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topNumber] forKey:@"shareGroupTopNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topUpper] forKey:@"shareGroupTopUpper"];
    
    [[NSUserDefaults standardUserDefaults] setObject:tempModel.istop forKey:@"shareGroupIsTop"];
    
    //团聊
    if ([tempModel.bartype isEqualToString:@"0"]) {
        UIImage *tempImage;
        if ([self.model.gamemode isEqualToString:@"3"]) {
            ArticleTableViewCell *cell = (ArticleTableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
            tempImage = cell.showImageView.image;
        }else{
            GroupTalkTableViewCell *cell = (GroupTalkTableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
            tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.contentImageView.image];
        }
        
        if (!tempImage) {
            tempImage =[UIImage imageNamed:@"ICON_120"];
        }
        
        NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
        UIImage *image = [UIImage imageWithData:data];
        
        [myshareView createView:GrouptTalkShareType withModel:tempModel withGroupModel:self.model];
        [myshareView setShareImage:image];
        
        //活动
    } else if ([tempModel.bartype isEqualToString:@"1"]) {
        [myshareView createView:ActiveShareType withModel:tempModel withGroupModel:self.model];
    }
}

#pragma mark 置顶/取消置顶
- (void)topBar {
    
    GroupTalkModel *cuModel = self.data[self.currentIndexPath.row];
    //置顶类型
    if ([cuModel.bartype isEqualToString:@"0"]) {
        self.topType = @"0";
    } else if ([cuModel.bartype isEqualToString:@"1"]) {
        self.topType = @"1";
    }
    talkResult = cuModel.barid;
    //是否置顶
    if ([cuModel.istop isEqualToString:@"0"]) {
        stopResult = @"1";
    } else {
        stopResult = @"0";
    }
    [self topRequestWithTalkId:talkResult isStop:stopResult];
}

#pragma mark - Request

#pragma mark 完成团组任务请求
- (void)requestWithFinishTask {
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_FINISHTASK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        UrgettaskModel *model = [UrgettaskModel objectWithKeyValues:dic];
        if (model.content.length > 0) {
            [weakSelf showAlertMsg:model.content andFrame:CGRectZero];
        }
        //成功
        if ([model.result isEqualToString:@"0"]) {
            [weakSelf reloadGroupData];
        }
    }];
}   

#pragma mark 催团长发任务请求
- (void)requestWithUrgetask {
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    
    //发送请求感兴趣的人
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_URGETASK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        self.finishTaskButton.userInteractionEnabled = YES;
        UrgettaskModel *model = [UrgettaskModel objectWithKeyValues:dic];
        if (model.content.length > 0) {
            [weakSelf showAlertMsg:model.content andFrame:CGRectZero];
        }
        //成功
        if ([model.result isEqualToString:@"0"]) {
            [weakSelf getTaskSuccess];
        }
    }];
}

#pragma mark 加载游戏参与者列表
-(void)requestWithGameParters{
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"6" forKey:@"pageSize"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    
    //发送请求感兴趣的人
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PARTERGAME parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakSelf.timePageNum = 1;
            [weakSelf.userArray removeAllObjects];
            NSArray *tempArray = dic[@"parterList"];
            for (NSDictionary *dic in tempArray) {
                intrestUserModel *model = [intrestUserModel modelWithDic:dic[@"userinfo"]];
                [weakSelf.userArray addObject:model];
            }
            [weakSelf setUserView];
        }
    }];
}

#pragma mark - 获取团组数据
-(void)reloadGroupData{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"5" forKey:@"partersize"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.clickevent] forKey:@"clickevent"];
    [self showWaitView];
    WEAKSELF_SS
    if (self.httpOpt && !self.httpOpt.finished) {
        [self removeWaitView];
        return;
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GAMEDETAIL parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (dic[ERRCODE]) {
            [weakSelf removeWaitView];
            weakSelf.isHiddenNav = NO;
            [weakSelf setNav];
            //该团组已解散
//            if ([dic[ERRCODE] isEqualToString:@"GAM060"]) {
                weakSelf.navigationController.navigationBar.top = 20;
                [weakSelf.header endRefreshing];
                [weakSelf.navigationController popViewControllerAnimated:NO];
                return;
//            }
        }else{
            
            weakSelf.parterid = dic[@"parterid"];
            weakSelf.gamests = dic[@"gmphase"];
            weakSelf.gameangle = dic[@"gameangle"];
            weakSelf.praisestatus = dic[@"praisestatus"];
            weakSelf.model.gamecrtor = dic[@"gamecrtor"];
            weakSelf.model.headerImage = dic[@"crtorimage"];
            weakSelf.model.username = dic[@"crtorname"];
            weakSelf.model.xuanyan = dic[@"gmslogan"];
            weakSelf.model.groupTags = dic[@"gametags"];
            weakSelf.model.groupName = dic[@"gamename"];
            weakSelf.model.groupImage = dic[@"imageurl"];
            weakSelf.model.groupType = dic[@"gamemode"];
            weakSelf.model.userSum = dic[@"totalnumpeo"];
            weakSelf.model.goodSum = dic[@"praisecount"];
            
            weakSelf.model.score = dic[@"psscore"];
            weakSelf.model.upWeightUserSum = dic[@"totalupweg"];
            weakSelf.model.beginTime = dic[@"gmbegintime"];
            weakSelf.model.endTime = dic[@"gmendtime"];
            weakSelf.model.gametask = dic[@"gametask"];
            weakSelf.model.psbegintime = dic[@"psbegintime"];
            weakSelf.model.psendtime = dic[@"psendtime"];
            weakSelf.model.whichweek = dic[@"whichweek"];
            weakSelf.model.pstask = dic[@"pstask"];
            weakSelf.model.disendtime = dic[@"disendtime"];
            weakSelf.model.phgoalweg = dic[@"phgoalweg"];
            weakSelf.model.showupload = dic[@"showupload"];
            weakSelf.model.nowWeight = dic[@"latestweg"];
            weakSelf.model.mecomplete = dic[@"mecomplete"];
            weakSelf.model.needlose = dic[@"needlose"];
            weakSelf.model.disstrtime = dic[@"disstrtime"];
            weakSelf.model.gamests = dic[@"gamests"];
            weakSelf.model.passtype = dic[@"passtype"];
            
            //普通团新增
            weakSelf.model.gamemode = dic[@"gamemode"];
            weakSelf.model.indays = dic[@"indays"];
            weakSelf.model.fstaskcount = dic[@"fstaskcount"];
            weakSelf.model.initialweg = dic[@"initialweg"];
            weakSelf.model.latestweg = dic[@"latestweg"];
            weakSelf.model.losepercent = dic[@"losepercent"];
            weakSelf.model.ptotallose = dic[@"ptotallose"];
            weakSelf.model.taskcontent = dic[@"taskcontent"];
            weakSelf.model.taskcmpl = dic[@"taskcmpl"];
            weakSelf.model.taskimage = dic[@"taskimg"];
            weakSelf.model.taskid = dic[@"taskid"];
            weakSelf.model.taskMonth = dic[@"month"];
            weakSelf.model.taskNum = dic[@"taskcount"];
            
            weakSelf.model.tasksts = dic[@"tasksts"];
            weakSelf.model.fstaskpct = dic[@"fstaskpct"];
            weakSelf.model.partercount = dic[@"partercount"];
            weakSelf.model.todayaddct = dic[@"todayaddct"];
            weakSelf.model.todayupwgct = dic[@"todayupwgct"];
            weakSelf.model.dyncount = dic[@"dyncount"];
            weakSelf.model.gametags = dic[@"gametags"];
            weakSelf.model.crtorintro = dic[@"crtorintro"];
            weakSelf.model.loseway = dic[@"loseway"];
            weakSelf.model.gtotallose = dic[@"gtotallose"];
            weakSelf.model.urgecount = dic[@"urgecount"];
            weakSelf.model.isfull = dic[@"isfull"];
            weakSelf.model.dissolvesub = dic[@"dissolvesub"];
            weakSelf.model.desctag = dic[@"desctag"];
            weakSelf.model.gmpassword = dic[@"gmpassword"];
            
            weakSelf.model.friendcount = dic[@"friendcount"];
            weakSelf.model.friendList = dic[@"friendList"];
            weakSelf.model.taglist = dic[@"taglist"];
            weakSelf.model.sendmsgct = dic[@"sendmsgct"];
            weakSelf.model.ispunch = dic[@"ispunch"];
            
            if (weakSelf.model.taglist.length > 0) {
                if ([[weakSelf.model.taglist substringFromIndex:weakSelf.model.taglist.length -1] isEqualToString:@","]) {
                    weakSelf.model.taglist = [weakSelf.model.taglist substringToIndex:weakSelf.model.taglist.length - 1];
                }
            }
            
            //普通团
            if ([weakSelf.model.gamemode isEqualToString:@"3"]) {
                [[NSNotificationCenter defaultCenter] removeObserver:self];
                //跳转至新界面
                GroupHappyViewController *happy = [[GroupHappyViewController alloc] init];
                happy.groupId = weakSelf.groupId;
                happy.clickevent = weakSelf.clickevent;
                happy.joinClickevent = weakSelf.joinClickevent;
                happy.gameDetailStatus = weakSelf.gameDetailStatus;
                happy.parterid = weakSelf.parterid;
                happy.gamests = weakSelf.gamests;
                happy.gameangle = weakSelf.gameangle;
                happy.model = weakSelf.model;
                happy.isShowAllUI = [weakSelf.gameangle isEqualToString:@"3"];
                happy.hidesBottomBarWhenPushed = YES;
//                [weakSelf.navigationController popToViewController:weakSelf.navigationController.childViewControllers[weakSelf.navigationController.childViewControllers.count - 2] animated:NO];
//                [weakSelf.navigationController pushViewController:happy animated:NO];
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
                [temp removeLastObject];
                [temp addObject:happy];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf removeWaitView];
                    weakSelf.navigationController.viewControllers = temp;
                return;
//                });
            
                
//                [weakSelf.navigationController setViewControllers:temp animated:NO];
//                [weakSelf.navigationController pushViewController:happy animated:NO];
                
//                //下载团组图片
//                [weakSelf downloadGroupImage];
//                
//                //团长
//                if ([weakSelf.gameangle isEqualToString:@"1"]) {
//                    [weakSelf setUpGUI];
//                    [weakSelf reloadTitleArticle];
//                    [weakSelf refresh];
//                }
//                //团员
//                if ([weakSelf.gameangle isEqualToString:@"2"]) {
//                    [weakSelf setUpGUI];
//                    [weakSelf reloadTitleArticle];
//                    [weakSelf refresh];
//                }
//                //访客
//                if ([weakSelf.gameangle isEqualToString:@"3"]) {
//                    [weakSelf requestWithGameParters];
//                    [weakSelf setUpGeneralGroupVistiUI];
//                }
                
                
                
            } else {
                [weakSelf removeWaitView];
                if (![weakSelf.gameangle isEqualToString:@"3"]) {
                    weakSelf.footerView.height = 47;
                    weakSelf.footerView.backgroundColor = ZDS_BACK_COLOR;
                }else weakSelf.footerView.height = 0;
                NSMutableArray *userTemp = [NSMutableArray array];
                for (NSDictionary *dict in dic[@"parterList"]) {
                    [userTemp addObject:dict[@"userinfo"]];
                }
                
                weakSelf.model.userArray = userTemp;
                [weakSelf setUpGUI];
                [weakSelf refresh];
                [weakSelf.table reloadData];
                [weakSelf addNewView];
            }
        }
        self.navigationController.navigationBar.top = 20;
    }];
}

#pragma mark 冒泡请求
- (void)requestWithBubble:(UIButton*)btn {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Group_Bubble parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        btn.userInteractionEnabled = YES;
        ZDSGroupBubbleModel *model = [ZDSGroupBubbleModel objectWithKeyValues:dic];
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            weakSelf.countDown = model.waittime.integerValue;
            [weakSelf createTimerWith:YES];
            [weakSelf refresh];
            if (weakSelf.data.count > 0) {
                [weakSelf.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }   
        }
    }];
    
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
    [dictionary setObject:deltype forKey:@"deltype"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Del_Bar parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            [weakSelf refresh];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
        }
    }];
}

#pragma mark NSNotification

-(void)good:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0; i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"receiveid"]]) {
            model.goodStatus = dic[@"praisestatus"];
            model.goodSum =[NSString stringWithFormat:@"%d",[model.goodStatus isEqualToString:@"0"]?model.goodSum.intValue+1:model.goodSum.intValue-1];
            if ([self.model.gamemode isEqualToString:@"3"]) {
                [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}
-(void)com:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            if ([self.model.gamemode isEqualToString:@"3"]) {
                [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            }else{
                [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

#pragma mark 团组解散通知
- (void)breakUpGroupNoti {
    self.model.dissolvesub = @"0";
}


//通知
- (void)joinAct:(NSNotification *)object {
    
    NSString *activeid = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:activeid]) {
            model.isjoin = @"0";
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)delteReply:(NSNotification*)object{
    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}

#pragma mark Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"frame"]) {
        if (!([self.model.gamemode isEqualToString:@"3"] && [self.gameangle isEqualToString:@"3"])) {
            [self viewOffsetMoveSubView];
        }
    }
}

#pragma mark Setters And Getters

- (NSString *)gamePwd {
    
    return self.model.gmpassword;
}

- (void)setGamePwd:(NSString *)gamePwd {
    self.model.gmpassword = gamePwd;
}

- (NSString *)notreadct {
    if ([WWTolls isNull:_notreadct]) {
        _notreadct = @"0";
    }
    return _notreadct;
}

- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

#pragma mark - 返回上一级
-(void)popButton{
    [WWTolls zdsClick:TJ_GROUPDETAIL_QX];
    [self.shareView removeFromSuperview];
    if (self.navigationController.viewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            
        }];
    }else if ([_gameDetailStatus isEqualToString:@"10086"]) {
        self.navigationController.tabBarController.selectedIndex = 3;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}



#pragma mark - 添加蒙层
#define firstopenstr @"isfirstBeginchuangguanGame"
#define firstopenhappystr @"isfirstBeginhappyGame"
#define firstupweightstr @"isfirstUpweight"
-(void)addNewView{
    if ([self.model.groupType isEqualToString:@"1"]) {//闯关
        //判断是否第一次打开
        if ([NSUSER_Defaults objectForKey:firstopenstr]==nil) {
            UIImageView *new1 = [[UIImageView alloc] init];
            new1.image = [UIImage imageNamed:@"group_new"];
            new1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 568);
            new1.bottom = SCREEN_HEIGHT;
            new1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newClick2:)];
            [new1 addGestureRecognizer:tap];
            [self.view addSubview:new1];
        }
    }else if([self.model.groupType isEqualToString:@"2"]){//欢乐
        //判断是否第一次打开
        if ([NSUSER_Defaults objectForKey:firstopenhappystr]==nil) {
            UIImageView *new1 = [[UIImageView alloc] init];
            new1.image = [UIImage imageNamed:@"group_new2"];
            new1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 568);
            new1.bottom = SCREEN_HEIGHT;
            new1.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newClick3:)];
            [new1 addGestureRecognizer:tap];
            [self.view addSubview:new1];
        }
    }
    
}
-(void)weightAddNew{
    if ([NSUSER_Defaults objectForKey:firstupweightstr]==nil) {
        UIImageView *new1 = [[UIImageView alloc] init];
        new1.image = [UIImage imageNamed:@"group_new_2"];
        new1.frame = CGRectMake(0, 0, SCREEN_WIDTH, 568);
        new1.bottom = SCREEN_HEIGHT;
        new1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Upweightclick:)];
        [new1 addGestureRecognizer:tap];
        [[UIApplication sharedApplication].keyWindow addSubview:new1];
    }
}
-(void)Upweightclick:(UIGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    [NSUSER_Defaults setObject:@"yes" forKey:firstupweightstr];
}
-(void)newClick2:(UIGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    [NSUSER_Defaults setObject:@"yes" forKey:firstopenstr];
}
-(void)newClick3:(UIGestureRecognizer*)tap{
    [tap.view removeFromSuperview];
    [NSUSER_Defaults setObject:@"yes" forKey:firstopenhappystr];
}


#pragma mark - 刷新数据
-(void)refresh{
    self.talkBarLoadDone = NO;
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
//    if ([self.model.gamemode isEqualToString:@"3"]) {
//        NSLog(@"欢乐团");
//        [dictionary setObject:@"1" forKey:@"pageSize"];
//    } else {
//        NSLog(@"28天团");
        [dictionary setObject:@"10" forKey:@"pageSize"];
//    }
    
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKDETAIL parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            topNumber = [dic[@"topcount"] intValue];
            topUpper = [dic[@"topupper"] intValue];
            //topupper
            
            if ([dic[@"waittime"] intValue] > 0) {
                weakSelf.countDown = [dic[@"waittime"] integerValue];
                [weakSelf createTimerWith:YES];
            }
            weakSelf.timePageNum=1;
            
            [weakSelf.data removeAllObjects];
            NSArray *tempArray = dic[@"barlist"];

            weakSelf.notreadct = dic[@"notreadct"];
            for (int i=0; i<tempArray.count; i++) {
                
                GroupTalkModel *groupTalkModel = [[GroupTalkModel alloc]init];
                
                NSDictionary *dict = [tempArray objectAtIndex:i];
                groupTalkModel.bartype = [dict objectForKey:@"bartype"];
                groupTalkModel.barid = [dict objectForKey:@"barid"];
                groupTalkModel.content = [dict objectForKey:@"content"];
                groupTalkModel.commentcount = [dict objectForKey:@"commentcount"];
                groupTalkModel.partercount = dict[@"partercount"];
                groupTalkModel.acttime = [dict objectForKey:@"acttime"];
                groupTalkModel.place = [dict objectForKey:@"place"];
                groupTalkModel.logangle = weakSelf.gameangle;
                groupTalkModel.userid = [dict objectForKey:@"userid"];
                groupTalkModel.username = [dict objectForKey:@"username"];
                groupTalkModel.userinfoimageurl =dict [@"userimage"];
                groupTalkModel.imageurl = dict[@"talkimage"];
                groupTalkModel.istop = [dict objectForKey:@"istop"];
                groupTalkModel.createtime =  [dict objectForKey:@"createtime"];
                groupTalkModel.goodSum = [dict objectForKey:@"praisecount"];
                groupTalkModel.goodStatus = [dict objectForKey:@"praisestatus"];
                groupTalkModel.isjoin = [dict objectForKey:@"isjoin"];
                groupTalkModel.actdate = [dict objectForKey:@"actdate"];
                groupTalkModel.acttiming = [dict objectForKey:@"acttiming"];
                
                [weakSelf.data addObject:groupTalkModel];
               
            }
             weakSelf.lastId = tempArray.lastObject[@"barid"];
            //普通团
//            if ([weakSelf.model.gamemode isEqualToString:@"3"]) {
//                
//                //团长
//                if ([weakSelf.gameangle isEqualToString:@"1"]) {
//                    [weakSelf setUpGeneralGroupCommanderUI];
//                }
//                //团员
//                if ([weakSelf.gameangle isEqualToString:@"2"]) {
//                    [weakSelf setUpGeneralGroupMemberUI];
//                }
//                //访客
//                if ([weakSelf.gameangle isEqualToString:@"3"]) {
//                    [weakSelf requestWithGameParters];
//                    [weakSelf setUpGeneralGroupVistiUI];
//                }
//            } else {
                [weakSelf.table reloadData];
//            }
        }
        weakSelf.talkBarLoadDone = YES;
        [weakSelf.header endRefreshing];
        [weakSelf removeWaitView];
    }];
}

#pragma mark - 加载更多回复
-(void)loadData{

    if (self.data.count == 0 ||self.data.count == 0 || self.data.count%10 != 0 || self.data.count<self.timePageNum*10) {
        if(!self.talkBarLoadDone){
            [self showWaitView];
            [self.footer endRefreshing];
            return;
        }
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.footer endRefreshing];
        return;
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求即将开团
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKDETAIL parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            weakSelf.timePageNum++;
            NSArray *tempArray = dic[@"barlist"];
            weakSelf.notreadct = dic[@"notreadct"];
            
            for (int i=0; i<tempArray.count; i++) {
                GroupTalkModel *groupTalkModel = [[GroupTalkModel alloc]init];
                
                NSDictionary *dict = [tempArray objectAtIndex:i];
                groupTalkModel.bartype = [dict objectForKey:@"bartype"];
                groupTalkModel.barid = [dict objectForKey:@"barid"];
                groupTalkModel.content = [dict objectForKey:@"content"];
                groupTalkModel.commentcount = [dict objectForKey:@"commentcount"];
                groupTalkModel.partercount = dict[@"partercount"];
                groupTalkModel.acttime = [dict objectForKey:@"acttime"];
                groupTalkModel.place = [dict objectForKey:@"place"];
                groupTalkModel.logangle = weakSelf.gameangle;
                groupTalkModel.userid = [dict objectForKey:@"userid"];
                groupTalkModel.username = [dict objectForKey:@"username"];
                groupTalkModel.userinfoimageurl =dict [@"userimage"];
                groupTalkModel.imageurl = dict[@"talkimage"];
                groupTalkModel.istop = [dict objectForKey:@"istop"];
                groupTalkModel.createtime =  [dict objectForKey:@"createtime"];
                groupTalkModel.goodSum = [dict objectForKey:@"praisecount"];
                groupTalkModel.goodStatus = [dict objectForKey:@"praisestatus"];
                groupTalkModel.isjoin = [dict objectForKey:@"isjoin"];
                groupTalkModel.actdate = [dict objectForKey:@"actdate"];
                groupTalkModel.acttiming = [dict objectForKey:@"acttiming"];
                
                [weakSelf.data addObject:groupTalkModel];
                weakSelf.lastId = groupTalkModel.barid;
            }
            [weakSelf.table reloadData];
        }
        [weakSelf.footer endRefreshing];
    }];
}

#pragma mark - 加载标题帖
- (void)reloadTitleArticle{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"3" forKey:@"pageSize"];
    
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_TITLE_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            [weakSelf.ArticleData removeAllObjects];
            for (int i = 0; i< ((NSArray*)dic[@"barlist"]).count; i++) {
                [weakSelf.ArticleData addObject:[GroupTalkModel modelWithDic:dic[@"barlist"][i]]];
                if (i == 2) {
                    break;
                }
            }
            [weakSelf.table reloadData];
        }
    }];
}

#pragma mark - 置顶事件
-(void)talkidString:(NSString *)talk andType:(NSString *)type
{
    self.topType = type;
    talkResult = talk;
}

-(void)topString:(NSString *)top{
    stopResult = top;
}

-(void)clickTopButton{
    [self topRequestWithTalkId:talkResult isStop:stopResult];
}

#pragma mark 置顶请求
-(void)topRequestWithTalkId:(NSString*)talkId isStop:(NSString*)isStop{
    
    /**
     0 否
     1 是
     */
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:isStop forKey:@"istop"];
    /**
     *  0 讨论置顶
     *  1 活动置顶
     */
    [dictionary setObject:self.topType forKey:@"toptype"];
    [dictionary setObject:talkId forKey:@"topid"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TOP_BAR parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
            if (!dic[ERRCODE]) {
                talkid = [dic objectForKey:@"talkid"];
                if ([dic[@"result"] isEqualToString:@"0"]) {
                    if ([isStop isEqualToString:@"1"]) {
                        [weakSelf showAlertMsg:@"置顶成功" andFrame:CGRectZero];
                    }else [weakSelf showAlertMsg:@"取消置顶成功" andFrame:CGRectZero];
                    [weakSelf refresh];
                }
            }
    }];
}

#pragma mark - 类型提示框
-(void)clickType{
    self.typeIntro.hidden = !self.typeIntro.hidden;
}
#pragma mark - 类型提示框隐藏
-(void)hideType:(UIGestureRecognizer*)tap{
    tap.view.hidden = YES;
}

#pragma mark - 举报接口
-(void)postReport:(NSString*)ifmtype{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:talkid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:repotType forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectMake(70,100,200,60)];
    }];
}

#pragma mark - 编辑宣言
-(void)EditorXuanyan{
    GroupEditorViewController *ge = [[GroupEditorViewController alloc] init];
    ge.msg = self.model.xuanyan;
    ge.model = self.model;
    ge.groupId = self.groupId;
    [self.navigationController pushViewController:ge animated:YES];
}

-(void)hideMenu{
    self.menuView.hidden = YES;
}

#pragma mark - 返回广场
-(void)goHome{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 去往规则页面
-(void)goRule{
    GameRuleViewController *rule = [[GameRuleViewController alloc] initWithNibName:@"GameRuleViewController" bundle:nil];
    [self.navigationController pushViewController:rule animated:YES];
}

-(void)createShareView:(ShareGameSubClassViewType)type
{
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    
    [NSUSER_Defaults setObject:self.groupId forKey:@"fenxianggameid"];
    [NSUSER_Defaults setObject:self.model.groupName forKey:@"fenxianggamename"];
    
    UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:self.image];
    NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
    
    [NSUSER_Defaults setObject:data forKey:@"fenxianggameimage"];
    
    myshareView.narDelegate = self;
    [myshareView createView:type withModel:nil withGroupModel:nil];
}

#pragma mark - 参与者视角的邀请按钮
- (IBAction)joinButtonPart:(id)sender {
    [MobClick event:@"GroupInviteClick"];
    [self createShareView:inType];
    
}

#pragma mark - 退出减脂团
- (IBAction)deleteBtn:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出吗?" message:@"你在本团的体重数据将不被保存哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 999;
    [alert show];
}

-(void)ExitMyGame{
    [self showWaitView];
    self.view.userInteractionEnabled = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_EXITDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if ([dic[@"exitflg"] isEqualToString:@"0"]) {
            [NSUSER_Defaults setObject:@"YES" forKey:@"tuanzubianhua"];
            [weakSelf showAlertMsg:@"退出减脂团成功" andFrame:CGRectMake(70,100,200,60)];
            //                [MBProgressHUD showError:@"退出减脂团成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf popButton];
            });
        }
    }];
}

-(void)joinMyGameWithPassword:(NSString *)password
{   
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    
    if (password) {
        //当为私密团时，需要填写的密码
        [dictionary setObject:[WWTolls encodePwd:password] forKey:@"pwd"];
    }
    
    [dictionary setObject:self.joinClickevent?self.joinClickevent:@"1" forKey:@"clickevent"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_JOINDO  parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.joinButton.userInteractionEnabled = YES;
        NSLog(@"加入失败信息%@,%@",[dic objectForKey:@"joinflg"],dic);
        if ([[dic objectForKey:@"joinflg"] isEqualToString:@"0"]) {
            //                self.joinButton.enabled = NO;
            [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"加入成功" andFrame:CGRectZero];
            [NSUSER_Defaults setObject:@"YES" forKey:@"tuanzubianhua"];
            if (self.comeTitleTalkid && self.comeTitleTalkid.length > 0) {
                self.navigationController.navigationBarHidden = NO;
                ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -50;
                ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -50;
                self.navigationController.navigationBar.top = 20;
                GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
                talk.groupId = self.groupId;
                talk.talkid = self.comeTitleTalkid;
                talk.talktype = GroupTitleTalkType;
                NSMutableArray *contrllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                [contrllers removeLastObject];
                [contrllers addObject:talk];
                [self.navigationController setViewControllers:contrllers animated:YES];
            }else{
                //普通团
                if ([weakSelf.model.gamemode isEqualToString:@"3"]) {
                    if ([weakSelf.gameangle isEqualToString:@"3"]) {
                        [weakSelf reloadGroupData];
                    }
                } else {
                    if([weakSelf.model.groupType isEqualToString:@"1"]){
                        [weakSelf showAlertMsg:@"加入成功！欢乐的减脂之旅即将启程！" andFrame:CGRectMake(70,100,200,60)];
                    }else if([weakSelf.model.groupType isEqualToString:@"2"]){
                        [weakSelf showAlertMsg:@"加入成功！欢乐的减脂之旅即将启程！" andFrame:CGRectMake(70,100,200,60)];
                    }
                    [weakSelf.header beginRefreshing];//刷新数据
                }
            }
            
        }
    }];
    
}

#pragma mark - 点赞
- (void)goodButton:(id)sender {
    NSLog(@"打招呼了");
    
}

-(void)clickGoodSender:(NSString*)praisesta
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:@"1" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    //  [dictionary setObject:userid forKey:@"rcvuserid"];//被赞人的用户ID当点赞类型为人时必输
    [dictionary setObject:self.groupId forKey:@"receiveid"];//被赞的游戏ID当点赞类型为游戏时必须输入
    //    [dictionary setObject:self.gamecrtor forKey:@"gamecrtor"];//游戏创建者的用户ID
    [dictionary setObject:praisesta forKey:@"praisestatus"];//0 已赞1 已取消2 已删除
    //    [dictionary setObject:self.gameName forKey:@"rcvgamename"];//点赞类型为1时必输
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PRAISE_104 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) {
            if ([weakSelf.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
                [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"yjy-32-32-"] forState:UIControlStateNormal];
                [weakSelf.goodButton popOutsideWithDuration:0.5];
                [weakSelf.goodButton animate];
                weakSelf.praisestatus = @"0";
            }else{
                [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"group_zan-30-30"] forState:UIControlStateNormal];
                [weakSelf.goodButton popInsideWithDuration:0.4];
                weakSelf.praisestatus = @"1";
            }
            if ([praisesta isEqualToString:@"0"]) {
                weakSelf.model.goodSum = [NSString stringWithFormat:@"%d",weakSelf.model.goodSum.intValue+1];
                weakSelf.googLabel.text = [NSString stringWithFormat:@"%d",weakSelf.googLabel.text.intValue+1];
            }
            else{
                weakSelf.model.goodSum = [NSString stringWithFormat:@"%d",weakSelf.model.goodSum.intValue-1];
                weakSelf.googLabel.text = [NSString stringWithFormat:@"%d",weakSelf.googLabel.text.intValue-1];
            }
        }
    }];
    
}

-(void)postPicture:(NSString*)myparterid
{
    self.shareView.shareMyType = shareInType;
    self.shareView.initShareView = self;
    self.shareView.parterid = [NSString stringWithFormat:@"%@",myparterid];
    [self.shareView createView:shareViewType_loadPhotoView];
    [self.view addSubview:self.shareView];
}

#pragma mark - 团组成员页面
-(void)goToGroupUser{
    GroupTeamViewController *team = [[GroupTeamViewController alloc] init];
    team.groupId = self.groupId;
    team.creatorId = self.model.gamecrtor;
    team.gameangle = self.gameangle;
    [self.navigationController pushViewController:team animated:YES];
}

#pragma mark - 团组信息
- (void)goToGroupMessage {
    GroupMessageViewController *gM = [[GroupMessageViewController alloc] init];
    gM.groupId = self.groupId;
    [self.navigationController pushViewController:gM animated:YES];
}

#pragma mark - 去往站内邀请页面
- (IBAction)invitationButton:(id)sender {
    [MobClick event:@"GroupInviteClick"];//邀请点击次数
    [self createShareView:inType];
}   

#pragma mark 进度页面（目标完成）
- (void)planButton{
    PlanViewController *plan = [[PlanViewController alloc]initWithNibName:@"PlanViewController" bundle:nil];
    plan.gameid = self.groupId;
    [self.navigationController pushViewController:plan animated:YES];
}

-(void)sendSuccess{
    [self refresh];
    if (self.data.count>0) {
        if ([self.model.gamemode isEqualToString:@"3"]) {
            [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else{
            [self.table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
    }
}   
#pragma mark 团聊页面
- (void)groupTalkButton{
    if (![self.model.gamemode isEqualToString:@"3"]) {
        [self talk];
        return;
    }
    UIView *talkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    talkView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:[talkView bounds]];
    //    [bar setBarTintColor:[UIColor colorWithWhite:1 alpha:1]];
    bar.barStyle = UIBarStyleDefault;
    bar.alpha = 0.9;
    bar.translucent = YES;
    [talkView addSubview:bar];
    
    self.talkView = talkView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noTalk)];
    [talkView addGestureRecognizer:tap];
    //白色背景
    UIView *white = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150)];
    [talkView addSubview:white];
    white.backgroundColor = [UIColor whiteColor];
    CGFloat btnLeft = (SCREEN_WIDTH - 120)/4;
    //说点啥
    UIButton *talkBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnLeft, 29, 60, 60)];
    [white addSubview:talkBtn];
    [talkBtn setBackgroundImage:[UIImage imageNamed:@"ksfb-120"] forState:UIControlStateNormal];
    UILabel *talkLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, talkBtn.bottom + 9, SCREEN_WIDTH/2, 16)];
    talkLbl.text = @"快速发布";
    talkLbl.font = MyFont(15);
    talkLbl.textAlignment = NSTextAlignmentCenter;
    talkLbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    [white addSubview:talkLbl];
    
    UIButton *BigBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 150)];
    [white addSubview:BigBtn];
    [BigBtn addTarget:self action:@selector(talk) forControlEvents:UIControlEventTouchUpInside];
    //精华
    talkBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - btnLeft - 60, 29, 60, 60)];
    [white addSubview:talkBtn];
    [talkBtn setBackgroundImage:[UIImage imageNamed:@"bjjh-120"] forState:UIControlStateNormal];
    talkLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, talkBtn.bottom + 9, SCREEN_WIDTH/2, 16)];
    talkLbl.text = @"编辑精华";
    talkLbl.font = MyFont(15);
    talkLbl.textAlignment = NSTextAlignmentCenter;
    talkLbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    [white addSubview:talkLbl];
    BigBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 150)];
    [white addSubview:BigBtn];
    [BigBtn addTarget:self action:@selector(talkMore) forControlEvents:UIControlEventTouchUpInside];

    //中间分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 1, 25, 1, 100)];
    line.backgroundColor = [WWTolls colorWithHexString:@"#ebebeb"];
    [white addSubview:line];
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:talkView];
}

#pragma mark - 前往精华帖列表
- (void)gotoMoreArticle{
    ArticleListViewController *list = [[ArticleListViewController alloc] init];
    list.groupId = self.groupId;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - 说点啥
- (void)talk{
    TalkAboutViewController *talk = [[TalkAboutViewController alloc]initWithNibName:@"TalkAboutViewController" bundle:nil];
    talk.delegate = self;
    talk.userid = [NSUSER_Defaults objectForKey:ZDS_USERID];
    talk.gmpassword = self.model.gmpassword;
    talk.gameid = self.groupId;
    talk.hiddenSynch = YES;
    [self.navigationController
     pushViewController:talk animated:YES];
    [self noTalk];
}

- (void)talkMore{
    CreateArticleViewController *talk = [[CreateArticleViewController alloc]init];
    talk.groupId = self.groupId;
    [self.navigationController
     pushViewController:talk animated:YES];
    [self noTalk];
}

- (void)noTalk{
    [self.talkView removeFromSuperview];
}
@end
