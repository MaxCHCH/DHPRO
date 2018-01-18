//
//  UserAblumViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UserAblumViewController.h"
#import "XimageView.h"

@interface UserAblumViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* Table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int PageNum;//当前页数
@end

@implementation UserAblumViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的相册页面"];
    [self.httpOpt cancel];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"我的相册页面"];
    [MobClick event:@"DISCOVER"];
    //导航栏标题
    self.titleLabel.text = @"健康日记";
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupGUI];
    [self readCoache];
    [self.header beginRefreshing];
}

#pragma mark - 初始化UI
-(void)setupGUI{
    //顶部类别宣言
    
    //相册列表
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.Table  = tableView;
    [self.view addSubview:tableView];
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = tableView;
    //    __weak typeof(self) weakself = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadDataWithIsMore:YES];
    };
}

#pragma mark - 读取缓存
-(void)readCoache{
    NSDictionary *dic = [NSUSER_Defaults objectForKey:ME_MYALBUM_COACHE];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.PageNum=1;
    [self.data removeAllObjects];
    [self.data addObjectsFromArray:dic[@"photolist"]];
    [self.Table reloadData];
}
#pragma mark - 加载更多
-(void)loadDataWithIsMore:(BOOL)isMore{
    
    if (isMore) {
        if (self.data.count == 0 || self.data.count%10!=0||self.data.count<self.PageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        }
    }
    if (self.httpOpt && !self.httpOpt.finished) {
        if (isMore) {
            [self.footer endRefreshing];
        }else{
            [self.header endRefreshing];
        }
        return;
    }
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.PageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"dateSize"];
    
    //发送请求
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_ME_MYALBUM parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.PageNum++;
            }else{
                weakSelf.PageNum=1;
                [weakSelf.data removeAllObjects];
                [NSUSER_Defaults setValue:dic forKey:ME_MYALBUM_COACHE];
            }
            NSArray *tempArray = dic[@"photolist"];
            [weakSelf.data addObjectsFromArray:tempArray];
            [weakSelf.Table reloadData];
        }
        if (isMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
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
    int photoCountThisDay = (int)((NSArray*)self.data[indexPath.row][@"imagelist"]).count;
    CGFloat h = 48;
    int rows = photoCountThisDay/2;
    rows = photoCountThisDay%2==0?rows:rows+1;
    h+=rows*((SCREEN_WIDTH - 75)/2 + 15) - 15;
    return h;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //获取数据
    NSDictionary *dic = self.data[indexPath.row];
    NSString *time = dic[@"createdate"];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
//    time = [time stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@"."];
    NSArray *images = dic[@"imagelist"];
    //添加时间lbl
    UILabel *timelbl = [[UILabel alloc] init];
    timelbl.frame = CGRectMake(15, 0, 150, 48);
    timelbl.font = MyFont(15);
    timelbl.textColor = ContentColor;
//    timelbl.textAlignment = NSTextAlignmentCenter;
    timelbl.text = time;
    [cell.contentView addSubview:timelbl];
    //添加竖线
    //竖线高度
//    int photoCountThisDay = (int)images.count;
//    CGFloat h = -25;
//    int rows = photoCountThisDay/2;
//    rows = photoCountThisDay%2==0?rows:rows+1;
//    h+=rows*(126*SCREEN_WIDTH/320+10);
    //上圈
//    if(indexPath.row!=0){
//        UIImageView *image = [[UIImageView alloc] init];
//        image.backgroundColor = [WWTolls colorWithHexString:@"#b2e34c"];
//        image.frame = CGRectMake(22.5, 0, 2, 5);
//        [cell.contentView addSubview:image];
//        UIImageView *quan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_yuan-14-14"]];
//        quan.frame = CGRectMake(20, 5, 7, 7);
//        [cell.contentView addSubview:quan];
//    }
//    //下圈
//    UIImageView *quan = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"album_yuan-14-14"]];
//    quan.frame = CGRectMake(20, 32, 7, 7);
//    [cell.contentView addSubview:quan];
//    
//    UIImageView *image = [[UIImageView alloc] init];
//    image.backgroundColor = [WWTolls colorWithHexString:@"#b2e34c"];
//    image.frame = CGRectMake(22.5, 39, 2, h-7);
//    [cell.contentView addSubview:image];
    
    for (int i = 0; i<images.count; i++) {
        XimageView *image = [[XimageView alloc] init];
        image.backgroundColor = [WWTolls colorWithHexString:@"#e5e5e5"];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [image sd_setImageWithURL:[NSURL URLWithString:images[i]]];
        int rrow = i/2;
        CGFloat width = (SCREEN_WIDTH - 75)/2;
        if (i%2==0) {//每排第一个
            image.frame = CGRectMake(30, 48+(width+15)*rrow, width, width);
        }else{//每排第二个
            image.frame = CGRectMake(width + 45, 48+(width+15)*rrow, width, width);
        }
        [cell.contentView addSubview:image];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}


-(void)dealloc{
    [self.header free];
    [self.footer free];
}

@end
