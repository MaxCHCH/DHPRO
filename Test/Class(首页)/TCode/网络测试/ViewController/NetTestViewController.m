//
//  NetTestViewController.m
//  Test
//
//  Created by Rillakkuma on 2017/8/11.
//  Copyright © 2017年 Rillakkuma. All rights reserved.
//

#import "NetTestViewController.h"
#import "SFNetWorkManager.h"
#import "CommentsModel.h"
#import "DataModel.h"
@interface NetTestViewController ()
{
	NSArray *_dataSource;
}
@end

@implementation NetTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self getdata];
}
-(void)getdata{
	NSString *URL = @"http://192.168.0.211:8015/houseInterface.ashx?json=GetListByTopics";
	NSString *ver = @"2";
	NSDictionary *param = NSDictionaryOfVariableBindings(ver);
	[SFNetWorkManager requestWithType:HttpRequestTypeGet withUrlString:URL withParaments:param withSuccessBlock:^(NSDictionary *object) {
		
		_dataSource = [DataModel mj_objectArrayWithKeyValuesArray:object[@"data"]];
			
	} withFailureBlock:^(NSError *error) {
		
	} progress:^(float progress) {
		
	}];
	
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
