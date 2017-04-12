//
//  PhotosViewController.m
//  Test
//
//  Created by Rillakkuma on 16/7/13.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "PhotosViewController.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoBrowserViewController.h"


#import "QRCodeGenerator.h"

#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImage.h"
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#define WEAKSELF_SS __weak __typeof(self)weakSelf = self;
#define     SCREEN_WIDTH                   ([[UIScreen mainScreen] bounds].size.width)

#define photoWidth (SCREEN_WIDTH - 25)/4

@interface PhotosViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UIButton *addimageButton;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *arrDataSources;
@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic , strong) NSArray *assets;//图片集合

@end

@implementation PhotosViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewMy.delegate = self;
    _tableViewMy.dataSource = self;
    
    // sample
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 300, 300)];
    imageView.image = [UIImage imageNamed:@"11"];//www.baidu.com" imageSize:imageView.bounds.size.width];
    
    
    
    _tableViewMy.tableFooterView = imageView;
    
    self.assets = [NSArray array];
 
    
    // Do any additional setup after loading the view from its nib.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
//    }
    
    myCell *cell = [[myCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];

    if (indexPath.row != 7) {
        cell.myLabel.text = @"adfa";
        cell.title.text = @"我的";
        cell.myImageView.image = [UIImage imageNamed:@"page"];
        
    }
    if (indexPath.row == 7) {
        cell.myLabel.hidden = YES;
        cell.title.hidden = YES;
        cell.myImageView.image = [UIImage imageNamed:@"page"];
        
        for (UIView *chirdView in cell.contentView.subviews) {
            if (chirdView.tag == 123) {
                [chirdView removeFromSuperview];
            }
            
        }
        
        
        addimageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        addimageButton.frame = CGRectMake(10, 05, 30, 30);
        [addimageButton setImage:[UIImage imageNamed:@"work_comming"] forState:(UIControlStateNormal)];
        addimageButton.titleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:20.0];
        addimageButton.contentMode = UIViewContentModeScaleAspectFill;
        addimageButton.clipsToBounds = YES;
        [addimageButton addTarget:self action:@selector(addimage) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:addimageButton];

        for (int i = 0; i<self.assets.count; i++) {
            UIImage *image;
            if ([self.assets[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                image =((MLSelectPhotoAssets*)self.assets[i]).originImage;
            }
            else image = self.assets[i];
            
            UIButton *button = [UIButton new];
            [cell.contentView addSubview:button];
            button.tag = 123;
            button.frame = CGRectMake(10+i*35, 5, 30, 30);
//            [button addTarget:self action:@selector(addimage) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:image forState:(UIControlStateNormal)];
        }
        addimageButton.frame = CGRectMake(10+self.assets.count*35, 5, 30, 30);
        if (self.assets.count>=3) {
            addimageButton.hidden = YES;
        }

    }

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)addimage{
    NSLog(@"%s",__FUNCTION__);
    
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // Default Push CameraRoll
    pickerVc.topShowPhotoPicker = YES;

    pickerVc.status = PickerViewShowStatusCameraRoll;
    // Limit Count.
    pickerVc.maxCount = 3;
    // Push
    [pickerVc showPickerVc:self];
    pickerVc.selectPickers = self.assets;

    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
//        [weakSelf.assets addObjectsFromArray:assets];
        
//        [weakSelf showPhotos];
        weakSelf.assets = assets;
        [weakSelf.tableViewMy reloadData];
        // CallBack or Delegate
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//        UIImage *image;
//        if ([assets[0] isKindOfClass:[MLSelectPhotoAssets class]]) {
//            image = ((MLSelectPhotoAssets*)assets[0]).originImage;
//        }else
//            image = assets[0];
//        for (int i = 0; i<assets.count; i++) {
//            UIButton *bu = (UIButton *)[self.view viewWithTag:1000];
//            bu.frame = CGRectMake(10+i*30, 05, 30, 30);
//            [bu setImage:assets[i] forState:(UIControlStateNormal)];
//        }
        

    };
    
//    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
//    //设置照片最大选择数
//    actionSheet.maxSelectCount = 5;
//    //设置照片最大预览数
//    actionSheet.maxPreviewCount = 20;
//    weakify(self);
//    [actionSheet showWithSender:self animate:YES lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
//        strongify(weakSelf);
//        strongSelf.arrDataSources = selectPhotos;
//        strongSelf.lastSelectMoldels = selectPhotoModels;
//        [strongSelf.collectionView reloadData];
//        NSLog(@"%@", selectPhotos);
//    }];
  
}
- (void)showPhotos{
//    for (UIView *subView in self.subviews) {
//        [subView removeFromSuperview];
//    }
    for (int i = 0;i < self.assets.count;i++) {
        MLSelectPhotoAssets *asset = self.assets[i];
        UIButton *btn = [[UIButton alloc]init];
//        UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
        btn.frame = CGRectMake(10+i*40, 05, 30, 30);
        [btn addTarget:self action:@selector(lookPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[MLSelectPhotoPickerViewController getImageWithImageObj:asset] forState:UIControlStateNormal];
        
    }
    
}
- (void)lookPhotos:(UIButton*)btn{
    if (!btn.userInteractionEnabled) {
        return;
    }
    MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
//    browserVc.currentPage = btn.tag;
    browserVc.photos = self.assets;
    [self.navigationController pushViewController:browserVc animated:YES];
}


//- (void)openEditMultipleWithController:(UIViewController *)controller  result:(UIImage *)result
//{
//    if (!self || !result) return;
//
//    UIButton *bu = (UIButton *)[self.view viewWithTag:1000];
//    [bu setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
//
//    
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLCollectionCell" forIndexPath:indexPath];
    cell.btnSelect.hidden = YES;
    cell.imageView.image = _arrDataSources[indexPath.row];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLCollectionCell *cell = (ZLCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [ZLShowBigImage showBigImage:cell.imageView];
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
