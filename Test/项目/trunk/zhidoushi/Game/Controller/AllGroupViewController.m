//
//  AllGroupViewController.m
//  zhidoushi
//
//  Created by nick on 15/6/15.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "AllGroupViewController.h"
#import "SearchResultTableViewCell.h"
#import "GroupViewController.h"
#import "GroupHappyViewController.h"
#import "SearchResultsViewController.h"
#import "HomeGroupModel.h"
@interface AllGroupViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@end
@implementation AllGroupViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"全部团组页面"];
    [self.httpOpt cancel];
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    [MobClick beginLogPageView:@"全部团组页面"];
    //导航栏标题
    self.titleLabel.text = @"全部团组";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = [WWTolls colorWithHexString:@"#475564"];
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    //导航栏搜索
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"ss-c-36"] forState:UIControlStateNormal];
    self.rightButton.width = 18;
    self.rightButton.height = 18;
    [self.rightButton addTarget:self action:@selector(goToSearch) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 去往搜索页面
-(void)goToSearch{
    SearchResultsViewController *search = [[SearchResultsViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
    self.table = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-66);
    [self.view addSubview:tableView];
    //初始化刷新
//    __weak typeof(self) weakSlef = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:YES];
    };
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
}

- (void)notifyHiden{
    self.table.height = SCREEN_HEIGHT - 16;
}

#pragma mark - 读取缓存
-(void)readCoache{
    
}

#pragma mark - 加载更多
-(void)loadDataWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    if (self.httpOpt && !self.httpOpt.finished) {
        [self.header endRefreshing];
        [self.footer endRefreshing];
        return;
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_HOME_ALLGROUP parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum=1;
                [weakSelf.data removeAllObjects];
            }
            NSArray *tempArray = dic[@"gamelist"];
            for (NSDictionary *dic in tempArray) {
                HomeGroupModel *model = [HomeGroupModel modelWithDic:dic];
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.gameid;
            }
            [weakSelf.table reloadData];
        }
        [weakSelf.header endRefreshing];
        [weakSelf.footer endRefreshing];
    }];
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}


#pragma UITableViewDelegate UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"groupcell";
    
    SearchResultTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                             TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"SearchResultTableViewCell" owner:self options:nil]lastObject];
//        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSUInteger row = [indexPath row];
    searchCell.searchModel = [self.data objectAtIndex:row];
    return searchCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeGroupModel *myReplyModel = self.data[indexPath.row];
    
        GroupViewController *gameDetail = [[GroupViewController alloc]init];
        gameDetail.clickevent = 2;
        gameDetail.joinClickevent = @"2";
        gameDetail.groupId = myReplyModel.gameid;
        gameDetail.ispwd = myReplyModel.ispwd;
        [self.navigationController pushViewController:gameDetail animated:YES];
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.header free];
    [self.footer free];
}
@end
