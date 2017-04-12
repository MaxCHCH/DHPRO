//
//  HeaderViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/4.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "HeaderViewController.h"
#import "HeaderView.h"
static NSString * const JPHeaderId = @"header";

@interface HeaderViewController ()
{
    HeaderView *headerView;
    NSArray *arrayData;
}
@end

@implementation HeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayData = @[@"数据显示",@"明正办理",@"善恶关系",@"我收的徒弟",@"金币数量",@"我的资料",@"设置"];
//    [_tableViwMt registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:JPHeaderId];
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString * identy = @"headFoot";

    UITableViewHeaderFooterView * hf = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identy];
    if (section == 0) {
        
    
    
    if (!hf) {
        
        
        hf = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:identy];
        
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//        
//        view.backgroundColor = [UIColor redColor];
//        
//        [hf addSubview:view];
        
        for (int i = 0; i<arrayData.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10+i*30, 100, 30)];
            //            label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            label.textColor = [UIColor blackColor];
            label.text = arrayData[i];
            label.font = [UIFont systemFontOfSize:14];
            [hf addSubview:label];
            
        }
        
    }
    
    // hf.contentView.backgroundColor = [UIColor purpleColor];（去掉此行注释：可设置hf。contentView背景色），若此行和上一行都不注释，显示红色
    
    return hf;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==  0) {
        return 0;
    }
    if (section == 1) {
       return 30;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 300;
    }
    
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%i",indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
