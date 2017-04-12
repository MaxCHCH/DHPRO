//
//  BlueToothViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/8.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "BlueToothViewController.h"
#import "ZLPhotoActionSheet.h"
#define weakify(var)   __weak typeof(var) weakSelf = var

@interface BlueToothViewController ()
{
    UIButton *button;
}
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(20.0 ,60.0 ,111.0 ,30.0)];
    button.backgroundColor = [UIColor colorWithRed:1.000 green:0.452 blue:0.039 alpha:0.000];       //背景颜色
    [button setTitle:@"我的图片" forState:(UIControlStateNormal)];
    button.layer.borderColor = [UIColor redColor].CGColor;
    button.layer.borderWidth = 0.3;
    button.layer.cornerRadius = 10;
    [button addTarget:self action:@selector(choosePhotos) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)choosePhotos{
    
//    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
//    //设置最大选择数量
//    actionSheet.maxSelectCount = 5;
//    //设置预览图最大数目
//    actionSheet.maxPreviewCount = 20;
//    weakify(self);
//    [actionSheet showWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
//        //        strongify(weakSelf);
//        //        strongSelf.arrDataSources = selectPhotos;
//        //        strongSelf.lastSelectMoldels = selectPhotoModels;
//        //        [strongSelf.collectionView reloadData];
//        
//        NSLog(@"%@", selectPhotos);
//    }];

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
