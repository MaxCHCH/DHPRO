//
//  GroupSendMsgListViewController.m
//  zhidoushi
//
//  Created by nick on 15/10/12.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupSendMsgListViewController.h"
#import "GroupMsgListTableViewCell.h"

@interface GroupSendMsgListViewController ()
@property(nonatomic,strong)UITableView* DisCoverTable;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@end

@implementation GroupSendMsgListViewController

#pragma mark Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"团组通知历史消息页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"团组通知历史消息页面"];
    //导航栏标题
    self.titleLabel.text = @"历史消息";
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
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    //初始化UI
    [self setupGUI];
    
    //刷新数据
    [self.header beginRefreshing];
}

#pragma mark - 初始化UI
-(void)setupGUI{
    
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_MIDDLE(160), 200, 160, 45)];
    [self.view addSubview:lbl];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    lbl.text = @"团长大人还没有发布过群发通知哦~";
    lbl.font = MyFont(16);
    
    
    UITableView *tableView = [[UITableView alloc] init];
    self.DisCoverTable = tableView;
    tableView.scrollsToTop = YES;
    tableView.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-16);
    [self.view addSubview:tableView];
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    WEAKSELF_SS
    self.header = header;
    header.scrollView = tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self refreshData];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadData];
    };
}

-(void)dealloc{
    [self.header free];
    [self.footer free];
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *TableSampleIdentifier = @"groupmsgListid";
    
    GroupMsgListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                         TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"GroupMsgListTableViewCell" owner:self options:nil]lastObject];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSUInteger row = [indexPath row];
    searchCell.time = [self.data objectAtIndex:row][@"createtime"];
    searchCell.msg = [self.data objectAtIndex:row][@"content"];
    return searchCell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WWTolls heightForString:[self.data objectAtIndex:indexPath.row][@"content"] fontSize:14 andWidth:SCREEN_WIDTH-30]+62;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark Event Responses

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

#pragma mark - 刷新数据
-(void)refreshData{
    
    [self requestWithActPartersIsLoadMore:NO];
}

#pragma mark - 加载更多
-(void)loadData{
    
    [self requestWithActPartersIsLoadMore:YES];
}

#pragma mark - Request

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
    [dictionary setObject:self.groupId forKey:@"gameid"];
    [dictionary setObject:@"1" forKey:@"loadtype"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    
    if (loadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
        [dictionary setObject:self.lastId forKey:@"lastid"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    
    //发送请求即将开团
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_MESSAGE_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (loadMore) {
                weakSelf.timePageNum++;
            } else {
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            
            NSArray *parterList = dic[@"massmsglist"];
            
            for (NSDictionary *dict in parterList) {
                [weakSelf.data addObject:dict];
                weakSelf.lastId = dict[@"massmsgid"];
            }
            if (weakSelf.data.count == 0) {
                weakSelf.DisCoverTable.hidden = YES;
            }
            [weakSelf.DisCoverTable reloadData];
        }
        
        if (loadMore) {
            [weakSelf.footer endRefreshing];
        } else {
            [weakSelf.header endRefreshing];
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

@end
