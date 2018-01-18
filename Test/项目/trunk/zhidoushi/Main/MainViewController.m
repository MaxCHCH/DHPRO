//
//  MainViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-10-28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <objc/runtime.h>

#import "MainViewController.h"

#import "GlobalUse.h"
#import "GameViewController.h"
#import "LoginViewController.h"
#import "MessageViewController.h"
#import "MeViewController.h"
#import "WWTolls.h"
#import "Define.h"
#import "XTabBar.h"
#import "DiscoverViewController.h"

#import "YCGameViewController.h"

@interface MainViewController ()
{
    UIButton * mybutton;
}

@property(nonatomic,strong)LoginViewController *login;

@end

#define SHAREDAPPDELE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

@implementation MainViewController

static MainViewController *mainInstance;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self configureSubViewController];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)configureSubViewController{

    //大厅
//    GameViewController *game = [[GameViewController alloc]init];
//    UINavigationController *gameNA = [[UINavigationController alloc]initWithRootViewController:game];
    YCGameViewController *game = [[YCGameViewController alloc]init];
    UINavigationController *gameNA = [[UINavigationController alloc]initWithRootViewController:game];
    
    //发现
    DiscoverViewController *discover = [[DiscoverViewController alloc]init];
    UINavigationController *myGameNA = [[UINavigationController alloc]initWithRootViewController:discover];
    //消息
    MessageViewController *store = [[MessageViewController alloc]init];
    UINavigationController *stroeNA = [[UINavigationController alloc]initWithRootViewController:store];
    //我
    MeViewController *user = [[MeViewController alloc] init];
    user.otherOrMe = 0;
    UINavigationController *userNA = [[UINavigationController alloc]initWithRootViewController:user];

    NSArray *viewControllers = [NSArray arrayWithObjects:gameNA,myGameNA,stroeNA,userNA,nil];
    
    
    _tabBarController = [[UITabBarController alloc] init];
    _tabBarController.viewControllers = viewControllers;
    _tabBarController.selectedIndex = 1;
    NSLog(@"%p",self.tabBarController);
    SHAREDAPPDELE.window.rootViewController = _tabBarController;
    SHAREDAPPDELE.window.makeKeyAndVisible;
    [_tabBarController setValue:[XTabBar shareXTabBar] forKeyPath:@"tabBar"];
    _tabBarController.tabBar.hidden = NO;
//    _tabBarController.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//
//    
//}
//
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//    //@"jznum",@"shnum",@"zwnum",@"djnum"
//    switch (tabBarController.selectedIndex) {
//        case 0:
//            [WWTolls zdsClick:@"jznum"];
//            break;
//        case 1:
//            [WWTolls zdsClick:@"shnum"];
//            break;
//        case 2:
//            [WWTolls zdsClick:@"djnum"];
//            break;
//        case 3:
//            [WWTolls zdsClick:@"zwnum"];
//            break;
//        default:
//            break;
//    }
//}


@end








