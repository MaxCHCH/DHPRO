//
//  LBEquiXSViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/2/21.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "LBEquiXSViewController.h"
#import "LBLabel&TextFieldCell.h"
#define kCellIdentify @"LBLabel_TextFieldCell"

@interface LBEquiXSViewController ()<UITableViewDelegate,UITableViewDataSource>
{
	UITableView *tableViewMy;
	UIView *headAllView,*headRunParamsView;
	NSArray *titleArray;//显示名称

	NSInteger numberCount;//行数
	NSInteger sectionHeight;//头高度
	UIButton *addImageBtn;//添加图片按钮
	NSInteger runCount;//运行行数

}

@end

@implementation LBEquiXSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.navigationController.interactivePopGestureRecognizer.enabled = YES;

	[self setUI];
	[self setData];
    // Do any additional setup after loading the view.
}
- (void)setData{
	numberCount = 6;runCount = 0;
	sectionHeight = 20;
	titleArray = @[@"巡查项目",@"设备编号",@"设备名称",@"设备位置",@"设备数量",@"重点巡查",@"生产厂家",@"设备型号",@"电机型号",@"技术参数",@"设备规格",@"设备状况",@"出厂编号",@"其他备注"];

}
-(void)setUI{
	
	tableViewMy = [[UITableView alloc]init];
	tableViewMy.layer.borderColor = [UIColor redColor].CGColor;
	tableViewMy.layer.borderWidth = 0.1;
	tableViewMy.frame = CGRectMake(0, 20, DeviceWidth, DeviceHeight-20);
	tableViewMy.delegate = self;
	tableViewMy.dataSource = self;tableViewMy.tableFooterView = [UIView new];
	[tableViewMy registerClass:[LBLabel_TextFieldCell class] forCellReuseIdentifier:kCellIdentify];
	[self.view addSubview:tableViewMy];
	
	//查看更多按钮
	headAllView = [[UIView alloc]init];
	headAllView.frame = CGRectMake(0, 0, DeviceWidth, 20);
	UIButton *titLabel = [UIButton buttonWithType:UIButtonTypeCustom];
	[titLabel setTitle:@"查看更多" forState:(UIControlStateNormal)];
	[titLabel addTarget:self action:@selector(showMoreInfo) forControlEvents:(UIControlEventTouchUpInside)];
	[titLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	titLabel.frame = CGRectMake(0, 0, DeviceWidth, 20);
	titLabel.titleLabel.textAlignment = NSTextAlignmentCenter;
	[headAllView addSubview:titLabel];
	headAllView.backgroundColor = [UIColor darkGrayColor];
	
	
	
	//运行状态
	headRunParamsView = [[UIView alloc]init];
	headRunParamsView.frame = CGRectMake(0, 0, DeviceWidth, 30);
	
	
	UILabel *RunParamsLabel = [[UILabel alloc]init];
	RunParamsLabel.frame = CGRectMake(15, 0, 80, 30);
	RunParamsLabel.text = @"运行状态";
	RunParamsLabel.textColor = [UIColor blackColor];
	[headRunParamsView addSubview:RunParamsLabel];

	UIButton *normarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[normarBtn setFrame:CGRectMake(RunParamsLabel.frame.origin.x+RunParamsLabel.frame.size.width, 0, 40, 30)];
	[normarBtn setTitle:@"正常" forState:(UIControlStateNormal)];
	[normarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[normarBtn addTarget:self action:@selector(normal) forControlEvents:(UIControlEventTouchUpInside)];
	[headRunParamsView addSubview:normarBtn];
	
	
	UIButton *fixBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[fixBtn setFrame:CGRectMake(normarBtn.frame.origin.x+normarBtn.frame.size.width+20, 0, 40, 30)];
	[fixBtn setTitle:@"故障" forState:(UIControlStateNormal)];
	[fixBtn addTarget:self action:@selector(Fault) forControlEvents:(UIControlEventTouchUpInside)];
	[fixBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[headRunParamsView addSubview:fixBtn];
	
	headRunParamsView.backgroundColor = [UIColor darkGrayColor];
	
}
- (void)normal{
	runCount = 0;
	[tableViewMy reloadData];

}
- (void)Fault{
	runCount = 1;
	[tableViewMy reloadData];

}
- (void)showMoreInfo{
	numberCount = titleArray.count;
	sectionHeight = 0;
	[tableViewMy reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	if (section == 1) {
		return headAllView;
	}
	if (section == 2) {
		return headRunParamsView;
	}
	return nil;

}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	NSLog(@"计算分组数");
	return 3;
	
}
//设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 1) {
		return sectionHeight;
	}
	if (section == 2) {
		return 30;
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 0) {
		
		return numberCount;
	}
	if (section == 1) {
		return 1;
	}
	if (section == 2) {
		
		return runCount;
	}
	return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ID = @"UITableViewCell";
	UITableViewCell *celll = [tableView dequeueReusableCellWithIdentifier:ID];
	if (celll == nil) {
		celll = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
	}

	
	if (indexPath.section == 0) {
		LBLabel_TextFieldCell *cell = [tableViewMy dequeueReusableCellWithIdentifier:kCellIdentify forIndexPath:indexPath];
		cell.titleLabel.text = titleArray[indexPath.row];
		return cell;

	}
	if (indexPath.section == 1) {
		//添加图片
		
		addImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[addImageBtn setFrame:CGRectMake(15, 5 , 40, 40)];
		addImageBtn.backgroundColor = [UIColor clearColor];       //背景颜色
		addImageBtn.layer.borderWidth = 0.3;
		addImageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//		[addImageBtn addTarget:self action:@selector(addImageMethod) forControlEvents:(UIControlEventTouchUpInside)];
		[addImageBtn setImage:[UIImage imageNamed:@"work_comming.png"] forState:(UIControlStateNormal)];
		[celll.contentView addSubview:addImageBtn];
		
	}
	return celll;

}
//-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//	if (section == 1) {
//		//        return [NSString stringWithFormat:@"优惠期间费用明细-%i条信息",arrayDataVlaue.count];
//		return @"物料明细";
//	}
//	else if (section == 2){
//		return @"审批意见";
//	}
//	return @" ";
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
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
