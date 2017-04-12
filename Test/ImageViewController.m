//
//  ImageViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "ImageViewController.h"
#import "AutlayoutTableViewCell.h"
@interface ImageViewController ()
{
	NSArray *_textArray;

}
@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_iamgeViewMy setContentScaleFactor:[[UIScreen mainScreen] scale]];
    _iamgeViewMy.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _iamgeViewMy.contentMode = UIViewContentModeScaleAspectFill;
    _iamgeViewMy.clipsToBounds = YES;

}





- (IBAction)buttonMethod:(UIButton *)sender {
	
	
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *ID =@"UITableViewCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
	}
	
//	if (indexPath.row == 0) {
//		int index = indexPath.row % 5;
//		static NSString *ID = @"test";
//		AutlayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//		if (!cell) {
//			cell = [[AutlayoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//		}
//		
//		cell.nameStr = _textArray[index];
//		return cell;
//
//	}
		if (indexPath.row == 0) {
			AutlayoutTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
			if (!cell) {
				cell = [[AutlayoutTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
			}
			return cell;
		}
	return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//	if (indexPath.row == 0) {
//		int index = indexPath.row % 5;
//		NSString *str = _textArray[index];
//		NSLog(@"%@",str);
//		// >>>>>>>>>>>>>>>>>>>>> * cell自适应步骤2 * >>>>>>>>>>>>>>>>>>>>>>>>
//		/* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
//		return [_tableViewMy cellHeightForIndexPath:indexPath model:str keyPath:@"nameStr" cellClass:[AutlayoutTableViewCell class] contentViewWidth:[self cellContentViewWith]];
//
//	}
	
	return 70;
	
}
- (CGFloat)cellContentViewWith
{
	CGFloat width = [UIScreen mainScreen].bounds.size.width;
	
	// 适配ios7横屏
	if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
		width = [UIScreen mainScreen].bounds.size.height;
	}
	return width;
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
