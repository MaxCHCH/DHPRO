//
//  MonitSelectedViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/12/15.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "MonitSelectedViewController.h"
#define kWidthOfScreen [[UIScreen mainScreen] bounds].size.width
#define kHeightOfScreen [[UIScreen mainScreen] bounds].size.height
@interface MonitSelectedViewController ()<UITableViewDataSource,UITableViewDelegate>
{
	UITableView*table;
	int cellCount;
}
@end

@implementation MonitSelectedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	table = [[UITableView alloc] init];
	table.frame = CGRectMake(0, 0, kWidthOfScreen, kHeightOfScreen);
	table.delegate = self;
	table.dataSource = self;
	//不允许滚动
	table.tableFooterView = [UIView new];
	[self.view addSubview:table];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapMethod)];
	[self.view addGestureRecognizer:tap];
	
	UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture:)];
	[self.view addGestureRecognizer:swipeGesture];
	
	
	if (_tabNum == 1) {
		cellCount = 7 + 1;
	}
	if (_tabNum == 2) {
		cellCount = 7 + 9;
	}
	if (_tabNum == 3) {
		cellCount = 7 + 9;
	}
	if (_tabNum == 4) {
		cellCount = 7 + 11;
	}
    // Do any additional setup after loading the view.
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
		//做自己想做的事
		return NO;
	}
	return YES;
}
- (void)handleSwipeGesture:(UIGestureRecognizer*)sender{
	UISwipeGestureRecognizerDirection direction=[(UISwipeGestureRecognizer*) sender direction];
	[self tapMethod];
}
- (void)tapMethod{
	[self dismissViewControllerAnimated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return cellCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ID =@"UITableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
	}
	cell.textLabel.text = [NSString stringWithFormat:@"这是第%ld行",indexPath.row];
	return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
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
