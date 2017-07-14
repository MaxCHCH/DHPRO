//
//  BaseNavigationController.m
//  ennew
//
//  Created by mijibao on 15/5/22.
//  Copyright (c) 2015年 ennew. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseTabBarViewController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
//{
//    UIView *alphaView;
//}

//-(id)initWithRootViewController:(UIViewController *)rootViewController{
//    self = [super initWithRootViewController:rootViewController];
//    if (self) {
//        CGRect frame = self.navigationBar.frame;
//        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height+20)];
////        alphaView.backgroundColor = IWColor(255,155,0);
//        [self.view insertSubview:alphaView belowSubview:self.navigationBar];
//        self.navigationBar.layer.masksToBounds = YES;
//    }
//    return self;
//}
//
//-(void)setBarTransparent:(BOOL)barTransparent
//{
//    _barTransparent =barTransparent;
//    if(barTransparent == YES){
//        [UIView animateWithDuration:0.5 animations:^{
//            alphaView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//        }];
//    }else{
//        [UIView animateWithDuration:0.5 animations:^{
//            alphaView.alpha = 1.0;
//        } completion:^(BOOL finished) {
//        }];
//    }
//}
//

- (void)viewDidLoad {
    [super viewDidLoad];
    
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
