//
//  MyFriendViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "MyFriendViewController.h"

//..netWork..//
#import "JSONKit.h"
#import "XLConnectionStore.h"
#import "WWRequestOperationEngine.h"
//..private..//
//#import "CoachModel.h"
#import "MyAttentionTableView.h"
#import "NSString+NARSafeString.h"
#import "UIViewController+ShowAlert.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSObject+NARSerializationCategory.h"
//....//
#import "XTabBar.h"
#import "Define.h"
#import "WWTolls.h"
#import "UIViewExt.h"
#import "MobClick.h"
#import "NewFViewController.h"
#import "SearchResultsViewController.h"

#import "UserFunsListViewController.h"
#import "UserFollowListViewController.h"

@interface MyFriendViewController ()<MyAttentionTableViewDelegate,MyattentionSwipDelegate>
{
    NSString *pageSizeNumber;//每页条数
    NSString *requestURL;
    NSString *requestType;
    NSInteger arrayCount;//数组里有多少内容
}
@property(nonatomic,strong)MyAttentionTableView * attentionView;

@property(nonatomic,strong)MyAttentionTableView * fansView;

@property(nonatomic,strong)MyAttentionTableView * friendsView;


@end

static NSInteger pageNumber;//页数

@implementation MyFriendViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"我的联系人页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的联系人页面"];
    
    //我的联系人
    self.attentionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleLabel.text = [NSString stringWithFormat:@"朋友"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    
    //左上返回按钮
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;
    
    labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    //导航栏搜索
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"home_searchIcon_36_36"] forState:UIControlStateNormal];
    self.rightButton.width = 18;
    self.rightButton.height = 18;
    [self.rightButton addTarget:self action:@selector(goToSearch) forControlEvents:UIControlEventTouchUpInside];
    //    加载数据
    [self reloadViewData];
    
    //    新好友消息
    [self receiveNewFriendsMessage];
    [self refreshMyData];
    
}
#pragma mark - 去往搜索页面
-(void)goToSearch{
    [MobClick event:@"HomeSearch"];
    SearchResultsViewController *search = [[SearchResultsViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
//    SearchUserViewController *search = [[SearchUserViewController alloc] init];
//    [self.navigationController pushViewController:search animated:YES];
}
-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.dianFriendsImageView.clipsToBounds = YES;
    self.dianFriendsImageView.layer.cornerRadius = 5;
    _attentionView = [[MyAttentionTableView alloc]initWithFrame:CGRectMake(0, self.redLineView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-105)];
    _attentionView.scrollsToTop = YES;
    _attentionView.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
    _attentionView.attentionTableViewDelegate = self;
    [_attentionView initMyTableView:@"1"  myurl:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFLWLIST]];
    [self.view addSubview:_attentionView];
    
    //..加载数据..//
    pageNumber = 1;
    pageSizeNumber = [NSString stringWithFormat:@"%d",10];
    requestType = @"1";
    requestURL = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFLWLIST];
    
    //首先刷新
    [self refreshMyData];
    
    
    //    kenshin
    //    左划代理
    _attentionView.attentionSwipDelegate = self;
}



-(void)switchView:(NSString* )switchDirection
{
    //    swip手势方法替换为pan手势
    if ([switchDirection isEqualToString:@"Left"])
    {
        NSLog(@"向右切换");
        
        //        当前为1 关注
        if ([requestType isEqualToString:@"1"])
        {
            [self fansButton:self.fansButton];
        }
        
    }
    else if ([switchDirection isEqualToString:@"Right"])
    {
        NSLog(@"向左切换");
        if ([requestType isEqualToString:@"2"])
        {
            [self attentionButton:self.attentionButton];
        }
    }
}



#define normalColor [UIColor blackColor]
#define selectColor RGBCOLOR(87, 95, 214)

#pragma mark - 点击了新朋友 type3
- (IBAction)newFriendsButton:(id)sender {
    NewFViewController *f = [[NewFViewController alloc] init];
    [self.navigationController pushViewController:f animated:YES];
}

#pragma mark - 点击了粉丝 type2
- (IBAction)fansButton:(id)sender {
    
    UserFunsListViewController *userfuns = [[UserFunsListViewController alloc] init];
    userfuns.seeuserId = [NSUSER_Defaults objectForKey:ZDS_USERID];
    [self.navigationController pushViewController:userfuns animated:YES];
    
    CGRect myrect = self.redLineView.frame;
    myrect.size.width = 50.f;
//    myrect.origin.x = 136;
    myrect.origin.x = SCREEN_WIDTH * 0.5 - myrect.size.width * 0.5;
    
    self.fansLabel.textColor = selectColor;
    
    self.txtFriends.textColor = normalColor;
    
    self.attentionLabel.textColor = normalColor;
    self.attentionView.contentOffset = CGPointZero;
    __weak typeof(self) weakself = self;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView animateWithDuration:0.2 animations:^{
        weakself.redLineView.frame = myrect;
    }];
    
    //刷新数据
    requestType = @"2";
    requestURL = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFNSLIST];
    [_attentionView initMyTableView:@"2"  myurl:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFNSLIST]];
    [self getAttentionData:pageNumber pageSizeFor:pageSizeNumber andURL:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFNSLIST] atype:@"2"];
    [self refreshMyData];
    
    _attentionView.backgroundColor = RGBCOLOR(239, 239, 239);
}

#pragma mark - 点击了关注 type1
- (IBAction)attentionButton:(id)sender {
    
    UserFollowListViewController *userfollow = [[UserFollowListViewController alloc] init];
    userfollow.seeuserId = [NSUSER_Defaults objectForKey:ZDS_USERID];
    [self.navigationController pushViewController:userfollow animated:YES];
    
    CGRect myrect = self.redLineView.frame;
    myrect.size.width = 50.f;
//    myrect.origin.x = 29;
    myrect.origin.x = SCREEN_WIDTH / 3 * 0.5 - myrect.size.width * 0.5;
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakself.redLineView.frame = myrect;
    }];
    
    self.attentionLabel.textColor = selectColor;
    self.txtFriends.textColor = normalColor;
    
    self.fansLabel.textColor = normalColor;
    [_attentionView setContentOffset:CGPointZero animated:NO];
    requestType = @"1";
    requestURL = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFLWLIST];
    [_attentionView initMyTableView:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFLWLIST]  myurl:@"1"];
    [self getAttentionData:pageNumber pageSizeFor:pageSizeNumber andURL:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETFLWLIST] atype:@"1"];
    
    
    [self refreshMyData];
    
    _attentionView.backgroundColor = RGBCOLOR(239, 239, 239);
}

#pragma mark - //..获取我的联系人信息..//
-(void)getAttentionData:(NSInteger)page pageSizeFor:(NSString*)pageSize andURL:(NSString*)and_url atype:(NSString*)a_type{
    //[self showWaitView];
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString *key = [NSString getMyKey:userID];
    __weak typeof(self) weakself = self;
    [[XLConnectionStore shareConnectionStore]getAttentionListWithPageNum:[NSString stringWithFormat:@"%ld",page] andPageSize:pageSize andURL:and_url  andUserid:userid andKey:key andAttentionType:a_type andComplection:^(id data, NSString *error) {
        if (page == 1) {
            //..首先移除数组中数据..//
            [_attentionView.dataArray removeAllObjects];
            
        }
        NSLog(@"attention数据***************%@",data);
        //        NSMutableArray * array =
        //        if (_attentionView.dataArray==nil || _attentionView.dataArray.count==0) {
        //            _attentionView.dataArray = [NSMutableArray arrayWithArray:[data restoreObjectsFromArray]];
        //        }else{
        NSArray * array = [data restoreObjectsFromArray];
        for (id MyObjectModel in array) {
            [_attentionView.dataArray addObject:MyObjectModel];
        }
        //        }
        arrayCount = _attentionView.dataArray.count;
        
        [_attentionView reloadData];
        [_attentionView endRefresh];
//        
//        if (arrayCount<10) {
//            [weakself initFooterViewFrame:CGRectMake(0,_attentionView.contentSize.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        }else{
//        }
        //[self initFooterViewFrame:CGRectMake(0,self.coachTableView.contentSize.height, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self removeWaitView];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadViewData{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETCOUNT];
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakself.fansLabel.text =[NSString stringWithFormat:@"粉丝 %@",[dic objectForKey:@"fansCount"]];
                weakself.attentionLabel.text = [NSString stringWithFormat:@"关注 %@",[dic objectForKey:@"flwCount"]];
                weakself.friendLabel.text = [NSString stringWithFormat:@"新朋友%@",[dic objectForKey:@"flwCount"]];
            });
        }
    }];
}

#pragma mark --加载
-(void)uploadMyData
{
    NSLog(@"*******我加载了*********");
    if (arrayCount%10==0&&arrayCount>=pageNumber*10) {
        pageNumber++;
        [self getAttentionData:pageNumber pageSizeFor:pageSizeNumber andURL:requestURL atype:requestType];
    }
}

#pragma mark --刷新
-(void)refreshMyData;
{
    NSLog(@"******我刷新了******");
    pageNumber = 1;
    
    [self getAttentionData:pageNumber pageSizeFor:pageSizeNumber andURL:requestURL atype:requestType];
}

-(void)receiveNewFriendsMessage
{
    //如果有电话号码的话
    self.dianFriendsImageView.hidden = YES;
    NSString *myString = [NSUSER_Defaults objectForKey:@"newFriendPhones"];
    if(myString.length!=0 && [myString isKindOfClass:[NSString class]])
    {
        self.dianFriendsImageView.hidden = NO;
    }
    NSString *myString2 = [NSUSER_Defaults objectForKey:@"newFriendSina"];
    if(myString2.length!=0 && [myString2 isKindOfClass:[NSString class]])
    {
        self.dianFriendsImageView.hidden = NO;
    }
}

@end
