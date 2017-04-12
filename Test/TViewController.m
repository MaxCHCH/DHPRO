//
//  TViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/4.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TViewController.h"
#import "TTableViewCell.h"
@interface TViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewT.delegate = self;
    _tableViewT.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        return  3;
    }
    else if (section == 2){
        return 8;
    }
    return 1;

}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"AAAAA";
    }
    else if (section == 1){
        return @"BBBBBB";
    }
    else if (section == 2){
        return @"CCCCCC";
    }
    return @"1";
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *ID =@"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
//    }
//    return cell;
    
    TTableViewCell *cell = [TTableViewCell cellWithTableView:tableView];

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    if (indexPat.section == 1) {
        return 80;
    }
    else if (indexPat.section == 2){
        return 130;
    }
    
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    
    return 30;
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
