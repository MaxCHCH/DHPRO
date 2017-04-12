//
//  EquiPmentViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/12/2.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//
#define MaxHeight 200
#define MinHeight 100
#import "EquiPmentViewController.h"
#import "CCTableViewCell.h"
#import "NNTableViewCell.h"
@interface EquiPmentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	BOOL boolTag;
	UITableView *tableViewMy;
	NSMutableArray*arrayTag;
}
@end

@implementation EquiPmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	tableViewMy = [[UITableView alloc]init];
	tableViewMy.delegate = self;
	tableViewMy.dataSource = self;
	tableViewMy.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
	[self.view addSubview:tableViewMy];
	
	arrayTag = [NSMutableArray array];
	UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
	commitButton.backgroundColor = [UIColor redColor];
	commitButton.layer.borderColor = [UIColor redColor].CGColor;
	commitButton.layer.borderWidth = 1;
	
	[commitButton setTitle:@"提交" forState:(UIControlStateNormal)];
	[commitButton setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
	[commitButton setFrame:CGRectMake(10.0 ,10.0 ,DeviceWidth-20 ,50.0)];
	commitButton.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色

	tableViewMy.tableFooterView = commitButton;
	
    // Do any additional setup after loading the view from its nib.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 15;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
//	static NSString *ID = @"UITableViewCell";
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//	if (cell == nil) {
//		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
//	}
	CCTableViewCell *cell = [CCTableViewCell cellWithTableView:tableView];
	cell.nameLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
	if (indexPath.row == 14) {
//		UIView *viewRoot = [[UIView alloc]init];
//		viewRoot.backgroundColor = [UIColor lightGrayColor];
//		if (boolTag == NO) {
//			viewRoot.frame = CGRectMake(0, 0, DeviceWidth, 100);
//		}
//		else {
//			viewRoot.frame = CGRectMake(0, 0, DeviceWidth, 200);
//		};
//		[cell.contentView addSubview:viewRoot];
		NNTableViewCell *cellS = [NNTableViewCell cellWithTableView:tableView];
		
		if ([arrayTag count] <= indexPath.row) {
			[arrayTag addObject:@"0"];
		}
		if ([[arrayTag objectAtIndex:0] integerValue] == 0) {
			[cellS.normalBtn setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];
			[cellS.disnormarBtn setBackgroundColor:[UIColor whiteColor]];
			cellS.normalBtn.selected=YES;  //分别给
			cellS.disnormarBtn.selected = YES;
			
		}else{
			[cellS.normalBtn setBackgroundColor:[UIColor whiteColor]];//normal
			[cellS.disnormarBtn setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];//fix
			cellS.normalBtn.selected=NO;  //分别给
			cellS.disnormarBtn.selected = NO;
		}
		
		
		[cellS.normalBtn addTarget:self action:@selector(normalBtn:) forControlEvents:(UIControlEventTouchUpInside)];
		
		[cellS.disnormarBtn addTarget:self action:@selector(fastBtn:) forControlEvents:(UIControlEventTouchUpInside)];
		return cellS;
	}
	return cell;
	
}
//正常
- (void)normalBtn:(UIButton *)button{
	NSLog(@"正常按钮 状态-%d",button.selected);
	
	UIView *v = [button superview];//获取父类view
	NNTableViewCell *cell = (NNTableViewCell *)[v superview];//获取cell
	NSIndexPath *indexPathAll = [tableViewMy indexPathForCell:cell];//获取cell对应的section
	
	if (button.selected == 1) {
		NSLog(@"cheng");
//		cell.textFieldTxt.hidden = NO;
	}
	else{
		NSLog(@"bai");
//		cell.textFieldTxt.hidden = YES;
	}
	
	NSLog(@"正常按钮 状态-%d-----%ld",button.selected,indexPathAll.row);
	
	if ([[arrayTag objectAtIndex:0] integerValue] == 1) {
		[cell.normalBtn setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];
		cell.normalBtn.selected = YES;
		[cell.disnormarBtn setBackgroundColor:[UIColor whiteColor]];cell.disnormarBtn.selected = NO;
		[arrayTag replaceObjectAtIndex:0 withObject:@"0"];
	}
	
}
//故障
- (void)fastBtn:(UIButton *)button{
	NSLog(@"故障按钮 状态-%d",button.selected);
	UIView *v = [button superview];//获取父类view
	NNTableViewCell *cell = (NNTableViewCell *)[v superview];//获取cell
	NSIndexPath *indexPathAll = [tableViewMy indexPathForCell:cell];//获取cell对应的section
	
	if (button.selected == 1) {
		NSLog(@"cheng");
//		cell.textFieldTxt.hidden = NO;
	}
	else{
		NSLog(@"bai");
//		cell.textFieldTxt.hidden = YES;
	}
	
	NSLog(@"故障按钮 状态-%d---%ld",button.selected,indexPathAll.row);
	
	if ([[arrayTag objectAtIndex:0] integerValue] == 0) {
		[cell.normalBtn setBackgroundColor:[UIColor whiteColor]];cell.normalBtn.selected=NO;
		[cell.disnormarBtn setBackgroundColor:[UIColor colorWithRed:0.165 green:0.773 blue:0.741 alpha:1.000]];
		cell.disnormarBtn.selected = NO;
		[arrayTag replaceObjectAtIndex:0  withObject:@"1"];
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 14) {
		if (boolTag == NO) {
			return 75;
		}return 200;
		
	}
	return 50;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
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
