//
//  ZDSActDetailViewController.m
//  zhidoushi
//
//  Created by licy on 15/5/26.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSActDetailViewController.h"

#import "DiscoverReplyModel.h"
#import "DisReplyTableViewCell.h"
#import "IQKeyboardManager.h"
#import "XimageView.h"
#import "MCFireworksButton.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "UITextField+LimitLength.h"
#import "FaceToolBar.h"

#import "ZDSUserListViewController.h"

#import "ZDSActDetailCell.h"
#import "ZDSActParterModel.h"
#import "ZDSActCommentModel.h"
#import "ZDSActDetailModel.h"

#import "MJExtension.h"

static NSString *PageTitle = @"活动详情";
static NSString *PageName = @"活动详情页面";

//static NSString *PlaceImage = @"mrtx_98_98.png";
static NSString *JoinImage = @"canjia-120-70.png";
static NSString *JoinedImage = @"yicanjia";
static NSString *ActFlagImage = @"huodong-42-42.png";
//static NSString *MoreImage = @"Discover_chengyuan_more.png";

////线颜色
static NSString *LineColor = @"#dcdcdc";
//
//static NSString *BgColor = @"#efefef";
//static NSString *BigFontColor = @"#6b6b6b";
//static NSString *SmallFontColor = @"#afafaf";

@interface ZDSActDetailViewController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,FaceToolBarDelegate,UINavigationControllerDelegate>


@property (nonatomic,assign) BOOL isCommiting;//是否正在发布

@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,assign) int partercount;//参与者总数
/*
 0 已参加
 1 未参加
 */
@property(nonatomic,nonnull) NSString *isjoin;//参加状态
@property(nonatomic,nonnull) ZDSActDetailModel *detailModel;//详情模型


@property(nonatomic,strong)UITableView* table;//tableView

@property (nonatomic,strong) UITapGestureRecognizer *tap;


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
@property(nonatomic,assign)CGFloat h;//高度
@property(nonatomic,assign)CGFloat w;//宽度
@property(nonatomic,strong)UIImage *showimageview;//图片

@property (nonatomic,strong) UIButton *joinButton;//参加按钮

@end

@implementation ZDSActDetailViewController

#pragma mark Life Cycle

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    [MobClick endLogPageView:PageName];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:PageName];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    //导航栏标题
    self.titleLabel.text = PageTitle;
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [self.table reloadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.view endEditing:YES];
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    self.navigationController.delegate = self;
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.isCommiting = NO;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self showWaitView];

    [self setupGUI];
    //初始化回复级别
    self.bycommentid = self.activityid;
    [self.header beginRefreshing];
}

- (void)dealloc {
    [self.header free];
    [self.footer free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDSActCommentModel *model = self.data[indexPath.row];
    NSString *s;

    if ([model.commentlevel isEqualToString:@"1"]) {
        s = model.content;
    }else{
        s = [NSString stringWithFormat:@"回复%@:%@",model.byusername,model.content];
    }
    CGFloat h = 45;
    h += [WWTolls heightForString:s fontSize:14 andWidth:257];
    
    if (!iPhone4) {
        h += 6;
    }
    
    return h;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        return nil;
    }
    
    //背景视图
    UIView *headView = [[UIView alloc] init];
    //头像
    UIImageView *headerView = [[UIImageView alloc] init];
    [headView addSubview:headerView];
    [headerView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.imageurl] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    headerView.frame = CGRectMake(7, 7, 40, 40);
    headerView.layer.cornerRadius = 20;
    headerView.clipsToBounds = YES;
    headerView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHead)];
    [headerView addGestureRecognizer:tap];
    
    //昵称
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(54, 13, 200, 17);
    lbl.font = MyFont(12);
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    lbl.text = self.detailModel.username;
    [headView addSubview:lbl];
    
    //时间
    UILabel *lbltime = [[UILabel alloc] init];
    lbltime.frame = CGRectMake(54, 34, 200, 13);
    lbltime.font = MyFont(10);
    lbltime.textColor = [WWTolls colorWithHexString:@"#afafaf"];
    lbltime.text = [WWTolls timeString22:self.detailModel.createtime];
//    lbltime.text = self.detailModel.acttime;
    [headView addSubview:lbltime];
    
    //参加/已参加
    self.joinButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 9 - 60, 14, 60, 35)];
    
    NSString *userId = [NSUSER_Defaults objectForKey:ZDS_USERID];
    
    //本人的团 或者非游戏参与者
    if ([userId isEqualToString:self.detailModel.userid] || [self.detailModel.userangle isEqualToString:@"1"]) {
        self.joinButton.hidden = YES;
    } else {
        self.joinButton.hidden = NO;
        //已参加
        if ([self.isjoin isEqualToString:@"0"]) {
            self.joinButton.userInteractionEnabled = NO;
            [self.joinButton setImage:[UIImage imageNamed:JoinedImage] forState:UIControlStateNormal];
        } else {
            self.joinButton.userInteractionEnabled = YES;
            [self.joinButton setImage:[UIImage imageNamed:JoinImage] forState:UIControlStateNormal];
        }
    }
    
    [self.joinButton addTarget:self action:@selector(goodClick:) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:self.joinButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, headerView.maxY + 12, SCREEN_WIDTH - 20, 0.5)];
    lineView.backgroundColor = [WWTolls colorWithHexString:LineColor];
    [headView addSubview:lineView];
    
    UIImageView *actImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, lineView.maxY + 12, 21, 21)];
    [actImageView setImage:[UIImage imageNamed:ActFlagImage]];
    [headView addSubview:actImageView];
    
    NSString *string =  [NSString stringWithFormat:@"      %@",self.detailModel.content];
    CGFloat contentH = [WWTolls heightForString:string fontSize:14 andWidth:306]+6;
    if (self.detailModel.content.length<1) {
        contentH = 0;
    }   
    
    //内容
    UILabel *lblcontent = [[UILabel alloc] init];
    lblcontent.numberOfLines = 0;
    lblcontent.frame = CGRectMake(actImageView.x, actImageView.midY - 10, SCREEN_WIDTH - 10 - actImageView.x, contentH);
    lblcontent.font = MyFont(14);
    lblcontent.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
//    lblcontent.backgroundColor = [UIColor redColor];
    lblcontent.text = string;
    [headView addSubview:lblcontent];
    
    //点赞数量
    UILabel *lblgoodsum = [[UILabel alloc] init];
    [lblgoodsum makeCorner:10.5];
    self.goodLbl = lblgoodsum;
    lblgoodsum.frame = CGRectMake(9, lblcontent.bottom+2, 21, 21);
    lblgoodsum.font = MyFont(11);
    lblgoodsum.textAlignment = NSTextAlignmentCenter;
    lblgoodsum.textColor = [UIColor whiteColor];
    lblgoodsum.backgroundColor = [WWTolls colorWithHexString:@"#B3E157"];
    lblgoodsum.text = [NSString stringWithFormat:@"%ld",(unsigned long)self.goodImages.count];
    [headView addSubview:lblgoodsum];
    
    //点赞人头像
    CGFloat margin = 6;
    CGFloat width = 21;
    
    UIView *goodlistView = [[UIView alloc] init];
    self.goodListView = goodlistView;
    
    goodlistView.frame = CGRectMake(38, lblgoodsum.y, 310, width);
    [headView addSubview:goodlistView];
    
    CGFloat x = 0;
    for (int i = 0; i<self.goodImages.count; i++) {
        UIButton *head = [[UIButton alloc] init];
        head.frame = CGRectMake(x, 0, width, width);
        head.clipsToBounds = YES;
        head.layer.cornerRadius = width/2;
        [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
        head.titleLabel.text = self.goodImages[i][@"userid"];
        [head addTarget:self action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
        [goodlistView addSubview:head];
        x+=margin+width;
    }
    if (self.goodImages.count>0) {
        //更多按钮
        UIButton *moreBtn = [[UIButton alloc] init];
        moreBtn.frame = CGRectMake(x, 0, width, width);
        [moreBtn setBackgroundImage:[UIImage imageNamed:@"Discover_chengyuan_more"] forState:UIControlStateNormal];
        [goodlistView addSubview:moreBtn];
        [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *grayView = [[UIView alloc] init];
    grayView.frame = CGRectMake(0,goodlistView.maxY + 12, SCREEN_WIDTH, 7);
    [headView addSubview:grayView];
    grayView.backgroundColor = RGBCOLOR(239, 239, 239);
    return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.detailModel.userangle isEqualToString:@"1"]) {
        self.tool.toolBar.hidden = YES;
        self.table.height = SCREEN_HEIGHT - 67;
    }else {
        self.tool.toolBar.hidden = NO;
        self.table.height = SCREEN_HEIGHT - 114;
    }
    
    if (section == 1) {
        return 0;
    }   
    
    CGFloat h = 114 + 5;
    if (self.showimage.length>0) {
        if (self.h==0) {
            self.h = 306;
        }
        h = 114+self.h;
    }
    
    NSString *string = [NSString stringWithFormat:@"      %@",self.detailModel.content];
    CGFloat contentH = [WWTolls heightForString:string fontSize:14 andWidth:306]+6;
    if (self.detailModel.content.length<1) {
        contentH = 0;
    }
    h += contentH;
    return h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZDSActDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZDSActDetailCell"];
    if (cell == nil) {
        cell = [ZDSActDetailCell loadNib];
    }
    cell.model = self.data[indexPath.row];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMan:)];
    [cell addGestureRecognizer:tap];
    return cell;
}   

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tool.toolBar.hidden) {
        return;
    }
    //选择评论发表二级回复
    ZDSActCommentModel *model = self.data[indexPath.row];
    if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        _tool.myTextView.placeholder = @"";
        self.bycommentid = self.activityid;
        return;
    }
    _tool.myTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model.username];
    [_tool.myTextView becomeFirstResponder];
    self.bycommentid = model.commentid;
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self tapGRActive:nil];
}

#pragma mark - Event Responses
//参加活动
- (void)actDetailJoinClick:(UIButton *)button {
    
    self.joinButton.userInteractionEnabled = NO;
    
    if ([self.praisestatus isEqualToString:@"1"]) {//如果用户未被赞
        
        [self clickGoodSender:@"0"];
    }else{
        
        [self clickGoodSender:@"1"];
    }
}

//前往活动评论列表
- (void)toActCommentList {
    
    ZDSUserListViewController *vc = [[ZDSUserListViewController alloc] init];
    vc.activityid = self.activityid;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击某个cell
-(void)clickMan:(UIGestureRecognizer*)tap{
    ZDSActCommentModel *model = ((ZDSActDetailCell*)tap.view).model;
    if ([model.userid isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        _tool.myTextView.placeholder = @"";
        self.bycommentid = self.activityid;
        return;
    }
    _tool.myTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model.username];
    [_tool.myTextView becomeFirstResponder];
    self.bycommentid = model.commentid;
}

#pragma mark - Private Methods
- (void)cmTapClick:(UIGestureRecognizer *)gets {
    [self.view endEditing:NO];
}

#pragma mark - Request
//活动评论列表
- (void)requestWithActCommentsIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (loadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
        [dictionary setObject:self.lastId forKey:@"lastid"];
    } else {
        [dictionary setObject:@"1" forKey:@"pageNum"];
    }
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:self.activityid forKey:@"activityid"];
    
    //发送请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Actcomments];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        } else {
            
            if (loadMore) {
                
                weakSelf.timePageNum++;
            } else {
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            
            NSArray *tempArray = dic[@"commentlist"];
            
            for (NSDictionary *dic in tempArray) {
                NSLog(@"dic:%@",dic);
                [weakSelf.data addObject:[ZDSActCommentModel objectWithKeyValues:dic]];
                weakSelf.lastId = dic[@"commentid"];
            }   
            [weakSelf.table reloadData];
        }
        if (loadMore) {
            [weakSelf.footer endRefreshing];
        } else {
            [weakSelf.header endRefreshing];
        }
        
    }];
}

//活动参与列表
- (void)requestWithActParters {
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"9" forKey:@"pageSize"];
    [dictionary setObject:self.activityid forKey:@"activityid"];
    [dictionary setObject:@"0" forKey:@"loadtype"];
    
    //发送请求感兴趣的人
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Actparters];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            weakSelf.isjoin = dic[@"isjoin"];
            NSArray *tempArray = dic[@"parterList"];
            
            [weakSelf.goodImages removeAllObjects];
            [weakSelf.goodImages addObjectsFromArray:tempArray];
            //            [weakSelf.table reloadSectionIndexTitles];
            //点赞人头像
            CGFloat margin = 6;
            CGFloat width = 21;
            for (UIView *btn in weakSelf.goodListView.subviews){
                [btn removeFromSuperview];
            }
            CGFloat x = 0;
            for (int i = 0; i<weakSelf.goodImages.count; i++) {
                UIButton *head = [[UIButton alloc] init];
                head.frame = CGRectMake(x, 0, width, width);
                head.clipsToBounds = YES;
                head.layer.cornerRadius = width/2;
                [head sd_setBackgroundImageWithURL:[NSURL URLWithString:weakSelf.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
                head.titleLabel.text = weakSelf.goodImages[i][@"userid"];
                head.userInteractionEnabled = YES;
                [head addTarget:weakSelf action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf.goodListView addSubview:head];
                x+=margin+width;
            }
            if (weakSelf.goodImages.count>0) {
                //更多按钮
                UIButton *moreBtn = [[UIButton alloc] init];
                moreBtn.frame = CGRectMake(x, 0, width, width);
                [moreBtn setBackgroundImage:[UIImage imageNamed:@"Discover_chengyuan_more"] forState:UIControlStateNormal];
                [weakSelf.goodListView addSubview:moreBtn];
                [moreBtn addTarget:self action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
            }
            [weakSelf.table reloadData];
        }
        [weakSelf.header endRefreshing];
    }];
}

//活动详情
- (void)requestWithActDetail {
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.activityid forKey:@"activityid"];
    [dictionary setObject:@"0" forKey:@"loadtype"];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Actdetail];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            weakSelf.detailModel = [ZDSActDetailModel objectWithKeyValues:dic];
            
            if (weakSelf.detailModel.errinfo.length > 0) {
                if ([weakSelf.detailModel.errcode isEqualToString:@"IEA084"]) {
                    weakSelf.table.hidden = YES;
                    weakSelf.tool.toolBar.hidden = YES;
                    [weakSelf showAlertMsg:weakSelf.detailModel.errinfo andFrame:CGRectZero];
                }
                
            } else {
                [weakSelf.table reloadData];
                //活动参与者列表
                [weakSelf requestWithActParters];
                //评论列表
                [weakSelf refresh];
            }
        }   
        [weakSelf.header endRefreshing];
    }];
}   

#pragma mark 活动参与者列表
- (void)requestWithActPartersIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.activityid forKey:@"activityid"];
    [dictionary setObject:@"1" forKey:@"loadtype"];
    
    [dictionary setObject:@"10" forKey:@"pageSize"];
    
    if (loadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Actparters];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            if (loadMore) {
                weakSelf.timePageNum++;
            } else {
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            
            int partercount = [dic[@"partercount"] intValue];
            NSString *isjoin = dic[@"isjoin"];
            NSArray *parterList = dic[@"parterList"];
            
            weakSelf.partercount = partercount;
            weakSelf.isjoin = isjoin;
            
            for (NSDictionary *dict in parterList) {
                ZDSActParterModel *model = [ZDSActParterModel objectWithKeyValues:dict];
                [weakSelf.data addObject:model];
            }
            
            [weakSelf.table reloadData];
        }
        
        if (loadMore) {
            [weakSelf.footer endRefreshing];
        }
    }];
}

//加入活动
- (void)requestWithJoinAct {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.activityid forKey:@"activityid"];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_Group_Joinact] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        weakSelf.joinButton.userInteractionEnabled = YES;
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            if ([dic[@"result"] isEqualToString:@"0"]) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"joinAct" object:weakSelf.activityid];
//                self.activityid
                
                [weakSelf.joinButton setImage:[UIImage imageNamed:JoinedImage] forState:UIControlStateNormal];
//                [self.joinButton setBackgroundImage:[UIImage imageNamed:JoinedImage] forState:UIControlStateNormal];
                weakSelf.joinButton.userInteractionEnabled = NO;
                weakSelf.goodsum = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue+1];
                weakSelf.goodLbl.text = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue+1];
                
                [weakSelf requestWithActParters];
            }
        }   
    }]; 
}   

#pragma mark - 初始化UI
-(void)setupGUI{
    //初始化tableview
    self.table = [[UITableView alloc] init];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.allowsSelection = YES;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-114);
    [self.view addSubview:self.table];
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView.userInteractionEnabled = YES;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        //活动详情
        [self requestWithActDetail];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadData];
    };
    
    //点击手势收起键盘
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRActive:)];
    [self.view addGestureRecognizer:tapGR];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //底部输入视图
    FaceToolBar *tool = [[FaceToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 47) superView:self.view withBarType:CommentDynamicToolBar];
    tool.faceToolBardelegate = self;
    tool.backgroundColor = [UIColor clearColor];
    
    self.tool = tool;
    self.tool.toolBar.hidden = YES;
    
    self.w = 0;
}

-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [self.view endEditing:YES];
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 刷新数据
-(void)refresh{
    [self requestWithActCommentsIsLoadMore:NO];
}

#pragma mark - 加载更多回复
-(void)loadData{
    [self requestWithActCommentsIsLoadMore:YES];
}

#pragma mark - 头像点击事件
-(void)clickHead{
    if (self.detailModel.userid.length<1) {
        return;
    }
    MeViewController *single = [[MeViewController alloc]init];
    single.userID = self.detailModel.userid;
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
    
    ZDSUserListViewController *vc = [[ZDSUserListViewController alloc] init];
//    vc.goodType = @"2";
//    vc.goodId = self.talkid;
    vc.activityid = self.activityid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点赞
- (void)goodClick:(id)sender {
    
    self.joinButton.userInteractionEnabled = NO;
    [self requestWithJoinAct];
}

-(void)clickGoodSender:(NSString*)praisesta {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:self.talkid forKey:@"receiveid"];
    [dictionary setValue:praisesta forKey:@"praisestatus"];
    [dictionary setObject:@"2" forKey:@"praisetype"];//0 赞人/1 赞游戏/2赞团聊
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_PRAISE_104] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        weakSelf.goodButton.userInteractionEnabled = YES;
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            if ([dic[@"result"] isEqualToString:@"0"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goodReply" object:dictionary];
                [weakSelf reloadGoodMan];
                if ([weakSelf.praisestatus isEqualToString:@"0"]) {
                    weakSelf.praisestatus = @"1";
                    [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"zan_32_32"] forState:UIControlStateNormal];
                    [weakSelf.goodButton popInsideWithDuration:0.4];
                    weakSelf.goodsum = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue-1];
                    weakSelf.goodLbl.text = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue-1];
                }
                else{
                    [weakSelf.goodButton setBackgroundImage:[UIImage imageNamed:@"zan_32_32-"] forState:UIControlStateNormal];
                    weakSelf.praisestatus = @"0";
                    [weakSelf.goodButton popOutsideWithDuration:0.5];
                    [weakSelf.goodButton animate];
                    
                    
                    weakSelf.goodsum = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue+1];
                    weakSelf.goodLbl.text = [NSString stringWithFormat:@"%d",weakSelf.goodLbl.text.intValue+1];
                }
            }
            
        }
        
    }];
    
}
#pragma mark - 刷新点赞列表
-(void)reloadGoodMan{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"9" forKey:@"pageSize"];
    [dictionary setObject:@"2" forKey:@"praisetype"];
    [dictionary setObject:self.talkid forKey:@"receiveid"];
    
    //发送请求感兴趣的人
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_DISCOVER_GOOD];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            NSArray *tempArray = dic[@"userlist"];
            [weakSelf.goodImages removeAllObjects];
            [weakSelf.goodImages addObjectsFromArray:tempArray];
            //            [weakSelf.table reloadSectionIndexTitles];
            //点赞人头像
            CGFloat margin = 6;
            CGFloat width = 21;
            for (UIView *btn in weakSelf.goodListView.subviews){
                [btn removeFromSuperview];
            }
            
            CGFloat x = 0;
            for (int i = 0; i<weakSelf.goodImages.count; i++) {
                UIButton *head = [[UIButton alloc] init];
                head.frame = CGRectMake(x, 0, width, width);
                head.clipsToBounds = YES;
                head.layer.cornerRadius = width/2;
                [head sd_setBackgroundImageWithURL:[NSURL URLWithString:self.goodImages[i][@"imageurl"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
                head.titleLabel.text = weakSelf.goodImages[i][@"userid"];
                head.userInteractionEnabled = YES;
                [head addTarget:weakSelf action:@selector(clickGoodMan:) forControlEvents:UIControlEventTouchUpInside];
                [weakSelf.goodListView addSubview:head];
                x+=margin+width;
            }
            if (weakSelf.goodImages.count>0) {
                //更多按钮
                UIButton *moreBtn = [[UIButton alloc] init];
                moreBtn.frame = CGRectMake(x, 0, width, width);
                [moreBtn setBackgroundImage:[UIImage imageNamed:@"Discover_chengyuan_more"] forState:UIControlStateNormal];
                [weakSelf.goodListView addSubview:moreBtn];
                [moreBtn addTarget:weakSelf action:@selector(goToGoodList) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
//    if (!self.tap) {
//        self.table.userInteractionEnabled = YES;
//        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRActive:)];
//        [self.table addGestureRecognizer:self.tap];
////        [self tapGRActive:nil];
//    }
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{

    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

-(void)tapGRActive:(UITapGestureRecognizer *)tapGR
{
    if (_tool.myTextView.text.length<1) {
        _tool.myTextView.placeholder = @"";
        self.bycommentid = self.activityid;
    }
    if (_tool.faceboardIsShow) {
        [_tool disFaceKeyboard];
    }
    [self.view endEditing:YES];
    
}

#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (!self.isCommiting) {
        [self commitPingLun];
        self.isCommiting = YES;
    }
    
    return YES;
}

#pragma mark - 发表评论
-(void)sendDidClick{
    [self commitPingLun];
}

-(void)commitPingLun{
    
    if (_tool.myTextView.text.length<1) {
        [self showAlertMsg:@"不能发布空评论" yOffset:0];
        return;
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.activityid forKey:@"activityid"];
    
    [dictionary setObject:_tool.myTextView.text forKey:@"content"];//回复内容
    
    NSLog(@"self.bycommentid:%@",self.bycommentid);
    NSLog(@"self.activityid:%@",self.activityid);
    
    //对活动评论
    if ([self.bycommentid isEqualToString:self.activityid]) {
        [dictionary setObject:@"1" forKey:@"commentlevel"];//回复级别
    } else {
        [dictionary setObject:@"2" forKey:@"commentlevel"];//回复级别
    }
    
    [dictionary setObject:self.bycommentid forKey:@"bycommentid"];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,@"/ineract/pubactcom.do"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        self.isCommiting = NO;
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            if ([dic[@"result"] isEqualToString:@"0"]) {//成功
                
                [weakSelf.view endEditing:YES];
                
                [weakSelf showAlertMsg:@"评论成功" andFrame:CGRectZero];
                weakSelf.bycommentid = weakSelf.activityid;
                weakSelf.tool.myTextView.placeholder = @"";
                _tool.myTextView.text = nil;
                
                // 2、刷新表格
                [weakSelf requestWithActCommentsIsLoadMore:NO];
                
            }else{//失败
                [weakSelf showAlertMsg:@"评论失败" yOffset:0];
            }
        }
    }];
}

#pragma mark Getters And Setters

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


@end













