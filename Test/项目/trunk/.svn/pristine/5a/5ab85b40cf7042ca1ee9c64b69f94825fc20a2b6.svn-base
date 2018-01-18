//
//  WWViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "LoginViewController.h"
//#import "RegistViewController.h"
#import "WelcomeViewController.h"
#import "OpenUDID.h"
#import "WWTolls.h"

#define HEIGHT (self.view.frame.size.height)
#define WIDTH  (self.view.frame.size.width)

@interface WelcomeViewController ()
{
    UIScrollView *scrol;
}
@property(strong,nonatomic) NSTimer* timer;
@property(strong,nonatomic) NSTimer* DJStimer;
//@property(nonatomic,strong)AVAudioPlayer *audioplayer;
//@property(weak,nonatomic) UIScrollView* scrol;
@property(nonatomic,strong)UILabel *personlbl;//人数
@property(nonatomic,assign)long long personAllsum;//总人数
@property(nonatomic,assign)long long personsum;//人数显示
@property(nonatomic,strong)UILabel *weighlbl;//减重
@property(nonatomic,assign)double weighAllsum;//总减重显示
@property(nonatomic,assign)double weighsum;//总减重
@property(nonatomic,strong)UILabel *djsLbl;//3秒倒计时
@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //        [self startPlayer];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.timer invalidate];
    [self.DJStimer invalidate];
    self.timer = nil;
    self.DJStimer = nil;
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self loginBtnAction];
    //    });
}
-(void)djs{
    
    if ([self.djsLbl.text isEqualToString:@"0秒"]) {
        [self loginBtnAction];
    }else self.djsLbl.text = [NSString stringWithFormat:@"%d秒",self.djsLbl.text.intValue-1];
}
-(void)anima{
    //人数
    long long size = _personAllsum/100;
    if (self.personsum < _personAllsum) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有%lld人",self.personsum]];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#fff100"] range:NSMakeRange(2,[NSString stringWithFormat:@"%lld",self.personsum].length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:37] range:NSMakeRange(2,[NSString stringWithFormat:@"%lld",self.personsum].length)];
        self.personlbl.attributedText = str;
        self.personsum+=size;
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已有%lld人",self.personAllsum]];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#fff100"] range:NSMakeRange(2,[NSString stringWithFormat:@"%lld",self.personAllsum].length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:37] range:NSMakeRange(2,[NSString stringWithFormat:@"%lld",self.personAllsum].length)];
        self.personlbl.attributedText = str;
        
    }
    //    else self.personlbl.text = [NSString stringWithFormat:@"已有%lld人",self.personAllsum];
    //减重
    size = _weighAllsum/100;
    if (self.weighsum <= _weighAllsum) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成功减重%.0fkg",self.weighsum]];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#fff100"] range:NSMakeRange(4,[NSString stringWithFormat:@"%.1f",self.weighsum].length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:37] range:NSMakeRange(4,[NSString stringWithFormat:@"%.0f",self.weighsum].length)];
        self.weighlbl.attributedText = str;
        //        self.weighlbl.text = ;
        self.weighsum+=size;
    }else{
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"成功减重%.0fkg",self.weighAllsum]];
        [str addAttribute:NSForegroundColorAttributeName value:[WWTolls colorWithHexString:@"#fff100"] range:NSMakeRange(4,[NSString stringWithFormat:@"%.0f",self.weighAllsum].length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:37] range:NSMakeRange(4,[NSString stringWithFormat:@"%.0f",self.weighAllsum].length)];
        self.weighlbl.attributedText = str;
        
    }
    //    else self.weighlbl.text = [NSString stringWithFormat:@"成功减重%.1fkg",self.weighAllsum];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = ZDS_BACK_COLOR;
    [self startPlayer];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        self.personAllsum = 368394;
    //        self.weighAllsum = 189304;
    //        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(anima) userInfo:nil repeats:YES];
    //    });
    
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSString *userID = nil;
    userID =  [OpenUDID value];
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString *key = [NSString getMyKey:userID];
    [dictionary setObject:userid forKey:@"userid"];
    [dictionary setObject:key forKey:@"key"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GET_TOTALPEOPLE];
    
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date =[dateFormatter dateFromString:@"2015-07-21 00:00:00"];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned int unitFlags = NSDayCalendarUnit;
        NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:[NSDate date]  options:0];
        long days = [comps day];
        self.personAllsum = 9800 + days*150 + arc4random()%50;
        self.weighAllsum = 49000 + days*150*5 + arc4random()%50;
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
        }else{
            
            if (dic[@"totalPep"] != nil) {
                self.personAllsum = [NSString stringWithFormat:@"%@",dic[@"totalPep"]].longLongValue;
            }
            if (dic[@"totalWeight"] != nil) {
                self.weighAllsum = [NSString stringWithFormat:@"%@",dic[@"totalWeight"]].doubleValue;
            }
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(anima) userInfo:nil repeats:YES];
        self.DJStimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(djs) userInfo:nil repeats:YES];
    }];
    
    
    //    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"newPage"]];
    //    image.frame = self.view.bounds;
    //    [self.view addSubview:image];
    
    //..注销掉注册按钮的触发事件..//
    //    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [registBtn setFrame:CGRectMake(30, HEIGHT-67, SCREEN_WIDTH-60, 38)];
    //    //    [registBtn setBackgroundImage:[UIImage imageNamed:@"jinru_580_84.png"] forState:UIControlStateNormal];
    //    [registBtn setTitle:@"" forState:UIControlStateNormal];
    //    [registBtn setBackgroundColor:[UIColor clearColor]];
    //    [registBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:registBtn];
    //    [_page setPageIndicatorTintColor:UIColorFromRGB(0x888888)];
    //    [_page setCurrentPageIndicatorTintColor:UIColorFromRGB(0x333333)];
    //    //    [_page addTarget:self action:@selector(pagego:) forControlEvents:UIControlEventValueChanged];//添加点击事件
    //    [self.view addSubview:_page];
    //初始化分享话述
    //    [NSUSER_Defaults setObject:@"" forKey:ZDS_APPSTOREURL]
    // Do any additional setup after loading the view.
}

-(void)startPlayer
{
    
    //    scrol = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    //    scrol.backgroundColor = ZDS_BACK_COLOR;
    //    scrol.contentSize = CGSizeMake(WIDTH*4, HEIGHT-100);
    //    [self.view addSubview:scrol];
    //
    //    UIImageView *aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, scrol.height)];
    //    [aView setImage:[UIImage imageNamed:@"1"]];
    //    [scrol addSubview:aView];
    //
    //    UIImageView *bView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, scrol.height)];
    //    [bView setImage:[UIImage imageNamed:@"2"]];
    //    [scrol addSubview:bView];
    //
    //    UIImageView *cView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 2, 0, WIDTH, scrol.height)];
    //    [cView setImage:[UIImage imageNamed:@"3"]];
    //    [scrol addSubview:cView];
    //
    //    UIImageView *dView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 3, 0, WIDTH, scrol.height)];
    //    [dView setImage:[UIImage imageNamed:@"4"]];
    //    [scrol addSubview:dView];
    //
    //
    //
    //    scrol.pagingEnabled = YES;
    //    scrol.delegate = self;
    //    scrol.bounces = NO;
    //    scrol.bouncesZoom = NO;
    //    scrol.showsHorizontalScrollIndicator = NO;
    //    self.scrol = scrol;
    //    _page = [[UIPageControl alloc] init];
    //    _page.numberOfPages = 4;
    //    _page.currentPageIndicatorTintColor = ZDS_DHL_TITLE_COLOR;
    //    _page.frame = CGRectMake(60, HEIGHT - 45,200,30);//指定位置大小
    //    _page.currentPage = 0;
    //    [self.view addSubview:_page];
    UIImageView *image = [[UIImageView alloc] init];
    image.image = [UIImage imageNamed:@"2222"];
    image.frame = self.view.bounds;
    [self.view addSubview:image];
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(SCREEN_WIDTH-13-55,13, 55, 28)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"anniu"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *djsLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 37, 28)];
    self.djsLbl = djsLbl;
    djsLbl.text = @"5秒";
    djsLbl.textColor = [UIColor whiteColor];
    djsLbl.font = MyFont(11);
    djsLbl.textAlignment = NSTextAlignmentCenter;
    [loginBtn addSubview:djsLbl];
    
    [self.view addSubview:loginBtn];
    
    //人数
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0,243*SCREEN_HEIGHT/568.0, SCREEN_WIDTH, 35)];
    if(iPhone4) lbl.top -= 10;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.font = MyFont(22);
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.text = @"已有0人";
    [self.view addSubview:lbl];
    self.personlbl = lbl;
    
    //减重
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 243*SCREEN_HEIGHT/568.0+45, SCREEN_WIDTH, 35)];
    if(iPhone4) lbl.top -= 10;
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = MyFont(22);
    lbl.text = @"成功减重0kg";
    [self.view addSubview:lbl];
    self.weighlbl = lbl;
    
    
    
    
    //定义URL  NSBundle获取文件路径
    //    NSURL *audioPath=[[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Zhidoushi_demo" ofType:@"mp3"]];
    //    NSError *error=nil;
    //    //audioPlayer初始化
    ////    self.audioplayer=[[AVAudioPlayer alloc]initWithContentsOfURL:audioPath error:&error];
    //    //设置代理
    //    self.audioplayer.delegate=self;
    //    //判断是否错误
    //    if(error!=nil)
    //    {
    //        NSLog(@"播放遇到错误了 信息：%@",[error description]);
    //        return ;
    //    }
    //    //开始播放
    //    [self.audioplayer play];
    
    //    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [loginBtn setFrame:CGRectMake(45, HEIGHT-70, 100, 40)];
    //    [loginBtn setBackgroundColor:[UIColor clearColor]];
    //    loginBtn.layer.cornerRadius = 5.0;
    //    loginBtn.layer.borderWidth = 1.0;
    //    loginBtn.layer.borderColor = [UIColor greenColor].CGColor;
    //    [loginBtn setTitle:@"注册" forState:UIControlStateNormal];
    //    [loginBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    //    [loginBtn addTarget:self action:@selector(registBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:loginBtn];
    
    //..正式版本下的按钮..//
    //        UIButton *loginBtn = [UIButtontonWithType:UIButtonTypeCustom];
    //        [loginBtn setFrame:CGRectMake((SCREEN_WIDTH-200)/2, HEIGHT-70, 200, 40)];
    //        [loginBtn setBackgroundColor:[UIColor clearColor]];
    //        loginBtn.layer.cornerRadius = 5.0;
    //        loginBtn.layer.borderWidth = 1.0;
    //        loginBtn.layer.borderColor = [UIColor greenColor].CGColor;
    //        [loginBtn setTitle:@"进入脂斗士" forState:UIControlStateNormal];
    //        [loginBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    //        [loginBtn addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    //        [self.view addSubview:loginBtn];
}

/**
 *  添加定时器
 */
//-(void)addTimer
//
//{
//
//
////    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(next) userInfo:nil repeats:YES];
//    //[[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//
//}
/**
 *  移除定时器
 */
//- (void)removeTimer
//{
////    [self.timer invalidate];
////    self.timer = nil;
//}
/**********轮播*******/
//- (void)next
//{
//
////    long page = 0;
////    page = _page.currentPage + 1;
////    if (page == 3) {
////        [self removeTimer];
////    }
////    CGFloat offsetX = page * self.scrol.frame.size.width;
////    CGPoint offset = CGPointMake(offsetX, 0);
////    [self.scrol setContentOffset:offset animated:YES];
////
//}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView //协议
//{
//    _page.currentPage = (scrollView.contentOffset.x+0.4*WIDTH) / WIDTH;
//}

/**
 *  开始拖拽的时候调用
 */
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    // 停止定时器(一旦定时器停止了,就不能再使用)
//    [self removeTimer];
//}

/**
 *  停止拖拽的时候调用
 */
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    // 开启定时器
//    [self addTimer];
//}

- (void)loginBtnAction
{
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //        NSString *URL = @"https://itunes.apple.com/cn/lookup?id=963050782";
    //        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //        [request setURL:[NSURL URLWithString:URL]];
    //        [request setHTTPMethod:@"POST"];
    //        NSHTTPURLResponse *urlResponse = nil;
    //        NSError *error = nil;
    //        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //        NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    //        NSData* data = [results dataUsingEncoding:NSUTF8StringEncoding];
    //        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //        NSDictionary *dic = result;
    //        NSArray *infoArray = [dic objectForKey:@"results"];
    //        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //        NSString *key = @"CFBundleShortVersionString";
    //        // 获取软件当前的版本号
    //        NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    //        NSString *currentVersion = dict[key];
    //
    //        if ([infoArray count]) {//获取当前app详细页
    //            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
    //            NSString *Appurl = [releaseInfo objectForKey:@"trackViewUrl"];//URL地址
    //            if (Appurl.length!=0) {
    //                [defaults setObject:Appurl forKey:@"AppUrl"];
    //            }
    //        }else{
    //            URL = @"https://itunes.apple.com/lookup?id=963050782";
    //            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //            [request setURL:[NSURL URLWithString:URL]];
    //            recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //            results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    //            data = [results dataUsingEncoding:NSUTF8StringEncoding];
    //            id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //            dic = result;
    //            infoArray = [dic objectForKey:@"results"];
    //            if ([infoArray count]) {//获取当前app详细页
    //                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
    //                NSString *Appurl = [releaseInfo objectForKey:@"trackViewUrl"];//URL地址
    //                if (Appurl.length!=0) {
    //                    [defaults setObject:Appurl forKey:@"AppUrl"];
    //                }
    //            }
    //        }
    //
    //        [defaults setObject:currentVersion forKey:key];
    //        [defaults synchronize];
    //    });
    
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:currentVersion forKey:@"CFBundleShortVersionString"];
    [defaults synchronize];
    
    
    LoginViewController *login = [[LoginViewController alloc]init];
    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:login];
    [self presentViewController:navVC animated:YES completion:^{
        //                [NSUSER_Defaults setObject:@"go" forKey:@"goin"];
        //                [NSUSER_Defaults synchronize];
    }];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)registBtnAction{
    
    //    RegistViewController *registered = [[RegistViewController alloc] init];
    //    UINavigationController *navVC = [[UINavigationController alloc]initWithRootViewController:registered];
    //    [self presentViewController:navVC animated:YES completion:^{
    //    }];
    //    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
