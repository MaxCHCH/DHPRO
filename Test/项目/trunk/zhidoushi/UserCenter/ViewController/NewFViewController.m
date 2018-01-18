//
//  NewFriendsViewController.m
//  zhidoushi
//
//  Created by nick on 15/6/1.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "NewFViewController.h"
#import "SearchResultsViewController.h"
#import "PhoneBookViewController.h"
#import "SinaWeiboViewController.h"
#import "XTabBar.h"
#import "WXApi.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"


@interface NewFViewController () <UISearchBarDelegate>
@property(nonatomic,strong) UILabel * phonered;//通讯录红点
@property(nonatomic,strong)UILabel *sinared;//微信红点
@property(nonatomic,strong)UIView *wxbg;//微信
@property(nonatomic,strong)UIView *qqbg;//QQ
@property (nonatomic,strong) UISearchBar *searchBar;
@end

@implementation NewFViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"添加朋友"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"添加朋友"];
    
    self.titleLabel.text = [NSString stringWithFormat:@"添加朋友"];
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
    
//    //导航栏搜索
//    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"home_searchIcon_36_36"] forState:UIControlStateNormal];
//    self.rightButton.width = 18;
//    self.rightButton.height = 18;
//    [self.rightButton addTarget:self action:@selector(goToSearch) forControlEvents:UIControlEventTouchUpInside];
    
    //    新好友消息
    [self receiveNewFriendsMessage];
}
#pragma mark - 去往搜索页面
-(void)goToSearch{
    [MobClick event:@"HomeSearch"];
    SearchResultsViewController *search = [[SearchResultsViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
//    SearchResultsViewController *search = [[SearchResultsViewController alloc] init];
//    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [MobClick event:@"HomeSearch"];
    SearchResultsViewController *search = [[SearchResultsViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
    return NO;
}

-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpGUI];
}


-(void)setUpGUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *searchView = [[UIView alloc] init];
    searchView.backgroundColor = ZDS_BACK_COLOR;
    searchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    [self.view addSubview:searchView];
    
    //搜索框
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 8, SCREEN_WIDTH-20, 28)];
    _searchBar.placeholder = @"Search";
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.layer.borderWidth = 0;
    _searchBar.layer.cornerRadius = 14;
    _searchBar.clipsToBounds = YES;
    //UIView *searchTextField = [[[_searchBar.subviews firstObject] subviews] lastObject];
    UIView *searchTextField = [self.searchBar.subviews objectAtIndex:0];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.layer.cornerRadius = 14;
    searchTextField.clipsToBounds = YES;
    _searchBar.backgroundColor = [UIColor whiteColor];
    //_searchBar.barStyle = UIBarStyleDefault;
    _searchBar.delegate = self;
    [searchView addSubview:_searchBar];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
//    self.searchBar.backgroundImage = imageView.image;
    
    UIView *friendbbg = [[UIView alloc] init];
    friendbbg.backgroundColor = ZDS_BACK_COLOR;
    friendbbg.frame = CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-44);
    [self.view addSubview:friendbbg];
    
    //通讯录好友
    UIView *bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    bg.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phonebook)];
    [bg addGestureRecognizer:tap];
    
    UIImageView *imagephone = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 20, 20)];
    imagephone.image = [UIImage imageNamed:@"txl-42"];
    [bg addSubview:imagephone];
    
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(45, 15, 100, 15);
    lbl.text = @"通讯录好友";
    lbl.font = MyFont(14);
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    [bg addSubview:lbl];
    UIImageView *more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
    more.frame = CGRectMake(SCREEN_WIDTH-30, 15, 15, 15);
    [bg addSubview:more];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(45, 43, SCREEN_WIDTH-30, 0.5)];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [bg addSubview:line];
    UILabel *red = [[UILabel alloc] init];
    self.phonered = red;
    [bg addSubview:red];
    red.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    red.layer.cornerRadius = 7.5;
    red.clipsToBounds = YES;
    red.textColor = [UIColor whiteColor];
    red.frame = CGRectMake(SCREEN_WIDTH-52, 15, 15, 15);
    red.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
    //    red.hidden = YES;
    red.userInteractionEnabled = NO;
    //[self.view addSubview:bg];
    [friendbbg addSubview:bg];
    
    //微博好友
    bg = [[UIView alloc] init];
    bg.backgroundColor = [UIColor whiteColor];
    bg.frame = CGRectMake(0, 44, SCREEN_WIDTH, 44);
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sina)];
    [bg addGestureRecognizer:tap];
    
    imagephone = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 20, 20)];
    imagephone.image = [UIImage imageNamed:@"wb-42"];
    [bg addSubview:imagephone];
    
    lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(45, 15, 100, 15);
    lbl.text = @"微博好友";
    lbl.font = MyFont(14);
    lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    [bg addSubview:lbl];
    more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
    more.frame = CGRectMake(SCREEN_WIDTH-30, 15, 15, 15);
    [bg addSubview:more];
    line = [[UIView alloc] initWithFrame:CGRectMake(45, 43, SCREEN_WIDTH-30, 0.5)];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [bg addSubview:line];
    red = [[UILabel alloc] init];
    self.sinared = red;
    [bg addSubview:red];
    red.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
    red.textColor = [UIColor whiteColor];
    red.layer.cornerRadius = 7.5;
    red.clipsToBounds = YES;
    red.frame = CGRectMake(SCREEN_WIDTH-52, 15, 15, 15);
    red.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
    //    red.hidden = YES;
    red.userInteractionEnabled = NO;
    //[self.view addSubview:bg];
    [friendbbg addSubview:bg];
    
    if ([WXApi isWXAppInstalled]) {
        //微信好友
        bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        bg.frame = CGRectMake(0, 88, SCREEN_WIDTH, 44);
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wx)];
        [bg addGestureRecognizer:tap];
        
        imagephone = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 20, 20)];
        imagephone.image = [UIImage imageNamed:@"wx-42"];
        [bg addSubview:imagephone];
        
        lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(45, 15, 100, 15);
        lbl.text = @"微信好友";
        lbl.font = MyFont(14);
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        [bg addSubview:lbl];
        more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
        more.frame = CGRectMake(SCREEN_WIDTH-30, 15, 15, 15);
        [bg addSubview:more];
        line = [[UIView alloc] initWithFrame:CGRectMake(45, 43, SCREEN_WIDTH-30, 0.5)];
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [bg addSubview:line];
        //[self.view addSubview:bg];
        [friendbbg addSubview:bg];
    }
    if ([QQApiInterface isQQInstalled]) {
        //qq好友
        bg = [[UIView alloc] init];
        bg.backgroundColor = [UIColor whiteColor];
        bg.frame = CGRectMake(0, 132, SCREEN_WIDTH, 44);
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qq)];
        [bg addGestureRecognizer:tap];
        
        imagephone = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 20, 20)];
        imagephone.image = [UIImage imageNamed:@"qq-42"];
        [bg addSubview:imagephone];
        
        lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(45, 15, 100, 15);
        lbl.text = @"QQ好友";
        lbl.font = MyFont(14);
        lbl.textColor = [WWTolls colorWithHexString:@"#535353"];
        [bg addSubview:lbl];
        more = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_more_26_26"]];
        more.frame = CGRectMake(SCREEN_WIDTH-30, 15, 15, 15);
        [bg addSubview:more];
        line = [[UIView alloc] initWithFrame:CGRectMake(45, 43, SCREEN_WIDTH-30, 0.5)];
        if (!iPhone4) {
            line.height = 0.3;
        }
        line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
        [bg addSubview:line];
        //[self.view addSubview:bg];
        [friendbbg addSubview:bg];
    }

    //微信邀请视图
    self.wxbg = [[UIView alloc] init];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBg)];
    [_wxbg addGestureRecognizer:tap];
    _wxbg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _wxbg.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-265, SCREEN_WIDTH, 200)];
    bg.backgroundColor = [UIColor whiteColor];
    lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, 15, SCREEN_WIDTH, 15);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    lbl.font = MyFont(14);
    lbl.text = @"邀请";
    [bg addSubview:lbl];
    //微信好友
    UIButton *btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"weixinhaoyou-120-156"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(67, 45, 60, 78);
    [btn addTarget:self action:@selector(wxhy) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    //微信朋友圈
    btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"pengyouquan-120-156"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREEN_WIDTH-129, 45, 60, 78);
    [btn addTarget:self action:@selector(wxpyq) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    //取消
    btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(17.5, 140, SCREEN_WIDTH-35, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"quxiao-570-80"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideBg) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    [_wxbg addSubview:bg];
    [self.view addSubview:_wxbg];
    
    
    //qq邀请视图
    self.qqbg = [[UIView alloc] init];
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBg)];
    [_qqbg addGestureRecognizer:tap];
    _qqbg.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _qqbg.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-265, SCREEN_WIDTH, 200)];
    bg.backgroundColor = [UIColor whiteColor];
    lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(0, 15, SCREEN_WIDTH, 15);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    lbl.font = MyFont(14);
    lbl.text = @"邀请";
    [bg addSubview:lbl];
    //qq好友
    btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"qq-120-156"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(67, 45, 60, 78);
    [btn addTarget:self action:@selector(qqhy) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    //qq空间
    btn = [[UIButton alloc] init];
    [btn setBackgroundImage:[UIImage imageNamed:@"qqkj-120-156"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(SCREEN_WIDTH-129, 45, 60, 78);
    [btn addTarget:self action:@selector(qqkj) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    //取消
    btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(17.5, 140, SCREEN_WIDTH-35, 40);
    [btn setBackgroundImage:[UIImage imageNamed:@"quxiao-570-80"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hideBg) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btn];
    [_qqbg addSubview:bg];
    [self.view addSubview:_qqbg];
    self.qqbg.hidden = YES;
    self.wxbg.hidden = YES;
    
}
#define zdsURL @"http://a.app.qq.com/o/simple.jsp?pkgname=com.health.fatfighter"
#pragma mark - 邀请微信好友
-(void)wxhy{
    self.wxbg.hidden = YES;
    [NSUSER_Defaults setObject:@"007" forKey:ZDS_WEIXINJUDGE];
    [NSUSER_Defaults synchronize];
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//分享内容带图片和文字时必须为NO
    UIImage *image = [UIImage imageNamed:@"ICON_120.png"];
    NSString *title = @"推荐脂斗士给你";
    //设置这个路径是为了点击聊天列表的气泡时也可以跳转
    WXWebpageObject *ext = [WXWebpageObject object];
    
    //获取app网址
    NSString *url = zdsURL;
    ext.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    message.mediaObject = ext;
    //如果分享的内容包括文字和图片,这个时候的文字不能使用req.text属性来接收,必须使用下边的两个属性
    message.title = title;
    message.description =[NSString stringWithFormat:@"来脂斗士搜“%@”，跟我一起快乐减脂吧！",[NSUSER_Defaults objectForKey:ZDS_USERNAME]];
    req.message = message;
    req.scene = WXSceneSession;//微信
    [WXApi sendReq:req];
}
#pragma mark - 邀请微信朋友圈
-(void)wxpyq{
    self.wxbg.hidden = YES;
    [NSUSER_Defaults setObject:@"007" forKey:ZDS_WEIXINJUDGE];
    [NSUSER_Defaults synchronize];
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;//分享内容带图片和文字时必须为NO
    UIImage *image = [UIImage imageNamed:@"ICON_120.png"];
    //设置这个路径是为了点击聊天列表的气泡时也可以跳转
    WXWebpageObject *ext = [WXWebpageObject object];
    
    NSString *url = zdsURL;
    ext.webpageUrl = url;
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:image];
    message.mediaObject = ext;
    //如果分享的内容包括文字和图片,这个时候的文字不能使用req.text属性来接收,必须使用下边的两个属性
    message.title = [NSString stringWithFormat:@"来脂斗士搜“%@”，跟我一起快乐减脂吧！",[NSUSER_Defaults objectForKey:ZDS_USERNAME]];
    message.description = @"";
    req.message = message;
    //    if (shartType == 1) {
    req.scene = WXSceneTimeline;//微信朋友圈
    
    [WXApi sendReq:req];
}

#pragma mark - 邀请qq
-(void)qqhy{
    [UMSocialData defaultData].extConfig.qqData.url = zdsURL;
    [UMSocialData defaultData].extConfig.qqData.title = @"推荐脂斗士给你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"来脂斗士搜“%@”，跟我一起快乐减脂吧！",[NSUSER_Defaults objectForKey:ZDS_USERNAME]] image:[UIImage imageNamed:@"ICON_120"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
        }
    }];
    self.qqbg.hidden = YES;
}

#pragma mark - 邀请qq空间
-(void)qqkj{
     [UMSocialData defaultData].extConfig.qzoneData.url = zdsURL;
     [UMSocialData defaultData].extConfig.qzoneData.title = @"推荐脂斗士给你";
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"来脂斗士搜“%@”，跟我一起快乐减脂吧！",[NSUSER_Defaults objectForKey:ZDS_USERNAME]] image:[UIImage imageNamed:@"ICON_120"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
        }
    }];
    self.qqbg.hidden = YES;
}

#pragma mark - 通讯录好友
-(void)phonebook{
    self.phonered.hidden = YES;
    [NSUSER_Defaults removeObjectForKey:@"newFriendPhones"];
    [[XTabBar shareXTabBar] friendDian];
    PhoneBookViewController *phone = [[PhoneBookViewController alloc] init];
    [self.navigationController pushViewController:phone animated:YES];
}

#pragma mark - 新浪微博好友
-(void)sina{
    self.sinared.hidden = YES;
    [NSUSER_Defaults removeObjectForKey:@"newFriendSina"];
    [[XTabBar shareXTabBar] friendDian];
    SinaWeiboViewController *phone = [[SinaWeiboViewController alloc] init];
    [self.navigationController pushViewController:phone animated:YES];
}

#pragma mark - 微信好友
-(void)wx{
    self.wxbg.hidden = NO;
}

#pragma mark - QQ好友
-(void)qq{
    self.qqbg.hidden = NO;
}
#pragma mark - 隐藏视图
-(void)hideBg{
    self.wxbg.hidden = YES;
    self.qqbg.hidden = YES;
}
-(void)receiveNewFriendsMessage
{
    //如果有电话号码的话
    NSString *myString = [NSUSER_Defaults objectForKey:@"newFriendPhones"];
    NSString *myString2 = [NSUSER_Defaults objectForKey:@"newFriendSina"];
    if(myString.length!=0 && [myString isKindOfClass:[NSString class]])
    {
        int sum = myString.intValue;
        NSString *title = sum==1?@" ":sum>99?@"99+":[NSString stringWithFormat:@"%d",sum];
        //        [btnSum setTitle:title forState:UIControlStateNormal];
        self.phonered.text = title;
        self.phonered.textAlignment = NSTextAlignmentCenter;
        if(sum == 1) self.phonered.frame = CGRectMake(SCREEN_WIDTH-50, 17, 10, 10);
        else if(sum<10&&sum>1) self.phonered.frame = CGRectMake(SCREEN_WIDTH-52, 15, 15, 15);
        else if(sum > 99) self.phonered.frame = CGRectMake(SCREEN_WIDTH-66, 15, 29, 15);
        else self.phonered.frame = CGRectMake(SCREEN_WIDTH-57, 15, 20, 15);
        self.phonered.layer.cornerRadius = 7.5;
        if(sum == 1) self.phonered.layer.cornerRadius = 5;
        self.phonered.clipsToBounds = YES;
        self.phonered.userInteractionEnabled = NO;
        self.phonered.hidden = NO;
    }else{
        self.phonered.hidden = YES;
    }
    if(myString2.length!=0 && [myString2 isKindOfClass:[NSString class]])
    {
        int sum = myString2.intValue;
        NSString *title = sum==1?@" ":sum>99?@"99+":[NSString stringWithFormat:@"%d",sum];
        self.sinared.text = title;
        self.sinared.textColor = [UIColor whiteColor];
        self.sinared.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        self.sinared.textAlignment = NSTextAlignmentCenter;
        if(sum == 1) self.sinared.frame = CGRectMake(SCREEN_WIDTH-50, 17, 10, 10);
        else if(sum<10&&sum>1) self.sinared.frame = CGRectMake(SCREEN_WIDTH-52, 15, 15, 15);
        else if(sum > 99) self.sinared.frame = CGRectMake(SCREEN_WIDTH-66, 15, 29, 15);
        else self.sinared.frame = CGRectMake(SCREEN_WIDTH-57, 15, 20, 15);
        self.sinared.layer.cornerRadius = 7.5;
        if(sum == 1) self.sinared.layer.cornerRadius = 5;
        self.sinared.clipsToBounds = YES;
        self.sinared.userInteractionEnabled = NO;
        self.sinared.hidden = NO;
        self.sinared.hidden = NO;
    }else{
        self.sinared.hidden = YES;
    }

}

@end
