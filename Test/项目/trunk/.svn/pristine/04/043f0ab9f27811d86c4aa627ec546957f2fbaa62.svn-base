//
//  InterestUserViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "InterestUserViewController.h"
#import "MeViewController.h"
#import "SearchUserViewController.h"
#import "intrestUserModel.h"
#import "UserListTableViewCell.h"

@interface InterestUserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* DisCoverTable;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@end

@implementation InterestUserViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"可能感兴趣的人页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"可能感兴趣的人页面"];
    //导航栏标题
    self.titleLabel.text = @"可能感兴趣的人";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //隐藏底部导航栏
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    //导航栏搜索
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"home_searchIcon_36_36"] forState:UIControlStateNormal];
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
    SearchUserViewController *search = [[SearchUserViewController alloc] init];
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
    [self refreshData];
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
//    __weak typeof(self) weakSlef = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadData];
    };
}

#pragma mark - 读取缓存
-(void)readCoache{
    
}

#pragma mark - 刷新数据
-(void)refreshData{
    
    //构造请求参数
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString *key = [NSString getMyKey:userID];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:userid forKey:@"userid"];
    [dictionary setObject:key forKey:@"key"];
    [dictionary setObject:@"1" forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    
    //发送请求感兴趣的人
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_DISCOVER_INTRESTUSER];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            weakSelf.timePageNum=1;
            [weakSelf.data removeAllObjects];
            NSArray *tempArray = dic[@"userlist"];
            for (NSDictionary *dic in tempArray) {
                intrestUserModel *model = [intrestUserModel modelWithDic:dic];
                model.flwstatus = @"1";
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.userid;
            }
            [weakSelf.DisCoverTable reloadData];
        }
        [weakSelf.header endRefreshing];
    }];
}

#pragma mark - 加载更多
-(void)loadData{
    
    if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.footer endRefreshing];
        return;
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    
    //发送请求
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_DISCOVER_INTRESTUSER];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [self showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            weakSelf.timePageNum++;
            NSArray *tempArray = dic[@"userlist"];
            for (NSDictionary *dic in tempArray) {
                intrestUserModel *model = [intrestUserModel modelWithDic:dic];
                model.flwstatus = @"1";
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.userid;
            }
            [weakSelf.DisCoverTable reloadData];
        }
        [weakSelf.footer endRefreshing];
    }];
}

-(NSMutableArray *)data{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}


#pragma mark - tableView dataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
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
    NSString *intertype = searchCell.model.intertype;
    if ([intertype isEqualToString:@"0"]) {//城市
        searchCell.msgLbl.text = [NSString stringWithFormat:@"你们都在：%@",searchCell.model.city];
    }else if ([intertype isEqualToString:@"1"]) {//朋友关注
        searchCell.msgLbl.text= [NSString stringWithFormat:@"%@也关注了他",searchCell.model.flwusername];
    }else if([intertype isEqualToString:@"2"]){
        searchCell.msgLbl.text = @"你可能感兴趣的人";
    }
    return searchCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MeViewController *user = [[MeViewController alloc] init];
    intrestUserModel *model = self.data[indexPath.row];
    user.userID = model.userid;
    user.otherOrMe = 1;
    [self.navigationController pushViewController:user animated:YES];
}


-(void)dealloc{
    [self.header free];
    [self.footer free];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
