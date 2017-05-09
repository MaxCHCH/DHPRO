//
//  AlipayViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/5/9.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "AlipayViewController.h"
#import "APViewController.h"
@interface AlipayViewController ()

@end

@implementation AlipayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	APViewController *AP = [[APViewController alloc]init];
	[self.navigationController pushViewController:AP animated:YES];
    // Do any additional setup after loading the view.
}
- (void)alipayMethod{
	
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
