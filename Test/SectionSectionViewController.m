//
//  SectionSectionViewController.m
//  Test
//
//  Created by Rillakkuma on 16/8/24.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "SectionSectionViewController.h"

@interface SectionSectionViewController ()
{
    UITextField * _textField;//创建一个输入框
}
@end

@implementation SectionSectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"第二页";
    
    
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 80, 200, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 120, 50, 50);
    button.titleLabel.text = @"Back";
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(didClickButtonAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];


}
- (void)didClickButtonAction
{
    
    //第一步注册通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"labelTextNotification" object:_textField.text];
    [self dismissViewControllerAnimated:YES completion:^{
        
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
