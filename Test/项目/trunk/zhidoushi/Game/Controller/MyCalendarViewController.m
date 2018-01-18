//
//  MyCalendarViewController.m
//  zhidoushi
//
//  Created by nick on 15/10/21.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyCalendarViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "CalendarDetailViewController.h"
#import "CalendarView.h"
#import "MJPhoto.h"
#import "PushCardViewController.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "AllWeekViewController.h"
#import <TuSDKGeeV1/TuSDKGeeV1.h>

@interface MyCalendarViewController ()<CalendarDelegate,CalendarDataSource>
{
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
}
@property(nonatomic,strong)CalendarView *calendar;//日历
@property(nonatomic,copy)NSString *today;//今天
@property(nonatomic,strong)NSMutableDictionary *data;//打卡数据
@property(nonatomic,copy)NSString *currentYM;//显示年月
@property(nonatomic,strong)UIView *mengceng;//未打卡蒙层
@property(nonatomic,strong)UIView *redDian;//红点
@end

@implementation MyCalendarViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"蜕变日记"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //友盟打点
    [MobClick beginLogPageView:@"蜕变日记"];
    //导航栏标题
    self.titleLabel.text = @"蜕变日记";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(17);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"周记" forState:UIControlStateNormal];
    if (!self.redDian) {
        UIView *red = [[UIView alloc] init];
        self.redDian = red;
        red.frame = CGRectMake(32, 0, 10, 10);
        red.backgroundColor = [UIColor redColor];
        red.layer.cornerRadius = 5;
        red.clipsToBounds = YES;
        [self.rightButton addSubview:red];
    }
    if ([[NSUSER_Defaults objectForKey:@"weekreddian"] isEqualToString:@"YES"]) {
        self.redDian.hidden = NO;
    }else self.redDian.hidden = YES;
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton addTarget:self action:@selector(goToWeek) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.rightButton.width = 40;
    self.rightButton.height = 25;
}

#pragma mark - 前往周记
- (void)goToWeek{
    AllWeekViewController *week = [AllWeekViewController new];
    [self.navigationController pushViewController:week animated:YES];
}
#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if(!self.today)
        [self reloadDataWithIsRefresh:NO];
}

- (void)reloadDataWithIsRefresh:(BOOL)isRefresh{
    
    [self showWaitView];
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    if (!isRefresh && self.today && self.today.length>0) {
        if ([self.data objectForKey:self.currentYM]) {
            NSDictionary *dic = [self.data objectForKey:self.currentYM];
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dd in dic[@"punchlist"]) {
                singinModel *model = [singinModel modelWithDic:dd];
                [array addObject:model];
            }
            self.calendar.currentDate = [NSString stringWithFormat:@"%@01",self.currentYM];
            self.calendar.data = array;
            [self removeWaitView];
            return;
        }
        [dictionary setObject:self.currentYM forKey:@"punchym"];
    }
    
    //发送请求
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GROUP_GET_CALENDAR parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dd in dic[@"punchlist"]) {
                singinModel *model = [singinModel modelWithDic:dd];
                [array addObject:model];
            }
            
            if (!isRefresh && weakSelf.today && weakSelf.today.length>0) {
                [weakSelf.data setObject:dic forKey:weakSelf.currentYM];
            }else{
                weakSelf.today = dic[@"today"];
//                weakSelf.today = @"20151112";
                weakSelf.calendar.today = weakSelf.today;
//                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//                [formatter setDateFormat:@"yyyyMMdd"];
//                NSDate *date=[formatter dateFromString:weakSelf.today];
//                weakSelf.calendar.calendarDate = date;
                self.currentYM = [weakSelf.today substringToIndex:6];
                self.calendar.currentDate = self.today;
                [weakSelf.data setObject:dic forKey:self.currentYM];
                if(iPhone4){
                    UIScrollView *back = [[UIScrollView alloc] initWithFrame:self.view.bounds];
                    back.bounces = NO;
                    back.contentSize = CGSizeMake(SCREEN_WIDTH, 500);
                    back.showsVerticalScrollIndicator = NO;
                    back.showsHorizontalScrollIndicator = NO;
                    [self.view addSubview:back];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [back addSubview:self.calendar];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view addSubview:self.calendar];
                    });
                }
                if (![self.isDaka isEqualToString:@"0"]) {//未打卡
                    //背景
                    UIView *mengceng = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT + 50)];
                    mengceng.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDaka)];
                    [mengceng addGestureRecognizer:tap];
                    self.mengceng = mengceng;
                    //打卡按钮
                    UIButton *daka = [[UIButton alloc] init];
                    [daka setBackgroundImage:[UIImage imageNamed:@"daka-djh-220"] forState:UIControlStateNormal];
                    [daka addTarget:self action:@selector(daka) forControlEvents:UIControlEventTouchUpInside];
                    daka.frame = CGRectMake(SCREEN_MIDDLE(110), SCREEN_HEIGHT_MIDDLE(110), 110, 110);
                    [mengceng addSubview:daka];
                    //取消按钮
                    UIButton *cancel = [[UIButton alloc] init];
                    [cancel setBackgroundImage:[UIImage imageNamed:@"ckrl-32-136"] forState:UIControlStateNormal];
                    [cancel addTarget:self action:@selector(cancelDaka) forControlEvents:UIControlEventTouchUpInside];
                    cancel.frame = CGRectMake(SCREEN_MIDDLE(68), SCREEN_HEIGHT - 28 - 16, 68, 16);
                    [mengceng addSubview:cancel];
                    [[UIApplication sharedApplication].keyWindow addSubview:mengceng];
                }
            }
            weakSelf.calendar.currentDate = [NSString stringWithFormat:@"%@01",self.currentYM];
            weakSelf.calendar.data = array;
            [NSUSER_Defaults setObject:weakSelf.data forKey:GROUP_COACHE_CALENDAR];
        }
        [weakSelf removeWaitView];
    }];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化数据
    self.data = [NSMutableDictionary dictionaryWithDictionary:[NSUSER_Defaults objectForKey:GROUP_COACHE_CALENDAR]];
    //初始化UI
    [self setupGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushcardSuess) name:@"pushcardSucess" object:nil];
}

- (void)pushcardSuess{
    self.isDaka = @"0";
    
    [self reloadDataWithIsRefresh:YES];
}

- (void)cancelDaka{
    [self.mengceng removeFromSuperview];
}

- (void)daka{
    
    // 创建选择tup控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    [NSUSER_Defaults setObject:@"打卡只能添加1张图片" forKey:@"zdsselectphotoTip"];
    //    pickerVc.selectPickers = self.assets;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 1;
    [self cancelDaka];
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        PushCardViewController *punch = [[PushCardViewController alloc] init];
        punch.gameid = weakSelf.gameId;
        UIImage *image;
        if ([assets[0] isKindOfClass:[MLSelectPhotoAssets class]]) {
            image = ((MLSelectPhotoAssets*)assets[0]).originImage;
        }else image = assets[0];

         _photoEditMultipleComponent =
        [TuSDKGeeV1 photoEditMultipleWithController:self
                                      callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
         {
             if (controller) {
                 [controller popViewControllerAnimated:YES];
             }
             punch.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:result.imagePath]];
             [weakSelf.navigationController pushViewController:punch animated:YES];
         }];
        // 设置图片
        _photoEditMultipleComponent.inputImage = image;
        //    _photoEditMultipleComponent.inputTempFilePath = result.imagePath;
        //    _photoEditMultipleComponent.inputAsset = result.imageAsset;
        // 是否在组件执行完成后自动关闭组件 (默认:NO)
        _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
        [_photoEditMultipleComponent showComponent];
        
    };
}

- (void)setupGUI{
    self.view.backgroundColor = [UIColor whiteColor];
    CalendarView *calendar = [[CalendarView alloc] initWithFrame:self.view.bounds];
    self.calendar = calendar;
    calendar.delegate = self;
    calendar.datasource = self;
}

#pragma mark - CalendarDelegate protocol conformance

-(void)dayClick:(CalendarDayButton*)btn{
    if ([btn.model.ispunch isEqualToString:@"1"] && [btn.model.punchdate isEqualToString:self.today]) {//今天
        [self daka];
    }else if (![btn.model.ispunch isEqualToString:@"0"]) {
        return;
    }else{
        CalendarDetailViewController *vc = [[CalendarDetailViewController alloc] init];
        vc.today = self.today;
        vc.gameId = self.gameId;
        NSMutableArray *array = [NSMutableArray array];
        int i  = 0;
        NSDictionary *dic = [self.data objectForKey:self.currentYM];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dd in dic[@"punchlist"]) {
            singinModel *model = [singinModel modelWithDic:dd];
            [arr addObject:model];
        }
        for (int j=0; j<arr.count; j++) {
            singinModel *model = arr[j];
            if ([model.punchdate isEqualToString:btn.model.punchdate]) {
                vc.currentPhotoIndex = i;
            }
            if ([model.ispunch isEqualToString:@"0"]) {
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:model.imageurl];
                for (UIView *chirldV in self.calendar.subviews) {
                    if (chirldV.tag == j+1) {
                        photo.srcImageView = ((CalendarDayButton*)chirldV).backImage;
                    }
                }
                photo.desc = model.punchcontent;
                photo.punchdate = model.punchdate;
                [array addObject:photo];
                i++;
            }
        }
        vc.photos = array;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)dayChangedToDate:(NSDate *)selectedDate
{
    NSLog(@"dayChangedToDate %@",selectedDate);
}

-(BOOL)canSwipeToDate:(NSDate *)date{
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *Todate=[formatter dateFromString:self.today];
    
    if (comps.year<2015 || (comps.year == 2015 && comps.month<10) || [date laterDate:Todate] == date) {
        return NO;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMM"];
    self.currentYM = [dateFormatter stringFromDate:date];
    [self reloadDataWithIsRefresh:NO];
    return NO;
}
-(BOOL)isDataForDate:(NSDate *)date{
    return NO;
}
@end
