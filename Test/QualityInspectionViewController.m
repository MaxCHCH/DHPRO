//
//  QualityInspectionViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/12/5.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "QualityInspectionViewController.h"
#import "DetailsDrawTableViewCell.h"
#import "GetDictionaryByID.h"
@interface QualityInspectionViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
{
	UITableView *tableViewMy;
	UIButton *buttonCommit;
	NSMutableArray*dataArray;
	
	
	NSMutableArray * dataArrayOne;

}
@end

@implementation QualityInspectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	tableViewMy = [[UITableView alloc]init];
	tableViewMy.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
	tableViewMy.delegate = self;
	tableViewMy.dataSource = self;
	buttonCommit = [UIButton buttonWithType:UIButtonTypeCustom];
	[buttonCommit setFrame:CGRectMake(0.0 ,5,DeviceWidth ,40.0)];
	buttonCommit.backgroundColor = [UIColor colorWithRed:0.110 green:0.651 blue:0.616 alpha:1.000];       //背景颜色
	[buttonCommit setTitle:@"提交" forState:(UIControlStateNormal)];
	[buttonCommit addTarget:self action:@selector(updateDate) forControlEvents:(UIControlEventTouchUpInside)];

	tableViewMy.tableFooterView = buttonCommit;
	[self.view addSubview:tableViewMy];
	
	[self getDict];
	dataArray = [[NSMutableArray alloc]init];
	dataArrayOne = [NSMutableArray array];

    // Do any additional setup after loading the view.
}
- (void)updateDate{
	/**
	 结果
	 */
	
		NSLog(@"%@",dataArrayOne);

}
- (void)getDict{
	NSString *urlll =[NSString stringWithFormat:@"%@&DTypeID=QTM025",API_BASE_URL(@"GetDictionaryByID")];
	
	urlll = [urlll stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
	[manager GET:urlll parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		NSLog(@"GetDictionaryByID %@",responseObject);
		
		[self reloadPositionDataArr:responseObject[@"Dictionary"]];
		[tableViewMy reloadData];
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		
	}];
}

- (void)reloadPositionDataArr:(NSArray *)arr{
	
	[dataArray removeAllObjects];
	for (int i = 0; i<[arr count]; i++) {
		NSDictionary *dict = [arr objectAtIndex:i];
		GetDictionaryByID *model = [[GetDictionaryByID alloc]init];
		[model setValuesForKeysWithDictionary:dict];
		[dataArray addObject:model];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}
//设置分组标题内容高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	if (section == 0) {
		return 0;
	}
	
	return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ID =@"UITableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
	}
	
	if (indexPath.section == 0) {
		cell.textLabel.text = [NSString stringWithFormat:@"HID:%@",@"123"];

	}
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			DetailsDrawTableViewCell *cellDe = [[DetailsDrawTableViewCell alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 200)];
			cellDe.returnidBlock = ^(NSString *id){
				NSLog(@"我的 ID  是 %@",id);
			};
//			cellDe.a = 11;
			cellDe.arr = dataArray;
			[cellDe setUpUI:dataArray];
			
			cellDe.textName.delegate = self;
			cellDe.textName.tag = indexPath.section;
			cellDe.textViewMy.delegate = self;
			cellDe.textViewMy.tag = indexPath.section;

			
			return cellDe;
		}
		if (indexPath.row == 1) {
			UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
			
			[cell.contentView addSubview:chooseButton];
		}
		
	}
		return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 100;
	} return 200;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[tableViewMy endEditing:YES];

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
	NSLog(@"输入内容%@",textView.text);
	if (dataArrayOne.count <= textView.tag) {
		NSDictionary * dict = @{@"textView":textView.text};
		[dataArrayOne addObject:dict];
	} else {
		NSMutableDictionary * dict =  [dataArrayOne[textView.tag] mutableCopy];
		[dict setObject:textView.text forKey:@"textView"];
		[dataArrayOne replaceObjectAtIndex:textView.tag withObject:dict];
	}
	return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView{
	NSLog(@"输入内容%@",textView.text);
	
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
	if (dataArrayOne.count <= textField.tag) {
		NSDictionary * dict = @{@"textField":textField.text};
		[dataArrayOne addObject:dict];
	} else {
		NSMutableDictionary * dict =  [dataArrayOne[textField.tag] mutableCopy];
		[dict setObject:textField.text forKey:@"textField"];
		[dataArrayOne replaceObjectAtIndex:textField.tag withObject:dict];
	}
	
	NSLog(@"输入内容%@",textField.text);
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touchesbegan:withevent:");
	[self.view endEditing:YES];
	[tableViewMy endEditing:YES];
	
	[super touchesBegan:touches withEvent:event];
	
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
