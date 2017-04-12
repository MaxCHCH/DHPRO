//
//  DoubleTableViewController.m
//  Test
//
//  Created by Rillakkuma on 16/8/15.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "DoubleTableViewController.h"

@interface DoubleTableViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIButton *buttonName;//选择公司
    UITableView *tableViewMy;//原数据列表
    UITableView *tableViewrResult;//搜索结果的数据
    NSArray *array,*arraySub;
    
    
    BOOL m_bHidden;
}
@end

@implementation DoubleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    array = @[@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1"];
    arraySub = @[@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考",@"阿打算考"];
    // Do any additional setup after loading the view.
    buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonName setFrame:CGRectMake(0, 64, 320, 50)];
    [buttonName setTitle:@"选择公司项目" forState:(UIControlStateNormal)];
    [buttonName setTitleColor:[UIColor colorWithRed:0.102 green:0.596 blue:0.557 alpha:1.000] forState:(UIControlStateNormal)];
    buttonName.layer.borderWidth = 0.3;
    buttonName.layer.borderColor = [UIColor grayColor].CGColor;
    [buttonName addTarget:self action:@selector(chooseTopSection:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:buttonName];
    
    
    tableViewMy = [[UITableView alloc]init];
    tableViewMy.hidden = YES;
    tableViewMy.delegate = self;
    tableViewMy.dataSource = self;
    tableViewMy.frame = CGRectMake(0, buttonName.frame.size.height+64, 320, 568);
    [self.view addSubview:tableViewMy];
    
    
    tableViewrResult = [[UITableView alloc]init];
    tableViewrResult.hidden = YES;
    tableViewrResult.delegate = self;
    tableViewrResult.dataSource = self;
    tableViewrResult.frame = CGRectMake(0,buttonName.frame.size.height+64,320, 568);
    [self.view addSubview:tableViewrResult];

}
- (void)chooseTopSection:(UIButton *)sender{
//    [UIView animateWithDuration:0.2f animations:^{
//        sender.userInteractionEnabled = false;
//        
//        if (m_bHidden!= NO) {//yes
//            tableViewrResult.hidden = NO;
//            tableViewMy.hidden = YES;
//            
//        }else{
//            tableViewMy.hidden = NO;
//            tableViewrResult.hidden = YES;
//        }
//        
//    } completion:^(BOOL finished) {
//        sender.userInteractionEnabled = true;
//        m_bHidden = !m_bHidden;
//        
//    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        sender.userInteractionEnabled = false;
        
        if (m_bHidden!=NO) {//yes
            tableViewrResult.hidden = NO;
            tableViewMy.hidden = YES;
        }else{
            tableViewMy.hidden = NO;
            tableViewrResult.hidden = YES;
        }
        
    } completion:^(BOOL finished) {
        sender.userInteractionEnabled = true;
        if (tableViewMy.hidden == NO) {
            m_bHidden = YES;
        }else{
            m_bHidden = tableViewrResult.hidden == NO?YES:NO;
        }
        //        m_bHidden = !m_bHidden;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (m_bHidden!=NO) {
        return arraySub.count;

    }else{
        return array.count;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    if (m_bHidden!=NO) {
        cell.textLabel.text = arraySub[indexPath.row];
        return cell;
    }
    else{
        cell.textLabel.text =array[indexPath.row];
        
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (m_bHidden) {
        [buttonName setTitle:cell.textLabel.text forState:(UIControlStateNormal)];
        [self chooseTopSection:buttonName];
        [tableViewrResult reloadData];
        if (tableView == tableViewrResult){
            
            NSLog(@"跳下一个界面");
        }

    }
   

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
