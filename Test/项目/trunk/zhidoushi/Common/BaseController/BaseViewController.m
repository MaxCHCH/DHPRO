//
//  BaseViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-9-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

#import "WWTolls.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if(self.tabBarController.selectedIndex != 2){//通知其他页面
        [NSUSER_Defaults setObject:@"YES" forKey:@"quleqitayemian"];
        [NSUSER_Defaults synchronize];
    }
    
    //    [[UIApplication sharedApplication]setStatusBarHidden:YES];//是否显示状态栏
    //    self.navigationController.navigationBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    //    self.navigationController.navigationBar.tintColor = [WWTolls colorWithHexString:@"27ee56"];
    //    self.navigationController.navigationBar.barTintColor = [WWTolls colorWithHexString:@"27ee56"];
    //改变状态栏颜色
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    if (self.navigationController.childViewControllers.count == 1) {
    //        [self.tabBarController.tabBar setHidden:NO];
    //    }else [self.tabBarController.tabBar setHidden:YES];
    if(!iOS8){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.lastId = @"0";
    
    self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.leftButton.titleLabel.font = MyFont(16.0);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:self.leftButton];
    [self.navigationItem setLeftBarButtonItem:leftBtn];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, 180, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = MyFont(20.0);
    _titleLabel.textColor = [UIColor whiteColor];
    //    _titleLabel.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTop)];
    //    [_titleLabel addGestureRecognizer:tap];
    [self.navigationItem setTitleView:self.titleLabel];
    
    // 清空导航条背景图片,系统判断当前是否为Nil,如果为nil,系统还是会自动生成一张背景图片
    //    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_640_88"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
}
-(UIButton *)leftButonWithImagename:(NSString *)name action:(SEL)selctor
{
    [self.leftButton setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    return self.leftButton;
}
-(UIButton *)rightButonWithTitle:(NSString *)title action:(SEL)selctor
{
    [self.rightButton setTitle:title forState:UIControlStateNormal];
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:selctor forControlEvents:UIControlEventTouchUpInside];
    return self.rightButton;
}
-(UIView *)customTitleView{
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    return titleViews;
}


//- (void)backTop{
//    for (UIView *chirldView in self.view.subviews) {
//        if ([chirldView isKindOfClass:[UIScrollView class]]) {
////            ((UIScrollView*)chirldView).scrollsToTop = YES;
//            [((UIScrollView*)chirldView) setContentOffset:CGPointZero animated:YES];
//        }
//    }
//}

-(instancetype)init{
    self = [super init];
    if (self) {
        if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            if (((UITabBarController*)([UIApplication sharedApplication].keyWindow.rootViewController)).selectedViewController.childViewControllers.count == 1) {
                self.hidesBottomBarWhenPushed = YES;
            }
        }
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
