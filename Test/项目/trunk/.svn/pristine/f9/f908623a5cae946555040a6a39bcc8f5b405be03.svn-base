//
//  ChatListViewController.m
//  zhidoushi
//
//  Created by nick on 15/7/17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ChatListViewController.h"
#import "MessageTableViewCell.h"
#import "ChatViewController.h"
@interface ChatListViewController()<UITableViewDelegate,UITableViewDataSource>
//私信
@property(nonatomic,strong)UITableView *messageTable;//私信视图
@property(nonatomic,strong)NSMutableArray* Messagedata;//数据
@property(nonatomic,strong)MJRefreshHeaderView *Messageheader;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *Messagefooter;//底部刷新
@property(nonatomic,assign)int MessagePageNum;//当前页数
@property(nonatomic,copy)NSString *messagelastid;//私信最后一条
@end
@implementation ChatListViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"私信页面"];
    [self.httpOpt cancel];
    [NSUSER_Defaults setObject:@"NO" forKey:@"messagechatred"];
    [NSUSER_Defaults synchronize];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"私信页面"];
    //导航栏标题
    self.titleLabel.text = @"私信";
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
    [self.messageTable reloadData];
    [self loadMessageWithIsMore:NO];
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpGUI];
    [self.Messageheader beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
}
- (void)notifyHiden{
    self.messageTable.height = SCREEN_HEIGHT - 64;
}

#pragma mark - 初始化UI
-(void)setUpGUI{

    
    CGFloat H = SCREEN_HEIGHT - 64;
    //私信视图
    UITableView *messageTable = [[UITableView alloc] init];
    self.messageTable = messageTable;
    [self.view addSubview:messageTable];
    messageTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, H);
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    messageTable.backgroundColor = [UIColor whiteColor];
    messageTable.separatorColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    messageTable.delegate = self;
    messageTable.dataSource = self;
    messageTable.scrollsToTop = YES;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//        headerView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//        headerView.layer.borderWidth = 0.5;

    messageTable.tableHeaderView = headerView;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    messageTable.tableFooterView = footView;
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
    
    //初始化数据
    self.Messagedata = [NSMutableArray array];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewMessage) name:@"newmessage" object:nil];
    //读取缓存
    NSDictionary *dic = [NSUSER_Defaults objectForKey:@"cacheChatList"];
    NSArray *tempArray = dic[@"letterlist"];
    for (NSDictionary *dic in tempArray) {
        [self.Messagedata addObject:dic];
        self.messagelastid = dic[@"rcvuserid"];
    }
    [self.messageTable reloadData];
}

-(void)recieveNewMessage{
    [self loadMessageWithIsMore:NO];
}
#pragma mark - 加载更多
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
    if(isMore && self.messagelastid!=nil) [dictionary setObject:self.messagelastid forKey:@"lastid"];
    if (self.httpOpt && !self.httpOpt.finished) {
        if (isMore) {
            [self.Messagefooter endRefreshing];
        }else{
            [self.Messageheader endRefreshing];
        }
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_MESSAGE_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.MessagePageNum++;
            }else{
                weakSelf.MessagePageNum = 1;
                [weakSelf.Messagedata removeAllObjects];
                [NSUSER_Defaults setObject:dic forKey:@"cacheChatList"];
            }
            NSArray *tempArray = dic[@"letterlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.Messagedata addObject:dic];
                weakSelf.messagelastid = dic[@"rcvuserid"];
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{        return self.Messagedata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{        return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MESSAGECELL"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MessageTableViewCell" owner:self options:nil]lastObject];
    }
    [cell.headerImage sd_setImageWithURL:[NSURL URLWithString:self.Messagedata[indexPath.row][@"imageurl"]] placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    cell.name.text =self.Messagedata[indexPath.row][@"username"];
    cell.message.text = self.Messagedata[indexPath.row][@"content"];
    cell.time.text = [WWTolls date:self.Messagedata[indexPath.row][@"createtime"]];
    if (((NSDictionary*)[NSUSER_Defaults objectForKey:@"newMessage"]).count>0) {
        if(((NSDictionary*)[NSUSER_Defaults objectForKey:@"newMessage"])[self.Messagedata[indexPath.row][@"rcvuserid"]]!=nil&&![((NSDictionary*)[NSUSER_Defaults objectForKey:@"newMessage"])[self.Messagedata[indexPath.row][@"rcvuserid"]] isEqualToString:@"0"]){
            int count =[NSString stringWithFormat:@"%@",((NSDictionary*)[NSUSER_Defaults objectForKey:@"newMessage"])[self.Messagedata[indexPath.row][@"rcvuserid"]]].intValue;
            if(count == 1){
                cell.redWidth.constant = 10;
                cell.redHeight.constant = 10;
            }
            else if(count > 99){
                cell.redWidth.constant = 29;
                cell.redHeight.constant = 15;
            }else if(count <10){
                cell.redWidth.constant = 15;
                cell.redHeight.constant = 15;
            }
            else{
                cell.redWidth.constant = 20;
                cell.redHeight.constant = 15;
            }
            [cell.redDian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.redDian.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
            cell.redDian.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
            cell.redDian.titleLabel.textAlignment = NSTextAlignmentCenter;
            cell.redDian.layer.cornerRadius = 7.5;
            if(count == 1) cell.redDian.layer.cornerRadius = 5;
            NSString *titlesum = count==1?@" ":count>99?@"99+":[NSString stringWithFormat:@"%d",count];
            [cell.redDian setTitle:titlesum forState:UIControlStateNormal];
            cell.redDian.hidden = NO;
        }else{
            cell.redDian.hidden = YES;
        }
    }else{
        cell.redDian.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.Messagedata[indexPath.row];
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.userId = dic[@"rcvuserid"];
    chat.title = dic[@"username"];
    [self.navigationController pushViewController:chat animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

#pragma mark 收到新朋友
-(void)receiveNewFriendsMessage
{
    [self loadMessageWithIsMore:NO];
}

#pragma mark 通知
-(void)apnsNotification
{
    
}

#pragma mark - 释放资源
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.Messageheader free];
    [self.Messagefooter free];
}

@end
