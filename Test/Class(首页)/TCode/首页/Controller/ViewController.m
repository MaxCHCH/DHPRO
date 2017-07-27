//
//  ViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/9/30.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
//#define URLMAINS  @"http://www.google.cn"
//
//#define URLMAIN  @"http://www.baidu.cn"
//
//#define API_BASE_URL(_URL_) [NSString stringWithFormat:@"%@/WebService/jsonInterface.ashx?json=%@",[GVUserDefaults standardUserDefaults].userName,_URL_]

//#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad  http://iphonedevwiki.net/index.php/AudioServices

//#include <objc/runtime.h>
//#import "CeModel.h"
//#import "JPShopCarController.h"
//#import <StoreKit/StoreKit.h>
//#import <NetworkExtension/NetworkExtension.h>
//#import <SystemConfiguration/CaptiveNetwork.h>
//#import "KSGuideManager.h"
//#import "YQMXModel.h"
//#import <AdSupport/ASIdentifierManager.h>
//#import <AudioToolbox/AudioToolbox.h> //声音提示

//#import "DetailsDrawViewController.h"
//#import "QRCodeViewController.h"
//#import "AutoLayoutViewController.h"
//#import "ReleaseViewController.h"
//#import "QRCodeVC.h"
//#import "ScottPopMenu.h"
//#import "UIViewExt.h"
//#import "LSTabBarViewController.h"
//#import "BaseTabBarViewController.h"
//#import "TestChooseViewController.h"
//#import "TestTableViewController.h"
//#import "ESMTabBarVC.h"
//#import "ADo_ViewController.h"
//#import "MyMapViewController.h"
//#import "SystermSetting.h"
//#import "SignatureViewController.h"
//#import "LabelMethodBlockVC.h"
//#import "IDCardViewController.h"
//#import "EquiPmentViewController.h"
//#import "QualityInspectionViewController.h"
//#import "ShopCollectionViewViewController.h"
//#import "MonitsViewController.h"
//#import "LBEquiXSViewController.h"
//#import "NobodyNibTableViewController.h"
//#import "IncludeNibTableViewController.h"
//#import "ImageViewController.h"
//#import "NSMutableArray+Util.h"
//#import "AddressBookViewController.h"
//#import "3DTouchViewController.h"
//#import "loginViewController.h"
//#import "ListViewHeaderFooterViewController.h"
//#import "ShowViewController.h"
//#import "AssistiveTouchViewController.h"
//
//#define kUseScreenShotGesture 1
//
//#if kUseScreenShotGesture
//#import "ScreenShotView.h"
//#endif
#import <CoreMotion/CoreMotion.h>
#import "ViewController.h"
#import "THomeCollectionViewCell.h"//主页
#import "T3DTouchViewController.h"//3DTouch
#import "GKHScanQCodeViewController.h"//二维码
#import "ContentOffSetVC.h"//滑动
#import "LSTabBarViewController.h"//四个菜单栏
#import "SignatureViewController.h"//签名
#import "ZLDashboardViewController.h"//动画
#import "ActionViewController.h"//咖啡机动画
#import "TMotionViewController.h"//碰撞球
#import "TShopAnimationViewController.h"//购物车动画
#import "TSidebarViewController.h"//侧边栏
#import "TGuideMViewController.h"//引导页
#import "IDCardViewController.h"
//@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QRScanViewDelegate,ScottPopMenuDelegate,SKStoreProductViewControllerDelegate>{

@interface ViewController ()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QRScanViewDelegate,UIAccelerometerDelegate>{
	NSMutableArray *valueArr;
	
	UICollectionView *_collectionView;
	NSArray *_arr_title;
	UILabel *_lb_showinfo;
}
@property (nonatomic, strong) CMMotionManager *mgr; // 保证不死

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic ,strong) NSMutableArray *assets;//图片集合

//#if kUseScreenShotGesture
//@property (strong, nonatomic) ScreenShotView *screenshotView;
//#endif
//- (void) openAppStore : (NSString *)appId;
@end

@implementation ViewController
- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"项目集合";

	self.view.backgroundColor = [UIColor whiteColor];

	[self setUPUI];
	// Do any additional setup after loading the view.
}
- (void)proximityStateDidChange
{
	if ([UIDevice currentDevice].proximityState) {
		NSLog(@"有物品靠近");
	} else {
		NSLog(@"有物品离开");
	}
	/*
	 IsInterface = 1;
	 Mark = "";
	 PNumber = 4JH39P;
	 PayType = "1,2,3";
	 "WX_AppId" = wx135d6c874a008913;
	 "WX_AppSecret" = a002fa50d77506b86b2339dc26c9d97d;
	 "ZFB_Key" = 66sgyebo4se126fqobzk8rdenp8xgomn;
	 "ZFB_PID" = 2088711930722495;
	 createDate = "2013/12/4 11:21:19";
	 id = 4;
	 ip = "http://kaifa.homesoft.cn/";
	 isDelete = 0;
	 modifyDate = "2017/7/19 13:56:32";
	 name = "\U5317\U4eac\U4e2d\U79d1\U534e\U535a\U7269\U4e1a";
	 userName = admin;
	 userPWD = 123456;
	 webservice = "http://kaifa.homesoft.cn/webService/forcelandEstateService.asmx";
	 */
	/*
	 MethodType = GET;
	 Url = "http://kaifa.homesoft.cn/WebService/jsonInterface.ashx";
	 Value = "?json=UserLogin&UserName=admin&Pwd=pwd";

	 */
	
	/*
	 {
	 UserInfo =     (
	 {
	 EmpId = 712;
	 "HX_UserID" = "1_712";
	 HeadUrl = "<null>";
	 Name = "TP_\U7cfb\U7edf\U7ba1\U7406";
	 },
	 {
	 EmpId = 679;
	 "HX_UserID" = "1_679";
	 HeadUrl = "<null>";
	 Name = "\U5f20\U4e39_\U7cfb\U7edf\U7ba1\U7406";
	 },
	 {
	 EmpId = 731;
	 "HX_UserID" = "<null>";
	 HeadUrl = "<null>";
	 Name = "\U90b8\U6743\U9f9901_\U516c\U53f8\U9886\U5bfc";
	 },
	 {
	 EmpId = 402;
	 "HX_UserID" = "1_402";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5402_\U884c\U653f\U4eba\U4e8b\U90e8";
	 },
	 {
	 EmpId = 682;
	 "HX_UserID" = "1_682";
	 HeadUrl = "<null>";
	 Name = "\U909d\U7fa4_\U884c\U653f\U4eba\U4e8b\U90e8";
	 },
	 {
	 EmpId = 653;
	 "HX_UserID" = "1_653";
	 HeadUrl = "<null>";
	 Name = "\U5f20\U9999\U9999_12\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 667;
	 "HX_UserID" = "1_667";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd511_12\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 427;
	 "HX_UserID" = "1_427";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5427_12\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 523;
	 "HX_UserID" = "1_523";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5523_\U5de5\U7a0b\U90e8";
	 },
	 {
	 EmpId = 676;
	 "HX_UserID" = "1_676";
	 HeadUrl = "<null>";
	 Name = "\U6a80\U76fc_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 694;
	 "HX_UserID" = "1_694";
	 HeadUrl = "<null>";
	 Name = "\U5362\U6dd1\U82b1_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 697;
	 "HX_UserID" = "1_697";
	 HeadUrl = "<null>";
	 Name = "\U6817\U6653\U6960_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 678;
	 "HX_UserID" = "1_678";
	 HeadUrl = "<null>";
	 Name = "\U90dd\U745e\U7ea2_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 672;
	 "HX_UserID" = "1_672";
	 HeadUrl = "<null>";
	 Name = "\U738b\U9707_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 700;
	 "HX_UserID" = "1_700";
	 HeadUrl = "<null>";
	 Name = "\U6e29\U677e_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 636;
	 "HX_UserID" = "1_636";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5_\U6d4b\U8bd5\U90e8\U95e8";
	 },
	 {
	 EmpId = 654;
	 "HX_UserID" = "1_654";
	 HeadUrl = "<null>";
	 Name = "\U7ba1\U7406\U5458_\U6d4b\U8bd5";
	 },
	 {
	 EmpId = 650;
	 "HX_UserID" = "1_650";
	 HeadUrl = "<null>";
	 Name = "\U5f20\U96e8\U7530_\U6d4b\U8bd5";
	 },
	 {
	 EmpId = 681;
	 "HX_UserID" = "1_681";
	 HeadUrl = "attachment/Employee/2017-01-24/681_0_20170124162918.jpg";
	 Name = "\U738b\U8f89_\U603b\U7ecf\U529e";
	 },
	 {
	 EmpId = 663;
	 "HX_UserID" = "1_663";
	 HeadUrl = "<null>";
	 Name = "\U59d3\U540d_\U5176\U4ed6\U90e8\U95e8";
	 },
	 {
	 EmpId = 683;
	 "HX_UserID" = "1_683";
	 HeadUrl = "<null>";
	 Name = "\U6ee1\U8fbe_\U9500\U552e\U90e8";
	 },
	 {
	 EmpId = 685;
	 "HX_UserID" = "1_685";
	 HeadUrl = "<null>";
	 Name = "\U5218\U65b9_\U9500\U552e\U90e8";
	 },
	 {
	 EmpId = 684;
	 "HX_UserID" = "1_684";
	 HeadUrl = "attachment/Employee/2017-06-17/684_0_20170617120027.jpg";
	 Name = "\U90b8\U6743\U9f99_\U9500\U552e\U90e8";
	 },
	 {
	 EmpId = 686;
	 "HX_UserID" = "1_686";
	 HeadUrl = "<null>";
	 Name = "\U674e\U9662\U9e4f_\U9500\U552e\U90e8";
	 },
	 {
	 EmpId = 687;
	 "HX_UserID" = "1_687";
	 HeadUrl = "<null>";
	 Name = "\U90ed\U91d1\U534e_\U9500\U552e\U90e8";
	 },
	 {
	 EmpId = 701;
	 "HX_UserID" = "1_701";
	 HeadUrl = "attachment/Employee/2017-01-24/701_0_20170124170114.jpg";
	 Name = "\U95eb\U5cf0_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 704;
	 "HX_UserID" = "1_704";
	 HeadUrl = "<null>";
	 Name = "\U5468\U6d77\U6960_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 702;
	 "HX_UserID" = "1_702";
	 HeadUrl = "attachment/Employee/2017-03-14/702_0_1489469708684.jpg";
	 Name = "\U5510\U6cfd\U8d35_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 703;
	 "HX_UserID" = "1_703";
	 HeadUrl = "attachment/Employee/2017-05-27/703_0_20170527104533.jpg";
	 Name = "\U8d75\U5b66\U793c_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 709;
	 "HX_UserID" = "1_709";
	 HeadUrl = "attachment/Employee/2017-03-13/709_0_1489381891559.jpeg";
	 Name = "\U8d75\U8fde\U4e1c_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 707;
	 "HX_UserID" = "1_707";
	 HeadUrl = "<null>";
	 Name = "\U5f20\U4e91\U9e64_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 652;
	 "HX_UserID" = "1_652";
	 HeadUrl = "attachment/Employee/2017-02-10/652_0_IMG20161224185424.jpg";
	 Name = "\U5f20\U5965_\U5f00\U53d1\U90e8";
	 },
	 {
	 EmpId = 738;
	 "HX_UserID" = "<null>";
	 HeadUrl = "<null>";
	 Name = "ws_Sander";
	 },
	 {
	 EmpId = 720;
	 "HX_UserID" = "1_720";
	 HeadUrl = "<null>";
	 Name = "\U535a\U4f17\U6d4b\U8bd5_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 661;
	 "HX_UserID" = "1_661";
	 HeadUrl = "<null>";
	 Name = "\U7ef4\U4fee\U5458_\U5de5\U7a0b\U90e8";
	 },
	 {
	 EmpId = 33;
	 "HX_UserID" = "1_33";
	 HeadUrl = "attachment/Employee/2017-01-23/33_0_20170123112933.jpg";
	 Name = "\U6708_\U5ba2\U670d\U4eba\U5458";
	 },
	 {
	 EmpId = 403;
	 "HX_UserID" = "1_403";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5403_\U4e2d\U63a7\U5ba4";
	 },
	 {
	 EmpId = 644;
	 "HX_UserID" = "1_644";
	 HeadUrl = "<null>";
	 Name = "\U5c0f\U674e_\U529e\U516c\U5ba4";
	 },
	 {
	 EmpId = 719;
	 "HX_UserID" = "1_719";
	 HeadUrl = "<null>";
	 Name = "\U535a\U4f17_\U5ba2\U670d\U90e8";
	 },
	 {
	 EmpId = 717;
	 "HX_UserID" = "1_717";
	 HeadUrl = "<null>";
	 Name = "yiyi_\U529e\U516c\U5ba4";
	 },
	 {
	 EmpId = 677;
	 "HX_UserID" = "1_677";
	 HeadUrl = "<null>";
	 Name = "admin999_\U5de5\U7a0b\U90e8";
	 },
	 {
	 EmpId = 61;
	 "HX_UserID" = "<null>";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd561_\U5de5\U7a0b\U90e8";
	 },
	 {
	 EmpId = 632;
	 "HX_UserID" = "1_632";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5632_\U4fdd\U5b89\U90e8";
	 },
	 {
	 EmpId = 680;
	 "HX_UserID" = "1_680";
	 HeadUrl = "<null>";
	 Name = "\U6d4b\U8bd5\U4eba\U5458_\U6d4b\U8bd5\U90e8\U95e8";
	 },
	 {
	 EmpId = 718;
	 "HX_UserID" = "1_718";
	 HeadUrl = "<null>";
	 Name = "\U5f20\U6d2a\U5cf0_\U5ba2\U670d\U90e8";
	 }
	 );
	 count = 45;
	 result = True;
	 }
	 */
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	NSLog(@"加速驾驶 /nx:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
}

- (CMMotionManager *)mgr
{
	if (_mgr == nil) {
		_mgr = [[CMMotionManager alloc] init];
	}
	return _mgr;
}
- (void)developer{
	
	// 1.获取单例对象
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	
	// 2.设置代理
	accelerometer.delegate = self;
	
	// 3.设置采样间隔
	accelerometer.updateInterval = 0.3;
	
	// 1.判断加速计是否可用
	if (!self.mgr.isAccelerometerAvailable) {
		NSLog(@"加速计不可用");
		return;
	}
	
	// 2.设置采样间隔
	self.mgr.accelerometerUpdateInterval = 0.3;
	
	// 3.开始采样
	[self.mgr startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) { // 当采样到加速计信息时就会执行
		if (error) return;
		
		// 4.获取加速计信息
//		CMAcceleration acceleration = self.mgr.accelerometerData.acceleration;

		CMAcceleration acceleration = accelerometerData.acceleration;
		NSLog(@"4/n获取加速计信息 x:%f y:%f z:%f", acceleration.x, acceleration.y, acceleration.z);
		_lb_showinfo.text = [NSString stringWithFormat:@"获取的X:%.2f,获取的Y:%.2f,获取的Z:%.2f",acceleration.x, acceleration.y, acceleration.z];
	}];
	
	if (![CMPedometer isStepCountingAvailable]) {
		NSLog(@"计步器不可用");
		return;
	}
	
	CMPedometer *stepCounter = [[CMPedometer alloc] init];
	
	[stepCounter startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
		if (error) return;
		// 4.获取采样数据
		NSLog(@"获取采样数据 = %@", pedometerData.numberOfSteps);
	}];
}
- (void)setUPUI{
	// 监听有物品靠近还是离开
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateDidChange) name:UIDeviceProximityStateDidChangeNotification object:nil];
	[UIDevice currentDevice].proximityMonitoringEnabled = YES;

	
	UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
	[flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
	flowLayout.minimumLineSpacing = 0.0;//minimumLineSpacing cell上下之间的距离
//	flowLayout.minimumInteritemSpacing = 5.0;//cell左右之间的距离
//	flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 20);
	
	_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, DH_DeviceWidth-30, DH_DeviceHeight) collectionViewLayout:flowLayout];
//	_collectionView=[[UICollectionView alloc] init];
//	_collectionView.collectionViewLayout = flowLayout;
	//注册Cell，必须要有
	[_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
	[_collectionView registerClass:[THomeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([THomeCollectionViewCell class])];

	_collectionView.dataSource=self;
	_collectionView.delegate=self;
	[_collectionView setBackgroundColor:[UIColor whiteColor]];
	[self.view addSubview:_collectionView];
	_arr_title = @[@"10上下滑动",@"113DTouch",@"12二维码",@"13滑动",@"14导航栏",@"15签名",@"16动画",@"17咖啡机",@"18碰撞球",@"19侧边栏",@"20购物车",@"21身份证",@"22待定",@"23待定",@"24待定",@"25待定",@"26待定",@"27待定",@"28待定",@"29待定",@"30待定",@"31待定",@"32待定",@"33待定",@"34待定",@"35待定",@"36待定",@"37待定",@"38待定",@"39待定",@"40待定",@"41待定"];
	
	_lb_showinfo = [[UILabel alloc]init];
	_lb_showinfo.backgroundColor = [UIColor brownColor];
	_lb_showinfo.textColor = [UIColor redColor];
	_lb_showinfo.font = [UIFont systemFontOfSize:14];
	_lb_showinfo.layer.borderColor = [UIColor redColor].CGColor;
	_lb_showinfo.layer.borderWidth = 1.0;
	_lb_showinfo.frame = CGRectMake(0, DH_DeviceHeight-20, DH_DeviceWidth, 20);
	[self.view addSubview:_lb_showinfo];
	
	[self developer];
	[self scrollerLabel];
	
}
- (void)scrollerLabel{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, DH_DeviceWidth, 30)];
	label.text = @"两块钱,你买不了吃亏,两块钱,你买不了上当,真正的物有所值,拿啥啥便宜,买啥啥不贵,都两块,买啥都两块,全场卖两块,随便挑,随便选,都两块！";
	//	label.backgroundColor = [UIColor redColor];
	label.layer.borderColor = [UIColor redColor].CGColor;
	label.layer.borderWidth = 0.3;
	label.textColor = [UIColor blackColor];
	
	[label sizeToFit];
	CGRect frame = label.frame;
	frame.origin.x = 320;
	label.frame = frame;
	
	[UIView beginAnimations:@"testAnimation" context:NULL];
	[UIView setAnimationDuration:12.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationRepeatAutoreverses:NO];
	[UIView setAnimationRepeatCount:999999];
	
	frame = label.frame;
	frame.origin.x = -frame.size.width;
	label.frame = frame;
	[UIView commitAnimations];
	[self.view addSubview:label];
}
#pragma mark -- UICollectionViewDataSource
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return _arr_title.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * CellIdentifier = @"THomeCollectionViewCell";
	THomeCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
	_cell.imageCover.image = [UIImage imageNamed:@"Facebook"];
	_cell.labelName.text = _arr_title[indexPath.row];
//	_cell.layer.borderColor = [UIColor redColor].CGColor;
//	_cell.layer.borderWidth = 1.0;
	return _cell;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	[_collectionView deselectItemAtIndexPath:indexPath animated:NO];
	switch (indexPath.row) {
	  case 0:
		{
			ContentOffSetVC *tabbarOne = [[ContentOffSetVC alloc]init];
			push(tabbarOne);
		}
			break;
		case 1:{
			T3DTouchViewController*tabbarTwo = [[T3DTouchViewController alloc]init];
			push(tabbarTwo);
		}
			break;
		case 2:{
			GKHScanQCodeViewController * sqVC = [[GKHScanQCodeViewController alloc]init];
			sqVC.delegate=self;
			UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
			[self presentViewController:nVC animated:YES completion:nil];

		}
			break;
		case 3:{
			ContentOffSetVC*tabbarTwo = [[ContentOffSetVC alloc]init];
			push(tabbarTwo);
		}
			break;
		case 4:{
			LSTabBarViewController*tabbarTwo = [[LSTabBarViewController alloc]init];
			push(tabbarTwo);
		}
			break;
		case 5:{
			SignatureViewController*tabbarTwo = [[SignatureViewController alloc]init];
			push(tabbarTwo);
		}
			break;
		case 6:{
			ZLDashboardViewController*tabbarTwo = [[ZLDashboardViewController alloc]init];
			push(tabbarTwo);
		}
			break;
		case 7:{
			ActionViewController*tabbarTwo = [[ActionViewController alloc]init];
			push(tabbarTwo);
		}
			break;
		case 8:{
			TMotionViewController*tabbarTwo = [[TMotionViewController alloc]init];
			push(tabbarTwo);
		}
			break;
			
		case 9:{
			TSidebarViewController*tabbarTwo = [[TSidebarViewController alloc]init];
			push(tabbarTwo);
		}
			break;
		case 10:{
			TShopAnimationViewController*tabbarTwo = [[TShopAnimationViewController alloc]init];
			push(tabbarTwo);
		}
			break;
			
		case 11:{

			IDCardViewController*tabbarTwo = [[IDCardViewController alloc]init];
			push(tabbarTwo);
		}
			break;
			
			
	  default:
			break;
		}
}
#pragma mark --UICollectionViewDelegateFlowLayout
//////定义每个Item 的大小(cell的宽高)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat width= self.view.frame.size.width/6;//间隙5

	return CGSizeMake(width,60);

}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(5,0,5,0);//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
}

//minimumLineSpacing 上下item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

	return 5;
}
//minimumInteritemSpacing 左右item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

	return 0;
}


//- (void)otherMethod{
//	self.assets = [NSMutableArray array];
//	[self fetchSSIDInfo];
//	valueArr = [NSMutableArray array];
//	Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
//	NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
//	NSLog(@"apps: %@", [workspace performSelector:@selector(allApplications)]);
//	[self scanApps];
//	
//	
//	
//	/**
//	 *  引导页
//	 */
//	
//	//	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
//	//
//	//	if([userDefaults objectForKey:@"FirstLoad"] == nil) {
//	//
//	//		//    [self showGuide];
//	//
//	//		ADo_ViewController *vc = [[ADo_ViewController alloc] init];
//	//		[self.navigationController pushViewController:vc
//	//											 animated:NO];
//	//		//
//	//		[userDefaults setBool:YES forKey:@"FirstLoad"];
//	//		[userDefaults synchronize];
//	//
//	//	}
//	NSMutableArray *paths = [NSMutableArray new];
//	//	for (int i = 0; i < pageCount; i ++) {
//	//
//	//		[paths addObject:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"0%d",i+1] ofType:@"jpg"]];
//	//
//	//		[[KSGuideManager shared] showGuideViewWithImages:paths];
//	//
//	//
//	//	}
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"01" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"02" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"03" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"04" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"04" ofType:@"png"]];
//	[paths addObject:[[NSBundle mainBundle] pathForResource:@"05" ofType:@"png"]];
//	
//	[[KSGuideManager shared] showGuideViewWithImages:paths];
//	
//	UIImageView *t= [[UIImageView alloc]init];
//	t.frame = CGRectMake(100, 200, 100, 100);
//	[t sd_setImageWithURL:[NSURL URLWithString:@"https://img3.imgtn.bdimg.com/it/u=1639391100,2392882587&fm=21&gp=0.jpg"]];
//	
//	[self.view addSubview:t];
//#pragma mark -创建
//	NSArray *showLabelArray = @[@"10上下滑动",@"11二维码",@"12AutoLayout",@"13添加图片",@"14导航栏",@"15导航栏",@"16TEAST",@"17tableView",@"18导航栏",@"19地图",@"20Block侧",@"21品质巡查",@"22签名",@"23身份证",@"24芝麻信用分",@"25分段导航",@"26通讯录",@"27collection",@"28QQ",@"29设备巡视",@"303DTouch",@"31登录",@"32H&F",@"33添加",@"34AssistiveTouch",@"35支付宝",@"36微信",@"37二维码",@"38待定",@"39待定",@"40待定",@"41待定"];
//	
//	
//	//添加彩种按钮
//	for (int i= 0; i<5; i++) {
//		for (int j = 0; j<6; j++) {
//			
//			_button = [self button];
//			[_button setTitle:[showLabelArray objectAtIndex:i*6+j] forState:UIControlStateNormal];
//			_button.layer.borderColor = [UIColor lightGrayColor].CGColor;
//			_button.layer.borderWidth = 0.7;
//			_button.titleLabel.font = [UIFont systemFontOfSize:13];
//			_button.frame = CGRectMake(2+j*70, 64+i*40, 60, 30);
//			_button.tag = 10+i*6+j;
//			
//			//			CALayer *cyanLayer = [CALayer layer];
//			//			cyanLayer.backgroundColor = [UIColor cyanColor].CGColor;
//			//			cyanLayer.bounds = _button.frame;
//			//			cyanLayer.position = CGPointMake(3, 3);
//			//			cyanLayer.shadowOffset = CGSizeMake(1, 3); //设置阴影的偏移量
//			//			cyanLayer.shadowRadius = 0.5;  //设置阴影的半径
//			//			cyanLayer.shadowColor = [UIColor lightGrayColor].CGColor; //设置阴影的颜色为黑色
//			//			cyanLayer.shadowOpacity = 0.9; //设置阴影的不透明度
//			//
//			//			[_button.layer addSublayer:cyanLayer];
//			
//			[_button addTarget:self action:@selector(chooseLottery:) forControlEvents:UIControlEventTouchUpInside];
//		}
//	}
//	NSLog(@"%@",[[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]);
//	BOOL bo = 8960;
//	NSLog(@"%p:",&bo);
//	NSLog(@"%i",bo);
//	NSLog(@"当前方法名：%@",NSStringFromSelector(_cmd));
//	NSLog(@"当前方法名: %s",sel_getName(_cmd));
//	NSLog(@"[类 方法]：%s",__func__);
//	NSLog(@"[类 方法]：%s",__FUNCTION__);
//	NSLog(@"当前类名：%@",NSStringFromClass([self class]));
//	NSLog(@"当前行号：%d",__LINE__);
//	NSLog(@"当前文件存储路径：%s",__FILE__);
//	NSString *pathStr = [NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding]; //将CString -> NSString
//	NSLog(@"当前文件名：%@",[pathStr lastPathComponent]);
//	NSLog(@"当前日期：%s",__DATE__);
//	NSLog(@"当前时间：%s",__TIME__);
//	NSLog(@"当前App运行要求的最低ios版本：%d",__IPHONE_OS_VERSION_MIN_REQUIRED);  //Develop Target: 已选8.0
//	NSLog(@"当前App支持的最高ios版本：%d",__IPHONE_OS_VERSION_MAX_ALLOWED);    //Develop Target: 最高9.0
//	NSLog(@"打印__IPHONE_7_0：%d",__IPHONE_7_0);  //打印ios7.0
//	NSLog(@"当前线程：%@",[NSThread currentThread]);
//	NSLog(@"主线程：%@",[NSThread mainThread]);
//	NSLog(@"当前栈信息：%@", [NSThread callStackSymbols]);
//	//	bool//0x7fff4fef2737
//	//	BOOL//0x7fff5da11737
//	
//	[self YYYYY];
//}
////实现SKStoreProductViewControllerDelegate委托的函数
//- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
//{
//	[viewController dismissViewControllerAnimated:YES completion:nil];
//}
////实现openAppStore函数
//- (void)openAppStore:(NSString *)appId
//{
//	SKStoreProductViewController *storeProductVC = [[SKStoreProductViewController alloc] init];
//	storeProductVC.delegate = self;
//	
//	NSDictionary *dict = [NSDictionary dictionaryWithObject:appId forKey:SKStoreProductParameterITunesItemIdentifier];
//	[storeProductVC loadProductWithParameters:dict completionBlock:^(BOOL result, NSError *error)
//	 {
//		 if (result)
//		 {
//			 [self presentViewController:storeProductVC animated:YES completion:nil];
//		 }
//	 }];
//}
//
//- (NSString *)fetchSSIDInfo{
//	[self getWIFIName];
//	NSString *wifiName = nil;
//	
//	CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
//	
//	if (!wifiInterfaces) {
//		
//		return @"未知";
//		
//	}
//	NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
//	
//	for (NSString *interfaceName in interfaces) {
//		
//		CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
//		
//		if (dictRef) {
//			
//			NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
//			
//			wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
//			
//			CFRelease(dictRef);
//			
//		}
//		
//	}
//	
//	CFRelease(wifiInterfaces);
//	
//	return wifiName;
//	
//}
//- (void)getWIFIName{
//	NSMutableDictionary* options = [[NSMutableDictionary alloc] init];
//	
//	[options setObject:@"我是副标题" forKey:kNEHotspotHelperOptionDisplayName];
//	
//	dispatch_queue_t queue = dispatch_queue_create("com.myapp.ex", NULL);
//	
//	BOOL returnType = [NEHotspotHelper registerWithOptions:options queue:queue handler: ^(NEHotspotHelperCommand * cmd) {
//		
//		NEHotspotNetwork* network;
//		
//		NSLog(@"COMMAND TYPE:   %ld", (long)cmd.commandType);
//		
//		[cmd createResponse:kNEHotspotHelperResultAuthenticationRequired];
//		
//		if (cmd.commandType == kNEHotspotHelperCommandTypeEvaluate || cmd.commandType ==kNEHotspotHelperCommandTypeFilterScanList) {
//			
//			NSLog(@"WIFILIST:   %@", cmd.networkList);
//			
//			for (network  in cmd.networkList) {
//				
//				NSLog(@"COMMAND TYPE After:   %ld", (long)cmd.commandType);
//				
//				if ([network.SSID isEqualToString:@"ssid"]|| [network.SSID isEqualToString:@"WISPr Hotspot"]) {
//					
//					double signalStrength = network.signalStrength;
//					
//					NSLog(@"Signal Strength: %f", signalStrength);
//					
//					[network setConfidence:kNEHotspotHelperConfidenceHigh];
//					
//					[network setPassword:@"password"];
//					
//					NEHotspotHelperResponse *response = [cmd createResponse:kNEHotspotHelperResultSuccess];
//					
//					NSLog(@"Response CMD %@", response);
//					
//					[response setNetworkList:@[network]];
//					
//					[response setNetwork:network];
//					
//					[response deliver];
//					
//				}
//				
//			}
//			
//		}
//		
//	}];
//	
//	NSLog(@"result :%d", returnType);
//	
//	NSArray *array = [NEHotspotHelper supportedNetworkInterfaces];
//	
//	NSLog(@"wifiArray:%@", array);
//	
//	NEHotspotNetwork *connectedNetwork = [array lastObject];
//	
//	NSLog(@"supported Network Interface: %@", connectedNetwork);
//
//}
//- (UIButton *)button{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    button.titleLabel.font = [UIFont systemFontOfSize:12];
//    button.backgroundColor = [UIColor grayColor];;       //背景颜色
//    [self.view addSubview:button];
//    return button;
//}
//-(void)GKHScanQCodeViewController:(GKHScanQCodeViewController *)lhScanQCodeViewController readerScanResult:(NSString *)result{
//	NSLog(@"result %@",result);
//}
//- (void)allApplications{
//	
//}
//- (void)defaultWorkspace{
//	
//}
//- (void)scanApps
//{
//
//	NSString *pathOfApplications;
//
//	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
////		        pathOfApplications = @"/var/mobile/Containers/Bundle/Application";
////		pathOfApplications = @"/private/var/containers/Bundle/Application/";
//
//		pathOfApplications = @"/var/mobile/Applications";
//
//
//	}
//
//	else{
//
//		pathOfApplications = @"/var/mobile/Applications";
//	
//	}
//
//
//	NSLog(@"scan begin");
//
//// all applications
//
//	NSArray *arrayOfApplications = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathOfApplications error:nil];
//
//
//	for (NSString *applicationDir in arrayOfApplications) {
// // path of an application
//
//		NSString *pathOfApplication = [pathOfApplications stringByAppendingPathComponent:applicationDir];
//
//		NSArray *arrayOfSubApplication = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathOfApplication error:nil];
//// seek for *.app
//
//		for (NSString *applicationSubDir in arrayOfSubApplication) {
//
//			if ([applicationSubDir hasSuffix:@".app"]) {// *.app
//
//				NSString *path = [pathOfApplication stringByAppendingPathComponent:applicationSubDir];
// 
//				NSString *imagePath = [pathOfApplication stringByAppendingPathComponent:applicationSubDir];
// 
//				path = [path stringByAppendingPathComponent:@"Info.plist"];
// // so you get the Info.plist in the dict
//
//				NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
//
//				if([[dict allKeys] containsObject:@"CFBundleIdentifier"] && [[dict allKeys] containsObject:@"CFBundleDisplayName"]){
//
//					NSArray *values = [dict allValues];
//
//					NSString *icon;
//
//					for (int j = 0; j < values.count; j++) {
// 
//						icon = [self getIcon:[values objectAtIndex:j] withPath:imagePath];
//
//						if (![icon isEqualToString:@""]) {
//
//						}
//
//						imagePath = [imagePath stringByAppendingPathComponent:icon];
//
//						break;
//
//					}
//
//				}
//
//			}
//
//		}
//
// }
//
//}
//
//- (NSString *)getIcon:(id)value withPath:(NSString *)imagePath
//{
//	if([value isKindOfClass:[NSString class]]) {
//		NSRange range = [value rangeOfString:@"png"];
//		NSRange iconRange = [value rangeOfString:@"icon"];
//		NSRange IconRange = [value rangeOfString:@"Icon"];
//		if (range.length > 0){
//			NSString *path = [imagePath stringByAppendingPathComponent:value];
//			UIImage *image = [UIImage imageWithContentsOfFile:path];
//			if (image != nil && image.size.width > 50 && image.size.height > 50) {
//				return value;
//			}
//		}
//		else if(iconRange.length > 0){
//			NSString *imgUrl = [NSString stringWithFormat:@"%@.png",value];
//			NSString *path = [imagePath stringByAppendingPathComponent:imgUrl];
//			UIImage *image = [UIImage imageWithContentsOfFile:path];
//			if (image != nil && image.size.width > 50 && image.size.height > 50) {
//				return imgUrl;
//			}
//		}
//		else if(IconRange.length > 0){
//			NSString *imgUrl = [NSString stringWithFormat:@"%@.png",value];
//			NSString *path = [imagePath stringByAppendingPathComponent:imgUrl];
//			UIImage *image = [UIImage imageWithContentsOfFile:path];
//			if (image != nil && image.size.width > 50 && image.size.height > 50) {
//				return imgUrl;
//			}
//		}
//	}
//	else if([value isKindOfClass:[NSDictionary class]]){
//		NSDictionary *dict = (NSDictionary *)value;
//		for (id subValue in [dict allValues]) {
//			NSString *str = [self getIcon:subValue withPath:imagePath];
//			if (![str isEqualToString:@""]) {
//				return str;
//			}
//		}
//	}
//	else if([value isKindOfClass:[NSArray class]]){
//		for (id subValue in value) {
//			NSString *str = [self getIcon:subValue withPath:imagePath];
//			if (![str isEqualToString:@""]) {
//				return str;
//			}
//		}
//	}
//	return @"";
//}
//
//
//
//-(void)chooseLottery:(UIButton *)sender{
//    NSLog(@"选择按钮 %ld",sender.tag);
//    
//    switch (sender.tag) {
//        case 10:
//        {
////			[SVProgressHUD showSuccessWithStatus:@"店家"];
////			AudioServicesPlaySystemSound(1005);
////			//一句话解决iphone  ipad 声音提示
//////			AudioServicesPlaySystemSound(SOUNDID);
//////			AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
////			
//            ContentOffSetVC *tabbar = [[ContentOffSetVC alloc]init];
//            [self.navigationController pushViewController:tabbar animated:YES];
//			
////			ScottPopMenu *uiui = [ScottPopMenu popMenuAtPoint:CGPointMake(0, 64+30) withTitles:@[@"开始",@"结束"] icons:@[@"left_",@"right"] menuWidth:50 delegate:self];//[ScottPopMenu popMenuRelyOnView:self.view withTitles:@[@"adf",@"adf"] icons:@[@"left_",@"right"] menuWidth:50 delegate:self];
////			[self.view addSubview:uiui];
//			
//        }
//            break;
//        case 11:
//        {
//            GKHScanQCodeViewController * sqVC = [[GKHScanQCodeViewController alloc]init];
//            sqVC.delegate=self;
//            UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
//            [self presentViewController:nVC animated:YES completion:nil];
//            
//            //    [self.navigationController pushViewController:[QRCodeVC new] animated:YES];
//
//        }
//            break;
//        case 12:
//        {
//			TestTableViewController *autolayout= [[TestTableViewController alloc]init];
////            AutoLayoutViewController *autolayout = [[AutoLayoutViewController alloc]init];
//            [self.navigationController pushViewController:autolayout animated:YES];
//
//        }
//            break;
//        case 13:
//        {
//            ReleaseViewController *ImagePicker = [[ReleaseViewController alloc]init];
//            [self.navigationController pushViewController:ImagePicker animated:YES];
//        }
//            break;
//        case 14:
//        {
//            LSTabBarViewController *viewC = [[LSTabBarViewController alloc]init];
//            [self.navigationController pushViewController:viewC animated:YES];
//        }
//            break;
//        case 15:
//        {
//            BaseTabBarViewController *tabbar = [[BaseTabBarViewController alloc]init];
//            [self.navigationController pushViewController:tabbar animated:YES];
//
//        }
//            break;
//        case 16:
//        {
//            TestChooseViewController*tabbar = [[TestChooseViewController alloc]init];
//            [self.navigationController pushViewController:tabbar animated:YES];
//        }
//            break;
//        case 17:
//        {
//			NobodyNibTableViewController *tabbar = [[NobodyNibTableViewController alloc]init];
////            IncludeNibTableViewController*tabbar = [[IncludeNibTableViewController alloc]init];
//            [self.navigationController pushViewController:tabbar animated:YES];
//
//        }
//            break;
//        case 18:
//        {
//			ESMTabBarVC *tabBar = [[ESMTabBarVC alloc]init];
//			[self.navigationController pushViewController:tabBar animated:YES];
////			self.window.rootViewController = tabBar;
////			[self.window makeKeyAndVisible];
//#if kUseScreenShotGesture
//			self.screenshotView = [[ScreenShotView alloc] initWithFrame:self.view.frame];
////			[self.window insertSubview:_screenshotView atIndex:0];
//			self.screenshotView.hidden = YES;
//#endif
//
//        }
//            break;
//        case 19:
//        {
//			
//			MyMapViewController*tabbar = [[MyMapViewController alloc]init];
//			[self.navigationController pushViewController:tabbar animated:YES];
//        }
//            break;
//		case 20:
//		{
//			
////			[[SystermSetting ba_systermSettingManage] ba_gotoSystermWIFISettings];
////			if ([[NSThread currentThread] isMainThread]) {
////				NSLog(@"main");
////			} else {
////				NSLog(@"not main");
////			}
////			dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
////			dispatch_async(defaultQueue, ^{
////				[[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"changeTabar4" object:@{@"key":@"123"} userInfo:nil]];
////			});
//			
//			LabelMethodBlockVC*tabbar = [[LabelMethodBlockVC alloc]init];
//			[self.navigationController pushViewController:tabbar animated:YES];
//
//		}
//			break;
//		case 21:{
//			QualityInspectionViewController*tabbar = [[QualityInspectionViewController alloc]init];
//			[self.navigationController pushViewController:tabbar animated:YES];
//		}
//			break;
//		case 22:{
//			SignatureViewController*tabbar = [[SignatureViewController alloc]init];
//			[self.navigationController pushViewController:tabbar animated:YES];
//		}
//			break;
//			
//		case 23:{
//			NSURL *appBUrl = [NSURL URLWithString:@"Identification://"];
//			
//		   // 2.判断手机中是否安装了对应程序
//		   if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
//			   // 3. 打开应用程序App-B
//			   [[UIApplication sharedApplication] openURL:appBUrl];
//		   } else {
//			   NSLog(@"没有安装");
//		   }
////			IDCardViewController *controller = [[IDCardViewController alloc] initWithNibName:nil bundle:nil];
////			controller.verify = false;
////			[self presentViewController:controller animated:YES completion:nil];
//
//		}
//			break;
//		case 24:{
//			
//			ZLDashboardViewController *controllers = [[ZLDashboardViewController alloc] init];
//			[self presentViewController:controllers animated:YES completion:nil];
//		}
//			break;
//		case 25:{
//			MonitsViewController *moitsVC = [[MonitsViewController alloc]init];
//			[self presentViewController:moitsVC animated:YES completion:nil];
//			
//		}
//			break;
//		case 26:{
//			AddressBookViewController*moitsVC = [[AddressBookViewController alloc]init];
//			[self presentViewController:moitsVC animated:YES completion:nil];
//
//		}
//			break;
//		case 27:{
//			ShopCollectionViewViewController*moitsVC = [[ShopCollectionViewViewController alloc]init];
//			[self presentViewController:moitsVC animated:YES completion:nil];
//			
//		}
//			break;
//			case 28://QQ
//		{
////			[self openAppStore:@"1149644212"];
//			NSURL *appBUrl = [NSURL URLWithString:@"mqqOpensdkSSoLogin://"];
//			
//			// 2.判断手机中是否安装了对应程序 参考 http://www.cnblogs.com/isItOk/p/4869499.html
//			if ([[UIApplication sharedApplication] canOpenURL:appBUrl]) {
//				// 3. 打开应用程序App-B
//				[[UIApplication sharedApplication] openURL:appBUrl];
//			} else {
//				NSLog(@"没有安装");
//			}
//		}
//		case 29:{
//			
//			LBEquiXSViewController*moitsVC = [[LBEquiXSViewController alloc]init];
//			[self presentViewController:moitsVC animated:YES completion:nil];
//		}
//			break;
//		case 30:{
//			
//			_DTouchViewController*moitsVC = [[_DTouchViewController alloc]init];
//			[self.navigationController pushViewController:moitsVC animated:YES];
//		}
//			break;
//		case 31:{
//			
//			loginViewController * login = [[loginViewController alloc] init];
//			[self presentViewController:login animated:YES completion:nil];
//
//		}
//			break;
//		case 32:{
//			
//			ListViewHeaderFooterViewController * login = [[ListViewHeaderFooterViewController alloc] init];
//			[self.navigationController pushViewController:login animated:YES];
//			
//		}
//			break;
//		case 33:{
//			
//			ShowViewController * login = [[ShowViewController alloc] init];
//			[self.navigationController pushViewController:login animated:YES];
//			
//		}
//			break;
//		case 34:{
//			
//			AssistiveTouchViewController * login = [[AssistiveTouchViewController alloc] init];
//			[self.navigationController pushViewController:login animated:YES];
//			
//		}
//			break;
//		case 35:{
//			
////			AlipayViewController * login = [[AlipayViewController alloc] init];
////			[self.navigationController pushViewController:login animated:YES];
//			
//		}
//			break;
//		case 36:{
//				
//			JPShopCarController *shopVC = [[JPShopCarController alloc]init];
//			[self presentViewController:shopVC animated:YES completion:nil];
//			}
//			break;
////		case 37:{
////				if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
////					static QRCodeReaderViewController *vc = nil;
////					static dispatch_once_t onceToken;
////								
////					dispatch_once(&onceToken, ^{
////						QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
////						vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
////						vc.modalPresentationStyle = UIModalPresentationFormSheet;
////					});
////					vc.delegate = self;
////								
////					[vc setCompletionWithBlock:^(NSString *resultAsString) {
////						NSLog(@"Completion with result: %@", resultAsString);
////					}];
////								
////					[self presentViewController:vc animated:YES completion:NULL];
////							}
////							else {
////					UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////								
////					[alert show];
////				}
////			
////			}
//			break;
//		case 38:{
//				
//			
//				
//			}
//			break;
//		case 39:{
//				
//			
//			}
//			break;
//		case 40:{
//			
//			
//		}
//			break;
//		case 41:{
//			
//			
//			
//		}
//			break;
//
//			
//			
//        default:
//            break;
//    }
//
//}
//
////- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
////{
////	[reader stopScanning];
////	
////	[self dismissViewControllerAnimated:YES completion:^{
////		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////		[alert show];
////	}];
////}
////
////- (void)readerDidCancel:(QRCodeReaderViewController *)reader
////{
////	[self dismissViewControllerAnimated:YES completion:NULL];
////}
//
//- (AFHTTPSessionManager *)mangers
//{
//	static AFHTTPSessionManager *manager = nil;
//	static dispatch_once_t onceToken;
//	dispatch_once(&onceToken, ^{
//		manager = [AFHTTPSessionManager manager];
//		manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//		manager.requestSerializer.timeoutInterval = 30.0;
//		manager.responseSerializer = [AFJSONResponseSerializer serializer];
//		manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
//		
//		
//	});
//	return manager;
//}
//
//#define URLMAIN  @"http://zkhb.homesoft.cn"
//#define API_URL_(_Field_)  [NSString stringWithFormat:@"%@",[[USERDEFAULTS objectForKey:@"url"] stringByAppendingString:[NSString stringWithFormat:@"/WebService/jsonInterface.ashx?json=%@",_Field_]]]
//
//- (void)setData:(NSDictionary *)dict{
//	
//	NSLog(@"%@",[[dict allKeys] objectAtIndex:0]);
//}
//
//
//- (void)YYYYY{
//
//    [self dataWithScreenshotInPNGFormat];
////	AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:(AFSSLPinningModeCertificate)];
//	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//	NSDictionary *paramS=@{
//						   @"type":@"M"
//						   };
//
//	NSString *url =@"http://kaifa.homesoft.cn/WebService/jsonPostInterfaceNew.ashx?json=GetDailywork";
//	
//	[manager GET:url parameters:paramS progress:^(NSProgress * _Nonnull downloadProgress) {
//		
//	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		NSLog(@"responseObject %@",responseObject);
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		NSLog(@"error %@",error);
//	}];
//	
//	[manager POST:url parameters:paramS constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//		
////		 AVURLAsset *asset ;//[AVURLAsset URLAssetWithURL:];
////		    AVAssetExportSession *exportSession= [[AVAssetExportSession alloc] initWithAsset:asset     presetName:AVAssetExportPresetMediumQuality];
////		    exportSession.outputURL = outputURL;
////		    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
////		    [exportSessionexportAsynchronouslyWithCompletionHandler:^(void) {
////			           switch (exportSession.status)
////			               {
////					                     case AVAssetExportSessionStatusUnknown:
////					                          break;
////					                     case AVAssetExportSessionStatusWaiting:
////					                          break;
////					                     case AVAssetExportSessionStatusExporting:
////					                          break;
////					                     case AVAssetExportSessionStatusCompleted: {
////						                          handler(exportSession)
////						                          break;
////						                       }
////					                     case AVAssetExportSessionStatusFailed:
////					                          break;
////				        }
////			     }];
//		
//		
//	} progress:^(NSProgress * _Nonnull uploadProgress) {
//		float u = uploadProgress.fractionCompleted;
//		NSLog(@"%.2f",u*0.03);
//	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		
////		NSMutableArray *uiui = [NSMutableArray array];
////		NSArray *arr = [responseObject allValues];
////		[arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////			[uiui addObject:arr[idx]];
////			NSLog(@"valueArr %@",uiui);
////			
////		}];
////		
////		NSString *str = [NSString stringWithFormat:@"%@%@%@",uiui[0],uiui[4],uiui[1]];
////		[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
////		NSLog(@"输出%@",str);
//		
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		
//	}];
//
//	
////	AFJSONResponseSerializer*response = [AFJSONResponseSerializer serializer];
//	
////	response.removesKeysWithNullValues=YES;
////	
////	manager.responseSerializer= response;
////	
////	manager.requestSerializer= [AFJSONRequestSerializer serializer];
//	
//	
////	manager.securityPolicy = securityPolicy;
//
//
//	
////    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////        NSString *url = [NSString stringWithFormat:@"ServiceHumanNameSet=%@&ServiceHumanName=%@&RepaireStatus=%@",@"admin",@"2",@"8"];
////
////        url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
////        
////        NSURL *zoneUrl = [NSURL URLWithString:url];
////        
////        NSError * error;
////        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:&error];
////        
////        if (zoneStr != nil) {
////            dispatch_async(dispatch_get_main_queue(), ^{
////                NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
////                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
////                NSLog(@"%@我的数据",dic);
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    
////                    NSLog(@"成功%@",dic);
////                    
////                });
//	
////            });
////        }
////        else{
////            if (error.localizedDescription) {
////                NSLog(@"error when download:%@", error);
////
////            }
////            
////        }
////    });
//
//    
////    NSString *url = @"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx?json=Disorder&EstateID=5&Method=VisitatorialPosition&UserID=2";
//////
////     [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
//	
//	
////	NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
////	[formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];//_HID
////	NSString *URL = [NSString stringWithFormat:@"&EmpID=%@&VisitatorialPositionId=%@&DutyStartTime=%@&InspectContent=%@&InspectDutyTypeID=%@&EstateID=%d",@"2",@"adf",@"2016-12-19 11:33:54",@"备注信息",@"1",@"5"];
////	NSDictionary *params=@{
////						   @"tableName":@"ESM_InspectDuty",
////						   @"url":URL
////						   };
//	
//	
//	
////    NSString *urr = [NSString stringWithFormat:@"ServiceHumanNameSet=admin&ServiceHumanName=2&RepaireStatus=8"];
////    
////    //ServiceHumanNameSet=admin&ServiceHumanName=2&RepaireStatus=8
////    NSDictionary *params = [NSDictionary dictionary];
////    params=@{
////             @"url":@"&ServiceHumanNameSet=admin&ServiceHumanName=2&RepaireStatus=8"
////             };
////    
////
//	
////  NSString *URL = @"http://218.107.133.90/estate/WebService/jsonInterface.ashx?json=GetOFMDocTransact";
////	NSDictionary *params = [NSDictionary dictionary];
////	params=@{
////			 @"HID":@"20161019000003"
////			 };
//	
////	NSDictionary *parameters = @{@"HID":@"20160420000004"
////								 };
//	
//	
////	NSString *URL =[NSString stringWithFormat:@"%@&usercode=18501369837&password=6631891",API_BASE_URL(@"GetLogin")];
//
////	[NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
//	
////	NSString *encodeParams = [self jsonStringFromObject:params];
////	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
////	[postRequest setHTTPBody:[NSData dataWithBytes:[encodeParams UTF8String] length:strlen([encodeParams UTF8String])]];
////	[postRequest setHTTPMethod:@"POST"];
////	[postRequest setValue:@"application/json;charset=gb2312" forHTTPHeaderField:@"Content-Type"];
////	
////	NSURLSessionDataTask *task = [[NSURLSession sharedSession]dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
////		if (error) {
////			NSLog(@"失败%@ error",error);
////		}
////		else{
////			NSString *jsonString = [[NSString alloc]initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
////			NSLog(@"sdjklv %@",jsonString);
////		}
////	}];
//	
//	
//	NSDictionary *params=@{
//						   @"Method":@"VisitatorialPosition",
//						   @"EstateID":@"5",
//						   @"UserID":@"2"
//						   };
////	NSString *utl = @"http://kaifa.homesoft.cn/webservice/jsonInterface.ashx?json=Disorder";
//
//	
//
////	NSString *utl = @"http://zl160528.15.baidusx.com/app/log_mobile.php";
////	NSString *url = @"http://106.3.46.118/nmgzwwy/WebService/jsonInterface.ashx?json=UserLogin";
//	int codeV = 100000 +  (arc4random() % 900001);
//
////	只传一个参数叫  mobile
//	NSDictionary *parameters = @{@"EmpID":@"2",
//								 @"EmpNumber":@"",
//								 @"CardTime":@"",
//								 @"GpsX":@"",
//								 @"GpsY":@"",
//								 @"InOrOut":@"In"};
//
////	NSString *urlll =[NSString stringWithFormat:@"%@&UserName=admin&Pwd=pwd",url];
////	urlll = [urlll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
//	
//	NSString *urlS =@"https://www.lianshiding.com/index.php/app/index/yaoqingren?";
//
//	[manager GET:urlS parameters:@{@"id":@"162",@"dj":@"1"} progress:^(NSProgress * _Nonnull downloadProgress) {
//		float u = downloadProgress.fractionCompleted;
//		NSLog(@"%.2f",u*0.03);
//	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		 NSLog(@"responseObject%@",responseObject[@"nr"] );
//		NSLog(@"网址 %@",task.response.URL);
//		NSArray *r=responseObject[@"nr"] ;
//		[r enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//			NSDictionary *dict = [r objectAtIndex:idx];
//			YQMXModel *model = [[YQMXModel alloc]init];
//			[model setValuesForKeysWithDictionary:dict];
//			[valueArr addObject:model];
//
//		}];
////		YQMXModel *model;
////		
////		model= valueArr[0];
////		NSLog(@"积分: %@",model.jifen);
////		NSLog(@"姓名: %@",model.name);
////		NSLog(@"时间: %@",model.time);
////		
////		model = valueArr[1];
////		NSLog(@"积分: %@",model.jifen);
////		NSLog(@"姓名: %@",model.name);
////		NSLog(@"时间: %@",model.time);
//		
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//				NSLog(@"网址 %@",task.response.URL);
//	}];
//	
//	NSString *URLS = @"http://itunes.apple.com/cn/lookup?id=1149644212";
//	[manager GET:URLS parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//		
//	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//		NSLog(@"responseObject%@",responseObject[@"results"] );
//	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//		
//	}];
//
//
//	
////	[manager POST:url parameters:paramss progress:^(NSProgress * _Nonnull uploadProgress) {
////        NSLog(@"进度 -- %.2f",uploadProgress.fractionCompleted);
////		//	[manager POST:stringUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
////		//		for (UIImage *image in self.assets) {
////		//			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
////		//			formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss:SSS";
////		//			NSString *fileName = [NSString stringWithFormat:@"%@.png",[formatter stringFromDate:[NSDate date]]];
////		//			NSLog(@"我的图片：%@",fileName);
////		//			[formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:fileName mimeType:@"image/png"];
////    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////         NSLog(@"responseObject%@",responseObject);
////		NSLog(@"---%d",codeV);
////		NSLog(@"网址 %@",task.response.URL);
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////		NSLog(@"error %@",error);
////		NSLog(@"网址 %@",task.response.URL);
////		//		NSLog(@"debugDescription%@",error.debugDescription);
////
////
////    }];
//	
//
//	
//}
////- (NSString *)getHttpTokenWith:(NSString *)token
////{
////	NSString *base64Token  = [NSString stringWithFormat:@"Basic %@",[token base64String]];
////	return base64Token;
////}
//- (NSString *)jsonStringFromObject:(id)object
//{
//	if([NSJSONSerialization isValidJSONObject:object]){
//		
//		NSError * error = nil;
//		NSData * data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
//		return [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
//	}
//	else {
//		NSLog(@"\n %s--- 不是合法的JSONObject\n",__FUNCTION__);
//	}
//	return nil;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
- (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
