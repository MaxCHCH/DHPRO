//
//  ListViewHeaderFooterViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/4/12.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "ListViewHeaderFooterViewController.h"
#import "TableViewCell.h"
#import "SectionHeaderView.h"
#import "CellModel.h"
#import "FooterView.h"
#import "ResultModel.h"
@interface ListViewHeaderFooterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL expandFlag;
@property (nonatomic, strong) NSMutableArray *footerDataArray;

@end

@implementation ListViewHeaderFooterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"合同详情";
	self.view.backgroundColor = [UIColor whiteColor];

	[self initialData];
	[self setUI];

    // Do any additional setup after loading the view.
}
#pragma mark - InitialData

- (void)initialData {
	
	self.dataArray = [NSMutableArray array];
	for (NSInteger i = 0; i < 8; i++) {
		CellModel *model = [[CellModel alloc]init];
		model.titleStr = @"合同编号: ";
		model.contentStr = [NSString stringWithFormat:@"合同编号%ld",i];
		[self.dataArray addObject:model];
	}
	
	self.footerDataArray = [NSMutableArray array];
	for (NSInteger i = 0; i < 3; i++) {
		ResultModel *model = [[ResultModel alloc]init];
		model.name = @"我";
		model.time = @"2017年12月20日";
		model.content = @"没事奥德赛发的所发生的范德萨发奥德赛发大水发的说法不要请假哟!";
		model.flag = @"同意";
		[self.footerDataArray addObject:model];
	}
}

#pragma mark - 设置界面

- (void)setUI {
	
	self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStyleGrouped];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.tableFooterView = [[UIView alloc]init];
	// 注册cell
	[self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:NSStringFromClass([TableViewCell class])];
	[self.tableView registerClass:[SectionHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([SectionHeaderView class])];
	[self.view addSubview: self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (section == 0) {
		return self.dataArray.count;
	} else {
		return self.expandFlag ? 3 : 0;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TableViewCell class]) forIndexPath:indexPath];
	cell.model = self.dataArray[indexPath.row];
	return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	
	if (section == 1) return 40;
	return FLT_EPSILON;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	
	if (section == 1) {
		return [FooterView ticketExamineResultViewWithExamineResultArray:self.footerDataArray].height ? : 0.0f;
	}
	return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	if (section == 1) {
		SectionHeaderView *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([SectionHeaderView class])];
		sectionHeaderView.contentView.backgroundColor = [UIColor clearColor];
		sectionHeaderView.block = ^(BOOL selected) {
			NSLog(@"%d",selected);
			self.expandFlag = selected;
			[self.tableView reloadData];
		};
		return sectionHeaderView;
	}
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
	FooterView *ticketExamineResultView;
	if (section == 1) {
		
		ticketExamineResultView = [FooterView ticketExamineResultViewWithExamineResultArray:self.footerDataArray];
		ticketExamineResultView.backgroundColor = [UIColor groupTableViewBackgroundColor];
		return ticketExamineResultView;
	} else {
		UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
		view.backgroundColor = [UIColor groupTableViewBackgroundColor];
		return view;
	}
	return nil;
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
