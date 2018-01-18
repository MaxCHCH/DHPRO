//
//  TaskDoneListViewController.m
//  zhidoushi
//
//  Created by nick on 15/9/21.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "TaskDoneListViewController.h"
#import "MeViewController.h"
#import "intrestUserModel.h"
#import "MJRefresh.h"

@interface TaskDoneListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@end

@implementation TaskDoneListViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"任务完成列表"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"任务完成列表"];
    //导航栏标题
    self.titleLabel.text = @"跟我减脂最欢乐";
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
    self.rightButton.frame = labelRect;
    self.leftButton.frame = labelRect;
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 去往搜索页面
-(void)goToSearch{
    //    SearchUserViewController *search = [[SearchUserViewController alloc] init];
    //    [self.navigationController pushViewController:search animated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化UI
    [self setupGUI];
    //刷新数据
    [self loadDataWithIsMore:NO];
}

#pragma mark - 初始化UI
-(void)setupGUI{
    self.view.backgroundColor = ZDS_BACK_COLOR;
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = [UIColor whiteColor];
    back.clipsToBounds = YES;
    back.layer.cornerRadius = 5;
    back.frame = CGRectMake(8, 8, SCREEN_WIDTH-16, SCREEN_HEIGHT-80);
    [self.view addSubview:back];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.table = tableView;
    tableView.layer.cornerRadius = 5;
    tableView.clipsToBounds = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.frame = CGRectMake(8, 8, SCREEN_WIDTH-16, SCREEN_HEIGHT-36);
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH-16, SCREEN_HEIGHT-34);
    [back addSubview:tableView];
    //头部视图
    UIView *head = [[UIView alloc] init];
    head.frame = CGRectMake(0, 0, SCREEN_WIDTH-16, 39);
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-16, 39)];
    lbl.text = @"查看完成人情况";
    lbl.font = MyFont(16);
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    lbl.textAlignment = NSTextAlignmentCenter;
    [head addSubview:lbl];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH-16, 0.5)];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [head addSubview:line];
    tableView.tableHeaderView = head;
    
    //初始化刷新
    //    __weak typeof(self) weakSlef = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:YES];
    };
}


#pragma mark - 加载
-(void)loadDataWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.data.count == 0 || self.data.count%20!=0||self.data.count<self.timePageNum*20) {
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
    [dictionary setObject:@"20" forKey:@"pageSize"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.taskId] forKey:@"taskid"];
    [dictionary setObject:[NSString stringWithFormat:@"%@",self.groupId] forKey:@"gameid"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_TASKDONELIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {

        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            NSArray *tempArray = dic[@"userlist"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[intrestUserModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"userid"];
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


#pragma mark - tableView dataSource Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSUInteger row = [indexPath row];
    intrestUserModel *model = self.data[row];
    //线
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-16, 0.5)];
    view.backgroundColor = [WWTolls colorWithHexString:@"#f6f6f6"];
    [cell.contentView addSubview:view];
    //名次
    if (row == 0) {//第一名
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dym-60-60"]];
        //        img.backgroundColor = [UIColor redColor];
        img.frame = CGRectMake(15, 23, 30, 30);
        [cell.contentView addSubview:img];
        cell.contentView.backgroundColor = [WWTolls colorWithHexString:@"#fff7eb"];
    }else{
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(14, 24, 32, 15)];
        lbl.font = MyFont(15);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = [NSString stringWithFormat:@"%lu",row+1];
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        [cell.contentView addSubview:lbl];
    }
    //头像
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(53, 18, 40, 40)];
    header.clipsToBounds = YES;
    header.layer.cornerRadius = 20;
    header.backgroundColor = ZDS_BACK_COLOR;
    [header sd_setImageWithURL:[NSURL URLWithString:model.imageurl]];
    [cell.contentView addSubview:header];
    //昵称
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(103, 30, SCREEN_WIDTH - 16 - 103 - 70, 16)];
    lbl.font = MyFont(14);
    lbl.text = model.username;
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    if (row == 0) {
        lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    }
    [cell.contentView addSubview:lbl];
    //日期
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 16 - 9 - 70, 33, 70, 13)];
    lbl.font = MyFont(12);
    lbl.textAlignment = NSTextAlignmentRight;
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    //    model.ptotallose = @"1332.9";
    lbl.text = [WWTolls timeString22:model.createtime];
    //    if (lbl.text.length>6) {
    //        [lbl sizeToFit];
    //    }
    //    [lbl sizeToFit];
    [cell.contentView addSubview:lbl];
    return cell;
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



@end
