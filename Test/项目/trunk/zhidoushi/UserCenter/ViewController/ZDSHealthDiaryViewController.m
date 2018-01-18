//
//  ZDSHealthDiaryViewController.m
//  zhidoushi
//
//  Created by System Administrator on 15/10/19.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSHealthDiaryViewController.h"
#import "ZDSHealthDiaryTableViewCell.h"
@interface ZDSHealthDiaryViewController ()

@end

@implementation ZDSHealthDiaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏标题
    self.titleLabel.text = @"健康日记";
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
    _m_arrayImage = [NSMutableArray array];
    
    
    //初始化刷新
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    self.header = header;
    header.scrollView = _m_tableView;
    //    __weak typeof(self) weakself = self;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
    };
    
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    self.footer = footer;
    footer.scrollView = _m_tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView){
        
    };
    

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZDSHealthDiaryTableViewCell *cell =[ZDSHealthDiaryTableViewCell cellWithTableView:tableView];
    
    return cell;
    
}
#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
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
