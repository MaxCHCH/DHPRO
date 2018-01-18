//
//  ZDSUserListViewController.m
//  zhidoushi
//
//  Created by licy on 15/5/27.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSUserListViewController.h"
#import "MeViewController.h"
#import "intrestUserModel.h"
#import "UserListTableViewCell.h"
#import "MJExtension.h"

@interface ZDSUserListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* DisCoverTable;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数

@end

@implementation ZDSUserListViewController

#pragma mark Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"活动列表页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"活动列表页面"];
    //导航栏标题
    self.titleLabel.text = @"活动列表";
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
    
    //读取缓存
    [self readCoache];
    
    //刷新数据
    [self.header beginRefreshing];
}

#pragma mark - 初始化UI
-(void)setupGUI{
    
    UITableView *tableView = [[UITableView alloc] init];
    self.DisCoverTable = tableView;
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
    
    static NSString *TableSampleIdentifier = @"searchermancell";
    
    UserListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                         TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil]lastObject];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSUInteger row = [indexPath row];
    searchCell.model = [self.data objectAtIndex:row];
    searchCell.msgLbl.text = searchCell.model.usersign;
    return searchCell;
}

#pragma mark UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark Event Responses

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods
#pragma mark - 读取缓存
-(void)readCoache{
    
}

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
    [dictionary setObject:self.activityid forKey:@"activityid"];
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
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_Group_Actparters parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (loadMore) {
                weakSelf.timePageNum++;
            } else {
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            
            NSArray *parterList = dic[@"parterList"];
            
            for (NSDictionary *dict in parterList) {
                intrestUserModel *model = [intrestUserModel objectWithKeyValues:dict];
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.userid;
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
