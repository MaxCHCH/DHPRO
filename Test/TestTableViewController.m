//
//  TestTableViewController.m
//  Test
//
//  Created by Rillakkuma on 16/6/15.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TestTableViewController.h"
#import "WViewController.h"
#import "GetDictionaryByID.h"
@interface TestTableViewController ()
{
    NSArray *section3titles;
}
@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    _tableViewMy.delegate = self;
    _tableViewMy.dataSource = self;
    
    
    section3titles = @[@"报修人员",@"报修地址",@"联系电话",@"报修时间",
                       @"维修人员",
                       @"物料费用",@"人工费用",@"维修结果"];
    [self load];
    
}
- (void)load{
    NSString *urlll =[NSString stringWithFormat:@"%@&DTypeID=HRM027",API_BASE_URL(@"GetDictionaryByID")];
    
    urlll = [urlll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:urlll parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		float u = downloadProgress.fractionCompleted;
		NSLog(@"%.2f",u*0.03);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self loadArray:responseObject[@"Dictionary"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
//    [manager GET:urlll parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];

}
- (void)loadArray:(NSArray *)arr{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section3titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
    }
    cell.detailTextLabel.text = section3titles[indexPath.row];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        HYJNegotiateView *size =[HYJNegotiateView instanceSizeTextView];
        size.delegate = self;
        size.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        [size.viewBackGround addGestureRecognizer:size.tapGesture];
        [size.tapGesture addTarget:self action:@selector(oneBtnsMethod)];
        [[UIApplication sharedApplication].keyWindow addSubview:size];
        self.negotiate = size;
        
    }
}
-(void)oneBtnsMethod{
    [self.negotiate removeFromSuperview];
    [self.negotiate.viewBackGround removeFromSuperview];
}
- (void)HYJxxiangqingSizevviewGouwuChe:(NSString *)sender indexPathS:(NSIndexPath *)indexPaths{
    NSLog(@"点击%@",sender);
    NSLog(@"--%@",indexPaths);

    WViewController *d= [[WViewController alloc]init];
    [self presentViewController:d animated:YES completion:nil];

//    [self.navigationController popViewControllerAnimated:YES];
    [self oneBtnsMethod];
    
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
