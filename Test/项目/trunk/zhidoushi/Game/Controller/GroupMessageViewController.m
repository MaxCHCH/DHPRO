//
//  GroupMessageViewController.m
//  zhidoushi
//
//  Created by nick on 15/6/17.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GroupMessageViewController.h"
#import "UIButton+WebCache.h"
#import "MeViewController.h"
#import "MJRefresh.h"
#import "GroupIntroModel.h"
#import "EditLoseWeightMethodViewController.h"
#import "EditCommanderIntroViewController.h"
#import "DiscoverViewController.h"

@interface GroupMessageViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong) MJRefreshHeaderView *header;
@property(nonatomic,strong)UIImageView *imageView;//封面
@property(nonatomic,strong)GroupIntroModel *model;//团组头部模型
@property(nonatomic,strong)UIScrollView *back;
@end

@implementation GroupMessageViewController

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    //友盟统计--结束
    [MobClick endLogPageView:@"团组介绍页面"];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -50;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -50;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self reloadGroupData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //友盟统计--开始
    [MobClick beginLogPageView:@"团组介绍页面"];
    
    //显示导航栏
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).notifyView.top = -70;
    ((DiscoverViewController*)((UINavigationController*)self.navigationController.tabBarController.viewControllers[1]).viewControllers[0]).y = -70;
}

-(void)viewDidLoad{
    //背景
    self.view.backgroundColor = ZDS_BACK_COLOR;
    UIScrollView *back = [[UIScrollView alloc] init];
    back.showsVerticalScrollIndicator = NO;
    back.delegate = self;
    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+50);
    [self.view addSubview:back];
    self.model = [[GroupIntroModel alloc] init];
    self.back = back;
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = back;
    //返回按钮
    UIButton *lastBtn = [[UIButton alloc] init];
    lastBtn.frame = CGRectMake(12, 12, 30, 30);
    [lastBtn setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:lastBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyHiden) name:@"notifyToggle" object:nil];
}
- (void)notifyHiden{
    self.view.clipsToBounds = NO;
    self.back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+50);
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self scrollViewDidScrollWithOffset:scrollView.contentOffset.y+60];
}
- (void)scrollViewDidScrollWithOffset:(CGFloat)scrollOffset
{
    if (scrollOffset < 0)
        self.imageView.transform = CGAffineTransformMakeScale(1 - (scrollOffset / 100), 1 - (scrollOffset / 100));
    else
        self.imageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
    

}
-(void)reloadGroupData{
    [self showWaitView];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:4];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    
    NSLog(@"游戏详细页——————————————%@",dictionary);
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GAMEMESSAGE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        [self removeWaitView];
        if (!dic[ERRCODE]) {
            weakSelf.model = [GroupIntroModel modelWithDic:dic];
            [weakSelf setUpGUI];
        }
        [weakSelf.header endRefreshing];
    }];
}
#pragma mark - 初始化UI
-(void)setUpGUI{
    //背景
//    self.view.backgroundColor = ZDS_BACK_COLOR;
//    UIScrollView *back = [[UIScrollView alloc] init];
//    back.showsVerticalScrollIndicator = NO;
//    back.delegate = self;
//    back.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+50);
//    [self.view addSubview:back];
    UIScrollView *back = self.back;
    for (UIView *view in back.subviews) {
        [view removeFromSuperview];
    }
    //团组封面
    UIImageView *header = [[UIImageView alloc] init];
    self.imageView = header;
    header.frame = CGRectMake(0, -60, SCREEN_WIDTH, SCREEN_WIDTH);
    header.backgroundColor = [UIColor whiteColor];
    [header sd_setImageWithURL:[NSURL URLWithString:self.model.imageurl]];
    [back addSubview:header];
    //黑色贴图
    UIImageView *backHead = [[UIImageView alloc] init];
    backHead.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH);
    backHead.image = [UIImage imageNamed:@"zz-640"];
    [header addSubview:backHead];
    
    UIView *bb = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH-60, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bb.backgroundColor = ZDS_BACK_COLOR;
    [back addSubview:bb];
    
    //返回按钮
    UIButton *lastBtn = [[UIButton alloc] init];
    lastBtn.frame = CGRectMake(12, 12, 30, 30);
    [lastBtn setBackgroundImage:[UIImage imageNamed:@"last"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    [back addSubview:lastBtn];
    
    //标签
    UILabel *tag = [[UILabel alloc] init];
    [back addSubview:tag];
    tag.hidden = NO;
    tag.textColor = [UIColor whiteColor];
    tag.font = MyFont(10);
    tag.textAlignment = NSTextAlignmentCenter;
    tag.layer.cornerRadius = 10;
    tag.clipsToBounds = YES;
    tag.frame = CGRectMake(12, 171, 44, 20);
    if([self.model.desctag isEqualToString:@"1"]){
        tag.text = @"官方团";
        tag.backgroundColor = [WWTolls colorWithHexString:@"#565bd9"];
    }else if([self.model.desctag isEqualToString:@"2"]){
        tag.text = @"已爆满!";
        tag.backgroundColor = [WWTolls colorWithHexString:@"#e99312"];
    }else if([self.model.desctag isEqualToString:@"3"]){
        tag.text = @"HOT!";
        tag.font = MyFont(11);
        tag.backgroundColor = [WWTolls colorWithHexString:@"#ea5041"];
    }else if([self.model.desctag isEqualToString:@"4"]){
        tag.text = @"NEW!";
        tag.font = MyFont(11);
        tag.backgroundColor = [WWTolls colorWithHexString:@"#da4a94"];
    }else if([self.model.isfull isEqualToString:@"0"]){
        tag.text = @"已爆满!";
        tag.backgroundColor = [WWTolls colorWithHexString:@"#e99312"];
    }else{
        tag.hidden = YES;
    }
    
    //团组名称
    UILabel *namelbl = [[UILabel alloc] init];
    namelbl.frame = CGRectMake(12, 167, 320, 23);
    if (!tag.hidden) {
        namelbl.left = tag.right + 3;
    }
    namelbl.font = MyFont(23);
    namelbl.textColor = [UIColor whiteColor];
    namelbl.text = self.model.gamename;
    [namelbl sizeToFit];
    [back addSubview:namelbl];

    //人数
    UIImageView *renshu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renshu2_32_32"]];
    renshu.frame = CGRectMake(12, namelbl.bottom+10, 16, 16);
    [back addSubview:renshu];
    UILabel *renshu2 = [[UILabel alloc] init];
    renshu2.frame = CGRectMake(35, namelbl.bottom+10, 70, 16);
    renshu2.font = MyFont(14);
    renshu2.textColor = [UIColor whiteColor];
    renshu2.text = [NSString stringWithFormat:@"人数 %@",self.model.totalnumpeo];
    [back addSubview:renshu2];
    
    //标签
    UILabel *taglbl = [[UILabel alloc] init];
    taglbl.frame = CGRectMake(renshu2.right - 33 + self.model.totalnumpeo.length*10  , namelbl.bottom + 6, 43, 23);
    taglbl.font = MyFont(10);
    taglbl.textAlignment = NSTextAlignmentCenter;
    taglbl.textColor = [UIColor whiteColor];
    taglbl.text = [self.model.gametags componentsSeparatedByString:@","][0];
    if (taglbl.text.length<1) {
        taglbl.hidden = YES;
    }
    taglbl.layer.cornerRadius = 9;
    taglbl.clipsToBounds = YES;
    taglbl.layer.borderWidth = 0.5;
    taglbl.layer.borderColor = [UIColor whiteColor].CGColor;
    [back addSubview:taglbl];
    
    //团组减重
    UIImageView *tuanzu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gjz-32-32"]];
    tuanzu.frame = CGRectMake(12, renshu2.bottom+9, 16, 16);
    [back addSubview:tuanzu];
    UILabel *tuanzu2 = [[UILabel alloc] init];
    tuanzu2.frame = CGRectMake(35, renshu2.bottom+9, 200, 16);
    tuanzu2.font = MyFont(14);
    tuanzu2.textColor = [UIColor whiteColor];
    tuanzu2.text = [NSString stringWithFormat:@"团组共减重 %@kg",self.model.gtotallose];
    [back addSubview:tuanzu2];
    
    //团长介绍
    UIView *taskView = [[UIView alloc] initWithFrame:CGRectMake(7.5, header.bottom + 10, SCREEN_WIDTH-15, 0)];
    taskView.backgroundColor = [UIColor whiteColor];
    [taskView makeCorner:5.0];
    [back addSubview:taskView];
    
    UIImageView *taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 18, 18)];
    [taskImageView setImage:[UIImage imageNamed:@"tzjs-36-36"]];
    [taskView addSubview:taskImageView];
    
    UILabel *taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskImageView.maxX + 12, taskImageView.midY - 7.5, 80, 15)];
    taskLabel.text = @"团长介绍";
    taskLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [taskView addSubview:taskLabel];
    
    UILabel *taskLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, taskImageView.maxY + 11, taskView.width, 0.5)];
    taskLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [taskView addSubview:taskLineLabel];
    //团长
    //头像
    UIButton *headerView = [[UIButton alloc] init];
    [taskView addSubview:headerView];
    [headerView sd_setBackgroundImageWithURL:[NSURL URLWithString:self.model.crtorimage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mrtx_98_98"]];
    headerView.titleLabel.text = self.model.gamecrtor;
    [headerView addTarget:self action:@selector(clickPater:) forControlEvents:UIControlEventTouchUpInside];
    headerView.frame = CGRectMake(12, taskLineLabel.bottom+15, 40, 40);
    headerView.layer.cornerRadius = 20;
    headerView.clipsToBounds = YES;
    
    //昵称
    UILabel *lbl = [[UILabel alloc] init];
    lbl.frame = CGRectMake(6, headerView.bottom+8,52, 40);
    lbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    lbl.text = self.model.crtorname;
    CGFloat h = [WWTolls heightForString:lbl.text fontSize:13 andWidth:52];
    lbl.height=h+1;
    lbl.numberOfLines = 0;
    lbl.font = MyFont(13);
    lbl.textAlignment = NSTextAlignmentCenter;
    [taskView addSubview:lbl];
    //团长介绍内容
    UILabel *introlbl = [[UILabel alloc] init];
    introlbl.font = MyFont(14);
    introlbl.numberOfLines = 0;
    introlbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    introlbl.text = self.model.crtorintro;
    h = [WWTolls heightForString:introlbl.text fontSize:14 andWidth:228];
    h = h>40?h:40;
    introlbl.frame = CGRectMake(headerView.right+13, taskLineLabel.bottom+19, 228, h+1);
    [taskView addSubview:introlbl];
    //团长介绍高度
    taskView.height = introlbl.bottom+15>150?introlbl.bottom+15:150;
    if ([self.model.gamecrtor isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {//团长
        UIButton *editor = [[UIButton alloc] init];
        [editor setBackgroundImage:[UIImage imageNamed:@"bj-142-60"] forState:UIControlStateNormal];
        [editor addTarget:self action:@selector(introEditor:) forControlEvents:UIControlEventTouchUpInside];
        editor.frame = CGRectMake(221, introlbl.bottom+15, 71, 30);
        [taskView addSubview:editor];
        taskView.height = editor.bottom+15;
    }
    
    //减脂方法
    taskView = [[UIView alloc] initWithFrame:CGRectMake(7.5, taskView.bottom + 10, SCREEN_WIDTH-15, 0)];
    taskView.backgroundColor = [UIColor whiteColor];
    [taskView makeCorner:5.0];
    [back addSubview:taskView];
    
    taskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 18, 18)];
    [taskImageView setImage:[UIImage imageNamed:@"rw-36"]];
    [taskView addSubview:taskImageView];
    
    taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(taskImageView.maxX + 12, taskImageView.midY - 7.5, 80, 15)];
    taskLabel.text = @"减脂方法";
    taskLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [taskView addSubview:taskLabel];
    
    taskLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, taskImageView.maxY + 11, taskView.width, 0.5)];
    taskLineLabel.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    [taskView addSubview:taskLineLabel];
    //图片
    UIImageView *fangfa = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jzff-234-140"]];
    fangfa.frame = CGRectMake(94, taskLineLabel.bottom+16, 117, 70);
    [taskView addSubview:fangfa];
    
    //减脂方法内容
    introlbl = [[UILabel alloc] init];
    introlbl.font = MyFont(14);
    introlbl.numberOfLines = 0;
    introlbl.textColor = [WWTolls colorWithHexString:@"#959595"];
    introlbl.text = [NSString stringWithFormat:@"%@",self.model.loseway];
    h = [WWTolls heightForString:introlbl.text fontSize:14 andWidth:285];
    introlbl.frame = CGRectMake(10, taskLineLabel.bottom+96, 285, h+1);
    [taskView addSubview:introlbl];
    //高度
    taskView.height = introlbl.bottom+15;
    if ([self.model.gamecrtor isEqualToString:[NSUSER_Defaults objectForKey:ZDS_USERID]]) {//团长
        UIButton *editor = [[UIButton alloc] init];
        [editor setBackgroundImage:[UIImage imageNamed:@"bj-142-60"] forState:UIControlStateNormal];
        [editor addTarget: self action:@selector(losewayEditor:) forControlEvents:UIControlEventTouchUpInside];
        editor.frame = CGRectMake(221, introlbl.bottom+15, 71, 30);
        [taskView addSubview:editor];
        taskView.height += 45;
    }
    
    //背景大小
    back.contentSize = CGSizeMake(SCREEN_WIDTH, taskView.bottom+15);
}

#pragma mark - 团长介绍编辑
-(void)introEditor:(UIButton*)btn{
    EditCommanderIntroViewController *ed = [[EditCommanderIntroViewController alloc] init];
    ed.groupId = self.groupId;
    ed.crtorintro = self.model.crtorintro;
    ed.loseway = self.model.loseway;
    ed.groupName = self.model.gamename;
    [self.navigationController pushViewController:ed animated:YES];
}
#pragma mark - 减脂方式编辑
-(void)losewayEditor:(UIButton*)btn{
    EditLoseWeightMethodViewController *ed = [[EditLoseWeightMethodViewController alloc] init];
    ed.groupId = self.groupId;
    ed.crtorintro = self.model.crtorintro;
    ed.loseway = self.model.loseway;
    ed.groupName = self.model.gamename;
    [self.navigationController pushViewController:ed animated:YES];
}
#pragma mark - 返回
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 团长点击
-(void)clickPater:(UIButton*)btn{
    if(btn.titleLabel.text.length<1) return;
    MeViewController *me = [[MeViewController alloc] init];
    me.otherOrMe = 1;
    me.userID = btn.titleLabel.text;
    [self.navigationController pushViewController:me animated:YES];
}
-(void)dealloc{
    [self.header free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
