//
//  GroupHappyViewController.m
//  zhidoushi
//
//  Created by nick on 15/10/8.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？

#import "GroupHappyViewController.h"
#import "DiscoverViewController.h"
#import "GroupTagView.h"
//分享相关
#import "InitShareButton.h"
#import "InitShareView.h"
#import "InitShareWeightView.h"
#import "ShareGameSubClassView.h"
#import "NARShareView.h"
#import "InvitationViewController.h"
#import "PlanViewController.h"
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
#import "HyPopMenuView.h"
#import "MenuLabel.h"
#import "EditorTagAlertView.h"
#import "UIView+SSLAlertViewTap.h"
#import "EditorLoseWayAlertView.h"
#import "IQKeyboardManager.h"
#import "MyCalendarViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "KYGooeyMenu.h"

#import "DXAlertView.h"
#import "GroupEditeViewController.h"

static NSString *UrgeMessage = @"催促消息已经发出，团长很快就会发布任务啦！这段时间可不要懈怠哦~";
static NSString *NoPubTaskMessage = @"团长大人还没有发布任务";
static NSString *ToUrgeMessage = @"这个团长很懒，居然没有留下任务，团员们快去催催他！";

//内容颜色
static NSString *TextColor = @"#999999";

@interface GroupHappyViewController ()<NARShareViewDelegate,InitShareViewDelegate,InitShareDelegate,
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
    InitShareView * shareView;
    InitShareButton * button;
}
@property (nonatomic,strong) NSString *topType;


@property (nonatomic,strong) UILabel *notreadctLabel;

@property (nonatomic,strong) UIButton *joinButton;
@property (nonatomic,strong) UIButton *uploadWeightButton;
@property (nonatomic,strong) UIView *userView;


@property (nonatomic,assign) BOOL isHasLoadArticle;

//上传体重弹框
@property(nonatomic,strong)InitShareWeightView *shareWeightView;

//团长任务内容label
@property(nonatomic,strong)UILabel *taskContentLabel;

//完成任务按钮
@property(nonatomic,strong)UIButton *finishTaskButton;
//发布新任务按钮
@property(nonatomic,strong)UIButton *pubNewTaskbutton;


@property(nonatomic,strong)UIImageView *imageView;//封面
@property(nonatomic,strong)UIView *back;//


@property(nonatomic,strong)UITableView *contentTableView;//

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



@property(nonatomic,strong)UIImage *image;//分享用的图片
@property(nonatomic,strong)UIView *footerView;//底部视图
@property(nonatomic,strong)UIView *talkView;//说点啥选择视图
@property(nonatomic,assign)BOOL talkBarLoadDone;//乐活吧加载成功标示

//@property(nonatomic,strong)UIView *burNav;//毛玻璃导航栏
@property(nonatomic,strong)UIView *playBarView;//乐活吧视图
@property(nonatomic,strong)UIButton *closePlayBarBtn;//乐活吧关闭按钮
@property(nonatomic,strong)UILabel *groupNameLbl;//团组名称
@property(nonatomic,strong)NSMutableArray *hotTags;//热门标签
@property(nonatomic,strong)UIButton *barBack;//返回
@property(nonatomic,strong)UIButton *barMore;//更多
@property(nonatomic,strong)UIButton *barShara;//更多
@property(nonatomic,assign)CGPoint backContentOffset;//当前滚动位置
@property(nonatomic,strong)UIView *topView;//顶部视图
@property(nonatomic,strong)UIView *bottomView;//底部视图
@property(nonatomic,strong)UIButton *topBtn;//展开按钮
@property(nonatomic,weak)TalkBarViewController *playControl;//乐活吧
@property(nonatomic,strong)UIImageView *dakaTag;//<#强引用#>
@property(nonatomic,strong)UIImageView *mengceng;//提示蒙层
@property(nonatomic,strong)UIView *messageView;//团组信息
@property(nonatomic,strong)UIView *tagView;//标签视图
@property(nonatomic,strong)KYGooeyMenu *jiahaoMenu;//加号按钮
@property(nonatomic,strong)UIImageView *dieceng;//叠层
/** 记录下最开始的Y轴偏移量 */
@property (nonatomic, assign) CGFloat oriOffsetY;

@end

@implementation GroupHappyViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"团组详情页面"];
    [self.jiahaoMenu close];
//    self.navigationController.navigationBarHidden = NO;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -50;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -50;
    self.navigationController.navigationBar.top = 20;
    self.titleLabel.textColor = TitleColor;
    self.barShara.selected = YES;
    self.barMore.selected = YES;
    self.leftButton.selected = YES;
//    [self.barMore setTitleColor:TitleColor forState:UIControlStateNormal];
//    [self.barShara setTitleColor:TitleColor forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:TitleColor forState:UIControlStateNormal];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [self.httpOpt cancel];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //友盟打点
    [MobClick beginLogPageView:@"团组详情页面"];
//    [self.navigationController setNavigationBarHidden:YES];
    
    
    if (![self.gameangle isEqualToString:@"3"]) {
        if ([self.model.ispunch isEqualToString:@"0"]) {
            self.dakaTag.image = [UIImage imageNamed:@"cxjl-116-40"];
        }
    }
    [self scrollViewDidScroll:self.contentTableView];
}

-(void)removemengceng:(UIGestureRecognizer*)tt{
    [tt.view removeFromSuperview];
    [NSUSER_Defaults setObject:@"YES" forKey:@"tuanzuyindang"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isHasLoadArticle) {
        [self downloadGroupImage];
        [self reloadTitleArticle];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    if ([_gameDetailStatus isEqualToString:@"10086"]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    //页面变化
//    self.back.contentInset = UIEdgeInsetsZero;
    
}

#pragma mark NSNotification
-(void)good:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"receiveid"]]) {
            model.goodStatus = dic[@"praisestatus"];
            model.goodSum =[NSString stringWithFormat:@"%d",[model.goodStatus isEqualToString:@"0"]?model.goodSum.intValue+1:model.goodSum.intValue-1];
            [self.contentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
-(void)com:(NSNotification*)object{
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue+1];
            [self.contentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}
-(void)delteReply:(NSNotification*)object{
    
    NSDictionary *dic = object.object;
    for (int i = 0;i<self.data.count;i++) {
        GroupTalkModel *model  = self.data[i];
        if ([model.barid isEqualToString:dic[@"talkid"]]) {
            model.commentcount =[NSString stringWithFormat:@"%d",model.commentcount.intValue-1];
            [self.contentTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
}
- (void)joinGroupsucess:(NSNotification*)no{
    if ([no.object[@"gameid"] isEqualToString:self.groupId]) {
        [self reloadGroupData];
        [self.playControl refresh];
    }
}
- (void)pushCardSucess{
    self.model.ispunch = @"0";
//    if (![self.gameangle isEqualToString:@"3"]) {
//        if ([self.model.ispunch isEqualToString:@"0"]) {
//            self.dakaTag.image = [UIImage imageNamed:@"cxjl-32-108"];
//            self.dakaTag.width = 54;
//            self.dakaTag.left = (SCREEN_WIDTH - 20)/2 - 58;
//        }
//    }
}


#pragma mark - 加号事件
//- (void) createContextSheet {
////    [MenuLabel CreatelabelIconName:@"lhb-100" Title:@"乐活吧" images:LHBimagesArray],
////    [MenuLabel CreatelabelIconName:@"jht-100" Title:@"精华帖" images:JHTimagesArray],
////    [MenuLabel CreatelabelIconName:@"qftz-100" Title:@"群发通知" images:QFTZimagesArray],
//    VLDContextSheetItem *item1 = [[VLDContextSheetItem alloc] initWithTitle: @"乐活吧"
//                                                                      image: [UIImage imageNamed: @"lhb-100"]
//                                                           highlightedImage: [UIImage imageNamed: @"lhb-100"]];
//    
//    
//    VLDContextSheetItem *item2 = [[VLDContextSheetItem alloc] initWithTitle: @"精华帖"
//                                                                      image: [UIImage imageNamed: @"jht-100"]
//                                                           highlightedImage: [UIImage imageNamed: @"jht-100"]];
//    
//    VLDContextSheetItem *item3 = [[VLDContextSheetItem alloc] initWithTitle: @"群发通知"
//                                                                      image: [UIImage imageNamed: @"qftz-100"]
//                                                           highlightedImage: [UIImage imageNamed: @"qftz-100"]];
//    
//    if([self.gameangle isEqualToString:@"1"]) self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[ item1, item2, item3 ]];
//    else self.contextSheet = [[VLDContextSheet alloc] initWithItems: @[ item1, item2]];
//    self.contextSheet.delegate = self;
//}
//
#pragma mark - 加号更多
-(void)menuDidOpen{
    self.dieceng.hidden = NO;
}
-(void)menuDidClose{
    self.dieceng.hidden = YES;
}
-(void)menuDidSelected:(NSInteger)index{
    NSLog(@"选中第%ld",(long)index);
    if (![self.gameangle isEqualToString:@"1"]) {
        if (index == 1) {
            [self talk];
        }else [self talkMore];
    }else{
        switch (index) {
            case 2:
                [self talk];
                break;
            case 1:
                [self talkMore];
                break;
            case 0:
            {
                SendAllMessageViewController *send = [[SendAllMessageViewController alloc] init];
                send.gameId = self.groupId;
                send.gameName = self.model.groupName;
                send.model = self.model;
                [self.navigationController pushViewController:send animated:YES];
                
            }
                break;
            default:
                break;
        }
    }
    
}

//- (void) contextSheet: (VLDContextSheet *) contextSheet didSelectItem: (VLDContextSheetItem *) item {
//    if ([item.title isEqualToString:@"乐活吧"]) {
//        [self talk];
//    }else if ([item.title isEqualToString:@"精华帖"]) {
//        [self talkMore];
//    }else if ([item.title isEqualToString:@"群发通知"]) {
//        SendAllMessageViewController *send = [[SendAllMessageViewController alloc] init];
//        send.gameId = self.groupId;
//        send.gameName = self.model.groupName;
//        send.model = self.model;
//        [self.navigationController pushViewController:send animated:YES];
//    }else if ([item.title isEqualToString:@"上传体重"]) {
//        [self uploadWeightButtonClick:nil];
//    }
//    NSLog(@"Selected item: %@", item.title);
//}
//
//- (void) longPressed: (UIGestureRecognizer *) gestureRecognizer {
////    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//    
//        [self.contextSheet startWithGestureRecognizer: gestureRecognizer
//                                               inView: self.view];
////    }
//}
//- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
//duration: (NSTimeInterval) duration {
//    
//    [super willRotateToInterfaceOrientation: toInterfaceOrientation duration: duration];
//    
//    [self.contextSheet end];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化导航栏
    [self setupNav];
    self.isHasLoadArticle = NO;
//    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(breakUpGroupNoti) name:@"breakUpGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleArticle) name:@"grouptitletoggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleArticle) name:@"sendTitleSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTitleArticle) name:@"grouptitletop" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitTaskSucess) name:@"submitTaskSucess" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinGroupsucess:) name:@"joinGroupSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publicTaskSucessNotify) name:@"PushTaskGroupSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endTaskSucessNotify) name:@"endTaskSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCardSucess) name:@"pushcardSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(good:) name:@"goodReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(com:) name:@"comReply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delteReply:) name:@"delteReply" object:nil];
    _hotTags = [NSMutableArray array];
    _data = [NSMutableArray array];
    self.backContentOffset = CGPointZero;
    if (self.model) {
        self.ArticleData = [NSMutableArray array];
//        TalkBarViewController *play = [[TalkBarViewController alloc] init];
//        play.groupId = self.groupId;
//        play.gameangle = self.gameangle;
//        play.happyCtl = self;
//        self.playControl = play;
//        self.playBarView = play.view;
//        self.playBarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self setUpGUI];
        [self refresh];
        if ([self.gameangle isEqualToString:@"1"]) {
            [self loadWhereTag];
        }
    }else{
        //团组封面
        UIImageView *header = [[UIImageView alloc] init];
        header.frame = CGRectMake(0, -60, SCREEN_WIDTH, SCREEN_WIDTH);
        header.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:header];
        //黑色贴图
        UIImageView *backHead = [[UIImageView alloc] init];
        backHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
        backHead.image = [UIImage imageNamed:@"zz-640"];
        [header addSubview:backHead];
        
        UIView *bb = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH - 60, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bb.backgroundColor = ZDS_BACK_COLOR;
        [self.view addSubview:bb];
        
        //返回按钮
        UIButton *lastBtn = [[UIButton alloc] init];
        lastBtn.frame = CGRectMake(10, 10, 30, 30);
        [lastBtn setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
        [lastBtn addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:lastBtn];
        
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(0, 100, SCREEN_WIDTH, 50);
        lbl.text = @"加载中...";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        [self.view addSubview:lbl];
        //导航栏标题
        self.titleLabel.text = self.model.groupName.length<1?@"":self.model.groupName;
        self.titleLabel.textColor = TitleColor;
        self.titleLabel.font = MyFont(17);
        
        //导航栏返回
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.leftButton.titleLabel.font = MyFont(13);
        [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
        CGRect labelRect = self.leftButton.frame;
        labelRect.size.width = 16;
        labelRect.size.height = 16;
        self.leftButton.frame = labelRect;
        
        self.model = [[GroupHeaderModel alloc] init];
        self.ArticleData = [NSMutableArray array];
//        TalkBarViewController *play = [[TalkBarViewController alloc] init];
//        play.groupId = self.groupId;
//        self.playBarView = play.view;
//        
//        [self.back addSubview:play.view];
//        self.playBarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self reloadGroupData];
    }
    
    
}

#pragma mark - 乐活吧点击
- (void)playBarClick{
//    [UIView animateWithDuration:0.5 animations:^{
//        self.playBarView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        self.closePlayBarBtn.hidden = NO;
////        self.burNav.hidden = NO;
//        self.barBack.selected = YES;
//        self.barMore.selected = YES;
//        self.barShara.selected = YES;
//    }];
}

- (void)closePlayBar{
//    self.closePlayBarBtn.hidden = YES;
////    self.burNav.hidden = !(self.back.contentOffset.y > 60);
//    self.barBack.selected = self.back.contentOffset.y > SCREEN_WIDTH - 60;
//    self.barMore.selected = self.barBack.selected;
//    self.barShara.selected = self.barMore.selected;
//    [UIView animateWithDuration:0.5 animations:^{
//        self.playBarView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
//    } completion:^(BOOL finished) {
//        
//    }];
}
/*
- (void)jiahaoTalkMore{
    //团长 乐活吧 精品贴 群发通知 上传体重
    NSMutableArray *LHBimagesArray = [NSMutableArray array];
    for (int i = 1; i<18; i++) {
        [LHBimagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"铅笔%d",i]]];
    }
    NSMutableArray *JHTimagesArray = [NSMutableArray array];
    for (int i = 1; i<13; i++) {
        [JHTimagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"报纸%d",i]]];
    }
    NSMutableArray *QFTZimagesArray = [NSMutableArray array];
    for (int i = 1; i<5; i++) {
        [QFTZimagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"喇叭%d",i]]];
    }
    NSMutableArray *SCTZimagesArray = [NSMutableArray array];
    for (int i = 1; i<12; i++) {
        [SCTZimagesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"称%d",i]]];
    }
    
    NSArray *Objs = @[
                      [MenuLabel CreatelabelIconName:@"lhb-100" Title:@"乐活吧" images:LHBimagesArray],
                      [MenuLabel CreatelabelIconName:@"jht-100" Title:@"精华帖" images:JHTimagesArray],
                      [MenuLabel CreatelabelIconName:@"qftz-100" Title:@"群发通知" images:QFTZimagesArray],
                      [MenuLabel CreatelabelIconName:@"称1" Title:@"上传体重" images:SCTZimagesArray],
                      ];
    if([self.gameangle isEqualToString:@"2"]){
        Objs = @[
                 [MenuLabel CreatelabelIconName:@"lhb-100" Title:@"乐活吧" images:LHBimagesArray],
                 [MenuLabel CreatelabelIconName:@"jht-100" Title:@"精华帖" images:JHTimagesArray],
                 [MenuLabel CreatelabelIconName:@"称1" Title:@"上传体重" images:SCTZimagesArray],
                 ];
    }
    
    WEAKSELF_SS
    [HyPopMenuView CreatingPopMenuObjectItmes:Objs TopView:nil OpenOrCloseAudioDictionary:nil SelectdCompletionBlock:^(MenuLabel *menuLabel, NSInteger index) {
        if ([menuLabel.title isEqualToString:@"乐活吧"]) {
            [weakSelf talk];
        }else if ([menuLabel.title isEqualToString:@"精华帖"]) {
            [weakSelf talkMore];
        }else if ([menuLabel.title isEqualToString:@"群发通知"]) {
            SendAllMessageViewController *send = [[SendAllMessageViewController alloc] init];
            send.gameId = self.groupId;
            send.gameName = self.model.groupName;
            send.model = self.model;
            [weakSelf.navigationController pushViewController:send animated:YES];
        }else if ([menuLabel.title isEqualToString:@"上传体重"]) {
            [weakSelf uploadWeightButtonClick:nil];
        }
    }];
}
*/

- (void)setupNav {
    
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.titleLabel.text = self.model.groupName;
    self.titleLabel.textColor = [UIColor whiteColor];

    // 导航条左侧返回按钮
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateSelected];
//    self.leftButton.titleLabel.font = MyFont(14);
//    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.bounds = CGRectMake(0, 0, 18, 18);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"fx-b-36"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"fx-c-36"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    button.size = CGSizeMake(18, 18);
    self.barShara = button;
    
    UIBarButtonItem *shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"gd-b-46"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"gd-c-100"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
    button.size = CGSizeMake(18, 18);
    self.barMore = button;
    
    UIBarButtonItem *moreButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(5, 5);
    UIBarButtonItem *jiange = [[UIBarButtonItem alloc] initWithCustomView:button];
//    moreButtonItem.tintColor = [UIColor blackColor];
//    UIBarButtonItem *moreButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"gd-46" highImageName:@"gd-h-46" target:self action:@selector(menu)];
    
    // 设置右边的按钮(夜间模式和设置按钮)
    if([self.gameangle isEqualToString:@"3"])
        self.navigationItem.rightBarButtonItems = @[shareButtonItem];
    else self.navigationItem.rightBarButtonItems = @[moreButtonItem,jiange,shareButtonItem];

}


- (void)setUpGUI{
//    for (UIView *view in self.view.subviews) {
//        [view removeFromSuperview];
//    }
    [self removeWaitView];
    //背景
    if(!self.contentTableView){
        self.view.backgroundColor = ZDS_BACK_COLOR;
        UITableView *contentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT + 64) style:UITableViewStylePlain];
        self.contentTableView = contentTableView;
        contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        contentTableView.backgroundColor = ZDS_BACK_COLOR;
        contentTableView.dataSource = self;
        contentTableView.delegate = self;
        [self.view addSubview:contentTableView];
        contentTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
        self.groupCell = [[GroupTalkTableViewCell alloc] init];
        //脚视图
        //    self.footerView = [[UIView alloc] init];
        //    self.footerView.frame = CGRectMake(0, SCREEN_HEIGHT-109, SCREEN_WIDTH, 47);
        //    self.footerView.clipsToBounds = YES;
        //    self.footerView.backgroundColor = [UIColor blueColor];
        //    [self.view addSubview:_footerView];
        //初始化刷新
        //    WEAKSELF_SS
        MJRefreshHeaderView *headerfresh = [MJRefreshHeaderView header];
        self.header = headerfresh;
        headerfresh.scrollView = self.contentTableView;
        headerfresh.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [self refresh];
        };
        
        MJRefreshFooterView *footerload = [MJRefreshFooterView footer];
        self.footer = footerload;
        footerload.scrollView = self.contentTableView;
        footerload.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
            [self loadData];
        };
//        UIImage *startImage = [UIImage imageNamed:@"jh-140-100"];
//
//        UIButton *talkBtn = [[UIButton alloc] init];
//        talkBtn.frame = CGRectMake(SCREEN_MIDDLE(45), SCREEN_HEIGHT-45 , 45, 45);
//        [talkBtn setBackgroundImage:[UIImage imageNamed:@"jh-140-100"] forState:UIControlStateNormal];
//        [talkBtn addTarget:self action:@selector(jiahaoClik:) forControlEvents:UIControlEventTouchUpInside];
        if(![self.gameangle isEqualToString:@"3"]){
            self.dieceng = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 210, SCREEN_WIDTH, 210)];
            self.dieceng.hidden = YES;
            self.dieceng.image = [UIImage imageNamed:@"jdc-750-420"];
            [self.view addSubview:self.dieceng];
            
            UIImage *image1 = [UIImage imageNamed:@"lhb-104-130"];
            UIImage *image2 = [UIImage imageNamed:@"jht-104-130"];
            UIImage *image3 = [UIImage imageNamed:@"qtz-104-130"];
            NSArray *images = @[image2, image1];
            if ([self.gameangle isEqualToString:@"1"]) {
                images = @[image3, image2, image1];
            }
            KYGooeyMenu *gooeyMenu = [[KYGooeyMenu alloc]initWithOrigin:CGPointMake(SCREEN_MIDDLE(50), SCREEN_HEIGHT-50) andDiameter:50.0f andDelegate:self themeColor:[UIColor clearColor] AndImages:images];
            self.jiahaoMenu = gooeyMenu;
            gooeyMenu.menuDelegate = self;
            gooeyMenu.radius = 100/4;//大圆的1/4
            gooeyMenu.extraDistance = 25;
            gooeyMenu.MenuCount = images.count;
//            [self.view addSubview:talkBtn];
        }
        //加入
        UIButton *talkBtn = [[UIButton alloc] init];
        talkBtn.frame = CGRectMake(SCREEN_MIDDLE(50), SCREEN_HEIGHT-60 , 50, 50);
        [talkBtn setBackgroundImage:[UIImage imageNamed:@"jh-100"] forState:UIControlStateNormal];
        [talkBtn addTarget:self action:@selector(joinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if([self.gameangle isEqualToString:@"3"]) [self.view addSubview:talkBtn];
    }
    
    
    
    
    UIView *back = [[UIView alloc] init];
//    back.scrollsToTop = YES;
//    back.delaysContentTouches = NO;
//    back.showsVerticalScrollIndicator = NO;
//    back.delegate = self;
    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    [self.contentTableView addSubview:back];
    
    
    self.back = back;
    //底部乐活吧按钮
//    UIButton *playBarBtn = [[UIButton alloc] init];
//    playBarBtn.frame = CGRectMake(0, SCREEN_HEIGHT-42 , SCREEN_WIDTH, 42);
//    [playBarBtn setBackgroundImage:[UIImage imageNamed:@"lhb-640-84"] forState:UIControlStateNormal];
//    [playBarBtn addTarget:self action:@selector(playBarClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:playBarBtn];

    //毛玻璃透明导航栏
//    UIView *burNav = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
//    [burNav ssl_addWhiteBlur];
    //标题
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 45)];
//    [burNav addSubview:titleLbl];
//    titleLbl.textAlignment = NSTextAlignmentCenter;
//    titleLbl.textColor = ZDS_DHL_TITLE_COLOR;
//    titleLbl.font = MyFont(16);
    //返回
//    UIButton *gobackBtn = [[UIButton alloc] init];
//    self.barBack = gobackBtn;
//    gobackBtn.frame = CGRectMake(10, 24, 18, 18);
//    [gobackBtn addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
//    [gobackBtn setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
//    [gobackBtn setBackgroundImage:[UIImage imageNamed:@"fh-h-36"] forState:UIControlStateSelected];
//    [burNav addSubview:gobackBtn];
//    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 21, 0, 0)];
//    if (![self.gameangle isEqualToString:@"3"]) {//团员
//        //更多
//        moreBtn.frame = CGRectMake(SCREEN_WIDTH - 12 - 23, 21, 23, 23);
//        self.barMore = moreBtn;
//        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gd-46"] forState:UIControlStateNormal];
//        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gd-h-46"] forState:UIControlStateSelected];
//        
////        [burNav addSubview:moreBtn];
//        [moreBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
//    }
//    //分享
//    UIButton *fenxiang = [[UIButton alloc] initWithFrame:CGRectMake(moreBtn.left - 12 - 18, 23, 18, 18)];
//    if(moreBtn.width == 18) fenxiang.left -= 18;
//    [fenxiang setBackgroundImage:[UIImage imageNamed:@"fx-40"] forState:UIControlStateNormal];
//    [fenxiang setBackgroundImage:[UIImage imageNamed:@"fx-h-36"] forState:UIControlStateSelected];
//    [fenxiang addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
////    [burNav addSubview:fenxiang];
//    self.barShara = fenxiang;
    
//    [self.view addSubview:burNav];
//    self.burNav = burNav;
//    burNav.hidden = YES;
    
    //乐活吧视图
    [self.view addSubview:self.playBarView];
    
//    //顶部乐活吧返回按钮
//    playBarBtn = [[UIButton alloc] init];
//    playBarBtn.hidden = YES;
//    if(self.closePlayBarBtn && !self.closePlayBarBtn.hidden) playBarBtn.hidden = NO;
//    self.closePlayBarBtn = playBarBtn;
//    playBarBtn.frame = CGRectMake(0, 20 , SCREEN_WIDTH, 42);
//    [playBarBtn setBackgroundImage:[UIImage imageNamed:@"lhb-640-84-"] forState:UIControlStateNormal];
//    UIView *btnline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    btnline.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//    [playBarBtn addSubview:btnline];
//    UIImageView *jt = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fh-36"]];
//    jt.frame = CGRectMake(SCREEN_WIDTH - 10 - 18, 12, 18, 18);
//    [playBarBtn addSubview:jt];
//    [playBarBtn addTarget:self action:@selector(closePlayBar) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:playBarBtn];
    
    
    
    //加号
//    UIButton *talkBtn = [[UIButton alloc] init];
//    talkBtn.frame = CGRectMake(SCREEN_MIDDLE(70), SCREEN_HEIGHT-50 , 70, 50);
//    [talkBtn setBackgroundImage:[UIImage imageNamed:@"jh-140-100"] forState:UIControlStateNormal];
//    UITapGestureRecognizer *tt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
//    [talkBtn addGestureRecognizer:tt];
    
    
    
    
    UIView *jianzhiBack = [[UIView alloc] init];
    [back addSubview:jianzhiBack];
    
    //团组封面
    UIImageView *header = [[UIImageView alloc] init];
    self.imageView = header;
    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    header.clipsToBounds = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    header.backgroundColor = [UIColor whiteColor];
    [header sd_setImageWithURL:[NSURL URLWithString:self.model.groupImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image;
    }];
    [back addSubview:header];
    //黑色贴图
    UIImageView *backHead = [[UIImageView alloc] init];
    backHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
    backHead.image = [UIImage imageNamed:@"zz-640"];
    [header addSubview:backHead];
    
    
    //返回按钮
//    UIButton *lastBtn = [[UIButton alloc] init];
//    lastBtn.frame = CGRectMake(10, 20, 30, 30);
//    [lastBtn setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
//    [lastBtn addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
////    [back addSubview:lastBtn];
//    moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 18, 0, 0)];
//    if (![self.gameangle isEqualToString:@"3"]) {//团员
//        //更多
//        moreBtn.frame = CGRectMake(SCREEN_WIDTH - 12 - 20, 28, 20, 20);
//        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gd-46"] forState:UIControlStateNormal];
////        [back addSubview:moreBtn];
//        [moreBtn addTarget:self action:@selector(menu) forControlEvents:UIControlEventTouchUpInside];
//    }
//    //分享
//    fenxiang = [[UIButton alloc] initWithFrame:CGRectMake(moreBtn.left - 12 - 20, 28, 20, 20)];
//    if(moreBtn.width == 20) fenxiang.left -= 18;
//    [fenxiang setBackgroundImage:[UIImage imageNamed:@"fx-40"] forState:UIControlStateNormal];
//    [fenxiang addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
//    [back addSubview:fenxiang];
    
    
    
    //标签
//    UIView *messageView = [[UIView alloc] init];
//    self.messageView = messageView;
//    [back addSubview:messageView];
//    messageView.frame = CGRectMake(0, 260, SCREEN_WIDTH, 41);
//    UILabel *tag = [[UILabel alloc] init];
//    [messageView addSubview:tag];
//    tag.hidden = NO;
//    tag.textColor = [UIColor whiteColor];
//    tag.font = MyFont(10);
//    tag.textAlignment = NSTextAlignmentCenter;
//    tag.layer.cornerRadius = 10;
//    tag.clipsToBounds = YES;
//    tag.frame = CGRectMake(15, 0, 44, 20);
//    if([self.model.desctag isEqualToString:@"1"]){
//        tag.text = @"官方团";
//        tag.backgroundColor = [WWTolls colorWithHexString:@"#565bd9"];
//    }else if([self.model.desctag isEqualToString:@"2"]){
//        tag.text = @"已爆满!";
//        tag.backgroundColor = [WWTolls colorWithHexString:@"#e99312"];
//    }else if([self.model.desctag isEqualToString:@"3"]){
//        tag.text = @"HOT!";
//        tag.font = MyFont(11);
//        tag.backgroundColor = [WWTolls colorWithHexString:@"#ea5041"];
//    }else if([self.model.desctag isEqualToString:@"4"]){
//        tag.text = @"NEW!";
//        tag.font = MyFont(11);
//        tag.backgroundColor = [WWTolls colorWithHexString:@"#da4a94"];
//    }else if([self.model.isfull isEqualToString:@"0"]){
//        tag.text = @"已爆满!";
//        tag.backgroundColor = [WWTolls colorWithHexString:@"#e99312"];
//    }else{
//        tag.hidden = YES;
//    }
    // 团组名称
//    UILabel *namelbl = [[UILabel alloc] init];
//    self.groupNameLbl = namelbl;
//    namelbl.frame = CGRectMake(10, 177, 320, 23);
    
//    CGFloat renshuTop = namelbl.bottom;
//    if (!tag.hidden || [self.model.groupTags componentsSeparatedByString:@","][0].length > 0) {
//        namelbl.top = 148;
//        renshuTop = namelbl.bottom + 30;
//    }
//    namelbl.font = MyFont(23);
//    namelbl.textColor = [UIColor whiteColor];
//    namelbl.text = self.model.groupName;
//    [namelbl sizeToFit];
//    [back addSubview:namelbl];
    
    
    
    //视图动画按钮
    UIButton *topBtn = [[UIButton alloc] init];
    topBtn.selected = !self.topBtn.selected;
    if (!self.topBtn) {
        topBtn.selected = NO;
    }
    self.topBtn = topBtn;
    [topBtn setBackgroundImage:[UIImage imageNamed:@"sq-b-30"] forState:UIControlStateNormal];
    [topBtn setBackgroundImage:[UIImage imageNamed:@"zk-b-30"] forState:UIControlStateSelected];
    topBtn.frame = CGRectMake(SCREEN_WIDTH -15 -11, 300 - 11 - 15, 11, 11);
    if(![self.gameangle isEqualToString:@"3"]) [back addSubview:topBtn];
    [topBtn addTarget: self action:@selector(ShowDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    //标签
//    tag.top = namelbl.bottom + 7;
//    UILabel *taglbl = [[UILabel alloc] init];
//    taglbl.frame = CGRectMake(10, namelbl.bottom + 7, 43, 20);
//    if (!tag.hidden) {
//        taglbl.left = tag.right + 5;
//    }
//    taglbl.font = MyFont(10);
//    taglbl.textAlignment = NSTextAlignmentCenter;
//    taglbl.textColor = [UIColor whiteColor];
//    taglbl.text = [self.model.groupTags componentsSeparatedByString:@","][0];
//    if (taglbl.text.length<1) {
//        taglbl.hidden = YES;
//    }
//    taglbl.layer.cornerRadius = 10;
//    taglbl.clipsToBounds = YES;
//    taglbl.layer.borderWidth = 0.5;
//    taglbl.layer.borderColor = [UIColor whiteColor].CGColor;
//    [back addSubview:taglbl];
    
    
    
//    //团组减重
//    UIImageView *tuanzu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gjz-32-32"]];
//    tuanzu.frame = CGRectMake(10, renshu2.bottom+9, 16, 16);
//    [back addSubview:tuanzu];
//    UILabel *tuanzu2 = [[UILabel alloc] init];
//    tuanzu2.frame = CGRectMake(32, renshu2.bottom+9, 200, 16);
//    tuanzu2.font = MyFont(14);
//    tuanzu2.textColor = [UIColor whiteColor];
//    tuanzu2.text = [NSString stringWithFormat:@"团减重 %@kg",self.model.gtotallose];
//    [back addSubview:tuanzu2];
    
    
    
//    //动态
//    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(back.width - 12 - 38, tuanzu.maxY - 10, 38, 12)];
//    [back addSubview:dynamicLabel];
//    //    dynamicLabel.backgroundColor = [UIColor redColor];
//    dynamicLabel.text = @"条动态";
//    dynamicLabel.font = MyFont(12.0);
//    dynamicLabel.textColor = [WWTolls colorWithHexString:@"#ffffff"];
//    
//    UILabel *dynamicCount = [[UILabel alloc] initWithFrame:CGRectMake(dynamicLabel.x - 6 - 100, dynamicLabel.y, 100, 12)];
//    [back addSubview:dynamicCount];
//    dynamicCount.text = [NSString stringWithFormat:@"%@",self.model.dyncount];
//    dynamicCount.textColor = [WWTolls colorWithHexString:@"#ffffff"];
//    dynamicCount.font = MyFont(12.0);
//    dynamicCount.textAlignment = NSTextAlignmentRight;
    
    
    CGFloat xuanyanH = [WWTolls heightForString:self.model.xuanyan fontSize:13 andWidth:SCREEN_WIDTH - 30] + 20;
    UILabel *fangfaLbl = [[UILabel alloc] init];
    fangfaLbl.frame = CGRectMake(15, 300 - xuanyanH - 5, SCREEN_WIDTH - 24, xuanyanH);
    fangfaLbl.font = MyFont(13);
    fangfaLbl.text = self.model.xuanyan;
    fangfaLbl.textColor = [UIColor whiteColor];
    fangfaLbl.numberOfLines = 0;
    [back addSubview:fangfaLbl];
    if (self.model.xuanyan.length < 1) {
        fangfaLbl.top = 290;
    }
    
    //人数
    UIImageView *renshu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rs-b-22"]];
    renshu.frame = CGRectMake(15, fangfaLbl.top - 16, 11, 11);
    [back addSubview:renshu];
    UILabel *renshu2 = [[UILabel alloc] init];
    renshu2.frame = CGRectMake(29, fangfaLbl.top - 18, 170, 15);
    renshu2.font = MyFont(13);
    renshu2.textColor = [UIColor whiteColor];
    renshu2.text = [NSString stringWithFormat:@"%@%@",self.model.partercount,!self.model.todayaddct || [self.model.todayaddct isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"（今日新增%@人）",self.model.todayaddct]];
    [back addSubview:renshu2];
    
    
    jianzhiBack.backgroundColor = [UIColor whiteColor];
    jianzhiBack.frame = CGRectMake(0, 300, SCREEN_WIDTH, 0);
    self.topView = jianzhiBack;
//    UIView *tagBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
//    self.tagView = tagBack;
//    tagBack.backgroundColor = [UIColor clearColor];
    
    GroupTagView *tagView = [[GroupTagView alloc] init];
    tagView.backgroundColor = [UIColor clearColor];
    tagView.frame = CGRectMake(0, 18, SCREEN_WIDTH, 0);
    tagView.isShowEditor = NO;
    tagView.tags = [self.model.taglist componentsSeparatedByString:@","];
//    WEAKSELF_SS
//    tagView.EditorClick = ^{
//        EditorTagAlertView *discover = [[EditorTagAlertView alloc] initWithFrame:weakSelf.view.window.bounds delegate:self];
//        discover.clickEvent = TJ_GROUPDETAIL_EDITORTAG_QX;
//        [discover createViewWithSelectTags:[self.model.taglist componentsSeparatedByString:@","] AndHotTags:weakSelf.hotTags];
//        [weakSelf.view.window addSubview:discover];
//        [discover ssl_show];
//    };
    [jianzhiBack addSubview:tagView];
    if (tagView.height != 0) {
        jianzhiBack.height = tagView.bottom + 3;
    }
//    [tagBack addSubview:tagView];
//    tagBack.height = tagView.height;
//    messageView.top = 245 - tagView.height;
//    tagBack.top = header.bottom - tagBack.height;
        //减脂方法
//    UIView *jianzhiway = [[UIView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH, 0)];
//    jianzhiway.backgroundColor = [UIColor whiteColor];
    if (self.model.friendcount && ![self.model.friendcount isEqualToString:@"0"]) {
        
        //            UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(12, jianzhiway.height + 5, (SCREEN_WIDTH - 119)/2, 0.5)];
        //            leftLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        //            [jianzhiway addSubview:leftLine];
        
        UILabel *font = [[UILabel alloc] init];
        font.frame = CGRectMake(15, (tagView.height == 0 ? 0 : tagView.bottom) + 22, 105, 17);
        font.text = [NSString stringWithFormat:@"%@位好友在这里",self.model.friendcount];
        //            font.textAlignment = NSTextAlignmentCenter;
        font.font = MyFont(14);
        font.textColor = OrangeColor;
        [font sizeThatFits:CGSizeMake(MAXFLOAT, 17)];
        [jianzhiBack addSubview:font];
        
        //            UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(font.right, jianzhiway.height + 5, SCREEN_WIDTH - font.right - 12, 0.5)];
        //            rightLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        //            [jianzhiway addSubview:rightLine];
        
        UIScrollView *scroll = [[UIScrollView alloc] init];
        [jianzhiBack addSubview:scroll];
        scroll.frame = CGRectMake(font.right + 10, (tagView.height == 0 ? 0 : tagView.bottom) + 15, SCREEN_WIDTH - font.right - 10, 34);
        scroll.bounces = NO;
        scroll.showsVerticalScrollIndicator = NO;
        scroll.showsHorizontalScrollIndicator = NO;
        //好友头像
        CGFloat x = 0;
        for (int i = 0; i<self.model.friendList.count; i++) {
            UIButton *head = [[UIButton alloc] init];
            head.frame = CGRectMake(x, 0, 34, 34);
            head.clipsToBounds = YES;
            head.layer.cornerRadius = 17;
            head.titleLabel.text = self.model.friendList[i][@"userid"];
            [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.friendList[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
            [head addTarget:self action:@selector(clickPater:) forControlEvents:UIControlEventTouchUpInside];
            [scroll addSubview:head];
            x+= 40;
        }
        scroll.contentSize = CGSizeMake(x, 0);
        
        jianzhiBack.height = scroll.bottom;
    }
        //减脂方法头部
//        UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(12, 15, (SCREEN_WIDTH - 153)/2, 0.5)];
//        leftLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        [jianzhiway addSubview:leftLine];
//        
//        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jzff-234-140"]];
//        image.frame = CGRectMake(leftLine.right + 7, 0, 50, 30);
//        [jianzhiway addSubview:image];
//        
//        UILabel *font = [[UILabel alloc] init];
//        font.font = MyFont(15);
//        font.frame = CGRectMake(image.right + 5, 0, 61, 30);
//        font.text = @"减脂宣言";
//        font.textColor = OrangeColor;
//        [jianzhiway addSubview:font];
    
//        UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(font.right + 7, 15, SCREEN_WIDTH - font.right - 19, 0.5)];
//        rightLine.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        [jianzhiway addSubview:rightLine];
//        if ([self.gameangle isEqualToString:@"1"]) {
//            rightLine.width -= 28;
//            UIButton *editorBtn = [[UIButton alloc] init];
//            editorBtn.frame = CGRectMake(rightLine.right + 9, 7, 16, 16);
//            [editorBtn setBackgroundImage:[UIImage imageNamed:@"bj-32"] forState:UIControlStateNormal];
//            [editorBtn addTarget:self action:@selector(editorLoseWay) forControlEvents:UIControlEventTouchUpInside];
//            [jianzhiway addSubview:editorBtn];
//        }
    
//        UILabel *font = [[UILabel alloc] init];
//        font.font = MyFont(17);
//        font.frame = CGRectMake(15, jianzhiway.height - 5, SCREEN_WIDTH, 45);
//        font.text = @"减脂宣言";
//        font.textColor = OrangeColor;
//        [jianzhiway addSubview:font];
    
//        [jianzhiway addSubview:fangfaLbl];
//        jianzhiway.height = fangfaLbl.bottom - 5;
    
    
    
//        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, jianzhiway.height-0.5, SCREEN_WIDTH, 0.5)];
//        lineview.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        [jianzhiway addSubview:lineview];
//    [jianzhiBack addSubview:jianzhiway];
//    jianzhiBack.height = jianzhiway.bottom;
    //*****************************************//
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, jianzhiBack.bottom, SCREEN_WIDTH, 0)];
    self.bottomView = bottomView;
    //我的成长
    /*
    UIView *coGrowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    if (![self.gameangle isEqualToString:@"3"]) {
        coGrowView.frame = CGRectMake(0,10, SCREEN_WIDTH, 87);
        coGrowView.backgroundColor = [UIColor whiteColor];
        coGrowView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
        coGrowView.layer.borderWidth = 0.5;
        [bottomView addSubview:coGrowView];
        
        NSArray *imageArray2 = @[@"cstz-42",@"dqtz-42",@"bfb-42",@"ljjz-42"];
        NSArray *textArray2 = @[@"初始体重",@"当前体重",@"减重百分比",@"累计减重"];
        NSArray *colorArray2 = @[@"#eb5b9f",@"#ffb65e",@"#805efb",@"#ff4f4e"];
        CGFloat perWidth = (SCREEN_WIDTH - 12) / 4;
        
        for (int i = 0; i < imageArray2.count; i++) {
            
            float weightImageX = (perWidth - 21) / 2 + perWidth*i + 6;
            float weightLabelX = perWidth * i + 6;
            float weightCountLabelX = perWidth * i + 6;
            
            UIImageView *weightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(weightImageX,15, 21, 21)];
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
            CGFloat weightLineLabelX = 6 + perWidth * (i + 1);
            UILabel *weightLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(weightLineLabelX, 10, 0.5, 69)];
            weightLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
            [coGrowView addSubview:weightLineLabel];
        }
    }
    */
    //减脂任务
//    [bottomView addSubview:pubTaskView];
    
    
    
    CGFloat Width = (SCREEN_WIDTH - 45)/2;
    CGFloat Height = Width*200/328;
    UIView *gameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height + 30)];
    gameView.backgroundColor = [UIColor whiteColor];
    [bottomView addSubview:gameView];
    
    //蜕变日记
    UIButton *dakaBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, Width, Height)];
    [dakaBtn addTarget:self action:@selector(daka) forControlEvents:UIControlEventTouchUpInside];
    [dakaBtn setBackgroundImage:[UIImage imageNamed:@"btrj-330-200"] forState:UIControlStateNormal];
    UIImageView *dakaTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"djl-116-40"]];
    dakaTag.frame = CGRectMake(Width - 60, 2, 58, 20);
    self.dakaTag = dakaTag;
    if (![self.gameangle isEqualToString:@"3"]) {
        if ([self.model.ispunch isEqualToString:@"0"]) {
            dakaTag.image = [UIImage imageNamed:@"cxjl-116-40"];
        }else{
            dakaTag.image = [UIImage imageNamed:@"djl-116-40"];
        }
    }
    [dakaBtn addSubview:dakaTag];
    [gameView addSubview:dakaBtn];
    //团组任务
    UIButton *taskBtn = [[UIButton alloc] initWithFrame:CGRectMake(dakaBtn.right + 15, 15, Width, Height)];
    [taskBtn addTarget:self action:@selector(taskclick) forControlEvents:UIControlEventTouchUpInside];
    [taskBtn setBackgroundImage:[UIImage imageNamed:@"tzrw-330-200"] forState:UIControlStateNormal];
    [gameView addSubview:taskBtn];
    UIImageView *taskTag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xrw-32-90"]];
    taskTag.frame = CGRectMake(Width - 60, 2, 58, 20);
    [taskBtn addSubview:taskTag];
    //有人完成
    if (![self.model.fstaskpct isEqualToString:@"0"] && ![self.model.taskcmpl isEqualToString:@"0"]) {
        UILabel *lbl  = [[UILabel alloc] init];
        lbl.font = MyFont(11);
        lbl.textColor = [UIColor whiteColor];
        lbl.text = [NSString stringWithFormat:@"%@ 人次完成",self.model.fstaskpct];
        lbl.frame = CGRectMake(4, Height - 4 - 11, 80, 11);
        [taskBtn addSubview:lbl];
    }
    if ([self.gameangle isEqualToString:@"3"]) {//访客
        
    }else if ([self.gameangle isEqualToString:@"2"]) {//团员
        
        if([WWTolls isNull:self.model.taskcontent]){//未发布任务
            
            if (self.model.urgecount.intValue > 0) {//已经催促过了
                taskTag.image = [UIImage imageNamed:@"drw-116-40"];
            } else {//没有催过
                taskTag.image = [UIImage imageNamed:@"crw-116-40"];
            }
            
        }else{//已发布任务
            if ([self.model.taskcmpl isEqualToString:@"0"]) {//已结束
                taskTag.image = [UIImage imageNamed:@"drw-116-40"];
            }else if ([self.model.tasksts isEqualToString:@"0"]) {//未完成
                taskTag.image = [UIImage imageNamed:@"jxzrw-142-40"];
                taskTag.width = 71;
                taskTag.left -= 13;
            } else if ([self.model.tasksts isEqualToString:@"1"]){//已完成
                taskTag.image = [UIImage imageNamed:@"xrw-116-40"];
            }
            
        }
    }else if ([self.gameangle isEqualToString:@"1"]) {//团长
        
        if ([WWTolls isNull:self.model.taskcontent]){
            taskTag.image = [UIImage imageNamed:@"frw-116-40"];
        }else{//已发布任务
            
            if ([self.model.taskcmpl isEqualToString:@"0"]) {//已结束
                taskTag.image = [UIImage imageNamed:@"frw-116-40"];
            }else if ([self.model.tasksts isEqualToString:@"0"]) {//未完成
                taskTag.image = [UIImage imageNamed:@"jxzrw-32-126"];
                taskTag.width = 63;
                taskTag.left -= 18;
            } else if ([self.model.tasksts isEqualToString:@"1"]){//已完成
                taskTag.image = [UIImage imageNamed:@"xrw-116-40"];
            }
            
        }
        
    }
    
    //精华帖
    UIView *playBar = [[UIView alloc] initWithFrame:CGRectMake(0,Height + 45, SCREEN_WIDTH, 33)];
    playBar.backgroundColor = [UIColor whiteColor];
    //            playBar.layer.borderWidth = 0.8;
    //            playBar.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    UILabel *font = [[UILabel alloc] init];
    font.font = MyFont(17);
    font.frame = CGRectMake(15, 15, SCREEN_WIDTH, 18);
    font.text = @"精华帖";
    font.textColor = OrangeColor;
    [playBar addSubview:font];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
//    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//    [playBar addSubview:line];
//    
//    UIImageView *barImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,11, 18, 18)];
//    [barImageView setImage:[UIImage imageNamed:@"game_playbar_titleIcon"]];
//    [playBar addSubview:barImageView];
//    
//    UILabel *barLabel = [[UILabel alloc] initWithFrame:CGRectMake(barImageView.maxX + 10, 12, 80, 17)];
//    barLabel.font = MyFont(15);
//    barLabel.text = @"精华帖";
//    barLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
//    [playBar addSubview:barLabel];
//    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ckgd-32"]];
//    img.frame = CGRectMake(SCREEN_WIDTH - 31, 12, 16, 16);
//    [playBar addSubview:img];
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMoreArticle)];
//    [playBar addGestureRecognizer:tap];
    if(self.ArticleData.count > 0) [bottomView addSubview:playBar];
    
    CGFloat lastY = playBar.bottom;
    for (int i = 0; i<self.ArticleData.count; i++) {
        GroupTalkModel *model = self.ArticleData[i];
        CGFloat h = 137;
        if (!model.imageurl || model.imageurl.length<1) {
            NSString *content = [[model.talkcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            CGFloat heigh = [WWTolls heightForString:content fontSize:14 andWidth:SCREEN_WIDTH - 30];
            if (heigh<55) {
                h = 87 + heigh;
            }else h = 137;
        }
        ArticleTableViewCell *cell = [ArticleTableViewCell loadNib];
        cell.frame = CGRectMake(0, lastY, SCREEN_WIDTH, h);
        
        [cell setUpWithTalkModel:model];
        cell.separLine.hidden = NO;
        if (i == 0) {
            cell.separLine.hidden = YES;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickArticle:)];
        [cell addGestureRecognizer:tap];
        [bottomView addSubview:cell];
        lastY = cell.bottom-0.5;
    }
    
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, lastY, SCREEN_WIDTH, 74)];
    footer.backgroundColor = [UIColor whiteColor];
    UIButton *footerBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, SCREEN_WIDTH - 30, 44)];
    [footerBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    [footerBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
    footerBtn.titleLabel.font = MyFont(17);
    footerBtn.clipsToBounds = YES;
    footerBtn.layer.cornerRadius = 22;
    footerBtn.layer.borderColor = OrangeColor.CGColor;
    footerBtn.layer.borderWidth = 1;
    [footerBtn addTarget:self action:@selector(gotoMoreArticle) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:footerBtn];
//
//    //更多团组
//    UILabel *lbl = [[UILabel alloc] init];
//    lbl.backgroundColor = [UIColor whiteColor];
//    lbl.frame = CGRectMake(-1, 0, SCREEN_WIDTH+2, 40);
//    lbl.text = @"查看更多";
//    lbl.font = MyFont(14);
//    lbl.textAlignment = NSTextAlignmentCenter;
//    lbl.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    lbl.layer.borderWidth = 0.5;
//    lbl.textColor = [WWTolls colorWithHexString:@"#959595"];
//    [footer addSubview:lbl];
//    lbl.userInteractionEnabled = YES;
//    //更多
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoMoreArticle)];
//    [lbl addGestureRecognizer:tap];
//    UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ckgd-32"]];
//    more.frame = CGRectMake(lbl.width/2+30, 12.5, 14, 14);
//    UIView *lastline = [[UIView alloc] initWithFrame:CGRectMake(0, lbl.bottom, SCREEN_WIDTH, 10)];
//    lastline.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
//    [footer addSubview:lastline];
//    [footer addSubview:more];
    if(self.ArticleData.count > 0) [bottomView addSubview:footer];
    
    CGFloat maxY = self.ArticleData.count>0?footer.bottom: gameView.bottom;
    
    //乐活吧标题
    UILabel *talkBarTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, maxY + 10, SCREEN_WIDTH-15, 30)];
    talkBarTitleLbl.text = @"乐活吧";
    talkBarTitleLbl.textColor = OrangeColor;
    talkBarTitleLbl.font = MyFont(17);
    [bottomView addSubview:talkBarTitleLbl];
    
    
    
    bottomView.height = talkBarTitleLbl.bottom;
    [self.back addSubview:bottomView];
    
    if ([self.gameangle isEqualToString:@"3"]) {
        self.topView.top = 300;
//        self.tagView.alpha = 1;
//        self.messageView.top = 260 - (self.tagView.height==0?15:self.tagView.height);
        self.bottomView.top = self.topView.bottom;
        topBtn.selected = NO;
    }else{
        self.topView.top = 300 - self.topView.height;
        self.bottomView.top = 300;
//        self.tagView.alpha = 0;
//        self.messageView.top = 245;
        topBtn.selected = YES;
    }
    self.back.height = self.bottomView.bottom;
    self.contentTableView.tableHeaderView = self.back;
    
//    back.contentSize = CGSizeMake(SCREEN_WIDTH, bottomView.bottom);
//    if (back.contentSize.height < SCREEN_HEIGHT+10) {
//        back.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
//    }
    
//    if ([self.gameangle isEqualToString:@"3"] || back.contentSize.height - 110 < SCREEN_HEIGHT) {
//        self.backContentOffset = CGPointZero;
//        topBtn.selected = YES;
//        [self ShowDetailNoAnimal:topBtn];
//    }else {
//        [self ShowDetailNoAnimal:topBtn];
//    }
//    if (![self.gameangle isEqualToString:@"3"] && back.contentSize.height - 110 > SCREEN_HEIGHT) {
////        [self.back setContentOffset:CGPointMake(0, 124.5)];
//        if (![[NSUSER_Defaults objectForKey:@"tuanzuyindang"] isEqualToString:@"YES"]) {
//            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd2"]];
//            image.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            image.userInteractionEnabled = YES;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removemengceng:)];
//            [image addGestureRecognizer:tap];
//            if (self.mengceng) {
//                [self.mengceng removeFromSuperview];
//            }
//            self.mengceng = image;
//            [[UIApplication sharedApplication].keyWindow addSubview:image];
//            
//        }
//    }else if(![self.gameangle isEqualToString:@"3"] && back.contentSize.height - 110 <= SCREEN_HEIGHT){
//        if (![[NSUSER_Defaults objectForKey:@"tuanzuyindang"] isEqualToString:@"YES"]) {
//            UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yd2-"]];
//            image.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            image.userInteractionEnabled = YES;
//            if (self.mengceng) {
//                [self.mengceng removeFromSuperview];
//            }
//            self.mengceng = image;
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removemengceng:)];
//            [image addGestureRecognizer:tap];
//            [[UIApplication sharedApplication].keyWindow addSubview:image];
//            
//        }
//    }

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
    taskLabel.font = MyFont(15);
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
            } else{
                self.model.taskcontent = @"这个团长很懒，居然没有留下任务。";
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
    
    taskView.height = tempHeight + 12 + 41 + 15;
    
    if ([self.gameangle isEqualToString:@"3"]) {
        taskView.height = tempHeight + 12;
    }
    
    return taskView;
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
- (void)pubTaskSuccess:(NSString*)taskid{
    [self reloadGroupData];
}

#pragma mark InitShareDelegate
-(void)confirmShare
{
    self.uploadWeightButton.userInteractionEnabled = YES;
    //    [self doneLoadingTableViewData];
    [self reloadGroupData];
}
-(void)editSuccessWithTags:(NSString*)tags AndContent:(NSString*)content{
    self.model.taglist = tags;
    self.model.xuanyan = content;
    [self setUpGUI];
}
#pragma mark CommanderMoreAlertViewDelegate 普通团 团长更多回调
- (void)commanderMoreAlertView:(CommanderMoreAlertView *)moreAlertView buttonClickWithIndex:(NSInteger)index {
    
    
    if (index == 0) {
        GroupEditeViewController *ed = [[GroupEditeViewController alloc] init];
        ed.groupId = self.groupId;
        ed.groupTags = self.model.taglist;
        ed.groupXuanyan = self.model.xuanyan;
        ed.grouphottags = self.hotTags;
        ed.delegate = self;
        [self.navigationController pushViewController:ed animated:YES];
    //团组成员
    }else if (index == 1) {
        [self goToGroupUser];
    }
    //邀请好友
    else if (index == 2) {
        
        [self createShareView:GeneralGroupShareType];
    }
    //解散团组
    else if (index == 3) {
        
        //已提交
        if ([self.model.dissolvesub isEqualToString:@"0"]) {
            [self showAlertMsg:@"该团组解散申请已提交\n请耐心等待" andFrame:CGRectZero];
            [moreAlertView ssl_hidden];
            return;
        }
        
        [self breakUpGroup];
    }
    //修改密码
    else if (index == 4) {
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
    //退出团组
    else if (index == 2) {
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
    } else if (alertView.tag == 777) {//删除
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
}
#pragma mark 进入修改密码页面
- (void)goToUpdatePassword {
    UpdatePasswordOriginalViewController *vc = [[UpdatePasswordOriginalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 菜单栏事件
-(void)menu {

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
}
-(void)sendSuccess{
    [self refresh];
}

#pragma mark 普通团上传体重
- (void)uploadWeightButtonClick:(UIButton *)button {
    
    self.uploadWeightButton.userInteractionEnabled = NO;
    
    [NSUSER_Defaults setObject:self.model.nowWeight forKey:@"xianzaidetizhong"];
    [NSUSER_Defaults setObject:self.model.groupType forKey:@"xianzaidetype"];
    
    self.shareWeightView = [[InitShareWeightView alloc]initWithFrame:self.view.window.bounds];
    self.shareWeightView.initShareDelegate = self;
    self.shareWeightView.initShareType = myWeightType;
    self.shareWeightView.parterid = self.parterid;
    self.shareWeightView.gameModel = self.model.gamemode;
    [self.shareWeightView createView];
    self.shareWeightView.weightView.top += 60;
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

#pragma mark - 好友头像点击
-(void)clickPater:(UIButton*)btn{
    if(btn.titleLabel.text.length<1) return;
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = btn.titleLabel.text;
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
    task.gameName = self.model.groupName;
    task.password = self.model.gmpassword;
    task.taskId = self.model.taskid;
    task.gameAngle = self.gameangle;
    if(task.taskId && task.taskId.length>0)
        [self.navigationController pushViewController:task animated:YES];
}

#pragma mark 提交成绩
- (void)finishTaskButtonClick:(UIButton *)button {
    [WWTolls zdsClick:TJ_GROUPDETAIL_TJCJ];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setUpGUI];
            });
            
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
    [self setUpGUI];
}
- (void)publicTaskSucessNotify{
    [self reloadGroupData];
}
#pragma mark - 提交成绩成功监听
-(void)submitTaskSucess{
    self.model.fstaskpct = [NSString stringWithFormat:@"%d",self.model.fstaskpct.intValue+1];
    self.model.tasksts = @"0";
    [self setUpGUI];
}

#pragma mark 发布新任务
- (void)pubNewTaskbuttonClick:(UIButton *)button {
    PublicTaskViewController *pubTask = [[PublicTaskViewController alloc] init];
    pubTask.delegate = self;
    pubTask.isFromGroup = YES;
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定加入吗?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"加入", nil];
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
#pragma mark 分享
-(void)createGame {
    [MobClick event:@"GroupShareClick"];//分享点击次数
    [self hideMenu];
    [self.shareView removeFromSuperview];
    [self createShareView:GeneralGroupOutShareType];
}
#pragma mark 下载图片
- (void)downloadGroupImage {
    
    self.image = [UIImage imageNamed:@"ICON_120.png"];
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
            [weakSelf showAlertMsg:@"你苛求任务的心意已经传达给团长大人，耐心等待吧！" yOffset:0];
        }
    }];
}

#pragma mark - 获取团组数据
-(void)reloadGroupData{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"5" forKey:@"partersize"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.clickevent] forKey:@"clickevent"];
//    [self showWaitView];
    WEAKSELF_SS
    if (self.httpOpt && !self.httpOpt.finished) {
        return;
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GAMEDETAIL parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [self removeWaitView];
        
        if (dic[ERRCODE]) {
            //该团组已解散
            if ([dic[ERRCODE] isEqualToString:@"GAM060"]) {
                [weakSelf.header endRefreshing];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                return;
            }
        }else{
            weakSelf.parterid = dic[@"parterid"];
            weakSelf.gamests = dic[@"gmphase"];
            weakSelf.gameangle = dic[@"gameangle"];
            if ([weakSelf.gameangle isEqualToString:@"3"]) {
                weakSelf.isShowAllUI = YES;
            }
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
            
            //下载团组图片
            [self removeWaitView];
            [weakSelf downloadGroupImage];
            [weakSelf setupNav];
            [weakSelf reloadTitleArticle];
            [weakSelf refresh];
            
//            //普通团
//            if ([weakSelf.model.gamemode isEqualToString:@"3"]) {
//                
//                //下载团组图片
//                [weakSelf downloadGroupImage];
//                
//                [weakSelf reloadTitleArticle];
//
//                
////                //团长
////                if ([weakSelf.gameangle isEqualToString:@"1"]) {
////                    [weakSelf setUpGUI];
////                    [weakSelf reloadTitleArticle];
////                }
////                //团员
////                if ([weakSelf.gameangle isEqualToString:@"2"]) {
////                    [weakSelf setUpGUI];
////                    [weakSelf reloadTitleArticle];
////                }
////                //访客
////                if ([weakSelf.gameangle isEqualToString:@"3"]) {
////                    [weakSelf setUpGUI];
////                }
//                
//                
//                
//            } else {
//                [weakSelf setUpGUI];
////                if (![weakSelf.gameangle isEqualToString:@"3"]) {
////                    weakSelf.footerView.height = 47;
////                    weakSelf.footerView.backgroundColor = ZDS_BACK_COLOR;
////                }else weakSelf.footerView.height = 0;
////                NSMutableArray *userTemp = [NSMutableArray array];
////                for (NSDictionary *dict in dic[@"parterList"]) {
////                    [userTemp addObject:dict[@"userinfo"]];
////                }
////                
////                weakSelf.model.userArray = userTemp;
////                [weakSelf setUpGUI];
////                [weakSelf refresh];
////                [weakSelf.table reloadData];
////                [weakSelf addNewView];
//            }
        }
    }];
}
#pragma mark 团组解散通知
- (void)breakUpGroupNoti {
    self.model.dissolvesub = @"0";
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
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    else{
        [self.navigationController popViewControllerAnimated:NO];
    }
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
            weakSelf.isHasLoadArticle = YES;
            [weakSelf.ArticleData removeAllObjects];
            for (int i = 0; i< ((NSArray*)dic[@"barlist"]).count; i++) {
                [weakSelf.ArticleData addObject:[GroupTalkModel modelWithDic:dic[@"barlist"][i]]];
                if (i == 2) {
                    break;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setUpGUI];
            });
        }
    }];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定退出吗?" message:@"是否确认退出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
        [weakSelf removeWaitView];
        if ([[dic objectForKey:@"joinflg"] isEqualToString:@"0"]) {
            //                self.joinButton.enabled = NO;
            [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"加入成功" andFrame:CGRectZero];
            [NSUSER_Defaults setObject:@"YES" forKey:@"tuanzubianhua"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"joinGroupSucess" object:@{@"gameid":weakSelf.groupId}];
            
            if (weakSelf.comeTitleTalkid && weakSelf.comeTitleTalkid.length > 0) {
                
                ((DiscoverViewController*)((UINavigationController*)weakSelf.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -50;
                ((DiscoverViewController*)((UINavigationController*)weakSelf.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -50;
                GroupTalkDetailViewController *talk = [[GroupTalkDetailViewController alloc] init];
                talk.groupId = weakSelf.groupId;
                talk.talkid = weakSelf.comeTitleTalkid;
                talk.talktype = GroupTitleTalkType;
                NSMutableArray *contrllers = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
                [contrllers removeLastObject];
                [contrllers addObject:talk];
                [weakSelf.navigationController setViewControllers:contrllers animated:YES];
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
                }
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

#pragma mark - 请求标签
-(void)loadWhereTag{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_CREATE_TAGS];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            
        }else{
            [weakSelf.hotTags removeAllObjects];
            [weakSelf.hotTags addObjectsFromArray:dic[@"taglist"]];
        }
    }];
}

#pragma mark - 编辑减脂方法点击
- (void)editorLoseWay{
    EditorLoseWayAlertView *discover = [[EditorLoseWayAlertView alloc] initWithFrame:self.view.window.bounds delegate:self];
    [discover createViewWithLoseWay:self.model.loseway];
    [self.view.window addSubview:discover];
    [discover ssl_show];
}
#pragma mark - 编辑减脂方式
- (void)commitLoseWay:(NSString *)text{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:text forKey:@"gmslogan"];
    [dictionary setObject:@"5" forKey:@"edittype"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_EDITOR parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf showAlertMsg:@"修改成功" andFrame:CGRectMake(70,100,200,60)];
            weakSelf.model.loseway = text;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setUpGUI];
            });
            
        }
    }];
}

#pragma mark - 编辑标签提交
-(void)commitEditor:(EditorTagAlertView *)discussAlert{
    NSArray *Tags = discussAlert.tagWriteView.tags;
    NSString *tags = @"";
    for (NSString *tag in Tags) {
        tags = [tags stringByAppendingString:tag];
        tags = [tags stringByAppendingString:@","];
    }
    if (Tags.count > 0) {
        tags = [tags substringToIndex:tags.length-1];
    }
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:tags forKey:@"taglist"];
    [dictionary setObject:@"3" forKey:@"edittype"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_EDITOR parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf showAlertMsg:@"修改成功" andFrame:CGRectMake(70,100,200,60)];
            weakSelf.model.taglist = tags;
            if(tags.length<1) weakSelf.model.taglist = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
               [weakSelf setUpGUI]; 
            });
            
        }
    }];
}

#pragma mark - 精品帖点击
-(void)clickArticle:(UIGestureRecognizer*)tap{
    GroupTalkModel *model = ((ArticleTableViewCell*)tap.view).talkModel;
    GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
    reply.talkid = model.talkid;
    reply.talktype = GroupTitleTalkType;
    reply.clickevent = 4;
    reply.isShowTopBtn = YES;
    reply.groupId = self.groupId;
    [self.navigationController pushViewController:reply animated:YES];
}

#pragma mark - 团组成员页面
-(void)goToGroupUser{
    GroupTeamViewController *team = [[GroupTeamViewController alloc] init];
    team.groupId = self.groupId;
    team.creatorId = self.model.gamecrtor;
    team.gameangle = self.gameangle;
    [self.navigationController pushViewController:team animated:YES];
}
#pragma mark - 去往站内邀请页面
- (IBAction)invitationButton:(id)sender {
    [MobClick event:@"GroupInviteClick"];//邀请点击次数
    [self createShareView:inType];
}
#pragma mark - 前往精华帖列表
- (void)gotoMoreArticle{
    ArticleListViewController *list = [[ArticleListViewController alloc] init];
    list.groupId = self.groupId;
    [self.navigationController pushViewController:list animated:YES];
}


#pragma mark - 团组任务
- (void)taskclick{
    if ([self.gameangle isEqualToString:@"3"]) {
        [self showAlertMsg:@"加入团组，参与任务" yOffset:0];
        return;
    }
    //如果任务内容为空时
    if ([WWTolls isNull:self.model.taskcontent]) {
        //团长
        if ([self.gameangle isEqualToString:@"1"]) {
            [self pubNewTaskbuttonClick:nil];
            //团员
        } else if ([self.gameangle isEqualToString:@"2"]) {
            if (self.model.urgecount.intValue > 0) {//已经催促过了
                [self showAlertMsg:@"已经催促过了，请耐心等待" yOffset:0];
            } else {
                [self requestWithUrgetask];
            }
        }
    }else{
        [self goToTaskDetail];
    }
}

#pragma mark - 打卡
- (void)daka{
    if ([self.gameangle isEqualToString:@"3"]) {
        [self showAlertMsg:@"加入团组，开始记录" yOffset:0];
        return;
    }
    MyCalendarViewController *ca = [[MyCalendarViewController alloc] init];
    ca.gameId = self.groupId;
    ca.isDaka = self.model.ispunch;
    [self.navigationController pushViewController:ca animated:YES];
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
}

- (void)talkMore{
    CreateArticleViewController *talk = [[CreateArticleViewController alloc]init];
    talk.groupId = self.groupId;
    [self.navigationController
     pushViewController:talk animated:YES];
}

#pragma mark - 展示详情按钮点击
- (void)ShowDetail:(UIButton*)btn{
    if (btn.selected) {
        [UIView animateWithDuration:0.4 animations:^{
            self.topView.top = 300;
            self.tagView.alpha = 1;
            self.messageView.top = 260 - (self.tagView.height==0?15:self.tagView.height);
            self.bottomView.top = self.topView.bottom;
        } completion:^(BOOL finished) {
            btn.selected = !btn.selected;
            self.back.height = self.bottomView.bottom;
            self.contentTableView.tableHeaderView = self.back;
//            self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.bottomView.bottom+10);
//            if (self.back.contentSize.height < SCREEN_HEIGHT+10) {
//                self.back.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
//            }
        }];
        
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.topView.top = 300 - self.topView.height;
            self.bottomView.top = 300;
            self.tagView.alpha = 0;
            self.messageView.top = 245;
        } completion:^(BOOL finished) {
            btn.selected = !btn.selected;
            self.back.height = self.bottomView.bottom;
            self.contentTableView.tableHeaderView = self.back;
//            self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.bottomView.bottom+10);
//            if (self.back.contentSize.height < SCREEN_HEIGHT+10) {
//                self.back.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
//            }
        }];
    }
    
}
- (void)ShowDetailNoAnimal:(UIButton*)btn{
    if (btn.selected) {
        self.topView.top = SCREEN_WIDTH - 60;
        self.bottomView.top = self.topView.bottom;
        btn.selected = !btn.selected;
//        self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.bottomView.bottom+10);
//        if (self.back.contentSize.height < SCREEN_HEIGHT+10) {
//            self.back.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
//        }
        
    }else{
        self.topView.top = SCREEN_WIDTH - 60 - self.topView.height;
        self.bottomView.top = SCREEN_WIDTH - 60;
        btn.selected = !btn.selected;
//        self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.bottomView.bottom+10);
//        if (self.back.contentSize.height < SCREEN_HEIGHT+10) {
//            self.back.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
//        }
    }
}

#pragma mark - 上滑手势

#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.jiahaoMenu close];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    // 获取当前的y轴偏移量
    CGFloat curOffsetY = scrollView.contentOffset.y;
    
    NSLog(@"%f", curOffsetY);
    
//    if (curOffsetY < 0) {
//        
//        // 不让刷新控件能看见
//        self.header.alpha = 0;
//    }
//    
    if (curOffsetY >= (200) || scrollView.contentOffset.y<-110) {
        
//        self.rightButton.hidden = NO;
        self.titleLabel.text = self.model.groupName;
        self.titleLabel.textColor = TitleColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    } else {
        
//        self.rightButton.hidden = YES;
        self.titleLabel.text = self.model.groupName;
        self.titleLabel.textColor = [WWTolls colorWithHexString:@"#ffffff"];
        if (self.navigationController.childViewControllers.lastObject == self) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    }
    self.leftButton.selected = scrollView.contentOffset.y > 200 || scrollView.contentOffset.y<-110;
    self.barMore.selected = self.leftButton.selected;
    self.barShara.selected = self.leftButton.selected;
    
    // 计算下与最开始的偏移量的差距
    CGFloat delta = curOffsetY - _oriOffsetY;
    
    // 获取当前导航条背景图片透明度，当delta=300 - 64的时候，透明图刚好为1.
    CGFloat alpha = delta * 1 / 200;
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    // 分类：根据颜色生成一张图片
    UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    
    //    UIImage *bgImage = [UIImage imageNamed:@"123"];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    
    
    [self hideMenu];
//    self.backContentOffset = scrollView.contentOffset;
//
//    if (self.topBtn.selected &&scrollView.contentOffset.y < -100) {
//        self.topBtn.selected = NO;
//        [UIView animateWithDuration:0.6 animations:^{
//            self.topView.top = SCREEN_WIDTH - 60;
//            self.bottomView.top = self.topView.bottom;
//        } completion:^(BOOL finished) {
////            self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.bottomView.bottom+10);
////            if (self.back.contentSize.height < SCREEN_HEIGHT+10) {
////                self.back.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+10);
////            }
//        }];
//    }
//    self.burNav.hidden = !(scrollView.contentOffset.y > 50);
    
//    if(self.playBarView.y != SCREEN_HEIGHT){
////        self.burNav.hidden = NO;
//        self.barMore.selected = YES;
//        self.barBack.selected = YES;
//        self.barShara.selected = YES;
//    }else{
//
//    }
//    self.groupNameLbl.hidden = !self.burNav.hidden;
//    [self scrollViewDidScrollWithOffset:scrollView.contentOffset.y + 60];
//    if (scrollView.contentOffset.y > scrollView.contentSize.height-SCREEN_HEIGHT + 80) {
//        [self playBarClick];
//    }
}

- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset {
    
    if (scrollOffset < 0)
        self.imageView.transform = CGAffineTransformMakeScale(1 - (scrollOffset / 100), 1 - (scrollOffset / 100));
    else
        self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);

}


#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupTalkModel *model = self.data[indexPath.row];
    
    //活动
    if ([model.bartype isEqualToString:@"1"]) {
        return [ZDSGroupActCell getMyCellHeightWithModel:self.data[indexPath.row]];
    }
    
    //冒泡
    if ([model.bartype isEqualToString:@"2"]) {
        return 60;
    }
    
    NSInteger row = indexPath.row;
    CGFloat h = [self.groupCell getMyCellHeight:self.data[indexPath.row]]+6;
//    h-=8;
    return h;
}

#pragma mark - 脚视图
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    //    if (section == 1) {
    //            self.footerView.height = 47;
    //            self.footerView.backgroundColor = ZDS_BACK_COLOR;
    //            return 47;
    //    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
    }
    UIView *foot = [[UIView alloc] init];
    foot.userInteractionEnabled = NO;
    return foot;
}

#pragma mark - 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    //    CGFloat space = (SCREEN_WIDTH - 30*3) / 4;
    //
    //    for (int i = 0; i < 3; i++) {
    //
    //        CGFloat tempX = space + (space + 30)*i;
    //
    //        if (i == 0) {
    //            tempX -= 15;
    //        } else if (i == 2) {
    //            tempX += 15;
    //        }
    //
    //        UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(tempX ,5, 30, 36)];
    //        [bg addSubview:tempButton];
    //
    //        //冒泡
    //        if (i == 0) {
    //            //                tempButton.backgroundColor = [UIColor redColor];
    //            [tempButton setImage:[UIImage imageNamed:MaoPaoImage] forState:UIControlStateNormal];
    //            [tempButton addTarget:self action:@selector(grougBubbleClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    //            NSMutableArray *arr = [NSMutableArray array];
    //            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 0, 21, 21)];
    //            //                imageView.backgroundColor = [UIColor yellowColor];
    //            for (int i = 1; i < 26; i++) {
    //                [arr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",i]]];
    //            }
    //
    //            imageView.animationDuration = 1.35;
    //            imageView.animationImages = arr;
    //            [imageView startAnimating];
    //            [tempButton addSubview:imageView];
    //
    //            self.countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(-5,25, tempButton.width + 10, 12)];
    //            self.countDownLabel.backgroundColor = COLOR_NORMAL_CELL_BG;
    //            self.countDownLabel.text = [NSString stringWithFormat:@"%02ld:%02ld",self.countDown/60,self.countDown%60];
    //            self.countDownLabel.font = MyFont(12.0);
    //            self.countDownLabel.textAlignment = NSTextAlignmentCenter;
    //            self.countDownLabel.textColor = [WWTolls colorWithHexString:TextColor];
    //            [tempButton addSubview:self.countDownLabel];
    //
    //            if (self.countDown > 0) {
    //                self.countDownLabel.hidden = NO;
    //                [self createTimerWith:YES];
    //            } else {
    //                self.countDownLabel.hidden = YES;
    //            }
    //
    //            //活动
    //        } else if (i == 1) {
    //            [tempButton setImage:[UIImage imageNamed:YueHuoDongImage] forState:UIControlStateNormal];
    //            [tempButton addTarget:self action:@selector(groupActivityClick) forControlEvents:UIControlEventTouchUpInside];
    //            //发表图文（即说点啥）
    //        } else if (i == 2) {
    //            [tempButton setImage:[UIImage imageNamed:ShuoDianShaImage] forState:UIControlStateNormal];
    //            [tempButton addTarget:self action:@selector(groupTalkButton) forControlEvents:UIControlEventTouchUpInside];
    //        }
    //    }
    //    if (section == 1) {
    if(self.data.count == 0){
        UIView *back = [[UIView alloc] init];
        //            UILabel *headView = [[UILabel alloc] init];
        //            headView.text = @"  乐活吧";
        //            headView.backgroundColor = ZDS_BACK_COLOR;
        //            headView.font = MyFont(15);
        //            headView.textColor = ZDS_DHL_TITLE_COLOR;
        //            headView.frame = CGRectMake(0, 0, 320, 40);
        //            [back addSubview:headView];
        UILabel *huashu = [[UILabel alloc] init];
        huashu.backgroundColor = [UIColor clearColor];
        huashu.text = @"还没有人发言，求破冰~(●'◡'●)ﾉ♥";
        huashu.textColor = [WWTolls colorWithHexString:@"#959595"];
        huashu.textAlignment = NSTextAlignmentCenter;
        huashu.font = MyFont(14);
        huashu.frame= CGRectMake(0, 30, 320, 22);
        [back addSubview:huashu];
        return back;
    }
    UILabel *headView = [[UILabel alloc] init];
    //        headView.text = @"  乐活吧";
    headView.backgroundColor = ZDS_BACK_COLOR;
    headView.font = MyFont(15);
    headView.textColor = ZDS_DHL_TITLE_COLOR;
    headView.frame = CGRectMake(0, 0, 0, 0);
    return headView;
    //    }
    
    
    //    return [[UIView alloc] init];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
        if(self.data.count == 0) return 60;
        return 0;
//    }
//    
//    CGFloat h = 0;
//    
//    return h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        GroupTalkModel *model = self.data[indexPath.row];
        UITableViewCell *cell = nil;
        
        //活动
        if ([model.bartype isEqualToString:@"1"]) {
            
            //            NSLog(@"model:%@",[model logClassData]);
            
            static NSString *CellIdentifier = @"ZDSGroupActCell";
            ZDSGroupActCell *groupCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (groupCell == nil) {
                
                groupCell = [ZDSGroupActCell loadNib];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.delegate = self;
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
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.delegate = self;
            }
            groupCell.topupper = topNumber;
            [groupCell initMyCellWithModel:model];
            cell = groupCell;
        }
        //团聊
        else if ([model.bartype isEqualToString:@"0"]) {
            
            NSString *CellIdentifier = @"cellGroup";
            
            GroupTalkTableViewCell *groupCell = [tableView dequeueReusableCellWithIdentifier:
                                                 CellIdentifier];
            
            if (groupCell==nil) {
                groupCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupTalkTableViewCell" owner:self options:nil]lastObject];
                groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
                groupCell.talkCellDelegate = self;
            }
            groupCell.topupper = topNumber;
            groupCell.indexPath = indexPath;
            if([self.gameangle isEqualToString:@"3"]) model.isparter = @"1";
            else model.isparter = @"0";
            [groupCell initMyCellWithModel:model];
            if (indexPath.row == 0) {
//                groupCell.consLineHeight.constant = 0;
                groupCell.line.layer.borderWidth = 0;
            }
//            groupCell.consLineHeight.constant = 0.5;
//            groupCell.smallLine.top = 0;
//            groupCell.line.height = 0;
            cell = groupCell;
        }
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupTalkModel *model = [self.data objectAtIndex:indexPath.row];
    if ([model.bartype isEqualToString:@"1"]) {
        ZDSActDetailViewController *vc = [[ZDSActDetailViewController alloc] init];
        vc.activityid = model.barid;
        [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:vc animated:YES];
    } else if ([model.bartype isEqualToString:@"2"]) {
        GroupTalkModel *model = self.data[indexPath.row];
        MeViewController *single = [[MeViewController alloc]init];
        single.userID = model.userid;
        single.otherOrMe = 1;
        [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:single animated:YES];
    } else if ([model.bartype isEqualToString:@"0"]) {
        GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
        reply.talkid = model.barid;
        [self.navigationController pushViewController:reply animated:YES];
        //        [((UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController).selectedViewController pushViewController:reply animated:YES];
    }
}


#pragma mark - 乐活吧事件
#pragma mark - 举报接口
-(void)postReport:(NSString*)ifmtype{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:talkid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:repotType forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectMake(70,100,200,60)];
    }];
}

#pragma mark - 刷新数据
-(void)refresh{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_TALKDETAIL];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        topNumber = [dic[@"topcount"] intValue];
        topUpper = [dic[@"topupper"] intValue];
        //topupper
        
        if ([dic[@"waittime"] intValue] > 0) {
            weakSelf.countDown = [dic[@"waittime"] integerValue];
//            [weakSelf createTimerWith:YES];
        }
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            weakSelf.timePageNum=1;
            [weakSelf.data removeAllObjects];
            NSArray *tempArray = dic[@"barlist"];
            
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
                //                weakSelf.lastId = groupTalkModel.barid;
            }
            weakSelf.lastId = tempArray.lastObject[@"barid"];
            [weakSelf.contentTableView reloadData];
        }
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark - 加载更多回复
-(void)loadData{
    
    if (self.data.count == 0||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.footer endRefreshing];
        return;
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_TALKDETAIL];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            weakSelf.timePageNum++;
            NSArray *tempArray = dic[@"barlist"];
            for (int i=0; i<tempArray.count; i++) {
                GroupTalkModel *groupTalkModel = [[GroupTalkModel alloc]init];
                
                NSDictionary *dict = [tempArray objectAtIndex:i];
                
                //                groupTalkModel.topcount = [dic objectForKey:@""]
                //                groupTalkModel.bartype = [dict objectForKey:@"bartype"];
                //                groupTalkModel.barid = [dict objectForKey:@"barid"];
                //                groupTalkModel.content = [dict objectForKey:@"content"];
                //                groupTalkModel.commentcount = [dict objectForKey:@"commentcount"];
                //                groupTalkModel.acttime = [dict objectForKey:@"acttime"];
                //                groupTalkModel.place = [dict objectForKey:@"place"];
                //                groupTalkModel.logangle = self.gameangle;
                //                groupTalkModel.userid = [dict objectForKey:@"userid"];
                //                groupTalkModel.username = [dict objectForKey:@"username"];
                //                groupTalkModel.userinfoimageurl =dict [@"imageurl"];
                //                groupTalkModel.talkcontent = [dict objectForKey:@"talkcontent"];
                //                groupTalkModel.imageurl = dict[@"imageurl"];
                //                groupTalkModel.istop = [dict objectForKey:@"istop"];
                ////                groupTalkModel.replycount =  [dict objectForKey:@"replycount"];
                //                groupTalkModel.createtime =  [dict objectForKey:@"createtime"];
                //                groupTalkModel.goodSum = [dict objectForKey:@"praisecount"];
                //                groupTalkModel.goodStatus = [dict objectForKey:@"praisestatus"];
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
                //                groupTalkModel.talkcontent = [dict objectForKey:@"talkcontent"];
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
            [weakSelf.contentTableView reloadData];
        }
        [weakSelf.footer endRefreshing];
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
    [self topRequestReload:talkResult stopID:stopResult];
    NSLog(@"stopResult********%@",stopResult);
}

-(void)topRequestReload:(NSString*)talkID stopID:(NSString*)stopid{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:stopid forKey:@"istop"];
    [dictionary setObject:self.topType forKey:@"toptype"];
    [dictionary setObject:talkID forKey:@"topid"];
    NSLog(@"——————————————%@",dictionary);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"ineract/topbar.do"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (dic == nil || ! [dic isKindOfClass:[NSDictionary class]]) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            talkid = [dic objectForKey:@"talkid"];
            if (dic[@"errinfo"]) {
                [weakSelf showAlertMsg:dic[@"errinfo"] andFrame:CGRectMake(60, 100, 200, 50)];
            }else{
                if ([stopid isEqualToString:@"1"]) {
                    [weakSelf showAlertMsg:@"置顶成功" andFrame:CGRectZero];
                }else [weakSelf showAlertMsg:@"取消置顶成功" andFrame:CGRectZero];
                [weakSelf refresh];
            }
            
            NSLog(@"置顶信息*********%@", dic);
        }
    }];
}


#pragma mark groupTalkCellDelegate
#pragma mark - 举报

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


#pragma mark 乐活吧分享
- (void)jubaoShare {
    
    [self hideMenu];
    
    [shareView removeFromSuperview];
    
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
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topUpper] forKey:@"shareGroupTopUpper"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topNumber] forKey:@"shareGroupTopNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:tempModel.istop forKey:@"shareGroupIsTop"];
    
    //团聊
    if ([tempModel.bartype isEqualToString:@"0"]) {
        
        GroupTalkTableViewCell *cell = (GroupTalkTableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        
        UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.contentImageView.image];
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
    
    [self topRequestReload:talkResult stopID:stopResult];
}
#pragma mark NARShareViewDelegate

//举报
- (void)shareViewDelegateReport {
    [self reportButtonSender];
}

//删除
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
    //    [self showWaitView:@"正在删除"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:deleteid forKey:@"deleteid"];
    [dictionary setObject:deltype forKey:@"deltype"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Del_Bar];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        
        DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
        
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            [weakSelf refresh];
            //                [weakSelf.data removeObjectAtIndex:weakSelf.currentIndexPath.row];
            //                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.currentIndexPath.row inSection:1]] withRowAnimation:YES];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            
            //                [weakSelf.table reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"团组详情页面释放");
}

@end
