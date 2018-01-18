//
//  NewFriendsViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/28.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "NewFriendsViewController.h"
#import "UserListTableViewCell.h"
#import "MeViewController.h"
#import "intrestUserModel.h"

@interface NewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@end

@implementation NewFriendsViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"新粉丝页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"新粉丝页面"];
    //导航栏标题
    self.titleLabel.text = @"新粉丝";
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

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.header free];
    [self.footer free];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [NSUSER_Defaults removeObjectForKey:@"flwsum"];
    [NSUSER_Defaults setObject:@"YES" forKey:@"fensishuaxin"];
    [NSUSER_Defaults setObject:@"NO" forKey:@"quleqitayemian"];
    [NSUSER_Defaults synchronize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpGUI];
    [self.header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
}
- (void)notifyHiden{
    self.table.height = SCREEN_HEIGHT - 64;
}


#pragma mark - 初始化UI
-(void)setUpGUI{
    self.table = [[UITableView alloc] init];
    [self.view addSubview:self.table];
    self.table.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollsToTop = YES;
    self.data = [NSMutableArray array];
    
    self.table.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    
    UIView *view =[ [UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    view.backgroundColor = [UIColor clearColor];
    [self.table setTableHeaderView:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    [self.table setTableFooterView:view];

    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:YES];
    };
    
    //读取缓存
    NSDictionary *dic = [NSUSER_Defaults objectForKey:@"newfriendscoachekey"];    
    if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
    }else{
        self.timePageNum=1;
        NSArray *tempArray = dic[@"fanslist"];
        if (tempArray.count>0) {
            for (NSDictionary *dic in tempArray) {
                [self.data addObject:[intrestUserModel modelWithDic:dic]];
                self.lastId = dic[@"userid"];
            }
            [self.table reloadData];
        }
    }
}
#pragma mark - 加载更多
-(void)loadDataWithIsMore:(BOOL)isMore{
    
    if (isMore) {
        if (self.data.count == 0 || self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    if (self.httpOpt && !self.httpOpt.finished) {
        if (isMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
        return;
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_NEWFUNS_NEW_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]){
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                [weakSelf.data removeAllObjects];
                [NSUSER_Defaults setObject:dic forKey:@"newfriendscoachekey"];
                [NSUSER_Defaults synchronize];
            }
            NSArray *tempArray = dic[@"fanslist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[intrestUserModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"userid"];
            }
            [weakSelf.table reloadData];
        }
        if (isMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
    }];
}

#pragma mark - tableviewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableSampleIdentifier = @"searchermancell";
    
    UserListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                         TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil]lastObject];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSUInteger row = [indexPath row];
    searchCell.model = [self.data objectAtIndex:row];
    searchCell.msgLbl.text = [WWTolls date:searchCell.model.updatetime];
    return searchCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

@end
