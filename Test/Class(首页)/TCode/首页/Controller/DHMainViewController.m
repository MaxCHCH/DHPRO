//
//  DHMainViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/7/27.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "DHMainViewController.h"

//功能展示
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
#import "DHNoteViewController.h"//节点
#import "DHZanViewController.h"//点赞
#import "ScrollImageViewViewController.h"
#import "DHImagePickerViewController.h"//高级定制添加图片
#import "CardViewController.h"
#import "NetTestViewController.h"
@interface DHMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,QRScanViewDelegate,UIAccelerometerDelegate>{
	NSMutableArray *valueArr;
	
	UICollectionView *_collectionView;
	NSArray *_arr_title;
	UILabel *_lb_showinfo;
	//测试
	NSTimer *timer;
	UILabel  *displayLabel;//提示语

}
@property (nonatomic, strong) CMMotionManager *mgr; // 保证不死
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic ,strong) NSMutableArray *assets;//图片集合

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;


@end

@implementation DHMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setUPUI];
	displayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, DH_DeviceHeight-50, DH_DeviceWidth, 40)];
	displayLabel.backgroundColor = [UIColor colorWithRed:0.962 green:0.971 blue:1.000 alpha:1.000];
	displayLabel.layer.shadowColor = [UIColor lightGrayColor].CGColor;
	displayLabel.layer.shadowOffset = CGSizeMake(0, -5);
	displayLabel.layer.shadowOpacity = 0.5;
	displayLabel.layer.shadowRadius= 4;
	displayLabel.textColor = [UIColor blackColor];
	displayLabel.hidden = YES;
	displayLabel.lineBreakMode = NSLineBreakByWordWrapping;
	displayLabel.numberOfLines = 0;
	[self.view addSubview:displayLabel];
	[[UIApplication sharedApplication].keyWindow addSubview:displayLabel];
}
- (void)proximityStateDidChange
{
	if ([UIDevice currentDevice].proximityState) {
		NSLog(@"有物品靠近");
	} else {
		NSLog(@"有物品离开");
	}

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
//- (id)transformedValue:(id)value﻿
//{﻿
//	
//	﻿
//	
//	   double convertedValue = [value doubleValue];﻿
//	
//	   int multiplyFactor = 0;﻿
//	
//	﻿
//	
//	   NSArray *tokens = [NSArray arrayWithObjects:@"bytes",@"KB",@"MB",@"GB",@"TB",@“PB”, @“EB”, @“ZB”, @“YB”,nil];﻿
//	
//	﻿
//	
//	   while (convertedValue > 1024) {﻿
//		
//		       convertedValue /= 1024;﻿
//		
//		       multiplyFactor++;﻿
//		
//		   }﻿
//	
//	﻿
//	
//	   return [NSString stringWithFormat:@"%4.2f %@",convertedValue, [tokens objectAtIndex:multiplyFactor]];﻿
//	
//}


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
		_lb_showinfo.text = [NSString stringWithFormat:@"获取的X:%.2f,获取的Y:%.2f,获取的Z:%.2f,获取网速:%lld",acceleration.x, acceleration.y, acceleration.z,[DHTool getInterfaceBytes]];
		NSLog(@"速度:%@",[NSByteCountFormatter stringFromByteCount:[DHTool getInterfaceBytes] countStyle:NSByteCountFormatterCountStyleFile]);
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
	
	self.titles = @[].mutableCopy;
	self.classNames = @[].mutableCopy;
	
//	_arr_title = @[@"01上下滑动",@"023DTouch",@"03二维码",@"04上下滑动",@"05导航栏",@"06签名",@"07动画",@"08咖啡机",@"09碰撞球",@"10侧边栏",@"11购物车",@"12身份证",@"13GZWaterfall",@"14网络",@"15赞",@"16待定",@"17待定",@"18待定",@"19待定",@"20待定",@"21待定",@"22待定",@"23待定",@"24待定",@"25待定",@"26待定",@"27待定",@"28待定",@"29待定",@"30待定",@"31待定",@"32待定"];
	[self addCell:@"01上下滑动" class:@"ContentOffSetVC"];
	[self addCell:@"023DTouch" class:@"T3DTouchViewController"];
	[self addCell:@"03二维码" class:@"GKHScanQCodeViewController"];
	[self addCell:@"04上下滑动" class:@"ContentOffSetVC"];
	[self addCell:@"05导航栏" class:@"LSTabBarViewController"];
	[self addCell:@"06签名" class:@"SignatureViewController"];
	[self addCell:@"07动画" class:@"ZLDashboardViewController"];
	[self addCell:@"08咖啡机" class:@"ActionViewController"];
	[self addCell:@"09碰撞球" class:@"TMotionViewController"];
	[self addCell:@"10侧边栏" class:@"TSidebarViewController"];
	[self addCell:@"11购物车" class:@"TShopAnimationViewController"];
	[self addCell:@"12身份证" class:@"IDCardViewController"];
	[self addCell:@"13图片滚动" class:@"ScrollImageViewViewController"];
	[self addCell:@"14添加图片" class:@"DHImagePickerViewController"];
	[self addCell:@"15待定" class:@"YYImageExample"];
	[self addCell:@"16待定" class:@"YYImageExample"];
	[self addCell:@"17待定" class:@"YYImageExample"];


	[_collectionView reloadData];
	_lb_showinfo = [[UILabel alloc]init];
	_lb_showinfo.backgroundColor = [UIColor brownColor];
	_lb_showinfo.textColor = [UIColor redColor];
	_lb_showinfo.font = DH_FontSize(12);
	_lb_showinfo.layer.borderColor = [UIColor redColor].CGColor;
	_lb_showinfo.layer.borderWidth = 1.0;
	_lb_showinfo.frame = CGRectMake(0, DH_DeviceHeight-44-30, DH_DeviceWidth, 25);
	[self.view addSubview:_lb_showinfo];
	
	[self developer];
	[self scrollerLabel];
	
}
- (void)addCell:(NSString *)title class:(NSString *)className {
	[self.titles addObject:title];
	[self.classNames addObject:className];
}
- (void)scrollerLabel{
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, DH_DeviceHeight-100, DH_DeviceWidth, 30)];
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
	return _titles.count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString * CellIdentifier = @"THomeCollectionViewCell";
	THomeCollectionViewCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//	_cell.imageCover.image = [UIImage imageNamed:@"Facebook"];
	_cell.labelName.text = _titles[indexPath.row];
	_cell.labelName.layer.borderColor = [UIColor blueColor].CGColor;
	_cell.labelName.layer.borderWidth = 1.0;
	
	_cell.layer.borderColor = [UIColor redColor].CGColor;
	_cell.layer.borderWidth = 1.0;
	
	return _cell;
	
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	[_collectionView deselectItemAtIndexPath:indexPath animated:NO];
	NSString *className = self.classNames[indexPath.row];
	Class class = NSClassFromString(className);
	if (class) {
		UIViewController *ctrl = class.new;
		ctrl.title = _titles[indexPath.row];
		push(ctrl);
	}
	
//	switch (indexPath.row) {
//		case 0:
//		{
//			ContentOffSetVC *tabbarOne = [[ContentOffSetVC alloc]init];
//			push(tabbarOne);
//		}
//			break;
//		case 1:{
//			T3DTouchViewController*tabbarTwo = [[T3DTouchViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 2:{
//			GKHScanQCodeViewController * sqVC = [[GKHScanQCodeViewController alloc]init];
//			sqVC.delegate=self;
//			UINavigationController * nVC = [[UINavigationController alloc]initWithRootViewController:sqVC];
//			[self presentViewController:nVC animated:YES completion:nil];
//			
//		}
//			break;
//		case 3:{
//			ContentOffSetVC*tabbarTwo = [[ContentOffSetVC alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 4:{
//			LSTabBarViewController*tabbarTwo = [[LSTabBarViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 5:{
//			SignatureViewController*tabbarTwo = [[SignatureViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 6:{
//			ZLDashboardViewController*tabbarTwo = [[ZLDashboardViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 7:{
//			ActionViewController*tabbarTwo = [[ActionViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 8:{
//			TMotionViewController*tabbarTwo = [[TMotionViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//			
//		case 9:{
//			TSidebarViewController*tabbarTwo = [[TSidebarViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 10:{
//			TShopAnimationViewController*tabbarTwo = [[TShopAnimationViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//			
//		case 11:{
//			IDCardViewController*tabbarTwo = [[IDCardViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//			
//		case 12:{
//			[self showPromptlanguage:@"全场卖两块,随便挑,随便选,都两块"];
//			DHNoteViewController*tabbarTwo = [[DHNoteViewController alloc]init];
//			push(tabbarTwo);
//		}
//			 break;
//		case 13:{
//			NetTestViewController*tabbarTwo = [[NetTestViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		case 14:{
//			DHZanViewController*tabbarTwo = [[DHZanViewController alloc]init];
//			push(tabbarTwo);
//		}
//			break;
//		
//		default:
//			break;
//	}
}
#pragma mark --UICollectionViewDelegateFlowLayout
//////定义每个Item 的大小(cell的宽高)
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat width = (self.view.frame.size.width/6);//间隙
	
	return CGSizeMake(width,width);
	
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	return UIEdgeInsetsMake(0, 0, 0, 0);//(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
}

//minimumLineSpacing 上下item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
	
	return 5;
}
//minimumInteritemSpacing 左右item之间的距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
	
	return 5;
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
//测试
- (void)showPromptlanguage:(NSString *)string
{
	[UIView animateWithDuration:1.0 animations:^{
		
		displayLabel.text = string;
		displayLabel.hidden = NO;
		
		//自适应高度
		CGRect txtFrame = displayLabel.frame;
		
		displayLabel.frame = CGRectMake(0, DH_DeviceHeight-50, DH_DeviceWidth,
										txtFrame.size.height =[string boundingRectWithSize:
															   CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
																				   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
																				attributes:[NSDictionary dictionaryWithObjectsAndKeys:displayLabel.font,NSFontAttributeName, nil] context:nil].size.height);
		NSLog(@"执行");


	} completion:^(BOOL finished) {
		timer = [NSTimer scheduledTimerWithTimeInterval:10.5f
												 target:self
											   selector:@selector(hiddenDataPicker)
											   userInfo:nil
												repeats:YES];
		[timer fire];
		
		NSLog(@"完成");
		
	}];
}

- (void)hiddenDataPicker{
	[UIView animateWithDuration:0.5 animations:^{
		displayLabel.frame = CGRectMake(0, DH_DeviceHeight+50, DH_DeviceWidth, 20);
		NSLog(@"执行隐藏");
	} completion:^(BOOL finished) {
		NSLog(@"执行完毕");
		[timer invalidate];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
