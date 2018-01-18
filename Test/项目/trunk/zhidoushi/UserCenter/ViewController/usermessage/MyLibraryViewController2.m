//
//  MyLibraryViewController2.m
//  zhidoushi
//
//  Created by ji on 15/11/12.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "MyLibraryViewController2.h"

#import "ImageButton.h"
//...private....//
#import "WWTolls.h"
#import "UserModel.h"
#import "PickerView+.h"
#import "ImageButton.h"
//..netWork..//
#import "JSONKit.h"
#import "AFNetworking.h"
#import "WWRequestOperationEngine.h"
//..gateGory..//
#import "NSString+NARSafeString.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+NARSafeDictionary.h"
#import "NSObject+NARSerializationCategory.h"

#import "UIViewController+ShowAlert.h"
#import "Define.h"
#import "MBProgressHUD+MJ.h"
#import "UITextField+LimitLength.h"
#import "UITextView+LimitLength.h"
#import "MobClick.h"
#import "QiniuSDK.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "YMUtils.h"
#import "IQKeyboardManager.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MLImageCrop.h"
#import "MLSelectPhotoAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoBrowserViewController.h"

#import "NickNameModifyController.h"
#import "SignatureController.h"
#import "SignatureCell.h"

/*
 
 MyLibraryViewController2 *myLibrary = [[MyLibraryViewController2 alloc] init];
 myLibrary.headImage = self.headImageView.image;
 myLibrary.image_URL = self.headerImageURLStr;
 myLibrary.seeuserid = self.userID;
 myLibrary.hidesBottomBarWhenPushed = YES;
 [self.navigationController pushViewController:myLibrary animated:YES];
 
 */

@interface MyLibraryViewController2 () <PickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UIPickerViewDelegate ,UIPickerViewDataSource,MLImageCropDelegate,UITableViewDataSource,UITableViewDelegate>
{
    int sexInt;//性别数字码(1男,2女,0未填)
    UIActionSheet *myActionSheetView;
    NSString * account_ID;
    NSString * name_String;
    NSString * sex_String;
    NSString * date_String;
    NSString * height_String;
    NSString * content_String;
    UIActionSheet *photoActionSheet;
    MBProgressHUD *HUD;
}

@property (nonatomic,strong) UITableView *mytableview;

@property(nonatomic,strong)UIButton * imageButton;
@property(nonatomic,strong)PickerView_ * date_picker;
@property(nonatomic,strong)PickerView_ * weight_picker;
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小

@property(nonatomic,strong)UIButton *selectButn;//确定
@property(nonatomic,strong)UIButton *concelButn;//取消
@property (strong, nonatomic) CLLocationManager *locationManager;//定位
@property (strong,nonatomic)NSString *longitudeStr;//经度
@property (strong,nonatomic) NSString *latitudeStr;//纬度
@property (strong,nonatomic) NSString *country;//国家
@property (strong,nonatomic) NSString *province;//省市
@property (strong,nonatomic) NSString *city;//市区

@property (strong,nonatomic) NSString *birth;//
@property (strong,nonatomic) NSString *currentDatetime;//

@end

@implementation MyLibraryViewController2
{
    NSInteger srow;
    NSInteger scomponent;
    NSInteger row1;
    NSInteger row2;
    NSInteger row3;
}

/*************************头像上传******************************/
-(void)photoFileSelector{
    [self.view endEditing:YES];
    [self hiddenPickerView];
    //    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
    //    photoActionSheet.tag = 999;
    //    [photoActionSheet showInView:self.view];
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    [NSUSER_Defaults setObject:@"最多只能添加1张图片" forKey:@"zdsselectphotoTip"];
    //        pickerVc.selectPickers = self.assets;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 1;
    [pickerVc showPickerVc:self];
    //__weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        UIImage *image;
        if ([assets[0] isKindOfClass:[MLSelectPhotoAssets class]]) {
            image = ((MLSelectPhotoAssets*)assets[0]).originImage;
        }else image = assets[0];
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        imageCrop.ratioOfWidthAndHeight = 600.0f/600.0f;
        imageCrop.image =image;
        [imageCrop showWithAnimation:NO];
    };
}

//调用相机
-(void)takePhoto:(BOOL)Editing
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        
        //        _picker = [[UIImagePickerController alloc] init];
        
        //        _picker.delegate = self;
        
        //设置拍照后的图片可被编辑
        
        _picker.allowsEditing = NO;
        
        _picker.sourceType = sourceType;
        
        [self.view.window.rootViewController presentViewController:_picker animated:YES completion:nil];
        
    }else
    {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

//调用相册
-(void)LocalPhoto:(BOOL)Editing
{
    
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //    _picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
    _picker.allowsEditing = NO;
    
    [self.view.window.rootViewController presentViewController:_picker animated:YES completion:nil];
    
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    [self showWaitView];
    UIImage *image = cropImage;
    if (image.size.width>image.size.height) {
        UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.width));
        
        // Draw image1
        [image drawInRect:CGRectMake(0, (image.size.width-image.size.height)/2, image.size.width, image.size.height)];
        
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        image = nil;
        image = newimage;
    }else if(image.size.width<image.size.height){
        UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.height));
        
        // Draw image1
        [image drawInRect:CGRectMake((image.size.height-image.size.width)/2, 0, image.size.width, image.size.height)];
        
        UIImage *newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        image = nil;
        image = newimage;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
    [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
        
        
        if (dic[ERRCODE]) {
            [weakSelf removeWaitView];
        }else{
#pragma mark - 七牛上传图片
            NSString *token = dic[@"uptoken"];
            if(token.length>0){
                NSData *data = [SSLImageTool compressImage:image withMaxKb:300];
                //七牛上传管理器
                QNUploadManager *upManager = [[QNUploadManager alloc] init];
                //开始上传
                CFUUIDRef uuidRef =CFUUIDCreate(NULL);
                
                CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
                
                CFRelease(uuidRef);
                
                NSString *UUIDStr = (__bridge NSString *)uuidStringRef;
                NSString *QNkey = [NSString stringWithFormat:@"images/0/%@.jpg",UUIDStr];
                [upManager putData:data key:QNkey token:token
                          complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {//resp hash key
                              weakSelf.isNew = NO;
                              [weakSelf removeWaitView];
                              if (info.isOK) {
                                  
                                  if(resp){
                                      weakSelf.Photohash = resp[@"hash"];
                                      weakSelf.Photokey = resp[@"key"];
                                      weakSelf.PhotoBig = data.length;
                                      weakSelf.PhotoSize = image.size;
                                      //直接把该图片读出来显示在按钮上
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [weakSelf.imageButton setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                      });
                                  }
                              }else{
                                  if (info.isConnectionBroken) {
                                      [MBProgressHUD showError:@"网速太不给力了"];
                                  }
                                  else if(info.statusCode == 401){//授权失败
                                      weakSelf.isNew = YES;
                                      [MBProgressHUD showError:@"上传失败，请重试"];
                                  }else [MBProgressHUD showError:@"上传失败，请重试"];
                              }
                              NSLog(@"%@", info);
                              NSLog(@"%@", resp);
                          } option:nil];
            }else{
                [weakSelf removeWaitView];
                [MBProgressHUD showError:@"上传失败请重试"];
            }
        }
    }];
}

//获取图片后的行为
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* editeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage* originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *image;//原图
        
        if (editeImage!=nil) {
            image = editeImage;
        }else{
            image = originalImage;
        }
        [picker dismissViewControllerAnimated:YES completion:^{
            MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
            imageCrop.delegate = self;
            imageCrop.ratioOfWidthAndHeight = 600.0f/600.0f;
            imageCrop.image =image;
            [imageCrop showWithAnimation:NO];
            
        }];
    }
    
    // 刷新指定行
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"修改资料页面"];
    self.rightButton.enabled = YES;
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"修改资料页面"];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width =13;
    labelRect.size.height = 13;
    self.leftButton.frame = labelRect;
    
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.rightButton.bounds = CGRectMake(0, 0, 30, 16);
    [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(15);
    //[self.rightButton addTarget:self action:@selector(success:) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.text = @"个人资料";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = [WWTolls colorWithHexString:@"#475564"];
    
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}
-(void)concel{
    [self.view endEditing:YES];
}

-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上传用户数据
- (IBAction)success:(id)sender {
    
    if(self.nameText != nil && self.nameText.length != 0){//必须输入昵称
        [self writeUserInformatinForPlist];
        [self operationManager_Request:nil parameter:nil];
    }
    else{
        [self showAlertMsg:@"请输入昵称" andFrame:CGRectMake(70,100,200,60)];
    }
    
}

#pragma mark - 修改用户数据
-(void)operationManager_Request:(NSString*)string parameter:(NSMutableDictionary*)para{
    [self.view endEditing:YES];
    [self showWaitView];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if (self.nameText.length > 10) {
        [self removeWaitView];
        [MBProgressHUD showError:@"昵称不能超过10个字符"];
        
        return;
    }else if(![WWTolls isNameValidate:self.nameText]){
        [self removeWaitView];
        [self showAlertMsg:@"昵称中必须包含汉字、字母或者数字，请修改您的昵称" yOffset:0];
        return;
    }else if([WWTolls isHasSensitiveWord:self.nameText]){
        [self removeWaitView];
        [self showAlertMsg:@"注意哦！昵称中含有敏感词！" yOffset:0];
        
        return;
    }
    
    if (self.contentText.length > 30) {
        [self removeWaitView];
        [MBProgressHUD showError:@"个人签名不能超过30个字符"];
        
        return;
    }else if([WWTolls isHasSensitiveWord:self.contentText]){
        [self removeWaitView];
        [self showAlertMsg:@"注意哦！个人签名中含有敏感词！" yOffset:0];
        return;
    }
    
    
    if (self.nameText.length!=0) {
        [dic setObject:self.nameText forKey:@"username"];
    }
    if (self.sexText.length!=0) {
        [dic setObject:[NSString stringWithFormat:@"%d",sexInt] forKey:@"usersex"];
    }
    if (self.heightText.length!=0) {
        NSString * height = [self.heightText stringByReplacingOccurrencesOfString:@"cm" withString:@""];
        [dic setObject:height forKey:@"height"];
    }
    if (self.birthDayText.length!=0) {
        [dic setObject:[NSString stringWithFormat:@"%@",date_String] forKey:@"birthday"];
    }
    if (self.contentText.length!=0) {
        [dic setObject:self.contentText forKey:@"usersign"];
    }
    if (self.Photokey.length>0) {
        [dic setObject:[NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig] forKey:@"imageurl"];
    }
    if(self.country.length>0) dic[@"country"] = self.country;
    if(self.province.length>0) dic[@"province"] = self.province;
    if(self.city.length>0) dic[@"city"] = self.city;
    if(self.longitudeStr.length>0) dic[@"longitude"] = self.longitudeStr;
    if(self.latitudeStr.length>0) dic[@"latitude"] = self.latitudeStr;
    
    __weak typeof(self) weakself = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_UPDATEMYINFO parameters:dic requestOperationBlock:^(NSDictionary *dictionary) {
        
        if (![[dictionary objectForKey:@"updateStatus"] isEqualToString:@"0"]) {
            [NSUSER_Defaults setValue:@"YES" forKey:@"xiugaiziliao"];
            [MBProgressHUD showSuccess:@"修改成功"];
            [weakself performSelector:@selector(popVIewMyController) withObject:nil afterDelay:0.1];
        }
    }];
    
}

-(void)popVIewMyController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)writeUserInformatinForPlist{
    
    UserModel *user = [[UserModel alloc]init];
    [user setNickName:self.nameText];
    [user setSex:sexInt];
    [user setUserAge:self.birthDayText];
    if (self.birthDayText.length!=0) {
        [user setBirthDay:self.birthDayText];
    }
    [NSUSER_Defaults setObject:[user savePropertiesToDictionary] forKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
    [NSUSER_Defaults synchronize];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.cityPicker.tag = 0;
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    
    [self.cityPicker selectRow:0 inComponent:0 animated:NO];
    self.cityPicker.showsSelectionIndicator = YES;
    [self.view addSubview:self.cityPicker];
    [self.cityPicker setBackgroundColor:[WWTolls colorWithHexString:@"#eeeeee"]];
    [self.view addSubview:self.cityPicker];
    UIButton* cancelButn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.concelButn = cancelButn;
    cancelButn.backgroundColor = [UIColor clearColor];
    [cancelButn setFrame:CGRectMake(0, SCREEN_HEIGHT, 50, 20)];
    [cancelButn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButn addTarget:self action:@selector(can) forControlEvents:UIControlEventAllEvents];
    [self.view addSubview:cancelButn];
    
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButn = selectBtn;
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn setFrame:CGRectMake(self.cityPicker.frame.size.width - 50, SCREEN_HEIGHT, 50, 20)];
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(sel) forControlEvents:UIControlEventAllEvents];
    selectBtn.titleLabel.font = MyFont(15);
    [self.view addSubview:selectBtn];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mytableview reloadData];
    });
    
}
-(void)can{
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         weakself.selectButn.frame = rr;
                         weakself.concelButn.frame = r2;
                         weakself.cityPicker.frame = rect;
                     } completion:^(BOOL finished) {
                     }];
}
-(void)sel{
    if (scomponent == 0) {
        row1 = srow;
        row2 = 0;
        row3 = 0;
        self.city = @"";
        self.province = @"";
        self.country = @"";
        self.areaText = [YMUtils getCityData][srow][@"name"];
        [self.cityPicker reloadComponent:1];
        [self.cityPicker reloadComponent:2];
    }
    else if (scomponent == 1){
        row2 = srow;
        row3 = 0;
        [self.cityPicker reloadComponent:2];
        self.city = @"";
        
    }
    else
    {
        row3 = srow;
        if ([self.country length]>0 && [self.province length]>0 && [self.city length]>0 )
        {
            NSString *title = [NSString stringWithFormat:@"%@ %@",self.province,self.city];
            self.areaText = title;
        }
    }
    
    NSInteger cityRow1 = [self.cityPicker selectedRowInComponent:0];
    NSInteger cityRow2 = [self.cityPicker selectedRowInComponent:1];
    NSInteger cityRow3 = [self.cityPicker selectedRowInComponent:2];
    NSMutableString *str = [[NSMutableString alloc]init];
    [str appendString:[YMUtils getCityData][cityRow1][@"name"]];
    
    self.country = str;
    
    NSArray *array = [YMUtils getCityData][cityRow1][@"children"];
    if ((NSNull*)array != [NSNull null])
    {
        //        [str appendString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"name"]];
        
        
        self.province = [NSString stringWithString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"name"]];
        
        
        NSArray *array1 = [YMUtils getCityData][cityRow1][@"children"][cityRow2][@"children"];
        if ((NSNull*)array1 != [NSNull null]) {
            //            [str appendString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"children"][cityRow3][@"name"]];
            
            self.city = [NSString stringWithString:[YMUtils getCityData][cityRow1][@"children"][cityRow2][@"children"][cityRow3][@"name"]];
        }
    }
    
    if ([self.country length]>0 && [self.province length]>0 && [self.city length]>0 )
    {
        NSString *title = [NSString stringWithFormat:@"%@ %@",self.province,self.city];
        self.areaText = title;
        //        [self.areaButton setTitle:title forState:UIControlStateApplication];
    }
    
    //[self checkUserInformation];
    NSLog(@"title %@ %@ %@",self.country,self.province,self.city);
    
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         weakself.selectButn.frame = rr;
                         weakself.concelButn.frame = r2;
                         weakself.cityPicker.frame = rect;
                     } completion:^(BOOL finished) {
                     }];
    
    // 刷新指定行
    NSIndexPath *path = [NSIndexPath indexPathForRow:2 inSection:2];
    [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self operationManagerRequest];
    
    self.currentuserID = [NSUSER_Defaults objectForKey:ZDS_USERID];
    
    [self initTableView];
    
    self.mytableview.sectionFooterHeight = 0;
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.mytableview.backgroundColor = [WWTolls colorWithHexString:@"#F7F1F1"];
    
    _imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageButton.frame = CGRectMake(self.mytableview.frame.size.width-60,5, 50, 50);
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-80"] forState:UIControlStateNormal];
    _imageButton.layer.cornerRadius = 25;
    _imageButton.contentMode = UIViewContentModeScaleAspectFill;
    _imageButton.clipsToBounds = YES;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-80"] forState:UIControlStateHighlighted];
    if (self.seeuserid == self.currentuserID) {
        [_imageButton addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightButton.hidden = NO;
        [self.rightButton addTarget:self action:@selector(success:) forControlEvents:UIControlEventTouchUpInside]; // 编辑
    }else{
        self.rightButton.hidden = YES;
    }
    
    _picker = [[UIImagePickerController alloc] init];
    [_picker setDelegate:self];
    
    self.date_picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:yearType];
    self.date_picker.pickDelegate = self;
    [self.view addSubview:self.date_picker];
    
    self.weight_picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:heightType];
    self.weight_picker.pickDelegate = self;
    [self.view addSubview:self.weight_picker];
    
    //    地址选择
    self.cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180)];
    
}

-(void)initTableView{
    
    self.mytableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    [self.view addSubview:self.mytableview];
}

#pragma mark -  pickViewDelegate 必须实现的两个方法
-(void)cancelBtn;{
    [self hiddenPickerView];
    
}
-(void)selectBtn:(PickerView_*)pick{
    [self hiddenPickerView];
    if (pick == self.date_picker) {
        NSString *subbirth = [date_String substringToIndex:4];
        NSString *subcur = [self.currentDatetime substringToIndex:4];
        NSInteger age = ([subcur integerValue] - [subbirth integerValue]);
        NSString *ageS = [NSString stringWithFormat:@"%zd",age];
        self.birthDayText = ageS;
        
        // 刷新指定行
        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:2];
        [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
        
    }
//    else if(pick == self.weight_picker){
//        self.heightText = height_String;
//        
//        // 刷新指定行
//        NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:2];
//        [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
//    }
    
}
-(void)datePickerValue:(NSDate*)date{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:date];
    
    date_String = currentDateStr1;
    
    //NSLog(@"date_String----------%@",date_String);
}

-(void)pickerValue:(NSString*)str
{
    height_String = str;
}

-(void)hiddenPickerView{
    
    //[self.heightTextField resignFirstResponder];
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2f animations:^{
        [weakself.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        [weakself.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        
        weakself.selectButn.frame = rr;
        weakself.concelButn.frame = r2;
        weakself.cityPicker.frame = rect;
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 999) {
        //弹出的菜单按钮点击后的响应
        if (buttonIndex == photoActionSheet.cancelButtonIndex)
        {
            
        }
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                
                [self takePhoto:YES];
                break;
                
            case 1:  //打开本地相册
                
                [self LocalPhoto:YES];
                break;
        }
        // 刷新指定行
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
    }else {
        switch (buttonIndex) {
            case 0:
                self.sexText = @"男";
                sexInt = 1;
                break;
            case 1:
                self.sexText = @"女";
                sexInt = 2;
                break;
            default:
                break;
        }
        // 刷新指定行
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:2];
        [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
    }
}

//返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView == self.cityPicker) {
        return 3;
    }
    else
        return 1;
}

//返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return [YMUtils getCityData].count;
    }
    else if (component == 1) {
        NSArray *array = [YMUtils getCityData][row1][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            return array.count;
        }
        return 0;
    }
    else {
        NSArray *array = [YMUtils getCityData][row1][@"children"];
        if ((NSNull*)array != [NSNull null]) {
            NSArray *array1 = [YMUtils getCityData][row1][@"children"][row2][@"children"];
            if ((NSNull*)array1 != [NSNull null]) {
                return array1.count;
            }
            return 0;
        }
        return 0;
    }
}
//设置当前行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(component == 0) {
        return [YMUtils getCityData][row][@"name"];
    }
    else if (component == 1) {
        return [YMUtils getCityData][row1][@"children"][row][@"name"];
    }
    else if (component == 3) {
        return [YMUtils getCityData][row1][@"children"][row2][@"children"][row][@"name"];
    }
    return nil;
    
}

//选择的行数
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    srow = row;
    scomponent = component;
    if (scomponent == 0) {
        row1 = srow;
        row2 = 0;
        row3 = 0;
        [self.cityPicker reloadComponent:1];
        [self.cityPicker reloadComponent:2];
    }
    else if (scomponent == 1){
        row2 = row;
        row3 = 0;
        [self.cityPicker reloadComponent:2];
    }
    else
    {
        row3 = row;
    }
    
    
}

//每行显示的文字样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 107, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (component == 0) {
        titleLabel.text = [YMUtils getCityData][row][@"name"];
    }
    else if (component == 1)
    {
        titleLabel.text = [YMUtils getCityData][row1][@"children"][row][@"name"];
    }
    else {
        titleLabel.text = [YMUtils getCityData][row1][@"children"][row2][@"children"][row][@"name"];
    }
    return titleLabel;
}


#pragma mark 定位代理方法

//允许定位后执行的代理方法
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    //    //将经度显示到label上
    self.longitudeStr = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //    //将纬度现实到label上
    self.latitudeStr = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    
    NSLog(@"%@ %@",self.longitudeStr,self.latitudeStr);
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
         
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             NSDictionary *placeDict = placemark.addressDictionary;
             NSLog(@"placeDict %@",placeDict);
             
             
             NSString *cityStr = [placeDict objectForKey:@"City"];
             
             //             国家
             NSString *countryStr = [placeDict objectForKey:@"Country"];
             
             //             城市
             NSString *stateStr = [placeDict objectForKey:@"State"];
             NSLog(@"%@ %@ %@",cityStr,countryStr,stateStr);
             
             //             区
             NSString *SubLocality = [placeDict objectForKey:@"SubLocality"];
             NSLog(@"%@",SubLocality);
             if ([SubLocality rangeOfString:@"区"].length>0) {
                 SubLocality = [SubLocality substringToIndex:SubLocality.length-1];
             }
             
             if ([countryStr length]>0 &&[stateStr length]>0 &&[SubLocality length]>0)
             {
                 //国内显示省市
                 if ([countryStr isEqualToString:@"中国"]||[countryStr isEqualToString:@"China"])
                 {
                     self.areaText = [NSString stringWithFormat:@"%@%@",stateStr,SubLocality];
                     //[self.areaButton setTitle:[NSString stringWithFormat:@"%@%@",stateStr,SubLocality] forState:UIControlStateNormal];
                 }
                 //             否则显示国家
                 else
                 {
                     self.areaText = [NSString stringWithFormat:@"%@",countryStr];
                     //[self.areaButton setTitle:[NSString stringWithFormat:@"%@",countryStr] forState:UIControlStateNormal];
                 }
                 
                 self.country = [NSString stringWithString:countryStr];
                 self.province = [NSString stringWithString:stateStr];
                 self.city = [NSString stringWithString:SubLocality];
                 
                 if ([self.country length]>0 && [self.province length]>0 && [self.city length]>0 )
                 {
                     NSString *title = [NSString stringWithFormat:@"%@ %@ %@",self.country,self.province,self.city];
                     self.areaText = title;
                     //[self.areaButton setTitle:title forState:UIControlStateNormal];
                     //[self.areaButton setTitle:title forState:UIControlStateDisabled];
                     //        [self.areaButton setTitle:title forState:UIControlStateApplication];
                 }
                 
             }
             
             
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.seeuserid == self.currentuserID) {
        return 4;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.seeuserid == self.currentuserID) {
        switch (section) {
            case 0:  return 1;
            case 1:  return 2;
            case 2:  return 3;
            case 3:  return 1;
            default: return 0;
        }
    }else{
        switch (section) {
            case 0: return 1;
            case 1: return 3;
            case 2: return 1;
            default: return 0;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // 设置tableviewcell字体
    //UIFont *newFont = [UIFont fontWithName:@"Arial" size:13.0];
    
    if (self.seeuserid == self.currentuserID) {
        if (indexPath.section == 0) {
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @[@"修改头像"][indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
            cell.textLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            cell.textLabel.font = MyFont(15);
            if (indexPath.row == 0) {
                _imageButton.frame = CGRectMake(self.mytableview.frame.size.width-65,10, 50, 50);
                [_imageButton setBackgroundImage:self.headImage forState:UIControlStateNormal];
                [cell.contentView addSubview:_imageButton];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }else if (indexPath.section == 1){
            static NSString *cellIdentifier = @"Cell1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @[@"账户ID",@"昵称"][indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
            cell.textLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            cell.textLabel.font = MyFont(15);
            cell.textLabel.alpha = 0.6;
            if (indexPath.row == 0) {
                //cell.detailTextLabel.text = self.accountID;
                
                UILabel *labelID = [[UILabel alloc] initWithFrame:CGRectMake(self.mytableview.frame.size.width-110,16, 100, 18)];
                labelID.text = self.accountID;
                labelID.font = [UIFont fontWithName:@"Arial" size:15.0];
                labelID.textColor = [WWTolls colorWithHexString:@"#4E777F"];
                labelID.font = MyFont(15);
                [labelID sizeToFit];
                [cell.contentView addSubview:labelID];
                
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else if (indexPath.row == 1){
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                lineView.alpha = 0.22;
                [cell.contentView addSubview:lineView];
                
                cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
                cell.detailTextLabel.text = self.nameText;
                cell.detailTextLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
                cell.detailTextLabel.font = MyFont(15);
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }
            return cell;
        }else if (indexPath.section == 2){
            static NSString *cellIdentifier = @"Cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @[@"性别",@"年龄",@"所在地"][indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
            cell.textLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            cell.textLabel.font = MyFont(15);
            cell.textLabel.alpha = 0.6;
            
            cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
            cell.detailTextLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            cell.detailTextLabel.font = MyFont(15);
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.sexText;
            }else if (indexPath.row == 1){
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                lineView.alpha = 0.22;
                [cell.contentView addSubview:lineView];
                
                if ([self.birthDayText integerValue] > 100) {
                    self.birthDayText = @"";
                }
                cell.detailTextLabel.text = self.birthDayText; // 年龄
            }else{
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                lineView.alpha = 0.22;
                [cell.contentView addSubview:lineView];
                cell.detailTextLabel.text = self.areaText;
            }
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            return cell;
            
        }else{
//            static NSString *identifier = @"cell3";
            
//            SignatureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (cell == nil) {
//                cell = [[SignatureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            
//            [cell setsignalNameText:@"个性签名" contentLabelText:self.contentText];
            
            static NSString *cellIdentifier = @"Cell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *signname = [[UILabel alloc] initWithFrame:CGRectMake(13, 14, 30, 16)];
            signname.text = @"签名";
            signname.font = [UIFont fontWithName:@"Arial" size:15.0];
            signname.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            signname.font = MyFont(15);
            signname.alpha = 0.3;
            [signname sizeToFit];
            [cell.contentView addSubview:signname];
            
            UILabel *signcontent = [[UILabel alloc] initWithFrame:CGRectMake(13, 45, SCREEN_WIDTH-30, 16)];
            signcontent.text = self.contentText;
            signcontent.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            signcontent.font = MyFont(15);
            [signcontent sizeToFit];
            [cell.contentView addSubview:signcontent];

            cell.accessoryType=UITableViewCellAccessoryNone;
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            static NSString *cellIdentifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if (indexPath.row == 0) {
                _imageButton.frame = CGRectMake(15,10, 50, 50);
                [_imageButton setBackgroundImage:self.headImage forState:UIControlStateNormal];
                [cell.contentView addSubview:_imageButton];
                UILabel *othername = [[UILabel alloc] initWithFrame:CGRectMake(72, 16, 200, 18)];
                othername.text = self.nameText;
                othername.font = [UIFont fontWithName:@"Arial" size:17.0];
                othername.textColor = [WWTolls colorWithHexString:@"#475564"];
                othername.font = MyFont(17);
                [othername sizeToFit];
                [cell.contentView addSubview:othername];
                UILabel *lableotherID = [[UILabel alloc] initWithFrame:CGRectMake(72, 39, 200, 18)];
                
                if (self.accountID.length == 0) {
                    self.accountID = @"";
                }
                lableotherID.text = [NSString stringWithFormat:@"ID:%@",self.accountID];
                lableotherID.font = [UIFont fontWithName:@"Arial" size:15.0];
                lableotherID.textColor = [WWTolls colorWithHexString:@"#4E777F"];
                lableotherID.font = MyFont(15);
                [lableotherID sizeToFit];
                [cell.contentView addSubview:lableotherID];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
        }else if (indexPath.section == 1){
            static NSString *cellIdentifier = @"Cell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = @[@"性别",@"年龄",@"所在地"][indexPath.row];
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
            cell.textLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            cell.textLabel.font = MyFont(15);
            cell.textLabel.alpha = 0.6;
            
            cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:15.0];
            cell.detailTextLabel.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            cell.detailTextLabel.font = MyFont(15);
            
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.sexText;
            }else if (indexPath.row == 1){
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                lineView.alpha = 0.22;
                [cell.contentView addSubview:lineView];
                [cell.contentView addSubview:lineView];
                
                cell.detailTextLabel.text = self.birthDayText; // 年龄
            }else{
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-15, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                lineView.alpha = 0.22;
                [cell.contentView addSubview:lineView];
                cell.detailTextLabel.text = self.areaText;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            return cell;
            
        }else{
//            static NSString *identifier = @"cell3";
//            
//            SignatureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (cell == nil) {
//                cell = [[SignatureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            
//            //        cell.textLabel.text = @[@"个性签名"][indexPath.row];
//            //        if (indexPath.row == 0) {
//            //            cell.detailTextLabel.text = self.contentText;
//            //        }
//            [cell setsignalNameText:@"个性签名" contentLabelText:self.contentText];
//            cell.accessoryType=UITableViewCellAccessoryNone;
            
            static NSString *cellIdentifier = @"Cell3";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            UILabel *signname = [[UILabel alloc] initWithFrame:CGRectMake(13, 14, 30, 16)];
            signname.text = @"签名";
            signname.font = [UIFont fontWithName:@"Arial" size:15.0];
            signname.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            signname.font = MyFont(15);
            signname.alpha = 0.3;
            [signname sizeToFit];
            [cell.contentView addSubview:signname];
            
            UILabel *signcontent = [[UILabel alloc] initWithFrame:CGRectMake(13, 45, SCREEN_WIDTH-30, 16)];
            signcontent.text = self.contentText;
            signcontent.textColor = [WWTolls colorWithHexString:@"#4E777F"];
            signcontent.font = MyFont(15);
            [signcontent sizeToFit];
            [cell.contentView addSubview:signcontent];
            
            cell.accessoryType=UITableViewCellAccessoryNone;
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seeuserid == self.currentuserID) {
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                return 70;
            }
        }else if (indexPath.section == 3){
            return 75;
        }
        return 50;
    }else{
        if (indexPath.section == 0) {
            return 70;
        }else if (indexPath.section == 1) {
            return 50;
        }else{
            return 75;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seeuserid != self.currentuserID) {
        return;
    }
    
    if (indexPath.section == 0) {  // 头像
        [self photoFileSelector];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) { // 账户ID
            
        }else{// 昵称
            NickNameModifyController *nicknameVC = [[NickNameModifyController alloc] init];
            [self.navigationController pushViewController:nicknameVC animated:YES];
            
            nicknameVC.strtext = self.nameText;
            
            nicknameVC.nameblock = ^(NSString *str){
                self.nameText = str;
            };
            
            // 刷新指定行
            NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:1];
            [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
        }
        
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {  // 性别
            [self hiddenPickerView];
            [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
            [self.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
            myActionSheetView = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            [myActionSheetView showInView:self.view];
            
        }else if (indexPath.row == 1){ // 年龄
            [self hiddenPickerView];
            
            [self.date_picker.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
            [formatter setDateFormat:@"yyyy-MM-dd"];
            self.date_picker.dataPicker.minimumDate = [formatter dateFromString:@"1900-01-01"];
            self.date_picker.dataPicker.maximumDate = [NSDate date];
            [UIView animateWithDuration:0.2f animations:^{
                [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
//                [self.weight_picker setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
            }];
            NSString *dateStr = @"1990-01-01";
            if (![self.birthDayText isEqualToString:@""]) {
                dateStr = date_String;
            }else{
                date_String = @"1990-01-01";
            }
            
            NSDate *date=[formatter dateFromString:dateStr];
            [self.date_picker.dataPicker setDate:date animated:YES];
            
        }else if (indexPath.row == 2){ // 所在地
            
            [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
//            [self.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
            
            __weak typeof(self) weakself = self;
            if (self.cityPicker.frame.origin.y == SCREEN_HEIGHT)
            {
                CGRect rect = self.cityPicker.frame;
                rect.origin.y = SCREEN_HEIGHT-240;
                CGRect rr = self.selectButn.frame;
                CGRect r2 = self.concelButn.frame;
                rr.origin.y = SCREEN_HEIGHT-233;
                r2.origin.y = SCREEN_HEIGHT-233;
                [UIView animateWithDuration:0.2f
                                 animations:^{
                                     weakself.selectButn.frame = rr;
                                     weakself.concelButn.frame = r2;
                                     weakself.cityPicker.frame = rect;
                                 } completion:^(BOOL finished) {
                                     //                             cancelBtn.hidden = YES;
                                     //                             confirmBtn.hidden = YES;
                                 }];
                
            }
            else
            {
                CGRect rect = self.cityPicker.frame;
                rect.origin.y = SCREEN_HEIGHT;
                CGRect rr = self.selectButn.frame;
                CGRect r2 = self.concelButn.frame;
                rr.origin.y = SCREEN_HEIGHT;
                r2.origin.y = SCREEN_HEIGHT;
                [UIView animateWithDuration:1.0f
                                 animations:^{
                                     weakself.selectButn.frame = rr;
                                     weakself.concelButn.frame = r2;
                                     weakself.cityPicker.frame = rect;
                                 } completion:^(BOOL finished) {
                                     //                             cancelBtn.hidden = YES;
                                     //                             confirmBtn.hidden = YES;
                                 }];
            }
        }
//        }else{ // 身高
//            [self hiddenPickerView];
//            __weak typeof(self) weakself = self;
//            [UIView animateWithDuration:0.2f animations:^{
//                [weakself.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height- 200, self.view.frame.size.width, 200)];
//                [weakself.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
//            }];
//            if ([self.heightText isEqualToString:@""]) {
//                [self.weight_picker.pickerView selectRow:65 inComponent:0 animated:YES];
//                height_String = @"165cm";
//            }else [self.weight_picker.pickerView selectRow:([self.heightText substringToIndex:3].intValue-100) inComponent:0 animated:YES];
//        }
        
    }else{ // 个性签名
        [self hiddenPickerView];
        [self.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        
        
        SignatureController *signatureVC = [[SignatureController alloc] init];
        [self.navigationController pushViewController:signatureVC animated:YES];
        
        signatureVC.strtext = self.contentText;
        
        
        signatureVC.signblock = ^(NSString *str){
            self.contentText = str;
        };
        
        // 刷新指定行
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:3];
        [self.mytableview reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationRight];
    }
}


#pragma mark - 获取我的个人信息
-(void)operationManagerRequest
{
    [self showWaitView];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    __weak typeof(self)weakSelf = self;
    
    [dic setObject:self.seeuserid forKey:@"seeuserid"];
    
    [WWRequestOperationEngine operationManagerRequest_Post:@"/user/detailinfo.do" parameters:dic requestOperationBlock:^(NSDictionary *baseUserDtoDictionary) {
        
        if (!baseUserDtoDictionary[ERRCODE]) {
            if (baseUserDtoDictionary) {
                
                if ([baseUserDtoDictionary objectForKeySafe:@"usercode"]) {
                    weakSelf.accountID = [baseUserDtoDictionary objectForKey:@"usercode"];
                    account_ID = [baseUserDtoDictionary objectForKey:@"usercode"];
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"username"]) {
                    weakSelf.nameText = [baseUserDtoDictionary objectForKey:@"username"];
                    name_String = [baseUserDtoDictionary objectForKey:@"username"];
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"imageurl"]) {
                    [_imageButton setBackgroundImage:self.headImage forState:UIControlStateNormal];
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"usersex"]) {
                    
                    if ([[baseUserDtoDictionary objectForKeySafe:@"usersex"]isEqualToString:@"2"]) {
                        weakSelf.sexText = @"女";
                        sexInt = 2;
                    }
                    else if ([[baseUserDtoDictionary objectForKeySafe:@"usersex"]isEqualToString:@"1"])
                    {
                        weakSelf.sexText = @"男";
                        sexInt = 1;
                    }
                    else{
                        weakSelf.sexText = @"女";
                        sexInt = 0;
                    }
                    
                    sex_String = weakSelf.sexText;
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"birthday"]&& ![[baseUserDtoDictionary objectForKeySafe:@"birthday"] isEqualToString:@"null"]) {
                    
                    weakSelf.birth = [NSString stringWithFormat:@"%@",[baseUserDtoDictionary objectForKey:@"birthday"]];
                    
                    date_String = weakSelf.birth;
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"curdate"]&& ![[baseUserDtoDictionary objectForKeySafe:@"curdate"] isEqualToString:@"null"]) {
                    weakSelf.currentDatetime = [baseUserDtoDictionary objectForKey:@"curdate"];
                    NSString *birthStr = [weakSelf.currentDatetime substringToIndex:4];
                    weakSelf.birth = [weakSelf.birth substringToIndex:4];
                    NSInteger age = ([birthStr integerValue] - [weakSelf.birth integerValue]);
                    
                    NSString *ageStr = [NSString stringWithFormat:@"%zd",age];
                    weakSelf.birthDayText = ageStr;
                }
                
                if (((NSString*)baseUserDtoDictionary[@"height"]).length>0 && ![[baseUserDtoDictionary objectForKeySafe:@"height"] isEqualToString:@"null"]) {
                    
                    weakSelf.heightText = [NSString stringWithFormat:@"%@cm",[baseUserDtoDictionary objectForKey:@"height"]];
                    height_String =  weakSelf.heightText;
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"usersign"]&& ![[baseUserDtoDictionary objectForKeySafe:@"usersign"] isEqualToString:@"null"]) {
                    weakSelf.contentText = [NSString stringWithFormat:@"%@",[baseUserDtoDictionary objectForKey:@"usersign"]];
                        content_String =   weakSelf.contentText;
                }
                
                weakSelf.country = [baseUserDtoDictionary[@"country"] isEqualToString:@"null"]?@"":baseUserDtoDictionary[@"country"];
                weakSelf.province = [baseUserDtoDictionary[@"province"] isEqualToString:@"null"]?@"":baseUserDtoDictionary[@"province"];
                weakSelf.city = [baseUserDtoDictionary[@"city"] isEqualToString:@"null"]?@"":baseUserDtoDictionary[@"city"];
                if (weakSelf.country.length>0&&weakSelf.province.length>0) {
                    weakSelf.areaText = [NSString stringWithFormat:@"%@ %@",weakSelf.province,weakSelf.city];
                }else if(weakSelf.country.length>0){
                    weakSelf.areaText = [NSString stringWithFormat:@"%@",weakSelf.country];
                }
            }
            [weakSelf.mytableview reloadData];
            [weakSelf removeWaitView];
        }
    }];
}

@end
