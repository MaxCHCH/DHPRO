//
//  SinaWeiboViewController.m
//  zhidoushi
//
//  Created by nick on 15/6/5.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SinaWeiboViewController.h"
#import "UserListTableViewCell.h"
#import "intrestUserModel.h"
#import "UMSocial.h"
#import "XTabBar.h"
#import "MeViewController.h"
@interface SinaWeiboViewController()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* table;//tableView
@property(nonatomic,strong)NSMutableArray* data;//数据
@property(nonatomic,strong)MJRefreshHeaderView *header;//头部刷新
@property(nonatomic,strong)MJRefreshFooterView *footer;//底部刷新
@property(nonatomic,assign)int timePageNum;//当前页数
@end
@implementation SinaWeiboViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [NSUSER_Defaults removeObjectForKey:@"newFriendSina"];
    [[XTabBar shareXTabBar] friendDian];
    [MobClick endLogPageView:@"新浪好友页面"];
    [self.httpOpt cancel];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"新浪好友页面"];
    //导航栏标题
    self.titleLabel.text = @"新浪好友";
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
    //初始化UI
    [self setupGUI];
    //请求微博好友
    [self getfriends];
    //刷新数据
    [self.header beginRefreshing];
}

#pragma mark - 请求微博好友
-(void)getfriends{
    __weak typeof(self) weakself = self;
    [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            [weakself getsinafriend:response];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取微博授权" message:@"获取微博好友需要微博授权，是否授权？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        //获取权限
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        __weak typeof(self) weakself = self;
        snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                [[UMSocialDataService defaultDataService] requestSnsFriends:UMShareToSina  completion:^(UMSocialResponseEntity *response){
                    if (response.responseCode == UMSResponseCodeSuccess) {
                        [weakself getsinafriend:response];
                    }
                }];
            }
        });

    }
}

-(void)getsinafriend:(UMSocialResponseEntity *)response{
    //上传新浪信息/cpwbflws.do
    NSDictionary *phoneString = [NSUSER_Defaults objectForKey:[NSString stringWithFormat:@"sina.%@",[NSUSER_Defaults objectForKey:ZDS_USERID]]];
    if (![phoneString isKindOfClass:[NSDictionary class]]) {
        [NSUSER_Defaults setObject:nil forKey:[NSString stringWithFormat:@"sina.%@",[NSUSER_Defaults objectForKey:ZDS_USERID]]];
        phoneString = nil;
    }
    NSMutableDictionary * resultString = [NSMutableDictionary dictionary];
    for (NSString *s in response.data.allKeys) {
        if(phoneString[s]==nil) [resultString setObject:response.data[s] forKey:s];
    }
    phoneString = response.data;
    if (resultString.count!=0) {
        NSLog(@"有新的用户噢噢噢噢噢噢噢噢哦哦哦");
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:resultString options:NSJSONWritingPrettyPrinted error:&parseError];
        NSString *phone = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        phone = [phone stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        [dictionary setObject:phone forKey:@"wbflwmap"];
        NSLog(@"上传通讯录dictionary——————————————%@",dictionary);
        __weak typeof(self) weakSelf = self;
        NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_CPSINAFRIENDDO];
        [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            
            if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
                NSLog(@"上传新浪好友失败");
            }else{
                NSLog(@"新浪好友返回数据*********%@", dic);
                [NSUSER_Defaults setValue:phoneString forKey:[NSString stringWithFormat:@"sina.%@",[NSUSER_Defaults objectForKey:ZDS_USERID]]];
                [NSUSER_Defaults synchronize];
                [weakSelf loadDataWithIsMore:NO];
            }
        }];
    }
}

#pragma mark - 初始化UI
-(void)setupGUI{
    UITableView *tableView = [[UITableView alloc] init];
    self.table = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = ZDS_BACK_COLOR;
    tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-16);
    [self.view addSubview:tableView];
    UILabel *head = [[UILabel alloc] init];
    head.frame = CGRectMake(-1, 0, SCREEN_WIDTH+2, 18);
    head.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    head.layer.borderWidth = 0.5;
    head.text = @"    已加入脂斗士";
    head.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    head.font = MyFont(10);
    tableView.tableHeaderView = head;
    //初始化刷新
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
}

#pragma mark - 加载
-(void)loadDataWithIsMore:(BOOL)isMore{
    if (isMore) {
        if (self.data.count == 0 || self.data.count%10!=0||self.data.count<self.timePageNum*10) {
            [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
            [self.footer endRefreshing];
            return;
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
        [dictionary setObject:[NSString stringWithFormat:@"%d",self.timePageNum+1] forKey:@"pageNum"];
    }else{
        [dictionary setObject:[NSString stringWithFormat:@"%d",1] forKey:@"pageNum"];
        
    }
    [dictionary setObject:@"10" forKey:@"pageSize"];
    if(isMore && self.lastId!=nil) [dictionary setObject:self.lastId forKey:@"lastid"];
    //发送请求
    __weak typeof(self)weakSelf = self;
    self.httpOpt = [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETNEWSINAFRIEND parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            if (isMore) {
                weakSelf.timePageNum++;
            }else{
                weakSelf.timePageNum = 1;
                [weakSelf.data removeAllObjects];
            }
            NSArray *tempArray = dic[@"newFriendList"];
            for (NSDictionary *dic in tempArray) {
                [weakSelf.data addObject:[intrestUserModel modelWithDic:dic]];
                weakSelf.lastId = dic[@"bookid"];
            }
            [weakSelf.table reloadData];
        }
        if (isMore) {
            [weakSelf.footer endRefreshing];
        }else{
            [weakSelf.header endRefreshing];
        }
    }];

    if (self.data.count == 0 || self.data.count%10!=0||self.data.count<self.timePageNum*10) {
        [self showAlertMsg:@"没有更多了" andFrame:CGRectZero];
        [self.footer endRefreshing];
        return;
    }
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
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableSampleIdentifier = @"searchermancell";
    
    UserListTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    if (searchCell == nil) {
        searchCell = [[[NSBundle mainBundle]loadNibNamed:@"UserListTableViewCell" owner:self options:nil]lastObject];
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSUInteger row = [indexPath row];
    searchCell.model = [self.data objectAtIndex:row];
    searchCell.msgLbl.text = [NSString stringWithFormat:@"新浪好友：%@",searchCell.model.uname];
    return searchCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    intrestUserModel *model = [self.data objectAtIndex:indexPath.row];
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = model.userid;
    [self.navigationController pushViewController:me animated:YES];
}


-(void)dealloc{
    [self.header free];
    [self.footer free];
}


@end
