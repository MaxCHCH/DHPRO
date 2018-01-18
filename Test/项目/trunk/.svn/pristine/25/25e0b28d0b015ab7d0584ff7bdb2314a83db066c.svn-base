//
//  GroupTalkDetailViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/14.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#define SLIDER_Y self.view.frame.size.height-90

#import "GroupTalkDetailViewController.h"
#import "DiscoverReplyModel.h"
#import "DisReplyTableViewCell.h"
#import "IQKeyboardManager.h"
#import "MCFireworksButton.h"
#import "GoodListViewController.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "UITextField+LimitLength.h"
#import "FaceToolBar.h"
#import "HTCopyableLabel.h"
#import "NARShareView.h"
#import "GroupViewController.h"
#import "DeleteBarModel.h"
#import "DiscoverTypeViewController.h"
#import "NSObject+MJKeyValue.h"
#import "ArticleCommentViewController.h"
#import "DisReplyWithImageTableViewCell.h"
#import "discussAlertView.h"
#import "UIView+SSLAlertViewTap.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
@interface GroupTalkDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,FaceToolBarDelegate,DiscussAlertDelegate,NARShareViewDelegate,DiscoverReplyModelDelegate>{
    UIActionSheet *myActionSheetView;

}

@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,copy)NSString *permission;//回复权限
@property(nonatomic,assign)int timePageNum;//当前页数
@property(nonatomic,copy)NSString *headimage;//头像
@property(nonatomic,copy)NSString *name;//姓名
@property(nonatomic,copy)NSString *userId;//发表人id
@property(nonatomic,copy)NSString *content;//内容
@property(nonatomic,copy)NSString *time;//时间
@property(nonatomic,copy)NSString *showimage;//配图
@property(nonatomic,copy)NSString *goodsum;//点赞数量
@property(nonatomic,copy)NSMutableArray *goodImages;//点赞头像数组
@property(nonatomic,copy)NSString *bycommentid;//被评论id
@property (weak, nonatomic) MCFireworksButton *goodButton;
@property (weak, nonatomic) UILabel *goodLbl;
@property(copy,nonatomic) NSString* praisestatus;//当前消息的点赞状态
@property(nonatomic,strong)UIView *goodListView;//点赞视图
@property(nonatomic,strong)FaceToolBar *tool;//输入框
@property(nonatomic,assign)BOOL enableCommit;//评论标示
@property(nonatomic,assign)CGFloat headerViewHEIGH;//header高度
@property(nonatomic,copy)NSString *Articletitle;//标题帖标题
@property (nonatomic,strong) NSIndexPath *currentIndexPath;//当前选择indexPath
@property(nonatomic,strong)UIView *joinBg;//加入背景

//标题帖子
@property(nonatomic,copy)NSString *topupper;//置顶上限
@property(nonatomic,copy)NSString *topcount;//置顶总数
@property(nonatomic,copy)NSString *creator;//团组创建者
@property(nonatomic,copy)NSString *istop;//置顶状态
@property(nonatomic,copy)NSString *isCollection;//收藏状态
@property(nonatomic,assign)BOOL isGoToGroup;//进入团组
@property(nonatomic,strong)UIButton *sendBtn;//发送按钮
@property(nonatomic,strong)DiscoverReplyModel *currentDiscussModel;//当前评论
@property(nonatomic,weak)UIView *headerView;//透视图
@property(nonatomic,copy)NSString *JubaoKind;//举报类型
@property(nonatomic,copy)NSString *dataCount;//回复总数
@property(nonatomic,copy)NSString *pageview;//游览量

@end

@implementation GroupTalkDetailViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [MobClick endLogPageView:@"图聊详情页面"];
    [self.httpOpt cancel];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    if (self.isGoToGroup) {
        [self LoadDataWithIsMore:NO];
        self.isGoToGroup = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(abovbThum:) name:@"aboveThumb" object:nil];

    //友盟打点
    [MobClick beginLogPageView:@"团聊详情页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //导航栏标题
    self.titleLabel.text = self.talktype == GroupTitleTalkType?@"精华帖":[NSString stringWithFormat:@"回复详情"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [self.table reloadData];
    self.enableCommit = YES;

    //导航栏更多
    [self.rightButton setTitle:@"  ···" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(30);
    [self.rightButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.bounds = CGRectMake(0, 0, 44, 28);
    
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view endEditing:YES];
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (self.talktype == GroupSimpleTalkType && !self.tool) {
        //底部输入视图
        FaceToolBar *tool = [[FaceToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 47) superView:self.view withBarType:UserFeedBackToolBar];
        tool.faceToolBardelegate = self;
        self.tool = tool;
        tool.myTextView.placeholder = @"添加评论";
        self.tool.toolBar.hidden = [self.permission isEqualToString:@"1"];
    }
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupGUI];
    self.isGoToGroup = NO;
    //初始化回复级别
    self.bycommentid = self.talkid;
    [self.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNewComent:) name:@"grouptitletoggle" object:nil];
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self tapGRActive:nil];

}
- (void)notifyHiden{
    self.table.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
}

- (void)reciveNewComent:(NSNotification*)no{
    if([no.object[@"talkid"] isEqualToString:self.talkid]){
        [self LoadDataWithIsMore:NO];
    }
}

-(void)dealloc{
    [self.header free];
    [self.footer free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"团聊详情页面释放");
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request
#pragma mark 删除团聊评论
- (void)requestWithDelreply {
    
    [self showWaitView];
    
    DiscoverReplyModel *currentModel = self.data[self.currentIndexPath.row];
    currentModel.delegate = self;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:currentModel.commentid forKey:@"replyid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_DELREPLY];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"delteReply" object:@{@"talkid":weakSelf.talkid}];
            [weakSelf showAlertMsg:@"删除成功" andFrame:CGRectZero];
            [weakSelf remove];
            
        }
    }];
}

- (void)remove {
    [self.data removeObjectAtIndex:self.currentIndexPath.row];
    [self.table deleteRowsAtIndexPaths:@[self.currentIndexPath] withRowAnimation:UITableViewRowAnimationRight];
}

#pragma mark - 初始化UI
-(void)setupGUI{
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化tableview
    self.table = [[UITableView alloc] init];
    self.table.scrollsToTop = YES;
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.allowsSelection = YES;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.table.separatorColor =  [WWTolls colorWithHexString:@"#dcdcdc"];
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
//    headerView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    headerView.layer.borderWidth = 0.5;
    self.table.backgroundColor = [UIColor whiteColor];
    self.table.tableHeaderView = headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 15)];
    headerView.backgroundColor = ZDS_BACK_COLOR;
    self.table.tableFooterView = headerView;
    [self.view addSubview:self.table];
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self reloadGoodMan];
        [self LoadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:YES];
    };
    
    //点击手势收起键盘
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRActive:)];
//    [self.view addGestureRecognizer:tapGR];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if (self.talktype == GroupTitleTalkType) {//发布按钮
//        FaceToolBar *tool = [[FaceToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 47) superView:self.view withBarType:UserFeedBackToolBar];
//        
//        UIButton *sendBtn = [[UIButton alloc] init];
//        sendBtn.frame = CGRectMake(0, 2, 30, 30);
//        sendBtn.titleLabel.text = @"地方";
//        [tool.theSuperView addSubview:sendBtn];
//        tool.sendButton.titleLabel.text = @"发送";
//        tool.myTextView.placeholder = @"添加评论";
//        tool.faceToolBardelegate = self;
//        tool.backgroundColor = [UIColor whiteColor];
//        tool.toolBar.backgroundColor = [UIColor whiteColor];
//        self.tool = tool;

        
        UIButton *sendBtn = [[UIButton alloc] init];
        self.sendBtn = sendBtn;
        sendBtn.frame = CGRectMake(0, self.view.frame.size.height-48 -66, SCREEN_WIDTH, 49);
        [sendBtn addTarget:self action:@selector(goToComment) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:sendBtn];
        sendBtn.backgroundColor = [UIColor whiteColor];
        sendBtn.layer.borderColor = [WWTolls colorWithHexString:@"#eaeaea"].CGColor;
        sendBtn.layer.borderWidth = 0.5;
        //评论图片
        UIImageView *pinglunImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"talkDitailReply"]];
        pinglunImage.frame = CGRectMake(SCREEN_WIDTH/2 - 30, 15, 19, 19);
        [sendBtn addSubview:pinglunImage];
        //评论字
        UILabel *pinglunlbl = [[UILabel alloc] init];
        pinglunlbl.text = @"评论";
        pinglunlbl.textColor = [WWTolls colorWithHexString:@"#959595"];
        pinglunlbl.font = MyFont(16);
        pinglunlbl.frame = CGRectMake(SCREEN_WIDTH/2 - 3, 0, 120, 49);
        [sendBtn addSubview:pinglunlbl];
        sendBtn.hidden = YES;
        
    }
    
    //加入团组参与讨论
    UIView *joinbg = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-113, SCREEN_WIDTH, 47)];
    self.joinBg = joinbg;
    joinbg.backgroundColor = [WWTolls colorWithHexString:@"#eaeaea"];
    [self.view addSubview:joinbg];
    UIButton *joinBtn = [[UIButton alloc] initWithFrame:CGRectMake(66,8,SCREEN_WIDTH-132,47-16)];
    joinBtn.backgroundColor = ZDS_DHL_TITLE_COLOR;
    joinBtn.titleLabel.textColor = [UIColor whiteColor];
    joinBtn.titleLabel.font = MyFont(17);
    [joinBtn setTitle:@"加入团组  参与讨论" forState:UIControlStateNormal];
    joinBtn.clipsToBounds = YES;
    joinBtn.layer.cornerRadius = 14;
    [joinBtn addTarget:self action:@selector(gotoGroup) forControlEvents:UIControlEventTouchUpInside];
    [joinbg addSubview:joinBtn];
    joinbg.hidden = YES;
}

- (void)goToComment{
    ArticleCommentViewController *aritcle = [[ArticleCommentViewController alloc] init];
    aritcle.byComendId = self.talkid;
    aritcle.talkId = self.talkid;
    [self.navigationController pushViewController:aritcle animated:YES];
}

#pragma mark - 加载数据
-(void)LoadDataWithIsMore:(BOOL)isLoadMore{
    if(isLoadMore){
        if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.talkid forKey:@"talkid"];
    if (isLoadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:@"1" forKey:@"pageNum"];
        [dictionary setObject:@"8" forKey:@"praimgcount"];//点赞列表显示数量
    }

    [dictionary setObject:[NSString stringWithFormat:@"%d",self.clickevent] forKey:@"clickevent"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求即将开团
    if (self.httpOpt && ![self.httpOpt isFinished]) {
        if (isLoadMore) {
            [self.footer endRefreshing];
        }else{
            [self.header endRefreshing];
        }
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:self.talktype == GroupTitleTalkType ? ZDS_GROUP_TITLE : ZDS_RPYDETAIL  parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            weakSelf.table.hidden = YES;
            weakSelf.tool.toolBar.hidden = YES;
            weakSelf.joinBg.hidden = YES;
            weakSelf.sendBtn.hidden = YES;
        }else{
            if (isLoadMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
                if (weakSelf.talktype == GroupTitleTalkType) {
                    switch (self.clickevent) {
                        case 1:
                            [WWTolls zdsClick:TJ_TITLE_SHGC];
                            break;
                        case 2:
                            [WWTolls zdsClick:TJ_TITLE_SHDT];
                            break;
                        case 3:
                            [WWTolls zdsClick:TJ_TITLE_HTCS];
                            break;
                        case 4:
                            [WWTolls zdsClick:TJ_TITLE_LHB];
                            break;
                        case 5:
                            [WWTolls zdsClick:TJ_TITLE_DJPL];
                            break;
                        default:
                            break;
                    }
                }
            }
            
            weakSelf.permission = dic[@"permission"];
            if(self.talktype == GroupTitleTalkType){
                weakSelf.permission = dic[@"isjoin"];
                weakSelf.isCollection = dic[@"iscollection"];
                if([weakSelf.permission isEqualToString:@"0"]) self.sendBtn.hidden = NO;
                weakSelf.topcount = dic[@"titlecount"];
                weakSelf.topupper = dic[@"titleupper"];
                weakSelf.gamename = dic[@"talkinfo"][@"gamename"];
                weakSelf.istop = dic[@"talkinfo"][@"istop"];
                weakSelf.pageview = dic[@"talkinfo"][@"pageview"];
                
            }
            weakSelf.creator = dic[@"creator"];
            NSArray *tempArray = dic[@"replyList"];
            dic = dic[@"talkinfo"];
            weakSelf.headimage = dic[@"userimage"];
            if (dic[@"title"] != nil) {
                weakSelf.Articletitle = dic[@"title"];
                weakSelf.dataCount = dic[@"replycount"];
            }
            weakSelf.groupId = dic[@"gameid"];
            weakSelf.name = dic[@"username"];
            weakSelf.content = dic[@"talkcontent"];
            weakSelf.time = dic[@"createtime"];
            if (dic[@"talkimage"] != nil) {
                weakSelf.showimage = dic[@"talkimage"];
            }
            weakSelf.goodsum = dic[@"praisecount"];
            weakSelf.praisestatus = dic[@"praisestatus"];
            weakSelf.userId = dic[@"userid"];
            if (self.talktype == GroupTitleTalkType && ([self.creator isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]] || [self.userId isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]])) {
                //导航栏更多
                [self.rightButton setTitle:@"  ···" forState:UIControlStateNormal];
                [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
                self.rightButton.titleLabel.font = MyFont(30);
                [self.rightButton addTarget:self action:@selector(more) forControlEvents:UIControlEventTouchUpInside];
                self.rightButton.bounds = CGRectMake(0, 0, 44, 28);

            }
            for (NSDictionary *dic in tempArray) {
                DiscoverReplyModel *model = [[DiscoverReplyModel alloc] init];
                model.commentid = dic[@"replyid"];
                model.floorcount = dic[@"floorcount"];
                model.showid = dic[@"gameid"];
                model.username = dic[@"userinfo"][@"username"];
                model.userid = dic[@"userinfo"][@"userid"];
                model.userimage = dic[@"userinfo"][@"imageurl"];
                model.content = dic[@"rpycontent"];
                model.commentlevel = dic[@"replylevel"];
                model.byuserid = dic[@"replyuser"];
                model.byusername = dic[@"rpyusername"];
                model.createtime = dic[@"createtime"];
                model.showimage = dic[@"imageurl"];
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.commentid;
            }
            [weakSelf.table reloadData];
            if (isLoadMore) {
                [weakSelf.footer endRefreshing];
            }else{
                [weakSelf.header endRefreshing];
            }
        }
    }];
}

-(void)loadDataWithNum:(int)pageNum{
    {
        //构造请求参数
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
        [dictionary setObject:self.talkid forKey:@"talkid"];
        [dictionary setObject:[NSString stringWithFormat:@"%d",pageNum] forKey:@"pageNum"];
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.clickevent] forKey:@"clickevent"];
        [dictionary setObject:@"10" forKey:@"pageSize"];
        if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
        //发送请求即将开团
        if (self.httpOpt && ![self.httpOpt isFinished]) {
            [self.httpOpt cancel];
        }
        __weak typeof(self)weakSelf = self;
        [self showWaitView];
        self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:self.talktype == GroupTitleTalkType ? ZDS_GROUP_TITLE : ZDS_RPYDETAIL  parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            
            if (dic[ERRCODE]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
                weakSelf.table.hidden = YES;
                weakSelf.tool.toolBar.hidden = YES;
                weakSelf.joinBg.hidden = YES;
                weakSelf.sendBtn.hidden = YES;
            }else{
                weakSelf.timePageNum = pageNum;
                    [weakSelf.data removeAllObjects];
                    if (weakSelf.talktype == GroupTitleTalkType) {
                        switch (self.clickevent) {
                            case 1:
                                [WWTolls zdsClick:TJ_TITLE_SHGC];
                                break;
                            case 2:
                                [WWTolls zdsClick:TJ_TITLE_SHDT];
                                break;
                            case 3:
                                [WWTolls zdsClick:TJ_TITLE_HTCS];
                                break;
                            case 4:
                                [WWTolls zdsClick:TJ_TITLE_LHB];
                                break;
                            case 5:
                                [WWTolls zdsClick:TJ_TITLE_DJPL];
                                break;
                            default:
                                break;
                        }
                    }
            
                NSArray *tempArray = dic[@"replyList"];
            
            
                for (NSDictionary *dic in tempArray) {
                    DiscoverReplyModel *model = [[DiscoverReplyModel alloc] init];
                    model.commentid = dic[@"replyid"];
                    model.showid = dic[@"gameid"];
                    model.username = dic[@"userinfo"][@"username"];
                    model.userid = dic[@"userinfo"][@"userid"];
                    model.userimage = dic[@"userinfo"][@"imageurl"];
                    model.content = dic[@"rpycontent"];
                    model.commentlevel = dic[@"replylevel"];
                    model.byuserid = dic[@"replyuser"];
                    model.byusername = dic[@"rpyusername"];
                    model.createtime = dic[@"createtime"];
                    model.showimage = dic[@"imageurl"];
                    model.floorcount = dic[@"floorcount"];
                    [weakSelf.data addObject:model];
                    weakSelf.lastId = model.commentid;
                }
                [weakSelf.table setContentOffset:CGPointZero];
                [weakSelf.table reloadData];
                [weakSelf removeWaitView];
            }
        }];
    }
}
-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
-(NSMutableArray *)goodImages{
    if (_goodImages == nil) {
        _goodImages = [NSMutableArray array];
    }
    return _goodImages;
}

#pragma mark - tableView dataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    if (self.talktype == GroupTitleTalkType && [self.permission isEqualToString:@"1"]) {
        return 0;
    }
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DiscoverReplyModel *model = self.data[indexPath.row];

    return [model getCellHeight];
}


#pragma mark - 头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return nil;
    }
    if (self.name.length < 1) {
        return nil;
    }
    //背景视图
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor whiteColor];
    if (self.talktype == GroupTitleTalkType) {
       
    }
    
    
    //头像
    UIImageView *headerView = [[UIImageView alloc] init];
    [headView addSubview:headerView];
    [headerView sd_setImageWithURL:[NSURL URLWithString:self.headimage] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    headerView.frame = CGRectMake(15, 15, 40, 40);
    headerView.layer.cornerRadius = 20;
    headerView.clipsToBounds = YES;
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [headerView addGestureRecognizer:tap];
    UIImageView *tuanzhangImage = [[UIImageView alloc] init];
    tuanzhangImage.image = [UIImage imageNamed:@"tuanzhang_40"];
    tuanzhangImage.frame = CGRectMake(39, 39, 16, 16);
    if ([self.creator isEqualToString:self.userId]) {
        [headView addSubview:tuanzhangImage];
    }
    
    //昵称
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(65, 19, 200, 16);
    lbl.font = MyFont(14);
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    lbl.text = self.name;
    [headView addSubview:lbl];
    
    //时间
    UILabel *lbltime = [[UILabel alloc] init];
    lbltime.frame = CGRectMake(65, 42, 60, 12);
    lbltime.font = MyFont(10);
    lbltime.textColor = [WWTolls colorWithHexString:@"#959595"];
    lbltime.text = [WWTolls configureTimeString:self.time andStringType:@"Y/M/d"];
    [headView addSubview:lbltime];
    
    if(self.talktype == GroupTitleTalkType){
        UIImageView *img = [[UIImageView alloc] init];
        img.frame = CGRectMake(lbltime.right, 42, 11, 11);
        img.image = [UIImage imageNamed:@"lll-32.png"];
        //        [headView addSubview:img];
        UILabel *lookSum = [[UILabel alloc] initWithFrame:CGRectMake(img.right+2, 42, 100, 12)];
        lookSum.font = MyFont(10);
        lookSum.textColor = [WWTolls colorWithHexString:@"#959595"];
        lookSum.text = self.pageview;
        //        [headView addSubview:lookSum];
    }
    
    if(self.talktype == GroupTitleTalkType && [self.permission isEqualToString:@"1"]){
        UILabel *comelabel = [[UILabel alloc] init];
        comelabel.frame = CGRectMake(SCREEN_WIDTH - [WWTolls WidthForString:[NSString stringWithFormat:@"来自%@",self.gamename] fontSize:10] -15, 42, [WWTolls WidthForString:[NSString stringWithFormat:@"来自%@",self.gamename] fontSize:10], 12);
        [headView addSubview:comelabel];
        
        
        comelabel.textColor = [WWTolls colorWithHexString:@"#959595"];
        comelabel.font = MyFont(10);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"来自%@",self.gamename]];
        [str addAttribute:NSForegroundColorAttributeName value:ZDS_DHL_TITLE_COLOR range:NSMakeRange(2,self.gamename.length)];
        comelabel.attributedText = str;
        UITapGestureRecognizer *grouptap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoGroup)];
        comelabel.userInteractionEnabled = YES;
        [comelabel addGestureRecognizer:grouptap];
    }
    CGFloat contentH = [WWTolls heightForString:self.content fontSize:15 andWidth:SCREEN_WIDTH-30]+1;
    if (self.content.length<1) {
        contentH = -8;
    }
    CGFloat titleHeight = 0;
    CGFloat beforeHeight = headerView.bottom;

    
    if (self.showimage && self.showimage.length > 0) {
        NSArray *images = [self.showimage componentsSeparatedByString:@"|"];
        int imageCount = (int)images.count;
        switch (imageCount) {
            case 1:{
                //配图
                if (self.showimage.length > 0) {
                    for (int i = 0; i<images.count; i++) {
                        UIImageView *showImage = [[UIImageView alloc] init];
                        [headView addSubview:showImage];
                        showImage.userInteractionEnabled = YES;
                        showImage.tag = i+1;
                        [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                        showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                        [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                        CGSize imagesize = [WWTolls sizeForQNURLStr:images[i]];
                        showImage.frame = CGRectMake(15, 55+15 ,SCREEN_WIDTH - 30, (SCREEN_WIDTH - 30)*imagesize.height/imagesize.width);
                        //                        showImage.contentMode = UIViewContentModeScaleAspectFit;
                        beforeHeight = showImage.bottom;
                    }
                }
            }
                break;
                 //3、4张 以上 为九宫格
            case 4:
            case 2:{
                
                for (int i = 0; i<images.count; i++) {
                    UIImageView *showImage = [[UIImageView alloc] init];
                    [headView addSubview:showImage];
                    showImage.userInteractionEnabled = YES;
                    showImage.tag = i+1;
                    [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                    showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                    [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                    showImage.contentMode = UIViewContentModeScaleAspectFill;
                    showImage.clipsToBounds = YES;
                    CGFloat width = (SCREEN_WIDTH - 30 - 3)/2;
                    showImage.frame = CGRectMake(15 + (width + 3)*(i%2), 55+15 + (width +3)*(i/2), width, width);
                    beforeHeight = showImage.bottom;
                    
                }
                

                }
                break;
                
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                case 3:{
                    
                    for (int i = 0; i<images.count; i++) {
                        
                        UIImageView *showImage = [[UIImageView alloc] init];
                        [headView addSubview:showImage];
                        showImage.userInteractionEnabled = YES;
                        showImage.tag = i+1;
                        [showImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
                        showImage.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
                        [showImage sd_setImageWithURL:[NSURL URLWithString:images[i]]];
                        showImage.contentMode = UIViewContentModeScaleAspectFill;
                        showImage.clipsToBounds = YES;
                        CGFloat width = (SCREEN_WIDTH - 30 - 6)/3;
                        
                        showImage.frame = CGRectMake(15 + (width + 3)*(i%3), 55 + 15 + i/3*(width+3), width, width);
                        beforeHeight = showImage.bottom;
                        
                    }

            }
                break;
                
            default:
                break;
        }
        
    }
    
    if (self.talktype == GroupTitleTalkType) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        titleLabel.textColor = TitleColor;
        titleLabel.numberOfLines = 0;
        [headView addSubview:titleLabel];
        titleLabel.text = self.Articletitle;
        titleHeight = [self.Articletitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:19] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height;
        titleLabel.frame = CGRectMake(15, beforeHeight + 15, SCREEN_WIDTH - 30, titleHeight);
//        titleLabel.frame = CGRectMake(15, 65, SCREEN_WIDTH - 30, titleHeight);
        beforeHeight = beforeHeight + 15 + titleHeight;
    }
    //内容
    ZDStagLabel *lblcontent = [[ZDStagLabel alloc] init];
    lblcontent.numberOfLines = 0;
    lblcontent.frame = CGRectMake(15, beforeHeight + 15,SCREEN_WIDTH-30, contentH);
    lblcontent.font = MyFont(15);
    lblcontent.textColor = ContentColor;
    lblcontent.userInteractionEnabled = YES;
    WEAKSELF_SS
    [lblcontent setContent:self.content WithTagClick:^(NSString *tag) {
        DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
        typeVC.showtag = tag;
        [weakSelf.navigationController pushViewController:typeVC animated:YES];
    } AndOtherClick:^{
        discussAlertView *discover = [[discussAlertView alloc] initWithFrame:weakSelf.view.window.bounds delegate:weakSelf];
        [discover createViewWithContentUserId:weakSelf.userId];
        [weakSelf.view.window addSubview:discover];
        [discover ssl_show];
    }];
    if (self.talktype == GroupTitleTalkType) {
        NSAttributedString *as = lblcontent.attributedText;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
        [paragraphStyle setLineSpacing:8];//调整行间距
        [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [self.content length])];
        lblcontent.attributedText = aas;
        lblcontent.numberOfLines = 0;
        lblcontent.size = [lblcontent sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, MAXFLOAT)];
        lblcontent.width = SCREEN_WIDTH - 30;
    }
    beforeHeight = lblcontent.bottom;
    
    UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(ContentlongTap:)];
    [headView addGestureRecognizer:longtap];
    
    [headView addSubview:lblcontent];

    
    CGFloat width = 0;
    if(![self.permission isEqualToString:@"1"]){
        //点赞
        MCFireworksButton *redXin = [[MCFireworksButton alloc] initWithFrame:CGRectMake(15, beforeHeight + 23, 19, 19)];
        self.goodButton = redXin;
        self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
        self.goodButton.particleScale = 0.05;
        self.goodButton.particleScaleRange = 0.02;
        
        if ([self.praisestatus isEqualToString:@"1"]) {
            [redXin setBackgroundImage:[UIImage imageNamed:@"jy-32.png"] forState:UIControlStateNormal];
        }else if ([self.praisestatus isEqualToString:@"0"]){
            [redXin setBackgroundImage:[UIImage imageNamed:@"jy-36-.png"] forState:UIControlStateNormal];
        }
        
        [redXin addTarget:self action:@selector(goodBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:redXin];
        
        //点赞人头像
        CGFloat margin = 5;
        CGFloat width = 34;
        
        UIView *goodlistView = [[UIView alloc] initWithFrame:CGRectMake(self.goodButton.maxX + 7, self.goodButton.top - 8, SCREEN_WIDTH - self.goodButton.right - 7, width)];
        [headView addSubview:goodlistView];
        self.goodListView = goodlistView;
        
        CGFloat x = 0;
        for (int i = 0; i<self.goodImages.count; i++) {
            
            UIButton *head = [[UIButton alloc] init];
            head.frame = CGRectMake(x, 0, width, width);
            [head makeCorner:width / 2];
            [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
            head.titleLabel.text = self.goodImages[i][@"userid"];
            [head addTarget:self action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
            [goodlistView addSubview:head];
            
            x += margin + width;
            if (x + width*2 > goodlistView.width) {
                break;
            }
        }
        
        if (self.goodImages.count > 0) {
            
            //更多按钮
            UIButton *moreBtn = [[UIButton alloc] init];
            moreBtn.frame = CGRectMake(x, 0, width, width);
            moreBtn.titleLabel.font = MyFont(10);
            [moreBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
            [moreBtn setTitle:[NSString stringWithFormat:@"%@+",self.goodsum] forState:UIControlStateNormal];
            moreBtn.layer.cornerRadius = width/2;
            moreBtn.clipsToBounds = YES;
            moreBtn.layer.borderColor = OrangeColor.CGColor;
            moreBtn.layer.borderWidth = 0.5;
            //        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gdjy-100-50.png"] forState:UIControlStateNormal];
            [goodlistView addSubview:moreBtn];
            [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
        }
//        //点赞
//        MCFireworksButton *redXin = [[MCFireworksButton alloc] init];
//        self.goodButton = redXin;
//        self.goodButton.particleImage = [UIImage imageNamed:@"RedSparkle"];
//        self.goodButton.particleScale = 0.05;
//        self.goodButton.particleScaleRange = 0.02;
//        
//        NSLog(@"self.praisestatus:%@",self.praisestatus);
//        if ([self.praisestatus isEqualToString:@"1"]) {
//            [redXin setBackgroundImage:[UIImage imageNamed:@"jy-40"] forState:UIControlStateNormal];
//        }else{
//            [redXin setBackgroundImage:[UIImage imageNamed:@"jy-40-"] forState:UIControlStateNormal];
//            
//        }
//        [redXin addTarget:self action:@selector(goodBtn:) forControlEvents:UIControlEventTouchUpInside];
//        redXin.frame = CGRectMake(15, beforeHeight + 20, 20, 17);
//        [headView addSubview:redXin];
//        
//        //点赞人头像
//        CGFloat margin = 7;
//        width = 33;
//        UIView *goodlistView = [[UIView alloc] init];
//        self.goodListView = goodlistView;
//        goodlistView.frame = CGRectMake(self.goodButton.maxX + 13, beforeHeight + 15, SCREEN_WIDTH - 10, width);
//        [headView addSubview:goodlistView];
//        CGFloat x = 0;
//        for (int i = 0; i<self.goodImages.count; i++) {
//            UIButton *head = [[UIButton alloc] init];
//            head.frame = CGRectMake(x, 0, width, width);
//            head.clipsToBounds = YES;
//            head.layer.cornerRadius = width/2;
//            [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
//            head.titleLabel.text = self.goodImages[i][@"userid"];
//            [head addTarget:self action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
//            [goodlistView addSubview:head];
//            x+=margin+width;
//        }
//        if (self.goodImages.count>0) {
//            //更多按钮
//            UIButton *moreBtn = [[UIButton alloc] init];
//            moreBtn.frame = CGRectMake(x, 0, 33, 33);
//            //            [moreBtn setBackgroundImage:[UIImage imageNamed:@"gdjy-100-50.png"] forState:UIControlStateNormal];
//            [moreBtn setTitle:[NSString stringWithFormat:@"%@+",self.goodsum] forState:(UIControlStateNormal)];
//            moreBtn.layer.borderColor = [WWTolls colorWithHexString:@"#ff2624"].CGColor;
//            moreBtn.layer.borderWidth = 0.5;
//            moreBtn.layer.cornerRadius = moreBtn.frame.size.width/2;
//            moreBtn.titleLabel.font = MyFont(14);
//            [moreBtn setTitleColor:[WWTolls colorWithHexString:@"#ff2624"] forState:(UIControlStateNormal)];
//            [goodlistView addSubview:moreBtn];
//            [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
//            
//        }
    }

    self.headerView = headView;
    return headView;
}
-(void)touxh:(UISlider *)s{
    s.value = (int)(s.value+0.5);
    NSLog(@"2");
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([self.permission isEqualToString:@"1"]) {
        self.tool.toolBar.hidden = YES;
        self.joinBg.hidden = NO;
        self.sendBtn.hidden = YES;
    }else {
        self.tool.toolBar.hidden = NO;
        self.joinBg.hidden = YES;
    }
    if (section == 1) {
        return 0;
    }
    if (self.talktype == GroupTitleTalkType && self.timePageNum != 1) {
        return 0;
    }
    CGFloat h = 120;
    
    if (self.content.length>0) {
        if (self.talktype == GroupTitleTalkType) {
            
            //内容
            HTCopyableLabel *lblcontent = [[HTCopyableLabel alloc] init];
            lblcontent.numberOfLines = 0;
            lblcontent.frame = CGRectMake(15, 0,SCREEN_WIDTH-30, 0);
            lblcontent.font = MyFont(15);
            lblcontent.textColor = [WWTolls colorWithHexString:@"#535353"];
            lblcontent.userInteractionEnabled = YES;
            WEAKSELF_SS
            [lblcontent setContent:self.content WithTagClick:^(NSString *tag) {
                DiscoverTypeViewController *typeVC = [[DiscoverTypeViewController alloc] init];
                typeVC.showtag = tag;
                [weakSelf.navigationController pushViewController:typeVC animated:YES];
            } AndOtherClick:nil];
            NSAttributedString *as = lblcontent.attributedText;
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            NSMutableAttributedString *aas = [[NSMutableAttributedString alloc] initWithAttributedString:as];
            [paragraphStyle setLineSpacing:8];//调整行间距
            [aas addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, [self.content length])];
            lblcontent.attributedText = aas;
            [lblcontent sizeToFit];
            h += lblcontent.height;
        }else h += [WWTolls heightForString:self.content fontSize:15 andWidth:(SCREEN_WIDTH-30)];
    }else h-=10;
    if (self.showimage && self.showimage.length > 0)  {
        NSArray *images = [self.showimage componentsSeparatedByString:@"|"];
        CGFloat imageH = 0;
        switch (images.count) {
            case 1:
            {
                CGSize imagesizes = [WWTolls sizeForQNURLStr:images[0]];
                imageH = (SCREEN_WIDTH - 30)*imagesizes.height/imagesizes.width;
            }
                break;
            case 2:
                imageH = (SCREEN_WIDTH-30 - 3)/2;
                break;
            case 4:
                imageH = (SCREEN_WIDTH-30 - 3)+3;
                break;
            default:
                imageH = (images.count + 2)/3 * ((SCREEN_WIDTH-30 - 6)/3);
                break;
        }
        h += imageH + 24;
        //        for (NSString *img in images) {
        //            h += [WWTolls sizeForQNURLStr:img].height / [WWTolls sizeForQNURLStr:img].width * (SCREEN_WIDTH - 14) + 7;
        //        }
        //        CGFloat w;
        //        for (int i = 0; i < images.count; i++) {
        //            w = [[WWTolls sizeForQNURLStr:images[i]].width/[WWTolls sizeForQNURLStr:images[i]].width * (SCREEN_WIDTH-14)];
        //            if (w>self.view.frame.size.width) {
        //
        //            }
        //        }
        
        
    }else h+=15;
    if (self.talktype == GroupTitleTalkType) {
        h += [self.Articletitle sizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:19] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height + 10;
    }
    if (self.data.count == 0 && [self.permission isEqualToString:@"1"]) {
        h -= 40;
    }
    self.headerViewHEIGH = h;
    return h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiscoverReplyModel *model = self.data[indexPath.row];
    if (self.talktype == GroupTitleTalkType) {
        int pageInt = self.timePageNum - ((int)self.data.count - (int)indexPath.row - 1)/10;
    }
    if (self.talktype == GroupTitleTalkType) {//带图片评论
        DisReplyWithImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageReplyCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DisReplyWithImageTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMan:)];
        UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(DiscusslongTap:)];
        [cell addGestureRecognizer:longtap];
        [cell addGestureRecognizer:tap];
        return cell;
    }else{
        DisReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"discoverReplyCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"DisReplyTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMan:)];
        UILongPressGestureRecognizer *longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(DiscusslongTap:)];
        [cell addGestureRecognizer:longtap];
        [cell addGestureRecognizer:tap];
        return cell;
    }
}

#pragma mark - 评论手势事件
/**
 *  内容长按
 */
-(void)ContentlongTap:(UILongPressGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press Ended");
        discussAlertView *discover = [[discussAlertView alloc] initWithFrame:self.view.window.bounds delegate:self];
        [discover createViewWithContentUserId:self.userId];
        [self.view.window addSubview:discover];
        [discover ssl_show];
    }
//    else {
//        NSLog(@"Long press detected.");
//    }
}
/**
 *  评论长按
 */
-(void)DiscusslongTap:(UILongPressGestureRecognizer*)tap{
    if (tap.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press Ended");
        DiscoverReplyModel *model = ((DisReplyTableViewCell*)tap.view).model;
        self.currentDiscussModel = model;
        discussAlertView *discover = [[discussAlertView alloc] initWithFrame:self.view.window.bounds delegate:self];
        [discover createViewWithModel:model];
        [self.view.window addSubview:discover];
        [discover ssl_show];

    }
    else {
        NSLog(@"Long press detected.");
    }
}
/**
 *  评论短按
 */
-(void)clickMan:(UIGestureRecognizer*)tap{

    if(self.talktype == GroupTitleTalkType){
        DiscoverReplyModel *model = ((DisReplyTableViewCell*)tap.view).model;
        if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
            return;
        }
        ArticleCommentViewController *comment = [[ArticleCommentViewController alloc] init];
        comment.talkId = self.talkid;
        comment.byComendId = model.commentid;
        comment.byComendName = model.username;
        [self.navigationController pushViewController:comment animated:YES];
        
    }else if (self.tool.toolBar.hidden) {
        
        
    }else if([self.tool isFirstResponder]){
        [self.view endEditing:YES];
    }else{
        //选择评论发表二级回复
        DiscoverReplyModel *model = ((DisReplyTableViewCell*)tap.view).model;
        if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
            _tool.myTextView.placeholder = @"添加评论";
            self.bycommentid = self.talkid;
            return;
        }
        
        _tool.myTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model.username];
        [_tool.myTextView becomeFirstResponder];
        self.bycommentid = model.commentid;
        
    }
}

//Editing
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//对选中的Cell根据editingStyle进行操作
- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSLog(@"删除评论事件");
        
        self.currentIndexPath = indexPath;
        [self requestWithDelreply];
    }
}

//Editing
//当在Cell上滑动时会调用此函数
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoverReplyModel *model = self.data[indexPath.row];
    
    NSString *myUserId = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_USERID];
    
    //自己发布的撒欢 (可以删除所有人的评论) || 不是自己发布的撒欢是自己发布的评论可以删除
    if ([self.userId isEqualToString:myUserId] || [model.userid isEqualToString:myUserId] || [myUserId isEqualToString:self.creator]) {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.talktype == GroupTitleTalkType){
        DiscoverReplyModel *model = self.data[indexPath.row];
        if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
            return;
        }
        ArticleCommentViewController *comment = [[ArticleCommentViewController alloc] init];
        comment.talkId = self.talkid;
        comment.byComendId = model.commentid;
        comment.byComendName = model.username;
        [self.navigationController pushViewController:comment animated:YES];
        
    }else if (self.tool.toolBar.hidden) {
        
        
    }else if([self.tool isFirstResponder]){
        [self.view endEditing:YES];
    }else{
        //选择评论发表二级回复
        DiscoverReplyModel *model = self.data[indexPath.row];
        if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
            _tool.myTextView.placeholder = @"添加评论";
            self.bycommentid = self.talkid;
            return;
        }
        
        _tool.myTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model.username];
        [_tool.myTextView becomeFirstResponder];
        self.bycommentid = model.commentid;
    
    }
}   
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self tapGRActive:nil];
//    NSLog(@"scrollViewWillBeginDragging");
//}

#pragma mark - 头像点击事件
-(void)clickHead{
    if (self.userId.length<1) {
        return;
    }
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.userId;
    single.otherOrMe = 1;
    [self.navigationController pushViewController:single animated:YES];
}
-(void)clickGoodMan:(UIButton*)btn{
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = btn.titleLabel.text;
    single.otherOrMe = 1;
    [self.navigationController pushViewController:single animated:YES];
}


#pragma mark - 前往点赞列表
-(void)goToGoodList{
    GoodListViewController *good = [[GoodListViewController alloc] init];
    good.goodType = @"2";
    good.goodId = self.talkid;
    [self.navigationController pushViewController:good animated:YES];
}   

#pragma mark - 点赞
- (void)goodBtn:(id)sender {
    if ([self.permission isEqualToString:@"1"]) {
        return;
    }
    self.goodButton.userInteractionEnabled = NO;
    //    self.goodBigBtn.userInteractionEnabled = NO;
    //    [self.superview bringSubviewToFront:self];
    [self.goodButton popOutsideWithDuration:0.5];
    if ([self.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
        
        [self clickGoodSender:@"0"];
    }else{
        
        [self clickGoodSender:@"1"];
        
    }
}
-(void)clickGoodSender:(NSString*)praisesta
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.talkid forKey:@"receiveid"];
    [dictionary setValue:praisesta forKey:@"praisestatus"];
    [dictionary setObject:@"2" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PRAISE_104 parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.goodButton.userInteractionEnabled = YES;
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goodReply" object:dictionary];
            [weakSelf reloadGoodMan];
            if ([weakSelf.praisestatus isEqualToString:@"0"]) {
                weakSelf.praisestatus = @"1";
                [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-40"] forState:UIControlStateNormal];
                [weakSelf.goodButton popInsideWithDuration:0.4];
                weakSelf.goodsum = [NSString stringWithFormat:@"%d",weakSelf.goodsum.intValue-1];
//                weakSelf.goodLbl.text = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue-1];
            }
            else{
                [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"jy-40-"] forState:UIControlStateNormal];
                weakSelf.praisestatus = @"0";
                [weakSelf.goodButton popOutsideWithDuration:0.5];
                [weakSelf.goodButton animate];
                
                weakSelf.goodsum = [NSString stringWithFormat:@"%d",weakSelf.goodsum.intValue+1];
//                weakSelf.goodLbl.text = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue+1];
            }
        }
    }];
    
}
#pragma mark - 刷新点赞列表
-(void)reloadGoodMan{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"7" forKey:@"pageSize"];
    [dictionary setObject:@"2" forKey:@"praisetype"];
    [dictionary setObject:self.talkid forKey:@"receiveid"];
    
    //发送请求感兴趣的人
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_DISCOVER_GOOD parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (dic[ERRCODE]) {
        }else{
            NSArray *tempArray = dic[@"userlist"];
            [weakSelf.goodImages removeAllObjects];
            [weakSelf.goodImages addObjectsFromArray:tempArray];
            CGFloat margin = 5;
            CGFloat width = 34;
            for (UIView *btn in weakSelf.goodListView.subviews){
                [btn removeFromSuperview];
            }
            CGFloat x = 0;
            for (int i = 0; i<self.goodImages.count; i++) {
                
                UIButton *head = [[UIButton alloc] init];
                head.frame = CGRectMake(x, 0, width, width);
                [head makeCorner:width / 2];
                [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
                head.titleLabel.text = self.goodImages[i][@"userid"];
                [head addTarget:self action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf.goodListView addSubview:head];
                
                x += margin + width;
                if (x + width*2 > weakSelf.goodListView.width) {
                    break;
                }
            }
            
            if (self.goodImages.count > 0) {
                
                //更多按钮
                UIButton *moreBtn = [[UIButton alloc] init];
                moreBtn.frame = CGRectMake(x, 0, width, width);
                moreBtn.titleLabel.font = MyFont(10);
                [moreBtn setTitleColor:OrangeColor forState:UIControlStateNormal];
                [moreBtn setTitle:[NSString stringWithFormat:@"%@+",self.goodsum] forState:UIControlStateNormal];
                moreBtn.layer.cornerRadius = width/2;
                moreBtn.clipsToBounds = YES;
                moreBtn.layer.borderColor = OrangeColor.CGColor;
                moreBtn.layer.borderWidth = 0.5;
                //        [moreBtn setBackgroundImage:[UIImage imageNamed:@"gdjy-100-50.png"] forState:UIControlStateNormal];
                [weakSelf.goodListView addSubview:moreBtn];
                [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
                
                //        UILabel *countLable = [[UILabel alloc] initWithFrame:CGRectMake(1, 5,40, 14)];
                //        countLable.text = self.goodsum;
                //        countLable.textAlignment = NSTextAlignmentCenter;
                //        countLable.font = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
                //        countLable.textColor = [WWTolls colorWithHexString:@"#ffffff"];
                //        self.goodLbl = countLable;
                //        [moreBtn addSubview:countLable];
            }
        }
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    _tool.faceboardIsShow = YES;
    _tool.keyboardIsShow = YES;
    [_tool disFaceKeyboard];
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        if ([self.bycommentid isEqualToString:self.talkid]) {//一级评论
            if (SCREEN_HEIGHT + ty-77>=self.headerViewHEIGH) {
                self.table.contentOffset = CGPointMake(0, ty);
            }else{
                self.table.contentOffset = CGPointMake(0, self.headerViewHEIGH - SCREEN_HEIGHT+110);
            }
        }else{//二级评论
            CGFloat h = self.headerViewHEIGH;
            for (DiscoverReplyModel *model in self.data) {
                NSString *s;
                if ([model.commentlevel isEqualToString:@"1"]) {
                    s = model.content;
                }else{
                    s = [NSString stringWithFormat:@"回复%@:%@",model.byusername,model.content];
                }
                h += [WWTolls heightForString:s fontSize:14 andWidth:SCREEN_WIDTH-66];
                h+= 54;
                if ([model.commentid isEqualToString:self.bycommentid]) {
                    break;
                }
            }
            h += 18;
            if (SCREEN_HEIGHT + ty - 77>=h) {
                self.table.contentOffset = CGPointMake(0, ty);
            }else{
                self.table.contentOffset = CGPointMake(0, h - SCREEN_HEIGHT+106);
            }
            
            
        }
    }];
}

#pragma mark - 评论长按代理
/**
 *  举报评论
 */
- (void)JuBaoAlertConfirmClick:(discussAlertView *)discussAlert{
    self.JubaoKind = @"1";
    [self reportButtonSender];
}
/**
 *  复制评论
 */
- (void)copyAlertConfirmClick:(discussAlertView *)discussAlert{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.currentDiscussModel.content;
    [MBProgressHUD showError:@"复制成功"];
}
/**
 *  举报帖子
 */
- (void)JuBaoContentAlertConfirmClick:(discussAlertView *)discussAlert{
    self.JubaoKind = @"0";
    [self reportButtonSender];
}
/**
 *  复制帖子
 */
- (void)copyContentAlertConfirmClick:(discussAlertView *)discussAlert{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.content;
    [MBProgressHUD showError:@"复制成功"];
}


#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.table.contentOffset = CGPointZero;
    }];
}
-(void)faceSendBtnClick{
    [self sendDidClick];
    [_tool disFaceKeyboard];
    [self.view endEditing:YES];
}

-(void)tapGRActive:(UITapGestureRecognizer *)tapGR
{
    if (_tool.myTextView.text.length<1) {
        _tool.myTextView.placeholder = @"添加评论";
        self.bycommentid = self.talkid;
    }
    if (_tool.faceboardIsShow) {
        [_tool disFaceKeyboard];
    }
    [self.view endEditing:YES];
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self commitPingLun];
    return YES;
}

#pragma mark - 发表评论
-(void)sendDidClick{
    [self commitPingLun];
}
-(void)commitPingLun{
    if ([_tool.myTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
        [self.view endEditing:YES];
        [self showAlertMsg:@"不能发布空评论" yOffset:0];
        return;
    }else if(_tool.myTextView.text.length > 1000){
        [self.view endEditing:YES];
        [self showAlertMsg:@"评论内容最多1000字" yOffset:0];
        return;
    }else if([WWTolls isHasSensitiveWord:_tool.myTextView.text]){
        [self.view endEditing:YES];
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }

    if (!_enableCommit) {
        return;
    }
    _enableCommit = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.talkid forKey:@"talkid"];
    [dictionary setObject:_tool.myTextView.text forKey:@"rpycontent"];//回复内容
    [dictionary setObject:[self.talkid isEqualToString:self.bycommentid]?@"1":@"2" forKey:@"replylevel"];//回复级别
    [dictionary setObject:self.bycommentid forKey:@"byreplyid"];
    
    //发送请求即将开团
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PUBLISHRPY parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if ([dic[@"result"] isEqualToString:@"0"]) {//成功
            
            [weakSelf.view endEditing:YES];
            if (weakSelf.talktype == GroupTitleTalkType) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"grouptitletoggle" object:@{@"talkid":weakSelf.talkid}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"comReply" object:dictionary];
            }
            // 2、刷新表格
            [weakSelf LoadDataWithIsMore:NO];
            [weakSelf showAlertMsg:@"评论成功" andFrame:CGRectZero];
            weakSelf.bycommentid = weakSelf.talkid;
            weakSelf.tool.myTextView.placeholder = @"添加评论";
            //清空文本框内容
            _tool.myTextView.text = nil;
        }
        weakSelf.enableCommit = YES;
    }];
}

- (void)gotoGroup{
    self.isGoToGroup = YES;
    NSMutableArray *contrllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    GroupViewController *group = [[GroupViewController alloc] init];
    group.groupId = self.groupId;
    group.clickevent = 6;
    group.joinClickevent = @"6";
    group.comeTitleTalkid = self.talkid;
    [contrllers removeLastObject];
    [contrllers addObject:group];
    [self.navigationController setViewControllers:contrllers animated:YES];
}

- (void)more{
    self.JubaoKind = @"0";
    [self jubaoShare];
}

#pragma mark 乐活吧分享
- (void)jubaoShare {
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
    myshareView.narDelegate = self;
    
    [[NSUserDefaults standardUserDefaults] setObject:[self.creator isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]?@"1":@"3" forKey:@"shareGroupGameAngle"];
    if (!self.isShowTopBtn) {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"shareGroupGameAngle"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"shareGroupUserId"];
    [[NSUserDefaults standardUserDefaults] setObject:self.creator forKey:@"shareGroupUserId"];

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.topcount.intValue] forKey:@"shareGroupTopNumber"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.topupper.intValue] forKey:@"shareGroupTopUpper"];
    [[NSUserDefaults standardUserDefaults] setObject:self.istop forKey:@"shareGroupIsTop"];
    [[NSUserDefaults standardUserDefaults] setObject:self.isCollection forKey:@"shareGroupIsCollection"];
    
    GroupTalkModel *tempModel = [GroupTalkModel new];
    tempModel.content = self.content;
    tempModel.imageurl = self.showimage&&self.showimage.length>0?[[self.showimage componentsSeparatedByString:@"|"] firstObject]:@"";
    tempModel.userid = self.userId;
    tempModel.barid = self.talkid;
    tempModel.talkid = self.talkid;
    tempModel.title = _Articletitle;
    [myshareView createView:GrouptTalkShareType withModel:tempModel withGroupModel:nil];
//    int i = 0;
//    for (; i < self.data.count; i++) {
//        GroupTalkModel *model = self.data[i];
//        if ([model.barid isEqualToString:talkid]) {
//            tempModel = model;
//            break;
//        }
//    }
//    
//    [[NSUserDefaults standardUserDefaults] setObject:self.gameangle forKey:@"shareGroupGameAngle"];
//    [[NSUserDefaults standardUserDefaults] setObject:tempModel.userid forKey:@"shareGroupUserId"];
//    [[NSUserDefaults standardUserDefaults] setObject:self.model.gamecrtor forKey:@"shareGroupUserId"];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:topNumber] forKey:@"shareGroupTopNumber"];
//    [[NSUserDefaults standardUserDefaults] setObject:tempModel.istop forKey:@"shareGroupIsTop"];
    
    //团聊
//    if ([tempModel.bartype isEqualToString:@"0"]) {
//        
//        GroupTalkTableViewCell *cell = (GroupTalkTableViewCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
//        
//        UIImage *tempImage = [SSLImageTool scaleToSize:CGSizeMake(120, 120) withImage:cell.contentImageView.image];
//        NSData *data = [SSLImageTool compressImage:tempImage withMaxKb:32];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        [myshareView createView:GrouptTalkShareType withModel:tempModel withGroupModel:self.model];
//        [myshareView setShareImage:image];
//        
//        //活动
//    } else if ([tempModel.bartype isEqualToString:@"1"]) {
    
//    }
}

#pragma mark 置顶/取消置顶
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

//收藏
- (void)shareViewDelegateCollect {
    NSString *stopResult;
    //是否置顶
    if ([self.isCollection isEqualToString:@"0"]) {
        stopResult = @"0";
    } else {
        stopResult = @"1";
    }
    
    [self CollectRequestReload:self.talkid stopID:stopResult];

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
    
    if (alertView.tag == 777) {//删除
        if (buttonIndex == 1) {
            
            [self requestWithDeleteBarWithDeleteid:self.talkid andDelType:@"1"];
        }
    }
}

#pragma mark groupTalkCellDelegate
#pragma mark - 举报
-(void)reportClick:(NSString*)discoverId AndType:(NSString*)type{
//    talkid = discoverId;
//    repotType = type;
//    [self jubaoShare];
}

-(void)removeMyActionSheet
{
    if (myActionSheetView!=nil) {
        [myActionSheetView removeFromSuperview];
    }
}

-(void)reportButtonSender
{
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
#pragma mark - 举报接口
-(void)postReport:(NSString*)ifmtype{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    if([self.JubaoKind isEqualToString:@"0"]) [dictionary setObject:self.talkid forKey:@"receiveid"];
    else [dictionary setObject:self.currentDiscussModel.commentid forKey:@"receiveid"];
    [dictionary setObject:ifmtype forKey:@"ifmtype"];
    [dictionary setObject:self.JubaoKind forKey:@"ifmkind"];//0 讨论举报1 回复举报
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_TALKINFORM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if ([dic[@"result"] isEqualToString:@"0"]) [weakSelf showAlertMsg:@"举报成功" andFrame:CGRectMake(70,100,200,60)];
    }];
}
#pragma mark 置顶/取消置顶
- (void)topBar {
    NSString *stopResult;
    //是否置顶
    if ([self.istop isEqualToString:@"0"]) {
        stopResult = @"1";
    } else {
        stopResult = @"0";
    }
    
    [self topRequestReload:self.talkid stopID:stopResult];
}

-(void)topRequestReload:(NSString*)talkID stopID:(NSString*)stopid{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:stopid forKey:@"istop"];
    [dictionary setObject:@"0" forKey:@"toptype"];
    [dictionary setObject:talkID forKey:@"topid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"ineract/toptitle.do"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (!dic[ERRCODE]){
            if([dic[@"result"] isEqualToString:@"0"]){
                
                if ([stopid isEqualToString:@"1"]) {
                    [weakSelf showAlertMsg:@"置顶成功" andFrame:CGRectZero];
                    self.istop = @"1";
                }else{
                    [weakSelf showAlertMsg:@"取消置顶成功" andFrame:CGRectZero];
                    self.istop = @"0";
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"grouptitletop" object:nil];
            }
        }
    }];
}

#pragma mark - 精华帖收藏
-(void)CollectRequestReload:(NSString*)talkID stopID:(NSString*)stopid{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:stopid forKey:@"iscollection"];
    [dictionary setObject:talkID forKey:@"talkid"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"/me/tocollection.do"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (!dic[ERRCODE]){
            if([dic[@"result"] isEqualToString:@"0"]){
                
                if ([stopid isEqualToString:@"1"]) {
                    [weakSelf showAlertMsg:@"收藏成功" andFrame:CGRectZero];
                    self.isCollection = @"0";
                }else{
                    [weakSelf showAlertMsg:@"取消收藏成功" andFrame:CGRectZero];
                    self.isCollection = @"1";
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"grouptitleCollection" object:nil];
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
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Del_Bar];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [weakSelf removeWaitView];
        
        DeleteBarModel *model = [DeleteBarModel objectWithKeyValues:dic];
        
        //处理成功
        if ([model.result isEqualToString:@"0"]) {
            //                [weakSelf.data removeObjectAtIndex:weakSelf.currentIndexPath.row];
            //                [weakSelf.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.currentIndexPath.row inSection:1]] withRowAnimation:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"grouptitletoggle" object:@{@"talkid":deleteid}];
            [MBProgressHUD showError:@"删除成功"];
            [self popButton];
        }
    }];
}

//图片游览
- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = [self.showimage componentsSeparatedByString:@"|"].count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [self.showimage componentsSeparatedByString:@"|"][i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        for (UIImageView *imgView in self.headerView.subviews) {
            if (imgView.tag == i+1) {
                photo.srcImageView = imgView;
            }
        }
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag - 1; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}


@end
