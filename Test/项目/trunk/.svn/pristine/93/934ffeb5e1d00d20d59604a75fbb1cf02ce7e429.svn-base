//
//  MessageViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "NewFriendsViewController.h"
#import "ChatViewController.h"
#import "InformationModel.h"
#import "InformationGoodTableViewCell.h"
#import "InformationTableViewCell.h"
#import "XTabBar.h"

#import "GroupTalkDetailViewController.h"
#import "DiscoverDetailViewController.h"
#import "GroupViewController.h"
#import "MeViewController.h"
#import "ZDSActDetailViewController.h"
#import "ChatListViewController.h"
#import "commentViewController.h"
#import "WebViewController.h"
#import "MessageGroupTableViewCell.h"
#import "MessageInformTableViewCell.h"
#import "MessagePersonalTableViewCell.h"
#import "MessageWeekTableViewCell.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

//新粉丝数量
@property(nonatomic,copy)NSString *newfunsCount;//新粉丝数量
//私信
@property(nonatomic,strong)UITableView *messageTable;//私信视图
@property(nonatomic,strong)NSMutableArray* Messagedata;//数据
@property(nonatomic,strong)MJRefreshHeaderView *Messageheader;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *Messagefooter;//底部刷新
@property(nonatomic,assign)int MessagePageNum;//当前页数
//通知
@property(nonatomic,strong)UITableView *infomTable;//通知视图
@property(nonatomic,strong)NSMutableArray* informdata;//数据
@property(nonatomic,strong)MJRefreshHeaderView *informheader;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *informfooter;//底部刷新
@property(nonatomic,assign)int informPageNum;//当前页数

@property(nonatomic,strong)UIButton *red;//红点

@property(nonatomic,assign)BOOL hasInformation;//有新通知

@property(nonatomic,copy)NSString *messagelastid;//私信最后一条

@end

@implementation MessageViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"动静页面"];
    [[XTabBar shareXTabBar] imageState];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"动静页面"];
    if (self.navigationController.tabBarController.selectedIndex != 2) {
        [MobClick event:@"MESSAGE"];
        [WWTolls zdsClick:@"djnum"];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //导航栏标题
    self.titleLabel.text = @"动静";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);

//    self.navigationController.tabBarController.tabBar.hidden = NO;
//    self.tabBarController.tabBar.hidden = NO;
    if([[NSUSER_Defaults objectForKey:@"groupinform"] isEqualToString:@"YES"]){
        [self.informheader beginRefreshing];
        [self loadInformWithIsMore:NO];
        [NSUSER_Defaults removeObjectForKey:@"groupinform"];
    }
    [self.infomTable reloadData];
    [NSUSER_Defaults setObject:@"NO" forKey:@"tabbarreddian"];
    [NSUSER_Defaults synchronize];
    [[XTabBar shareXTabBar] imageState];
    
    self.infomTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasInformation = NO;
    [self setUpGUI];
    [self readCoche];
//    [self.Messageheader beginRefreshing];
    [self.informheader beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
}

- (void)notifyHiden{
    self.infomTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
}


- (void)readCoche{
    NSDictionary *dic = [NSUSER_Defaults objectForKey:MESSAGE_COACHE_LIST];    
    if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
    }else{
        self.informPageNum=1;
        NSArray *tempArray = dic[@"noticelist"];
        for (NSDictionary *dic in tempArray) {
            [self.informdata addObject:[InformationModel modelWithDic:dic]];
            self.lastId = dic[@"noticeid"];
        }
        [self.infomTable reloadData];
    }
}




#pragma mark - 初始化UI
-(void)setUpGUI{
    self.newfunsCount = @"0";
    self.view.backgroundColor = ZDS_BACK_COLOR;
    CGFloat H = SCREEN_HEIGHT - 64;
    //通知视图
    UITableView *informTable = [[UITableView alloc] init];
    self.infomTable = informTable;
    informTable.separatorColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [self.view addSubview:informTable];
    informTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, H);
    informTable.backgroundColor = ZDS_BACK_COLOR;
    informTable.delegate = self;
    informTable.dataSource = self;
    informTable.scrollsToTop = YES;
    //隐藏多余分割线
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [informTable setTableHeaderView:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 0.5)];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [view addSubview:line];
    [informTable setTableFooterView:view];
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.informheader = header;
    header.scrollView = informTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadInformWithIsMore:NO];
    };
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.informfooter = footer;
    footer.scrollView = informTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadInformWithIsMore:YES];
    };
    
    //初始化数据
    self.informdata = [NSMutableArray array];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewMessage) name:@"newmessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewInformation) name:@"newinformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewInformation) name:@"newNotification" object:nil];
}

-(void)recieveNewInformation{
    if (self.tabBarController.selectedIndex!=2) {
        [[XTabBar shareXTabBar] imageState];
    }
    [self.infomTable reloadData];
    self.hasInformation = YES;
}

-(void)recieveNewMessage{
    [self.infomTable reloadData];
}

#pragma mark - 加载数据
-(void)loadInformWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.informdata.count%10!=0||self.informdata.count<self.informPageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.informfooter endRefreshing];
            return;
        }
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.informPageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    __weak typeof(self)weakSelf = self;
    if (self.httpOpt && !self.httpOpt.isFinished) {
        if (isMore) {
            [self.informfooter endRefreshing];
        }else{
            [self.informheader endRefreshing];
        }
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_INFORMATION_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.informPageNum++;
            }else{
                [NSUSER_Defaults setObject:dic forKey:MESSAGE_COACHE_LIST];
                [NSUSER_Defaults setObject:@"0" forKey:@"newmsgid"];
                [NSUSER_Defaults synchronize];
                [[XTabBar shareXTabBar] imageState];
                weakSelf.informPageNum = 1;
                [weakSelf.informdata removeAllObjects];
            }
            NSArray *tempArray = dic[@"noticelist"];
            for (NSDictionary *dic in tempArray) {
//                InformationModel *model = [[InformationModel alloc] init];
//                model.noticetype = @"9";
//                model.message = @"asdkfjaldfjlaksdjflaskdjfalsdkfjalsdkjfaldsf";
//                model.content = @"http://www.baidu.com";
//                [weakSelf.informdata addObject:model]
                [weakSelf.informdata addObject:[InformationModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"noticeid"];
            }
            [weakSelf.infomTable reloadData];
        }
        if (isMore) {
            [weakSelf.informfooter endRefreshing];
        }else{
            [weakSelf.informheader endRefreshing];
        }
    }];
}


#pragma mark - tableView dataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.messageTable) {
        return self.Messagedata.count;
    }else if(tableView == self.infomTable){
        if (self.informdata.count == 0) {
            self.infomTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        }else{
            self.infomTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        return self.informdata.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.messageTable) {
        return 70;
    }else{
        
        InformationModel *model = self.informdata[indexPath.row];
        CGFloat widthNOimage = SCREEN_WIDTH-67;
        CGFloat widthHaveImage = SCREEN_WIDTH - 136;
        if ([model.noticetype isEqualToString:@"2"]) {//新任务
            return 136;
        }else if ([model.noticetype isEqualToString:@"3"]) {//团组邀请
            CGFloat h = [WWTolls heightForString:model.content fontSize:17 andWidth:SCREEN_WIDTH-30];
            return 174 + h;
        }else if ([model.noticetype isEqualToString:@"8"]){//广播
            CGFloat h = [WWTolls heightForString:model.content fontSize:15 andWidth:SCREEN_WIDTH-60];
            return h + 63;
        }else if ([model.noticetype isEqualToString:@"9"]){//周记，唤醒
            return 217;
        }
        if ([model.noticetype isEqualToString:@"2"] || [model.noticetype isEqualToString:@"8"]) {//团组通知
            CGFloat h;
            if(model.message.length>0) h = [WWTolls heightForString:model.content fontSize:14 andWidth:SCREEN_WIDTH-77] + [WWTolls heightForString:model.message fontSize:15 andWidth:SCREEN_WIDTH-77] + 10;
            else h = [WWTolls heightForString:model.content fontSize:15 andWidth:SCREEN_WIDTH-77];
            return h+58;
        }else if ([model.noticetype isEqualToString:@"9"]) {//
            CGFloat h;
            h = [WWTolls heightForString:model.message fontSize:15 andWidth:SCREEN_WIDTH-77];
            return h+58;
        }else if([model.noticetype isEqualToString:@"0"]){//回复
            CGFloat h = [WWTolls heightForString:[NSString stringWithFormat:@"回复：%@",model.content] fontSize:14 andWidth:widthHaveImage];
            return h+71;
        }else if([model.noticetype isEqualToString:@"3"]){//邀请
            NSString *s = [NSString stringWithFormat:@"%@",model.content];
            CGFloat h = [WWTolls heightForString:s fontSize:14 andWidth:widthNOimage];
            return 75+h;
        }else if([model.noticetype isEqualToString:@"4"]){//展示评论
            CGFloat h = [WWTolls heightForString:[NSString stringWithFormat:@"回复：%@",model.content] fontSize:14 andWidth:widthHaveImage];
            return h+71;
        }else if([model.noticetype isEqualToString:@"5"]){//打招呼
            CGFloat h = [WWTolls heightForString:@"捏了一下你的小肉肉" fontSize:14 andWidth:widthNOimage];
            return h+90;
        }else if([model.noticetype isEqualToString:@"6"]){//活动回复
            CGFloat h = [WWTolls heightForString:[NSString stringWithFormat:@"回复：%@",model.content] fontSize:14 andWidth:widthHaveImage];
            return h+71;
        }else if([model.noticetype isEqualToString:@"7"]){//加入活动
            return 85;
        }
        return 84;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        InformationModel *model = self.informdata[indexPath.row];
    if ([model.noticetype isEqualToString:@"2"]) {//新任务
        MessageGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageGroup"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageGroupTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        
        return cell;
        
    }else if ([model.noticetype isEqualToString:@"3"]) {//团组邀请
        MessagePersonalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagePersonal"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MessagePersonalTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        
        
        return cell;
    }else if ([model.noticetype isEqualToString:@"8"]){//广播
        MessageInformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessagePersonal"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageInformTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        return cell;
    }else if ([model.noticetype isEqualToString:@"9"]){//周记，唤醒
        MessageWeekTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Messageweek"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageWeekTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        return cell;
    }
        if ([model.noticetype isEqualToString:@"2"] || [model.noticetype isEqualToString:@"8"] || [model.noticetype isEqualToString:@"9"]) {//0回复1赞2通知3邀请4评论
            InformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCELL"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"InformationTableViewCell" owner:self options:nil]lastObject];
            }
            cell.model = model;
            return cell;
        }else{
            InformationGoodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationGoodCELL"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"InformationGoodTableViewCell" owner:self options:nil]lastObject];
            }
            cell.model = model;
            return cell;
        }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.messageTable){
        NSDictionary *dic = self.Messagedata[indexPath.row];
        ChatViewController *chat = [[ChatViewController alloc] init];
        chat.userId = dic[@"rcvuserid"];
        chat.title = dic[@"username"];
        chat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chat animated:YES];
    }else if(tableView == self.infomTable){
        InformationModel *model = self.informdata[indexPath.row];
        if([model.status isEqualToString:@"1"]){//无效
            [self showAlertMsg:@"该信息已删除╮(╯▽╰)╭" yOffset:0];
        }else{
            if ([model.noticetype isEqualToString:@"0"]) {//回复
                GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
                reply.talkid = model.talkid;
                reply.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:reply animated:YES];
            }else if ([model.noticetype isEqualToString:@"1"]) {//赞
                if ([model.praisetype isEqualToString:@"0"]) {//人
                    MeViewController *me = [[MeViewController alloc] init];
                    me.otherOrMe = 1;
                    me.userID = model.receiveid;
                    me.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:me animated:YES];
                }else if ([model.praisetype isEqualToString:@"1"]) {//团组
                    GroupViewController *group = [[GroupViewController alloc] init];
                    group.clickevent = 9;
                    group.joinClickevent = @"9";
                    group.groupId = model.receiveid;
                    group.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:group animated:YES];
                }else if ([model.praisetype isEqualToString:@"2"]) {//团聊天
                    GroupTalkDetailViewController *reply = [[GroupTalkDetailViewController alloc] init];
                    reply.talkid = model.receiveid;
                    reply.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:reply animated:YES];
                }else if ([model.praisetype isEqualToString:@"3"]) {//展示
                    DiscoverDetailViewController *dis = [[DiscoverDetailViewController alloc] init];
                    dis.discoverId = model.receiveid;
                    dis.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:dis animated:YES];
                }
            }else if ([model.noticetype isEqualToString:@"2"]) {//通知
                if([model.msgkind isEqualToString:@"17"]){//群组群发通知
                    ChatViewController *chat = [[ChatViewController alloc] init];
                    chat.title = model.username;
                    chat.userId = model.userid;
                    chat.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:chat animated:YES];
                }else if([model.msgkind isEqualToString:@"18"]||[model.msgkind isEqualToString:@"20"]||[model.msgkind isEqualToString:@"21"]){//群组解散通知
                    [self.tabBarController setSelectedIndex:0];
                }else if([model.msgkind isEqualToString:@"19"]){
                
                }else{
                    GroupViewController *group = [[GroupViewController alloc] init];
                    group.clickevent = 9;
                    group.joinClickevent = @"9";
                    group.groupId = model.gameid;
                    group.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:group animated:YES];
                }
            }else if ([model.noticetype isEqualToString:@"3"]) {//邀请
                GroupViewController *group = [[GroupViewController alloc] init];
                group.joinClickevent = @"9";
                group.clickevent = 9;
                group.groupId = model.gameid;
                group.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:group animated:YES];
            }else if ([model.noticetype isEqualToString:@"4"]) {//展示评论
                DiscoverDetailViewController *dis = [[DiscoverDetailViewController alloc] init];
                dis.discoverId = model.showid;
                dis.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:dis animated:YES];
            }else if([model.noticetype isEqualToString:@"5"]){//打招呼
                MeViewController *me = [[MeViewController alloc] init];
                me.otherOrMe = 1;
                me.userID = model.snduserid;
                me.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:me animated:YES];
            }else if([model.noticetype isEqualToString:@"6"]){//活动回复
                ZDSActDetailViewController *me = [[ZDSActDetailViewController alloc] init];
                me.activityid = model.activityid;
                me.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:me animated:YES];
            }else if([model.noticetype isEqualToString:@"7"]){//加入活动回复
                ZDSActDetailViewController *me = [[ZDSActDetailViewController alloc] init];
                me.activityid = model.activityid;
                me.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:me animated:YES];
            }else if ([model.noticetype isEqualToString:@"8"] && model.linkurl.length>0) {//广播
                WebViewController *web = [[WebViewController alloc] init];
                web.URL = model.linkurl;
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }else if ([model.noticetype isEqualToString:@"9"] && model.content.length>0) {//周记
                WebViewController *web = [[WebViewController alloc] init];
                web.URL = model.content;
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
        }
    }
}

#pragma mark - 通知headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.infomTable) {
        
        //通知头部视图
        UIView *headView = [[UIView alloc] init];
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
        headView.backgroundColor = ZDS_BACK_COLOR;
        //背景
        CGFloat h = 15;
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 9.5, SCREEN_WIDTH, 0.5)];
//        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
//        [headView addSubview:line];
        UIButton *back = [[UIButton alloc] init];
//        back.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//        back.layer.borderWidth = 0.5;
        [back setShowsTouchWhenHighlighted:YES];
        CGSize imageSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
        //高亮图片
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[WWTolls colorWithHexString:@"#efefef"] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //正常图片
        UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
        [[UIColor whiteColor] set];
        UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
        UIImage *colorimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [back setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
        [back setBackgroundImage:colorimage forState:UIControlStateNormal];
        back.frame = CGRectMake(0, h, SCREEN_WIDTH, 50);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(50, 49, SCREEN_WIDTH-50, 1)];
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [back addSubview:line];
        if (![[NSUSER_Defaults objectForKey:@"flwsum"] isKindOfClass:[NSDictionary class]]) {
            [NSUSER_Defaults setObject:[NSDictionary dictionary] forKey:@"flwsum"];
        }
        if (([NSUSER_Defaults objectForKey:@"flwsum"] != nil && ((NSDictionary*)[NSUSER_Defaults objectForKey:@"flwsum"]).count > 0 )|| [[NSUSER_Defaults objectForKey:@"quleqitayemian"] isEqualToString:@"NO"]) {
            h+=50;
            [headView addSubview:back];
        }
        
        //新粉丝图标
        UIImageView *imag = [[UIImageView alloc] init];
        imag.frame = CGRectMake(15, 15, 19, 19);
        imag.image = [UIImage imageNamed:@"xfs-36"];
        [back addSubview:imag];
        //新粉丝文字
        UILabel *lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(50, 15, 120, 16);
        lbl.text = @"新粉丝";
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        lbl.font = MyFont(16);
        [back addSubview:lbl];
        //新粉丝数量
        UILabel *btnSum = [[UILabel alloc] init];
        NSString *title;
        int sum;
        NSDictionary *newFunsDic = [NSUSER_Defaults objectForKey:@"flwsum"];
        sum = newFunsDic.allKeys.count;
        title = sum==1?@" ":sum>99?@"99+":[NSString stringWithFormat:@"%d",sum];
//        [btnSum setTitle:title forState:UIControlStateNormal];
        btnSum.text = title;
        btnSum.textColor = [UIColor whiteColor];
        btnSum.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        btnSum.textAlignment = NSTextAlignmentCenter;
        if(sum == 1) btnSum.frame = CGRectMake(SCREEN_WIDTH-43, 20, 10, 10);
        else if(sum<10&&sum>1) btnSum.frame = CGRectMake(SCREEN_WIDTH-45, 18, 15, 15);
        else if(sum > 99) btnSum.frame = CGRectMake(SCREEN_WIDTH-59, 18, 29, 15);
        else btnSum.frame = CGRectMake(SCREEN_WIDTH-50, 18, 20, 15);
//        [btnSum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSum.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
//        btnSum.titleLabel.font = MyFont(11);
//        btnSum.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnSum.layer.cornerRadius = 7.5;
        if(sum == 1) btnSum.layer.cornerRadius = 5;
        btnSum.clipsToBounds = YES;
        btnSum.userInteractionEnabled = NO;
        if(sum>0) [back addSubview:btnSum];
        
        //右边箭头
        UIImageView *row = [[UIImageView alloc] init];
        row.frame = CGRectMake(SCREEN_WIDTH-25, 20, 10, 10);
        row.image = [UIImage imageNamed:@"home_more_26_26"];
        [back addSubview:row];
        [back addTarget:self action:@selector(gotoNewFuns) forControlEvents:UIControlEventTouchUpInside];
        
        //评论
        back = [[UIButton alloc] init];
        line = [[UIView alloc] initWithFrame:CGRectMake(50, 49, SCREEN_WIDTH-50, 1)];
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [back addSubview:line];
        [back setShowsTouchWhenHighlighted:YES];
        [back setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
        [back setBackgroundImage:colorimage forState:UIControlStateNormal];
        back.frame = CGRectMake(0, h, SCREEN_WIDTH, 50);
        h+=50;
        [headView addSubview:back];
        //评论图标
        imag = [[UIImageView alloc] init];
        imag.frame = CGRectMake(15, 15, 19, 19);
        imag.image = [UIImage imageNamed:@"message-pl-36"];
        [back addSubview:imag];
        //评论文字
        lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(50, 15, 120, 18);
        lbl.text = @"评论";
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        lbl.font = MyFont(16);
        [back addSubview:lbl];
        //评论数量
        btnSum = [[UILabel alloc] init];
        sum = [NSString stringWithFormat:@"%@",[NSUSER_Defaults objectForKey:@"inform"]].intValue;
        title = sum==1?@" ":sum>99?@"99+":[NSString stringWithFormat:@"%d",sum];
        btnSum.text = title;
        btnSum.textColor = [UIColor whiteColor];
        btnSum.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        btnSum.textAlignment = NSTextAlignmentCenter;        btnSum.frame = CGRectMake(SCREEN_WIDTH-50, 25, 15, 15);
        if(sum == 1) btnSum.frame = CGRectMake(SCREEN_WIDTH-43, 20, 10, 10);
        else if(sum<10&&sum>1) btnSum.frame = CGRectMake(SCREEN_WIDTH-45, 18, 15, 15);
        else if(sum > 99) btnSum.frame = CGRectMake(SCREEN_WIDTH-59, 18, 29, 15);
        else btnSum.frame = CGRectMake(SCREEN_WIDTH-50, 18, 20, 15);
//        [btnSum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSum.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
//        btnSum.titleLabel.font = MyFont(11);
//        btnSum.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnSum.layer.cornerRadius = 7.5;
        if(sum == 1) btnSum.layer.cornerRadius = 5;
        btnSum.clipsToBounds = YES;
        btnSum.userInteractionEnabled = NO;
        if([NSUSER_Defaults objectForKey:@"inform"] != nil && ![[NSUSER_Defaults objectForKey:@"inform"] isEqualToString:@"0"])
            [back addSubview:btnSum];
        
        //右边箭头
        row = [[UIImageView alloc] init];
        row.frame = CGRectMake(SCREEN_WIDTH-25, 20, 10, 10);
        row.image = [UIImage imageNamed:@"home_more_26_26"];
        [back addSubview:row];
        [back addTarget:self action:@selector(gotoComment) forControlEvents:UIControlEventTouchUpInside];
        
        
        //私信
        back = [[UIButton alloc] init];
//        back.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//        back.layer.borderWidth = 0.5;
//        [back setShowsTouchWhenHighlighted:YES];
//        [back setBackgroundImage:pressedColorImg forState:UIControlStateReserved];
        [back setBackgroundImage:pressedColorImg forState:UIControlStateHighlighted];
        [back setBackgroundImage:colorimage forState:UIControlStateNormal];
//        back.backgroundColor = [UIColor whiteColor];
        back.frame = CGRectMake(0, h, SCREEN_WIDTH, 50);
        h+=50;
        [headView addSubview:back];
        //私信图标
        imag = [[UIImageView alloc] init];
        imag.frame = CGRectMake(15, 15, 19, 19);
        imag.image = [UIImage imageNamed:@"sx-36"];
        [back addSubview:imag];
        //私信文字
        lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(50, 15, 120, 18);
        lbl.text = @"私信";
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        lbl.font = MyFont(16);
        [back addSubview:lbl];
        //私信数量
        NSDictionary *dic = [NSUSER_Defaults objectForKey:@"newMessage"];
        int count = 0;
        for (NSString *value in dic.allValues) {
            count += value.integerValue;
        }
        title = count==1?@" ":count>99?@"99+":[NSString stringWithFormat:@"%d",count];
        btnSum = [[UILabel alloc] init];
        btnSum.text = title;
        btnSum.textColor = [UIColor whiteColor];
        btnSum.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        btnSum.textAlignment = NSTextAlignmentCenter;
        if(count == 1) btnSum.frame = CGRectMake(SCREEN_WIDTH-43, 20, 10, 10);
        else if(count<10&&count>1) btnSum.frame = CGRectMake(SCREEN_WIDTH-45, 18, 15, 15);
        else if(count > 99) btnSum.frame = CGRectMake(SCREEN_WIDTH-59, 18, 29, 15);
        else btnSum.frame = CGRectMake(SCREEN_WIDTH-50, 18, 20, 15);
//        [btnSum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSum.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
//        btnSum.titleLabel.font = MyFont(11);
//        btnSum.titleLabel.textAlignment = NSTextAlignmentCenter;
        btnSum.layer.cornerRadius = 7.5;
        if(count == 1) btnSum.layer.cornerRadius = 5;
        btnSum.clipsToBounds = YES;
        btnSum.userInteractionEnabled = NO;
        if(count && [[NSUSER_Defaults objectForKey:@"messagechatred"] isEqualToString:@"YES"])
            [back addSubview:btnSum];
        //右边箭头
        row = [[UIImageView alloc] init];
        row.frame = CGRectMake(SCREEN_WIDTH-25, 20, 10, 10);
        row.image = [UIImage imageNamed:@"home_more_26_26"];
        [back addSubview:row];
        [back addTarget:self action:@selector(gotoNewMessage) forControlEvents:UIControlEventTouchUpInside];
        
        //通知头部
        UILabel *informTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, h, 150, 47)];
        informTitle.font = MyFont(17);
        informTitle.textColor = OrangeColor;
        informTitle.text = @"通知";
        [headView addSubview:informTitle];
        h += 47;
        
        headView.height = h;
        self.infomTable.tableHeaderView = headView;
        return [[UIView alloc] init];
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.infomTable) {
        return 0.1;
    }
    return 0;
}

#pragma mark - 去往新粉丝页面
-(void)gotoNewFuns{
    NewFriendsViewController *funs = [[NewFriendsViewController alloc] init];
    funs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:funs animated:YES];
}
#pragma mark - 去往评论页面
-(void)gotoComment{
    commentViewController *funs = [[commentViewController alloc] init];
    funs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:funs animated:YES];
}

#pragma mark - 去往私信页面
-(void)gotoNewMessage{
    ChatListViewController *funs = [[ChatListViewController alloc] init];
    funs.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:funs animated:YES];
}

#pragma mark - 释放资源
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.Messageheader free];
    [self.Messagefooter free];
    [self.informfooter free];
    [self.informheader free];
}

@end
