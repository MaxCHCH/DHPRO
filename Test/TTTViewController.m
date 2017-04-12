//
//  TTTViewController.m
//  Test
//
//  Created by Rillakkuma on 16/6/24.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "TTTViewController.h"
#import "SuPhotoPicker.h"
#import "MLSelectPhotoPickerViewController.h"
#import "MLSelectPhotoAssets.h"
@interface TTTViewController ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL isFullScreen;
    UITableViewCell *cell;
    UIButton *buttonAddimage;
}
@property(nonatomic,strong) NSMutableArray *assets;//图片集合

@property (weak, nonatomic) IBOutlet UITableView *tableViewMy;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation TTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableViewMy.delegate = self;
    _tableViewMy.dataSource =self;
    
    
    UIButton *buttonFoot = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonFoot setFrame:CGRectMake(10.0 ,20.0 ,300 ,50)];
    buttonFoot.backgroundColor = [UIColor colorWithRed:0.99 green:1.00 blue:0.45 alpha:1.00];       //背景颜色

    [buttonFoot setTitle:@"Start" forState:(UIControlStateNormal)];
    [buttonFoot setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    _tableViewMy.tableFooterView = buttonFoot;
    // Do any additional setup after loading the view from its nib.
    
    
    self.photos = [[NSMutableArray alloc ] init];
    
    self.dataArray = [[NSMutableArray alloc ] init];
    [self.dataArray addObject:[UIImage imageNamed:@"tjtp-168"]];
    isFullScreen=NO;
    
    
}
- (IBAction)Back:(UISwipeGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID =@"UITableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        
    }
    cell.textLabel.text = @"2014-02";
    
    
    if (indexPath.row == 2) {
        cell.textLabel.hidden = YES;;
//        //显示
        

        buttonAddimage = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonAddimage setFrame:CGRectMake(0.0 ,5.0 ,50.0 ,50.0)];
        [buttonAddimage setBackgroundImage:[UIImage imageNamed:@"tjtp-168"] forState:(UIControlStateNormal)];
        [buttonAddimage addTarget:self action:@selector(addPhotos) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.contentView addSubview:buttonAddimage];
        
        
        
        
        
    }
    return cell;
    
}
-(NSMutableArray *)assets{
    if (_assets == nil) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
- (void)addPhotos{
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    //        [NSUSER_Defaults setObject:@"最多只能添加1张图片" forKey:@"zdsselectphotoTip"];
    //        pickerVc.selectPickers = self.assets;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 9;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        UIImage *image;
        if ([assets[0] isKindOfClass:[MLSelectPhotoAssets class]]) {
            image = ((MLSelectPhotoAssets*)assets[0]).originImage;
            [buttonAddimage setImage:image forState:(UIControlStateNormal)];
        
        }else image = assets[0];
        //            [weakSelf openEditMultipleWithController:weakSelf result:image];
    };
}
- (void)showSelectedPhotos:(NSArray *)imgs {

    for (int i = 0; i < imgs.count; i ++) {
        UIImageView * iv = [[UIImageView alloc]initWithFrame:CGRectMake(50 * i, 200, 50, 50)];
        iv.image = imgs[i];
        [self.view addSubview:iv];
    }

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
