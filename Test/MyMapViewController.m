//
//  MyMapViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/11/2.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "MyMapViewController.h"

@interface MyMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
	BMKMapView*_mapView;
}
@property(strong,nonatomic) BMKLocationService *locService;

@end

@implementation MyMapViewController
-(void)viewWillAppear:(BOOL)animated
{
	[_mapView viewWillAppear];
	_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	UIButton *anbtn;
	anbtn = [UIButton buttonWithType:UIButtonTypeCustom];
	anbtn.frame =CGRectMake(DeviceWidth-200,30,26,26);
	[anbtn setBackgroundColor:[UIColor redColor]];
	anbtn.layer.masksToBounds =NO;
	anbtn.layer.frame = anbtn.frame;
	anbtn.layer.borderColor = [UIColor cyanColor].CGColor;
	anbtn.layer.cornerRadius=13;
	anbtn.layer.shadowOffset = CGSizeMake(0, 3); //设置阴影的偏移量
	anbtn.layer.shadowRadius = 10;  //设置阴影的半径
	anbtn.layer.shadowColor = [UIColor colorWithRed:0.000 green:0.773 blue:1.000 alpha:1.000].CGColor; //设置阴影的颜色为黑色
	anbtn.layer.shadowOpacity = 0.8; //设置阴影的不透明度
	[anbtn addTarget:self action:@selector(btnclickAnbtn:) forControlEvents:UIControlEventTouchUpInside];

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:anbtn];

	
	
	BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];

	[self.view addSubview:mapView];
	//以下_mapView为BMKMapView对象
	_mapView.showsUserLocation = YES;//显示定位图层
	
	_locService = [[BMKLocationService alloc]init];
	_locService.delegate = self;
	//启动LocationService
	[_locService startUserLocationService];
	_mapView.zoomLevel = 22;//加载比例尺

	_mapView.showsUserLocation = YES;//显示定位图层

//	self.view = mapView;
    // Do any additional setup after loading the view.
}
- (void)btnclickAnbtn:(UIButton *)ser{
	[_locService startUserLocationService];
	
	_mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;//设置定位的状态

	_mapView.centerCoordinate = _locService.userLocation.location.coordinate;

}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
	[_mapView updateLocationData:userLocation];

	//NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
	//NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
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
