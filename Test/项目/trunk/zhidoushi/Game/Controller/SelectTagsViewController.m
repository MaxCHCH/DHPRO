//
//  SelectTagsViewController.m
//  zhidoushi
//
//  Created by nick on 15/4/24.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SelectTagsViewController.h"
#import "CreateGroupTwoViewController.h"
#import "CreateGroupOneViewController.h"


@interface SelectTagsViewController ()
@property(strong,nonatomic)NSMutableArray *whereData;
@property(strong,nonatomic)NSMutableArray *howData;
@property(nonatomic,strong)UIScrollView *back;//背景视图
@property(nonatomic,strong)UIView *back1;//普通
@property(nonatomic,strong)UIView *back2;//28天团
@property(nonatomic,strong)UIButton *createBtn;//创建28天按钮
@property(nonatomic,strong)UIButton *createPtBtn;//创建普通团
@property(nonatomic,copy)NSString *groupType;//减脂团类型1：普通团 2：28天团
@property(nonatomic,copy)NSString *gameperiod;
@property(nonatomic,copy)NSString *crtdays;
@property(nonatomic,copy)NSString *crtbegindate;
@property(nonatomic,assign)BOOL enableCreate;//是否可以创建
@property(nonatomic,assign)BOOL isPassWordGrouper;//是否为密码团创建者
@end
@implementation SelectTagsViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"创建减脂团页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"创建减脂团页面"];
    
    self.enableCreate = NO;
    [self typeBtnClick:self.createPtBtn];
    [self loadIsEnableCreate];
}

#pragma mark - 返回
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    self.enableCreate = NO;
    self.isPassWordGrouper = NO;
    //头部导航
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.enabled = NO;
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"创建减脂团";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    //初始化数组
    self.whereData = [NSMutableArray array];
    self.howData = [NSMutableArray array];
    //初始化背景视图
    UIScrollView *back = [[UIScrollView alloc] init];
    back.frame = self.view.bounds;
    self.back = back;
    [self.view addSubview:back];
    //读取缓存
    [self readCoache];
    //加载页面
    [self setupGUI];
    //装载数据
    [self loadData];
}

#pragma mark - 读取缓存
-(void)readCoache{
    
    NSDictionary *dic = [NSUSER_Defaults valueForKey:ZDS_CREATE_TAGS];
    if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
        
    }else{
        [self.whereData removeAllObjects];
        [self.whereData addObjectsFromArray:dic[@"wherelist"]];
        [self.howData removeAllObjects];
        [self.howData addObjectsFromArray:dic[@"howlist"]];
        [self setupGUI];
    }
    
}

#pragma mark - 请求数据
-(void)loadData{
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_CREATE_TAGS];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {

        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            
        }else{
            [weakSelf.whereData removeAllObjects];
            [weakSelf.whereData addObjectsFromArray:dic[@"wherelist"]];
            [weakSelf.howData removeAllObjects];
            [weakSelf.howData addObjectsFromArray:dic[@"howlist"]];
            [NSUSER_Defaults setValue:dic forKey:ZDS_CREATE_TAGS];
            [weakSelf setupGUI];
        }
    }];
}

#pragma mark - UI
-(void)setupGUI{
    //清空view
    for (UIView *view in self.back.subviews) {
        [view removeFromSuperview];
    }
    self.back.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    self.enableCreate = NO;
    //减脂类型
    UILabel *typelbl = [[UILabel alloc] init];
    typelbl.frame = CGRectMake(-1, 7, SCREEN_WIDTH+2, 33);
    typelbl.layer.borderWidth = 0.5;
    typelbl.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    typelbl.font = MyFont(14);
    typelbl.text = @"   减脂团类型";
    typelbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    typelbl.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:typelbl];
    //普通团
    UIButton *btn = [[UIButton alloc] init];
    self.createPtBtn = btn;
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.titleLabel.font = MyFont(12);
    [btn setTitle:@"欢乐团" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn setBackgroundImage:[self buttonImageFromColor:[WWTolls colorWithHexString:@"#cacaca"]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self buttonImageFromColor:[WWTolls colorWithHexString:@"#565bdc"]] forState:UIControlStateSelected];
    btn.frame = CGRectMake(27.5, 60, (SCREEN_WIDTH-90)/2, 35);
    [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.back addSubview:btn];
    //设置初始选中
    btn.selected = YES;
    self.groupType = @"1";
    //28天团
    btn = [[UIButton alloc] init];
    self.createBtn = btn;
    btn.layer.cornerRadius = 5;
    btn.clipsToBounds = YES;
    btn.titleLabel.font = MyFont(12);
    [btn setTitle:@"28天瘦4%团" forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn setBackgroundImage:[self buttonImageFromColor:[WWTolls colorWithHexString:@"#cacaca"]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self buttonImageFromColor:[WWTolls colorWithHexString:@"#565bdc"]] forState:UIControlStateSelected];
    btn.frame = CGRectMake((SCREEN_WIDTH-90)/2+62.5, 60, (SCREEN_WIDTH-90)/2, 35);
    [btn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.back addSubview:btn];
    //设置初始选中
    btn.selected = NO;
    
    //瘦哪里视图
    UILabel *whereLbl = [[UILabel alloc] init];
    whereLbl.frame = CGRectMake(-1, 121, SCREEN_WIDTH+2, 33);
    whereLbl.layer.borderWidth = 0.5;
    whereLbl.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    whereLbl.font = MyFont(14);
    whereLbl.text = @"   瘦哪里";
    whereLbl.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    whereLbl.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:whereLbl];
    
    //限选一种
    UILabel *whereOne = [[UILabel alloc] init];
    whereOne.frame = CGRectMake(0, 159, 320, 17);
    whereOne.font = MyFont(11);
    whereOne.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    whereOne.text = @"   限选一种";
    [self.back addSubview:whereOne];
    
    CGFloat margin = 17;
    CGFloat width = (SCREEN_WIDTH-margin*5)/4;
    CGFloat height = 34;
    //标签
    for (int i = 0; i<self.whereData.count; i++) {
        btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.titleLabel.font = MyFont(12);
        [btn setTitle:self.whereData[i] forState:UIControlStateNormal];
        if ([btn.titleLabel.text isEqualToString:self.Wheretag]) {
            btn.selected = YES;
        }
        btn.titleLabel.textColor = [UIColor whiteColor];
        [btn setBackgroundImage:[self buttonImageFromColor:[WWTolls colorWithHexString:@"#cacaca"]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self buttonImageFromColor:[WWTolls colorWithHexString:@"#565bdc"]] forState:UIControlStateSelected];
        btn.tag = 1;//17 6034
        
        btn.frame = CGRectMake(i%4*(margin+width)+margin, 185+i/4*(margin+height), width, height);
        [btn addTarget:self action:@selector(whereClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.back addSubview:btn];
    }
    
    //模式介绍
    //普通
    UIView *back = [[UIView alloc] init];
    back.frame = CGRectMake(-1, btn.bottom+25, SCREEN_WIDTH+2, 500);
    back.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    back.layer.borderWidth = 0.5;
    back.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:back];
    UILabel *ll1 = [[UILabel alloc] init];
    ll1.font = MyFont(14);
    ll1.textColor = [WWTolls colorWithHexString:@"#535353"];
    ll1.frame = CGRectMake(11, 20, 120, 15);
    ll1.text = @"欢乐团";
    [back addSubview:ll1];
    UILabel *ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+12, 300, 11);
    ll2.text = @"（1）团长自行设定减脂目标、减脂方法、减脂任务等";
    [back addSubview:ll2];
    ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+30, 300, 11);
    ll2.text = @"（2）团长带领、监督团员们一起完成减脂任务";
    [back addSubview:ll2];
    ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+48, 300, 11);
    ll2.text = @"（3）与团员们多交流，互相监督，互相鼓励~";
    [back addSubview:ll2];
    self.back1 = back;
    //闯关
    back = [[UIView alloc] init];
    back.frame = CGRectMake(-1, btn.bottom+25, SCREEN_WIDTH+2, 500);
    back.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    back.layer.borderWidth = 0.5;
    back.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:back];
    ll1 = [[UILabel alloc] init];
    ll1.font = MyFont(14);
    ll1.textColor = [WWTolls colorWithHexString:@"#535353"];
    ll1.frame = CGRectMake(11, 20, 120, 15);
    ll1.text = @"28天瘦4%团";
    [back addSubview:ll1];
    ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+12, 300, 11);
    ll2.text = @"您和团员需要一起完成以下任务：";
    [back addSubview:ll2];
    ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+30, 300, 11);
    ll2.text = @"（1）4周减重4%，每周减重目标：0.5%、0.5%、1%、2%";
    [back addSubview:ll2];
    ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+48, 300, 11);
    ll2.text = @"（2）开团前2天及每周结束时，上传体重照片";
    [back addSubview:ll2];
    ll2 = [[UILabel alloc] init];
    ll2.font = MyFont(11);
    ll2.textColor = [WWTolls colorWithHexString:@"#6b6b6b"];
    ll2.frame = CGRectMake(11, ll1.bottom+66, 300, 11);
    ll2.text = @"（3）脂斗士审核通过体重照片后，即可过关";
    [back addSubview:ll2];
    back.hidden = YES;
    self.back2 = back;
    self.back.contentSize = CGSizeMake(SCREEN_WIDTH,btn.bottom+220);
}

#pragma mark - 团组类型选择
/**
 *  团组类型选择
 *
 *  @param btn 团组类型按钮
 */
-(void)typeBtnClick:(UIButton*)btn{
    if (btn == self.createPtBtn) {//普通团
        self.back1.hidden = NO;
        self.back2.hidden = YES;
        self.groupType = @"1";
        btn.selected = YES;
        self.createBtn.selected = NO;
    }else if(btn == self.createBtn){//28天团
        if (self.enableCreate) {
            self.back2.hidden = NO;
            self.back1.hidden = YES;
            self.groupType = @"2";
            btn.selected = YES;
            self.createPtBtn.selected = NO;
        }else{
            [self showAlertMsg:@"你暂时不能创建28天团！" andFrame:CGRectMake(60, 100, 200, 50)];
        }
        
    }
}

#pragma mark - 请求是否可创建28天团组
-(void)loadIsEnableCreate{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_CREATECHK] parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        
        if (!dic[ERRCODE]) {
            NSString * createflg = [dic objectForKey:@"createflg"];
            if([createflg isEqualToString:@"0"]){//0 可创建
                self.gameperiod = dic[@"gameperiod"];
                self.crtdays = dic[@"crtdays"];
                self.crtbegindate = dic[@"crtbegindate"];
                weakSelf.enableCreate = YES;
            }else{
                weakSelf.enableCreate = NO;
            }
            if ([dic[@"ispasswd"] isEqualToString:@"0"]) {//创建私密团
                weakSelf.isPassWordGrouper = YES;
            }else weakSelf.isPassWordGrouper = NO;
            self.rightButton.enabled = YES;
        }
    }];
    
}
#pragma mark - 下一步
-(void)Next{
    if([self.groupType isEqualToString:@"2"]){//1普通团
        CreateGroupOneViewController * create = [[CreateGroupOneViewController alloc]init];
        create.isPassWordGrouper = self.isPassWordGrouper;
        create.gamedays = [self.gameperiod intValue];
        create.days = [self.crtdays intValue];
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        [inputFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* inputDate = [inputFormatter dateFromString:self.crtbegindate];
        create.theBeginDate = inputDate;
        create.Wheretag = self.Wheretag;
        [self.navigationController pushViewController:create animated:YES];
    }else if([self.groupType isEqualToString:@"1"]){//28天团
        CreateGroupTwoViewController * create = [[CreateGroupTwoViewController alloc]init];
        create.isPassWordGrouper = self.isPassWordGrouper;
        create.Wheretag = self.Wheretag;
        [self.navigationController pushViewController:create animated:YES];
    }
}
#pragma mark - 瘦哪里点击事件
-(void)whereClick:(UIButton*)btn{
    if (btn.tag == 1) {//瘦哪里
        for (UIView *view in self.back.subviews) {
            if (view.tag == 1) {//瘦哪里
                ((UIButton*)view).selected = NO;
            }
        }
        btn.selected = YES;
        self.Wheretag = btn.titleLabel.text;
    }
}

#pragma mark - 通过颜色生成图片
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.back.frame.size.width, self.back.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


@end
