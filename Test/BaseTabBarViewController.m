//
//  BaseTabBarViewController.m
//  LBJH
//
//  Created by 创投天下 on 15/9/2.
//  Copyright (c) 2015年 cttx. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "BaseNavigationController.h"

#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface BaseTabBarViewController ()<UITabBarControllerDelegate>
{
    UILabel *_redLab;
}

@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myTabbar];
    // Do any additional setup after loading the view.
}
- (void)myTabbar
{   OneViewController *one = [[OneViewController alloc]init];
    [self addOneChildVC:one title:@"你好" backgroundColor:nil imageName:@"soul1" selectedName:@"soul11"];
    one.tabBarItem.title = @"创业圈";
    
    
    TwoViewController *two = [[TwoViewController alloc]init];
    [self addOneChildVC:two title:@"啦啦啦" backgroundColor:nil imageName:@"soul2" selectedName:@"soul22"];
    two.tabBarItem.title = @"啦啦啦";
    
    ThreeViewController *three = [[ThreeViewController alloc]init];
    [self addOneChildVC:three title:@"我的" backgroundColor:nil imageName:@"soul3" selectedName:@"soul33"];
    three.tabBarItem.title = @"个人中心";

}
- (void)addOneChildVC:(UIViewController *)childVC title:(NSString *)title backgroundColor:(UIColor *)color imageName:(NSString *)imageName selectedName:(NSString *)selectImageName
{
    childVC.navigationItem.title = title;
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.image = image;
    
    UIImage *selectImage = [UIImage imageNamed:selectImageName];
    selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   childVC.tabBarItem.selectedImage = selectImage;
    
//    
//    UIView *tabBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 460-48,375, 48)] ;
//    [self.view addSubview:tabBarView];
//    //    UIImageView *backGroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabBar_background.png"]];
//    tabBarView.backgroundColor = IWColor(255,155,0);    [tabBarView addSubview:tabBarView];

    
    BaseNavigationController *childNav = [[BaseNavigationController alloc]initWithRootViewController:childVC];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor greenColor],NSForegroundColorAttributeName, nil] forState:(UIControlStateNormal)];
    
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];

    
    //背景色
    self.tabBar.barTintColor = [UIColor whiteColor];
    [self addChildViewController:childNav];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end








