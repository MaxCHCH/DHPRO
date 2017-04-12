//
//  FirstFirstViewController.m
//  Test
//
//  Created by Rillakkuma on 16/8/24.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "FirstFirstViewController.h"
#import "SectionSectionViewController.h"
@interface FirstFirstViewController ()

@end

@implementation FirstFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"首页";
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 80, 200, 30)];
    _label.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 120, 50, 50);
    button.titleLabel.text = @"Push";
    button.backgroundColor = [UIColor lightGrayColor];
    [button addTarget:self action:@selector(didClickButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    //第二步,通知中心,发送一条消息通知----------其中name名字千万不要写错了,会出现在3个地方
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLabelText:) name:@"labelTextNotification" object:nil];

}
- (void)showLabelText:(NSNotification *)notification
{
    //第三,实现通知中心内部的方法,并实现传值
    id text = notification.object;
    _label.text = text;
}

- (void)didClickButtonAction
{
    
    
    SectionSectionViewController * secondVC = [[SectionSectionViewController alloc]init];
    [self presentViewController:secondVC animated:YES completion:^{
        
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
