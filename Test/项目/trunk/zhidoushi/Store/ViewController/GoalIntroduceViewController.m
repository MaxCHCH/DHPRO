//
//  GoalIntroduceViewController.m
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "GoalIntroduceViewController.h"

@interface GoalIntroduceViewController ()

@end

@implementation GoalIntroduceViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.titleLabel.text = [NSString stringWithFormat:@"斗币说明"];
    self.titleLabel.textColor =ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(20);

    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    //    [self.leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backGroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 700);
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
