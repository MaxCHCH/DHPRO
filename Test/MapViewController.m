//
//  MapViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/11/1.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI/BMKMapView.h>//只引入所需的单个头文件
@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
@property(strong,nonatomic) BMKMapView *mapView;
@property(strong,nonatomic) BMKLocationService *locService;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	_mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth,DeviceHeight/3)];
	_mapView.showsUserLocation = NO;//先关闭显示的定位图层
	_mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
	_mapView.showsUserLocation = YES;//显示定位图层
	_mapView.zoomLevel = 22;//加载比例尺
	_mapView.rotateEnabled = NO;//支持旋转
	_mapView.overlookEnabled = NO;//支持俯仰角
	_mapView.showMapScaleBar = NO;//比例尺
	//    //设置定位精确度，QQ默认：kCLLocationAccuracyBest
	[BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
	//    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
	[BMKLocationService setLocationDistanceFilter:10.f];
	_mapView.isSelectedAnnotationViewFront = YES;
	//    _mapView.centerCoordinate = _locService.userLocation.location.coordinate;
	[self.view addSubview:_mapView];
	
	_geocodesearch = [[BMKGeoCodeSearch alloc]init];
	
	_locService = [[BMKLocationService alloc]init];
	
	_searcher =[[BMKPoiSearch alloc]init];
	_searcher.delegate = self;
	//启动LocationService
	[_locService startUserLocationService];
	
    // Do any additional setup after loading the view.
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
