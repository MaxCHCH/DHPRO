//
//  CollectionViewController.m
//  zhidoushi
//
//  Created by glaivelee on 15/11/4.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CollectionViewController.h"
#import "ArticleTableViewCell.h"
@interface CollectionViewController ()

@end

@implementation CollectionViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的收藏"];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"我的收藏"];
    [UIApplication sharedApplication].statusBarHidden = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    //导航栏标题
    self.titleLabel.text = @"我的收藏";
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
//    //发布
//    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"sdsb-42"] forState:UIControlStateNormal];
//    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font = MyFont(13);
////    [self.rightButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
//    labelRect = self.rightButton.frame;
//    labelRect.size.width = 21;
//    labelRect.size.height = 21;
//    self.rightButton.frame = labelRect;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * showUserInfoCellIdentifier = @"ShowUserInfoCell";
    ArticleTableViewCell * cell = [_myTableView dequeueReusableCellWithIdentifier:showUserInfoCellIdentifier];
    if (cell == nil)
    {
        // Create a cell to display an ingredient.
        cell = [[ArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:showUserInfoCellIdentifier];
        cell = [ArticleTableViewCell loadNib];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.topTag.hidden = YES;
    return cell;
    // Configure the cell.
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
