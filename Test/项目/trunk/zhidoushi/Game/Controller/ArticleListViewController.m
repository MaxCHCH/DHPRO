//
//  ArticleListViewController.m
//  zhidoushi
//
//  Created by nick on 15/9/9.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ArticleListViewController.h"
#import "CreateArticleViewController.h"
#import "ArticleTableViewCell.h"
#import "GroupTalkDetailViewController.h"

@interface ArticleListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* DisCoverTable;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数

@end

@implementation ArticleListViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"精品帖列表页面"];
    [self.httpOpt cancel];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"精品帖列表页面"];
    //导航栏标题
    self.titleLabel.text = @"精华帖";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    //发布
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"cj-36"] forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font = MyFont(13);
    [self.rightButton addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
    labelRect = self.rightButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.rightButton.frame = labelRect;
    
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createArticle{
    CreateArticleViewController *art = [[CreateArticleViewController alloc] init];
    art.groupId = self.groupId;
    [self.navigationController pushViewController:art animated:YES];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTitleSucess) name:@"sendTitleSucess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTitleSucess) name:@"grouptitletoggle" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendTitleSucess) name:@"grouptitletop" object:nil];
    
}

-(void)sendTitleSucess{
    [self LoadDataWithIsMore:NO];
}

- (void)notifyHiden{
    self.DisCoverTable.height = SCREEN_HEIGHT - 64;
}


#pragma mark - 初始化UI
-(void)setupGUI{
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = ZDS_BACK_COLOR;
    self.DisCoverTable = tableView;
    tableView.delegate = self;
    tableView.scrollsToTop = YES;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:tableView];
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:NO];
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self LoadDataWithIsMore:YES];
    };
}

#pragma mark - 加载数据
-(void)LoadDataWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.data.count == 0 ||self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
        }
    }
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    if (self.httpOpt && !self.httpOpt.finished) {
        if (isMore) {
            [self.footer endRefreshing];
        }else{
            [self.header endRefreshing];
        }
        return;
    }
    
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_TITLE_LIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]){
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            for (NSDictionary *dict in dic[@"barlist"]) {
                GroupTalkModel *model = [GroupTalkModel modelWithDic:dict];
                [weakSelf.data addObject:model];
                weakSelf.lastId = model.talkid;
            }
            [weakSelf.DisCoverTable reloadData];
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
    GroupTalkModel *model = self.data[indexPath.row];
    if (!model.imageurl || model.imageurl.length<1) {
        NSString *content = [[model.talkcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        CGFloat heigh = [WWTolls heightForString:content fontSize:13 andWidth:SCREEN_WIDTH - 30];
        if (heigh<50) {
            return 87 + heigh;
        }else return 137;
    }
    return 137;
    //    if (!model.imageurl || model.imageurl.length<1) {
    //        NSString *content = [[model.talkcontent stringByReplacingOccurrencesOfString:@"\r" withString:@" "] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    //        CGFloat heigh = [WWTolls heightForString:content fontSize:14 andWidth:SCREEN_WIDTH - 30];
    //        if (heigh<72) {
    //            return 70 + heigh;
    //        }else return 138;
    //    }
    //    return 148;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"ZDSGroupActicalCell";
    
    ArticleTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:
                                        TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [ArticleTableViewCell loadNib];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSUInteger row = [indexPath row];
    [searchCell setUpWithTalkModel:self.data[row]];
    if (row == 0) {
        searchCell.separLine.hidden = YES;
    }else searchCell.separLine.hidden = NO;
    return searchCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GroupTalkModel *model = self.data[indexPath.row];
    model.pageview = [NSString stringWithFormat:@"%d",model.pageview.intValue+1];
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    GroupTalkDetailViewController *group = [[GroupTalkDetailViewController alloc] init];
    group.talktype = GroupTitleTalkType;
    group.clickevent = 4;
    group.isShowTopBtn = YES;
    group.talkid = model.talkid;
    group.groupId = self.groupId;
    [self.navigationController pushViewController:group animated:YES];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.header free];
    [self.footer free];
}
@end
