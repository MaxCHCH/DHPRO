//
//  InvitationViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "InvitationViewController.h"

#import "WWTolls.h"
#import "JSONKit.h"
#import "NSString+NARSafeString.h"
#import "WWRequestOperationEngine.h"
#import "MJRefresh.h"
#import "invitationModel.h"
#import "MeViewController.h"
#import "MobClick.h"

@interface InvitationViewController ()<InvitationTabeleDelegate,UITableViewDelegate>
{
    NSMutableArray *modelArray;
    NSString *pageSizeNumber;
    NSInteger arrayCount;//数组里有多少内容
}
@property(nonatomic,strong)MJRefreshHeaderView *header;
@property(nonatomic,strong)MJRefreshFooterView *footer;
@end

static     NSInteger pageNumber;//页数

@implementation InvitationViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邀请粉丝页面"];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"邀请粉丝页面"];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;

    self.titleLabel.text = @"邀请朋友";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
}

-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    invitationModel *model = (invitationModel*)[modelArray objectAtIndex:indexPath.row];
    MeViewController *single = [[MeViewController alloc]init];
    single.otherOrMe = 1;
    single.userID = model.userid;
    [self.navigationController pushViewController:single animated:YES];
}
-(void)dealloc{
    [self.header free];
    [self.footer free];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    modelArray = [[NSMutableArray array]init];
    if (iOS8) {
        self.invitationTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height+50);
    }
#pragma mark -- 刷新模块
//    [self initFreshView:self.invitationTableView];//先初始化
//    [self.invitationTableView addSubview:self.freshHeaderView];
//    [self.invitationTableView addSubview:self.freshFooterView];

    //刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.invitationTableView; // 或者tableView
    self.header = header;
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.invitationTableView; // 或者tableView
    self.footer = footer;
//    WEAKSELF_SS
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self doneLoadingTableViewData:nil];
        [refreshView endRefreshing];
    };
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        [self loadMoreData:nil];
        [refreshView endRefreshing];
    };
    
    pageNumber = 1;
    pageSizeNumber = [NSString stringWithFormat:@"10"];
    [self reloadView2:pageNumber pageSize:pageSizeNumber userID:self.userid game_ID:self.gameid];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"cellInvitation";
    self.invitationCell = [tableView dequeueReusableCellWithIdentifier:
                       CellIdentifier];

    if (!self.invitationCell) {
        self.invitationCell = [[[NSBundle mainBundle]loadNibNamed:@"InvitationTableViewCell" owner:self options:nil]lastObject];
        self.invitationCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.invitationCell.InvitationDelegate = self;
    }
    if (modelArray.count>0) {
        [self.invitationCell initWithMyCell:[modelArray objectAtIndex:indexPath.row]];

    }
    return self.invitationCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 邀请代理
-(void)clickInvitatinButton:(NSString *)rcvuser_name rcvuserID:(NSString *)rcvuser_id buttonTag:(NSInteger)tag
{

    [self invitaPeople:self.userid game_ID:self.gameid rcvuserID:rcvuser_id rcvuser_Name:rcvuser_name andTag:tag];

}

-(void)reloadView2:(NSInteger)page pageSize:(NSString*)pSize userID:(NSString*)user_id game_ID:(NSString*)game_id
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:game_id  forKey:@"gameid"];
    [dictionary setObject:[NSString stringWithFormat:@"%ld",page] forKey:@"pageNum"];
    [dictionary setObject:pSize forKey:@"pageSize"];
    if (page>1) {
        if(self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    }
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_INVITELIST parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {

        if (!dic[ERRCODE]) {
            if (page == 1) {
                [modelArray removeAllObjects];
            }
            NSArray *userlogListArray = [dic objectForKey:@"inviteList"];

            for (int i=0; i<userlogListArray.count; i++) {

                invitationModel *invitaModel = [[invitationModel alloc]init];

                NSDictionary *userInfoDictionary = [userlogListArray objectAtIndex:i];
                //NSDictionary *userInfoDictionary = [listDictionary objectForKey:@"userinfo"];
                invitaModel.userid = [userInfoDictionary objectForKey:@"userid"];
                invitaModel.username = [userInfoDictionary objectForKey:@"username"];
                invitaModel.usersign = [userInfoDictionary objectForKey:@"usersign"];
                invitaModel.imageurl = [userInfoDictionary objectForKey:@"imageurl"];
                //invitaModel.flwstatus = [userInfoDictionary objectForKey:@"flwstatus"];
                invitaModel.invitests = [userInfoDictionary objectForKey:@"invitests"];
                [modelArray addObject:invitaModel];
                weakSelf.lastId = invitaModel.userid;
            }

            arrayCount = modelArray.count;

            if (arrayCount>0) {
                [weakSelf.invitationTableView reloadData];
            }
        NSLog(@"邀请列表table数据error%@",[dic objectForKey:@"errinfo"]);

        NSLog(@"邀请列表0table数据*********%@", dic);

        }
    }];
}

-(void)invitaPeople:(NSString*)user_id game_ID:(NSString*)game_id rcvuserID:(NSString*)rcvuser_id rcvuser_Name:(NSString*)rcvuserName andTag:(NSInteger)myTag
{
    if (myTag==100) {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dictionary setObject:game_id  forKey:@"gameid"];
    [dictionary setObject:rcvuser_id forKey:@"rcvuserid"];
    [dictionary setObject:rcvuserName forKey:@"rcvusername"];
    NSLog(@"——————————————%@",dictionary);
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_INVITEPEOPLE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        if (!dic[ERRCODE]) {
            [weakSelf showAlertMsg:@"邀请成功" andFrame:CGRectMake(110, 200, 130, 30)];
            for (int i = 0; i<modelArray.count; i++) {
                if ([((invitationModel*)modelArray[i]).userid isEqualToString:rcvuser_id]) {
                    ((invitationModel*)modelArray[i]).invitests = @"0";//本地数据改为已邀请
                    break;
                }
            }
        }
    }];
    }
}

#pragma mark --加载
- (void)loadMoreData:(UITableView*)myTableView{
    NSLog(@"*******我加载了*********");
    //..刷新时清除cell保存数据..//
//    if (self.indexCellSet.count>0) {
//        [self.indexCellSet removeAllObjects];
//    }

    if (arrayCount%10==0&&arrayCount==pageNumber*10) {
        pageNumber++;
        [self reloadView2:pageNumber pageSize:pageSizeNumber userID:self.userid game_ID:self.gameid];
//        [self.freshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.invitationTableView];
    }
    
}

#pragma mark --刷新
- (void)doneLoadingTableViewData:(UITableView*)myTableView{
    NSLog(@"******我刷新了******");
    pageNumber = 1;
    //..刷新时清除cell保存数据..//
//    if (self.indexCellSet.count>0) {
//        [self.indexCellSet removeAllObjects];
//    }
    
    [self reloadView2:pageNumber pageSize:pageSizeNumber userID:self.userid game_ID:self.gameid];
//    [self.freshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.invitationTableView];
}



@end
