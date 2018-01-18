//
//  GameRuleViewController.m
//  zhidoushi
//
//  Created by xinglei on 15/1/30.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GameRuleViewController.h"
#import "WWTolls.h"
#import "MobClick.h"

@interface GameRuleViewController ()
{
    float sheight;
}
@end

@implementation GameRuleViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"任务攻略页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"任务攻略页面"];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    self.titleLabel.text = @"任务攻略";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.backGroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.backImageView.height+14);
//    self.backImageView.backgroundColor = [UIColor redColor];
    if (iPhone4) {
        self.backGroundScrollView.height = [UIScreen mainScreen].bounds.size.height;
        //        self.backGroundScrollView.contentSize = CGSizeMake(320,self.backImageView.size.height+44);
    }
}

-(void)popButton
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.backImageView.image = [UIImage imageNamed:@"moreRules"];
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
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
