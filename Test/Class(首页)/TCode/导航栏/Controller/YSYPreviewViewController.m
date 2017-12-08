//
//  YSYPreviewViewController.m
//  Test
//
//  Created by Rillakkuma on 2016/10/9.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "YSYPreviewViewController.h"
#import "LBTabBarTextController.h"
static UIImage *currentImage;
@interface YSYPreviewViewController ()
@end

@implementation YSYPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	UIButton *btn_TabBar = [UIButton buttonWithType:UIButtonTypeCustom];
	[btn_TabBar setFrame:CGRectMake(100.0 ,100.0 ,100.0 ,30.0)];
	btn_TabBar.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:0.00];       //背景颜色
	[btn_TabBar setTitle:@"返回" forState:0];
	[btn_TabBar setTitleColor:[UIColor redColor] forState:0];
	[btn_TabBar addTarget:self action:@selector(tabBar) forControlEvents:(UIControlEventTouchUpInside)];
	[self.view addSubview:btn_TabBar];
	
	
    _previewImageView.image=currentImage;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void)tabBar{
	dis;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
- (IBAction)deleteSelectedImage:(id)sender {
    UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"要删除这张照片吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
    [action showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==actionSheet.cancelButtonIndex)
    {
        return;
    }
    else
    {
        [PostTableViewController deleteSelectedImageWithImage:currentImage];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
+(void)setPreviewImage:(UIImage *)image{
    currentImage=image;
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
