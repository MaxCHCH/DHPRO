//
//  UserFunsListViewController.m
//  zhidoushi
//
//  Created by nick on 15/11/6.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UserFunsListViewController.h"
#import "UserListTableViewCell.h"
#import "MeViewController.h"
#import "intrestUserModel.h"

@interface UserFunsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数

@end

@implementation UserFunsListViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.httpOpt cancel];
    [MobClick endLogPageView:@"粉丝页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"粉丝页面"];
    //导航栏标题
    self.titleLabel.text = @"粉丝";
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpGUI];
    [self.header beginRefreshing];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    //self.table.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    self.table.backgroundColor = [WWTolls colorWithHexString:@"#FFFFFF"];
    
    UIView *view =[ [UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    view.backgroundColor = [UIColor clearColor];
    [self.table setTableHeaderView:view];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
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
    [dictionary setObject:self.seeuserId forKey:@"seeuserid"];
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
    //  /user/fanslist.do
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post: @"/user/fanslist.do" parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]){
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                [weakSelf.data removeAllObjects];
//                [NSUSER_Defaults setObject:dic forKey:@"newfriendscoachekey"];
//                [NSUSER_Defaults synchronize];
            }
            NSArray *tempArray = dic[@"fansList"];
            for (NSDictionary *dic in tempArray) {
                intrestUserModel *model = [intrestUserModel modelWithDic:dic];
                [weakSelf.data addObject:model];
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
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    intrestUserModel *model = self.data[indexPath.row];
    me.userID = model.userid;
    [self.navigationController pushViewController:me animated:YES];
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
    //searchCell.msgLbl.text = [WWTolls date:searchCell.model.updatetime];
    
    if(searchCell.model.fanscount.length == 0){
        searchCell.model.fanscount = @"0";
    }
    if([searchCell.model.usersex isEqualToString:@"1"]){
        searchCell.model.usersex = @"他";
    }else{
        searchCell.model.usersex = @"她";
    }
    searchCell.msgLbl.text = [NSString stringWithFormat:@"有%@人关注%@",searchCell.model.fanscount,searchCell.model.usersex];
    
    NSUInteger lastrow = row + 1;
    if (self.data.count < 10) {
        if(lastrow == self.data.count) {
            searchCell.lineHeight.constant = 0;
        }
    }
    
    if (![self.seeuserId isEqualToString: [NSUSER_Defaults objectForKey:ZDS_USERID]]) {
        searchCell.guanzhuBtn.hidden = YES;
    }else{
        searchCell.guanzhuBtn.hidden = NO;
    }
    
    return searchCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (SCREEN_HEIGHT - 64) * 0.1;
}

@end
