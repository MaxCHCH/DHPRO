//
//  AddressBookViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/1/17.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "AddressBookViewController.h"
#import "UserInfo.h"
#import "pinyin.h"
#import "ChineseString.h"

@interface AddressBookViewController ()
{
	NSMutableArray *dataArray;//数据源
	UITableView *tableViewMy;
	
	NSMutableArray *indexArray, *LetterResultArr;

}
@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	dataArray = [NSMutableArray array];
	[self setUI];
	[self loadData];
	[tableViewMy reloadData];

}
- (void)setUI{
	tableViewMy = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, DeviceWidth, DeviceHeight-20) style:(UITableViewStylePlain)];
	tableViewMy.delegate = self;
	tableViewMy.dataSource = self;
	tableViewMy.sectionIndexColor = [UIColor colorWithRed:0.169 green:0.737 blue:0.698 alpha:1.000];
	[self.view addSubview:tableViewMy];

}
- (void)loadData {
	
	NSDictionary *parameters = @{@"UserID":@"2"};
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.requestSerializer.timeoutInterval = 3;
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[manager GET:@"http://kaifa.homesoft.cn/WebService/jsonInterface.ashx?json=GetUserInfoAll" parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
			
		} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
			if ([responseObject[@"result"] isEqualToString:@"True"]) {
				[self reloaddataArr:responseObject[@"UserInfo"]];
				NSLog(@"dataArray %@--%lu",dataArray,(unsigned long)dataArray.count);
				NSMutableArray *arr = [NSMutableArray array];
				
				[dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
					UserInfo *model = dataArray[idx];
					
					[arr addObject:model.Name];
				}];
				indexArray = [ChineseString IndexArray:arr];
    
				LetterResultArr = [ChineseString LetterSortArray:arr];
				
				
				[tableViewMy reloadData];
			}
			
		} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
			
		}];
	});
	
}
- (void)reloaddataArr:(NSArray *)arr{
	[dataArray removeAllObjects];
	for (int i = 0; i<[arr count]; i++) {
		NSDictionary *dic = [arr objectAtIndex:i];
		UserInfo * getRepairDetail = [[UserInfo alloc]init];
		[getRepairDetail setValuesForKeysWithDictionary:dic];
		[dataArray addObject:getRepairDetail];
	}
}
#pragma mark -Section的Header的值
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *key = [indexArray objectAtIndex:section];
	return key;
}
#pragma mark - Section header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 20)];
	lab.backgroundColor = [UIColor grayColor];
	lab.text = [indexArray objectAtIndex:section];
	lab.textColor = [UIColor whiteColor];
	return lab;
}
#pragma mark -
#pragma mark Table View Data Source Methods
#pragma mark -设置右方表格的索引数组
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	return indexArray;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	NSLog(@"title===%@",title);
	return index;
}
#pragma mark -允许数据源告知必须加载到Table View中的表的Section数。
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [indexArray count];
}
#pragma mark -设置表格的行数为数组的元素个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[LetterResultArr objectAtIndex:section] count];
}
//#p
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//	return dataArray.count;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ID =@"UITableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
	}
//	UserInfo * getRepairDetail = dataArray[indexPath.row];
	NSLog(@"%@---",[LetterResultArr objectAtIndex:indexPath.section]);
	cell.textLabel.text = [[LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
	[cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kaifa.homesoft.cn/%@",[[LetterResultArr objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]] placeholderImage:[UIImage imageNamed:@"check_icon@2x"]];
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
