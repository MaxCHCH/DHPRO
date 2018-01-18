//
//  MemberLoseWeightViewController.m
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MemberLoseWeightViewController.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "LoseWeightTableViewCell.h"
#import "LoseDetailModel.h"
#import "MJExtension.h"

@interface MemberLoseWeightViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic) int timePageNum;

@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新

@end

@implementation MemberLoseWeightViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ZDS_DHL_TITLE_COLOR;
    
    [self setUpUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"团员减重榜页面"];
    
    //导航栏标题
    self.titleLabel.text = self.gameName;
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"团员减重榜页面"];
    [self.httpOpt cancel];
}

- (void)dealloc {
    [self.header free];
    [self.footer free];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI
- (void)setUpUI {
    
    self.view.backgroundColor = ZDS_BACK_COLOR;
    UIView *back = [[UIView alloc] init];
    back.backgroundColor = [UIColor whiteColor];
    back.clipsToBounds = YES;
    back.layer.cornerRadius = 5;
    back.frame = CGRectMake(7.5, 8, SCREEN_WIDTH-16, SCREEN_HEIGHT-80);
    [self.view addSubview:back];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.table = tableView;
    tableView.layer.cornerRadius = 5;
    tableView.clipsToBounds = YES;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollsToTop = YES;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    //    tableView.frame = CGRectMake(8, 8, SCREEN_WIDTH-16, SCREEN_HEIGHT-36);
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH-15, SCREEN_HEIGHT-34);
    [back addSubview:tableView];
    
    //头部视图
    UIView *head = [[UIView alloc] init];
//    head.backgroundColor = [UIColor redColor];
    head.frame = CGRectMake(0, 0, SCREEN_WIDTH-15, 70);
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_reduce_member"]];
    img.frame = CGRectMake(12, 11, 12, 15);
    [head addSubview:img];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(img.maxX + 8, 11, 98, 16)];
    lbl.text = @"团员体重日志";
    lbl.font = MyFont(16);
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    [head addSubview:lbl];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(lbl.maxX + 2, lbl.midY - 5, 100, 10)];
    lbl.text = @"(单位:kg)";
    lbl.font = MyFont(10);
    lbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    [head addSubview:lbl];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, lbl.maxY + 11, SCREEN_WIDTH-15, 0.5)];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [head addSubview:line];
    
    
    UILabel *memberLable = [[UILabel alloc] initWithFrame:CGRectMake(0, line.maxY + 15, 96, 11)];
    [head addSubview:memberLable];
    memberLable.font = MyFont(11);
    memberLable.textAlignment = NSTextAlignmentCenter;
    memberLable.textColor = [WWTolls colorWithHexString:@"#959595"];
    memberLable.text = @"团员";
    
    for (int i = 0; i < 4; i++) {
        CGFloat x = memberLable.maxX + i * 52;
        UILabel *tLbl = [[UILabel alloc] initWithFrame:CGRectMake(x, line.maxY, 0.5, 41)];
        [head addSubview:tLbl];
        tLbl.backgroundColor = [WWTolls colorWithHexString:@"#f6f6f6"];
    }
    
    NSArray *array = @[@"入团体重",@"当前体重",@"已经减重",@"当前任务"];
    for (int i = 0; i < 4; i++) {
        CGFloat x = memberLable.maxX + 1 + 10 + (52) * i;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, line.maxY + 8, 27, 27)];
        [head addSubview:label];
        label.text = array[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 2;
        
        label.textColor = [WWTolls colorWithHexString:@"#959595"];
        label.font = MyFont(11);
    }   
    
    UILabel *lineTwoLable = [[UILabel alloc] initWithFrame:CGRectMake(0, memberLable.maxY + 15, head.width, 0.5)];
    [head addSubview:lineTwoLable];
    lineTwoLable.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    
    head.height = lineTwoLable.maxY;
    tableView.tableHeaderView = head;
    
    //初始化刷新
    
//    WEAKSELF_SS
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = self.table;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self refreshSource];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = self.table;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self reloadSource];
    };
    
    [self.header beginRefreshing];
}

#pragma mark - Delegate
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}   

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LoseWeightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoseWeightTableViewCell"];
    if (cell == nil) {
        cell = [[LoseWeightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LoseWeightTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    LoseDetailModel *model = self.data[indexPath.row];
    cell.model = model;
    
    return cell;
}


#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

#pragma mark - Event Responses
- (void)popButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

#pragma mark 刷新列表
- (void)refreshSource {
    [self requestWithActPartersIsLoadMore:NO];
}

#pragma mark 加载更多
- (void)reloadSource {
    [self requestWithActPartersIsLoadMore:YES];
}

#pragma mark - Request
#pragma mark 团员减重详细列表请求
- (void)requestWithActPartersIsLoadMore:(BOOL)loadMore {
    
    if (loadMore) {
        if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:self.gameId forKey:@"gameid"];
    
    if (loadMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
        if(self.lastId) [dictionary setObject:self.lastId forKey:@"lastid"];
    } else {
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    
    __weak typeof(self)weakSelf = self;
    if (self.httpOpt && !self.httpOpt.finished) {
        if (loadMore) {
            [weakSelf.footer endRefreshing];
        } else {
            [weakSelf.header endRefreshing];
        }
        return;
    }
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_LOSEDETAIL parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            
            if (loadMore) {
                weakSelf.timePageNum++;
            } else {
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            
            NSArray *parterList = dic[@"loselist"];
            
            for (NSDictionary *dict in parterList) {
                LoseDetailModel *model = [LoseDetailModel objectWithKeyValues:dict];
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.userid;
            }
            
            [weakSelf.table reloadData];
        }
        
        if (loadMore) {
            [weakSelf.footer endRefreshing];
        } else {
            [weakSelf.header endRefreshing];
        }
    }];
}

#pragma mark - Getters And Setters
- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}   


@end









