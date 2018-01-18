//
//  commentViewController.m
//  zhidoushi
//
//  Created by nick on 15/7/20.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "commentViewController.h"
#import "GroupTalkDetailViewController.h"
#import "DiscoverDetailViewController.h"
#import "CommentModel.h"
#import "CommentOneReplyTableViewCell.h"
#import "CommentTwoReplyTableViewCell.h"
@interface commentViewController()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *messageTable;//评论视图
@property(nonatomic,strong)NSMutableArray* Messagedata;//数据
@property(nonatomic,strong)MJRefreshHeaderView *Messageheader;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *Messagefooter;//底部刷新
@property(nonatomic,assign)int MessagePageNum;//当前页数
@end
@implementation commentViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"评论页面"];
    [self.httpOpt cancel];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"评论页面"];
    //导航栏标题
    self.titleLabel.text = @"评论";
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
    //去除红点
    [NSUSER_Defaults setObject:@"0" forKey:@"inform"];
    [NSUSER_Defaults synchronize];
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
    self.view.backgroundColor = ZDS_BACK_COLOR;
    messageTable.backgroundColor = ZDS_BACK_COLOR;
    messageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    messageTable.delegate = self;
    messageTable.scrollsToTop = YES;
    messageTable.dataSource = self;
    messageTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    //初始化刷新
    //    __weak typeof(self) weakself = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.Messageheader = header;
    header.scrollView = messageTable;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:NO];
    };
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.Messagefooter = footer;
    footer.scrollView = messageTable;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:YES];
    };
    
    //初始化数据
    self.Messagedata = [NSMutableArray array];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNewMessage) name:@"newmessage" object:nil];
}

-(void)recieveNewMessage{
    [self loadDataWithIsMore:NO];
}


#pragma mark - 加载
-(void)loadDataWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.Messagedata.count == 0 ||self.Messagedata.count%10!=0||self.Messagedata.count<self.MessagePageNum*10) {
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
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    if (self.httpOpt && !self.httpOpt.finished) {
        if (isMore) {
            [self.Messagefooter endRefreshing];
        }else{
            [self.Messageheader endRefreshing];
        }
        return;
    }
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_MESSAGE_COMMENT parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.MessagePageNum++;
            }else{
                weakSelf.MessagePageNum = 1;
                [weakSelf.Messagedata removeAllObjects];
            }
            NSArray *tempArray = dic[@"commentlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.Messagedata addObject:[CommentModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"valueid"];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.Messagedata.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.Messagedata[indexPath.row];
    if ([model.valuetype isEqualToString:@"1"]) {//团聊回复
//            model.imageurl = @"http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg";
//            model.byimageurl = @"http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg|http://file.ynet.com/2/1509/25/10407731-500.jpg";
        if([model.kind isEqualToString:@"1"]){//一级评论
            if (model.imageurl && model.imageurl.length > 0) {
                return 280+[WWTolls heightForString:model.content fontSize:13 andWidth:SCREEN_WIDTH-30];
            }
            return 183+[WWTolls heightForString:model.content fontSize:13 andWidth:SCREEN_WIDTH-30];
        }else if([model.kind isEqualToString:@"2"]){//二级评论
            CGFloat h = 194+[WWTolls heightForString:[NSString stringWithFormat:@"回复 %@  %@",model.byusername,model.content] fontSize:13 andWidth:SCREEN_WIDTH-30] + [WWTolls heightForString:[NSString stringWithFormat:@"  %@ 回复 %@  %@",model.byusername,model.username,model.bycontent] fontSize:13 andWidth:SCREEN_WIDTH-30];
            if (model.imageurl && model.imageurl.length > 0) {
                h += 95;
            }
            if (model.byimageurl && model.byimageurl.length > 0) {
                h += 45;
            }
            return h;
        }
    }else if([model.valuetype isEqualToString:@"2"]){//撒欢回复
        if([model.kind isEqualToString:@"1"]){//一级评论
            if (model.imageurl && model.imageurl.length > 0) {
                return 280+[WWTolls heightForString:model.content fontSize:13 andWidth:SCREEN_WIDTH-30];
            }
            return 193+[WWTolls heightForString:model.content fontSize:13 andWidth:SCREEN_WIDTH-30];
        }else if([model.kind isEqualToString:@"2"]){//二级评论
            CGFloat h = 194+[WWTolls heightForString:[NSString stringWithFormat:@"回复 %@  %@",model.byusername,model.content] fontSize:13 andWidth:SCREEN_WIDTH-30] + [WWTolls heightForString:[NSString stringWithFormat:@"  %@ 回复 %@  %@",model.byusername,model.username,model.bycontent] fontSize:13 andWidth:SCREEN_WIDTH-30];
            if (model.imageurl && model.imageurl.length > 0) {
                h += 95;
            }
            if (model.byimageurl && model.byimageurl.length > 0) {
                h += 45;
            }
            return h;
        }
    }else if([model.valuetype isEqualToString:@"3"]){//赞
        return 205;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *model = self.Messagedata[indexPath.row];
    if ([model.valuetype isEqualToString:@"1"]||[model.valuetype isEqualToString:@"2"]) {//回复
        if([model.kind isEqualToString:@"1"]){//一级评论
            CommentOneReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentonecell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentOneReplyTableViewCell" owner:self options:nil]lastObject];
            }
            cell.model = model;
            return cell;
        }else if([model.kind isEqualToString:@"2"]){//二级评论
            CommentTwoReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commenttwocell"];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentTwoReplyTableViewCell" owner:self options:nil]lastObject];
            }
            cell.model = model;
            return cell;
        }
    }else if([model.valuetype isEqualToString:@"3"]){//赞
        CommentOneReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentonecell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentOneReplyTableViewCell" owner:self options:nil]lastObject];
        }
        cell.model = model;
        return cell;

    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.Messagedata[indexPath.row];
    if([model.status isEqualToString:@"1"]){//无效
        [self showAlertMsg:@"该信息已删除╮(╯▽╰)╭" yOffset:0];
    }else{
        if ([model.valuetype isEqualToString:@"1"]) {//团聊回复
            GroupTalkDetailViewController *gt = [[GroupTalkDetailViewController alloc] init];
            gt.talktype = model.title&&model.title.length>0?GroupTitleTalkType:GroupSimpleTalkType;
            
            gt.clickevent = 5;
            gt.talkid = model.parentid;
            [self.navigationController pushViewController:gt animated:YES];
        }else if([model.valuetype isEqualToString:@"2"]){//撒欢回复
            DiscoverDetailViewController *gt = [[DiscoverDetailViewController alloc] init];
            gt.discoverId = model.parentid;
            [self.navigationController pushViewController:gt animated:YES];
        }else if([model.valuetype isEqualToString:@"3"]){//赞
            if([model.kind isEqualToString:@"2"]){//团聊
                GroupTalkDetailViewController *gt = [[GroupTalkDetailViewController alloc] init];
                gt.talkid = model.parentid;
                gt.talktype = model.title&&model.title.length>0?GroupTitleTalkType:GroupSimpleTalkType;
                gt.clickevent = 5;
                [self.navigationController pushViewController:gt animated:YES];
            }else if([model.kind isEqualToString:@"3"]){//撒欢
                DiscoverDetailViewController *gt = [[DiscoverDetailViewController alloc] init];
                gt.discoverId = model.parentid;
                [self.navigationController pushViewController:gt animated:YES];
            }
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}


#pragma mark - 释放资源
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.Messageheader free];
    [self.Messagefooter free];
}

@end
