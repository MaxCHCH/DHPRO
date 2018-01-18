

//
//  GroupTypeViewController.m
//  zhidoushi
//
//  Created by nick on 15/11/5.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupTypeViewController.h"
#import "SearchResultTableViewCell.h"
#import "GroupViewController.h"
#import "GroupHappyViewController.h"
#import "CreateGroupTwoViewController.h"
#import "HomeGroupModel.h"
#import "WWTolls.h"
#import "PingTransition.h"
#import "YCImageView.h"

#import "CreateGroupTwoNewViewController.h"

#import "UIImageView+WebCache.h"

@interface GroupTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数

/** 头部ImgView */
@property (nonatomic, strong)YCImageView *headerImageView;

@property(nonatomic,copy)NSString* headerImgURL; // 头部视图地址


/** 记录下最开始的Y轴偏移量 */
@property (nonatomic, assign) CGFloat oriOffsetY;




@end

@implementation GroupTypeViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.delegate = nil;
    
    // 侧滑的时候改变导航栏标题文字颜色
    self.titleLabel.textColor = TitleColor;
    
    [MobClick endLogPageView:@"圈子详情页面"];
    [self.httpOpt cancel];
    [self.table deselectRowAtIndexPath:[self.table indexPathForSelectedRow] animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [MobClick beginLogPageView:@"圈子详情页面"];
    //导航栏标题
    self.titleLabel.text = self.gamecircle;
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = [WWTolls colorWithHexString:@"#ffffff"];
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    
    //导航创建团组按钮
//    [self.rightButton setTitle:@"创建" forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font = MyFont(16);
//    self.rightButton.titleLabel.textColor = [WWTolls colorWithHexString:@"#959595"];
    
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"cj-36"] forState:UIControlStateNormal];
    
    [self.rightButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 18, 18);
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
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:tableView];
    //初始化刷新
    //    __weak typeof(self) weakSlef = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.height = 0;
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
    
    
    YCImageView *imageHeaderView = [[YCImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.headerImageView = imageHeaderView;
    imageHeaderView.userInteractionEnabled = YES;
    
//    imageHeaderView.image = [UIImage imageNamed:];
    
    
    YCImageView *menbanView = [[YCImageView alloc] init];
    menbanView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    menbanView.frame = imageHeaderView.bounds;
    [imageHeaderView addSubview:menbanView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.creatBtn = btn;
    
    [btn addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
 
    btn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, 300 - 25, 60, 60);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"cj-118"] forState:UIControlStateNormal];
    
    [menbanView addSubview:btn];
    
    self.table.tableHeaderView = imageHeaderView;

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
    [dictionary setObject:self.gamecircle forKey:@"gamecircle"];
    if (isMore) {
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:@"/game/circlegames.do" parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
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
            
            NSString *headerImgUrl = dic[@"imageurl"];
            
            if (headerImgUrl.length != 0) {
                
                [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImgUrl]];
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
    return 111;
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



#pragma mark - 跳转到创建游戏界面
-(void)createGame{
    [MobClick event:@"HomeCreate"];
    
    // 设置转场的代理
    self.navigationController.delegate = self;
    
    self.rightButton.userInteractionEnabled = NO;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATECHK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if (!dic[ERRCODE]) {
            CreateGroupTwoNewViewController * create = [[CreateGroupTwoNewViewController alloc]init];
            create.isPassWordGrouper = [dic[@"ispasswd"] isEqualToString:@"0"];
            create.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:create animated:YES];
        }
        weakSelf.rightButton.userInteractionEnabled = YES;
    }];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.header free];
    [self.footer free];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 获取当前的y轴偏移量
    CGFloat curOffsetY = scrollView.contentOffset.y;
    
    if (curOffsetY < 0) {
        
        // 不让刷新控件能看见
//        self.header.alpha = 0;
    }
    
    
    if (curOffsetY >= 115) {
        
        self.titleLabel.textColor = [WWTolls colorWithHexString:@"#475564"];
        
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
        
    } else {
        
        self.titleLabel.textColor = [UIColor clearColor];
        
        [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-b-36"] forState:UIControlStateNormal];
        
    }

    if (curOffsetY >= (300 - 64)) {
    
        self.rightButton.hidden = NO;
        self.creatBtn.hidden = YES;

    } else {
    
        self.rightButton.hidden = YES;
        self.creatBtn.hidden = NO;

    }
    
    // 计算下与最开始的偏移量的差距
    CGFloat delta = curOffsetY - _oriOffsetY;
    
    // 获取当前导航条背景图片透明度，当delta=300 - 64的时候，透明图刚好为1.
    CGFloat alpha = delta * 1 / (300 - 64);
    if (alpha >= 1) {
        alpha = 0.99;
    }
    
    // 分类：根据颜色生成一张图片
    UIImage *bgImage = [WWTolls imageWithColor:[UIColor colorWithWhite:1 alpha:alpha]];
    
    //    UIImage *bgImage = [UIImage imageNamed:@"123"];
    [self.navigationController.navigationBar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [PingTransition new];
        return ping;
    }else{
        return nil;
    }
}


@end
