//
//  PerfectInformationViewController.m
//  zhidoushi
//
//  Created by xinglei on 14-11-10.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//
#define WIDTH  self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#import "PerfectInformationViewController.h"

#import "MainViewController.h"
#import "ContactViewController.h"
//#import "AddSocialViewController.h"
//..private..//
#import "WWTolls.h"
#import "UserModel.h"
#import "GlobalUse.h"
#import "PickerView+.h"
#import "ImageButton.h"
#import "WWRequestOperationEngine.h"
#import "NSObject+NARSerializationCategory.h"
//..netWork..//
#import "JSONKit.h"
#import "Define.h"
#import "UIViewExt.h"
#import "AFNetworking.h"
#import "UIViewController+ShowAlert.h"
#import "NSURL+MyImageURL.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+NARSafeString.h"
#import "UITextField+LimitLength.h"
#import "QiniuSDK.h"
#import "MLImageCrop.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "YMUtils.h"
#import "MLSelectPhotoAssets.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MLSelectPhotoBrowserViewController.h"

@interface PerfectInformationViewController ()<UITextFieldDelegate,UIActionSheetDelegate,PickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UIPickerViewDelegate ,UIPickerViewDataSource>
{
    NSString * urlString;
    int sexInt;//性别数字码(1男,2女,0未填)
    UIActionSheet *photoActionSheet;
    NSString *dateString;
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UITextField *sexField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property(nonatomic,strong)UIButton * imageButton;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property(nonatomic,strong)PickerView_ * picker;
@property (weak, nonatomic) IBOutlet UIButton *complete;
@property(nonatomic,strong)    NSString *imageURL;//返回的照片路径
@property(nonatomic,strong) UIImagePickerController *ppicker;
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小

- (IBAction)areaButtonClick:(id)sender;//选择地区按钮点击
@property(nonatomic,strong)UIButton *selectButn;//确定
@property(nonatomic,strong)UIButton *concelButn;//取消
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property (strong, nonatomic) CLLocationManager *locationManager;//定位
@property (strong,nonatomic)NSString *longitudeStr;//经度
@property (strong,nonatomic) NSString *latitudeStr;//纬度
@property (strong,nonatomic) NSString *country;//国家
@property (strong,nonatomic) NSString *province;//省市
@property (strong,nonatomic) NSString *city;//市区

@end

@implementation PerfectInformationViewController
{
    NSInteger row1;
    NSInteger row2;
    NSInteger row3;
    NSInteger srow;
    NSInteger scomponent;
    
    UIButton *cancelBtn;
    UIButton *confirmBtn;
}

/*************************头像上传******************************/
-(void)photoFileSelector{
    [self.view endEditing:YES];
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
    __weak typeof(self) weakSelf = self;
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
- (IBAction)bigBtnclick:(id)sender {
    [self photoFileSelector];
}

//调用相机
-(void)takePhoto:(BOOL)Editing
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        
        //设置拍照后的图片可被编辑
        
        _ppicker.allowsEditing = NO;
        
        _ppicker.sourceType = sourceType;
        
        [self presentViewController:_ppicker animated:YES completion:nil];
        
    }else
        
    {
        
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
    
}

//调用相册
-(void)LocalPhoto:(BOOL)Editing
{
    
    _ppicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    _picker.delegate = self;
    
    //设置选择后的图片可被编辑
    
    _ppicker.allowsEditing = NO;
    
    [self presentViewController:_ppicker animated:YES completion:nil];
    
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
    [dict setValue:self.phoneNumber forKey:@"userid"];
    NSString * keyString = [self.phoneNumber stringByAppendingString:ZDS_M_PI];
    NSString * keyStringMD5 = [WWTolls md5:keyString];
    [dict setValue:keyStringMD5 forKey:@"key"];
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:ZDS_UPLOADTOKEN parameters:dict requestOperationBlock:^(NSDictionary *dic) {
        
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf removeWaitView];
            [MBProgressHUD showError:@"上传失败请重试"];
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
                                          if (_nickName.text.length>0 && [_birthdayField.text length] >0 && ![weakSelf.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
                                          {
                                              weakSelf.complete.enabled = YES;
                                          }
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
}



-(void)viewDidAppear:(BOOL)animated{
    
    //    地址选择d
    [super viewDidAppear:animated];
    self.cityPicker.delegate = self;
    self.cityPicker.dataSource = self;
    [self.cityPicker selectRow:0 inComponent:0 animated:NO];
    
}
-(void)can{
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         self.selectButn.frame = rr;
                         self.concelButn.frame = r2;
                         self.cityPicker.frame = rect;
                     } completion:^(BOOL finished) {
                         //                             cancelBtn.hidden = YES;
                         //                             confirmBtn.hidden = YES;
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
        [self.areaButton setTitle:[YMUtils getCityData][srow][@"name"] forState:UIControlStateNormal];
        [self.areaButton setTitle:[YMUtils getCityData][srow][@"name"] forState:UIControlStateDisabled];
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
            NSString *title = [NSString stringWithFormat:@"%@ %@ %@",self.country,self.province,self.city];
            [self.areaButton setTitle:title forState:UIControlStateNormal];
            [self.areaButton setTitle:title forState:UIControlStateDisabled];
            //        [self.areaButton setTitle:title forState:UIControlStateApplication];
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
        NSString *title = [NSString stringWithFormat:@"%@ %@ %@",self.country,self.province,self.city];
        [self.areaButton setTitle:title forState:UIControlStateNormal];
        [self.areaButton setTitle:title forState:UIControlStateDisabled];
        //        [self.areaButton setTitle:title forState:UIControlStateApplication];
    }
    
    if (_nickName.text.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
    {
        self.complete.enabled = YES;
    }
    NSLog(@"%@ %@ %@",self.country,self.province,self.city);
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         self.selectButn.frame = rr;
                         self.concelButn.frame = r2;
                         self.cityPicker.frame = rect;
                     } completion:^(BOOL finished) {
                         //                             cancelBtn.hidden = YES;
                         //                             confirmBtn.hidden = YES;
                     }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.titleLabel.text = @"完善资料";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    if(iOS8) [[UINavigationBar appearance] setTranslucent:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, HEIGHT, SCREEN_WIDTH, 200)];
    self.cityPicker.tag = 0;
    self.cityPicker.showsSelectionIndicator = YES;
    [self.cityPicker setBackgroundColor:[WWTolls colorWithHexString:@"#eeeeee"]];
    [self.view addSubview:self.cityPicker];
    UIButton* cancelButn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.concelButn = cancelButn;
    cancelButn.backgroundColor = [UIColor clearColor];
    [cancelButn setFrame:CGRectMake(0, HEIGHT, 50, 20)];
    [cancelButn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButn addTarget:self action:@selector(can) forControlEvents:UIControlEventAllEvents];
    [self.view addSubview:cancelButn];
    
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButn = selectBtn;
    selectBtn.backgroundColor = [UIColor clearColor];
    [selectBtn setFrame:CGRectMake(self.cityPicker.frame.size.width - 50, HEIGHT, 50, 20)];
    [selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(sel) forControlEvents:UIControlEventAllEvents];
    [self.view addSubview:selectBtn];
    
    
    self.sexField.text = @"";
    self.sexField.textColor = [UIColor lightGrayColor];
    
    // Do any additional setup after loading the view from its nib.
    _imageButton = [[UIButton alloc]init];
    _imageButton.frame = CGRectMake(15,25, 50, 50);
    //[_imageButton setTitle:@"上传头像" forState:UIControlStateNormal];
    _imageButton.titleLabel.font = MyFont(12);
    _imageButton.backgroundColor = [UIColor grayColor];
    _imageButton.layer.cornerRadius = 25;
    _imageButton.clipsToBounds = YES;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"tx-100"] forState:UIControlStateNormal];
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"tx-100"] forState:UIControlStateHighlighted];
    [_imageButton addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
    _ppicker = [[UIImagePickerController alloc] init];
    _ppicker.delegate = self;
    [self.view addSubview:_imageButton];
    
    //self.nickName.frame = CGRectMake(15,_imageButton.bottom+15, 290, 41);
    //self.sexField.frame = CGRectMake(15, self.nickName.bottom+8, 290, 41);
    //self.birthdayField.frame = CGRectMake(15, self.sexField.bottom+8, 290, 41);
    //self.complete.frame = CGRectMake(15, self.birthdayField.bottom+8, 290, 38);
    [self.nickName limitTextLength:10];
    self.complete.enabled = NO;
    
    self.picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:yearType];
    self.picker.pickDelegate = self;
    [self.view addSubview:self.picker];
    
    [self.picker.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.picker.dataPicker.minimumDate = [formatter dateFromString:@"1900-01-01"];
    self.picker.dataPicker.maximumDate = [NSDate date];
    NSString *dateStr = @"1990-01-01";
    NSDate *date=[formatter dateFromString:dateStr];
    [self.picker.dataPicker setDate:date animated:YES];
    
    sexInt = 0;//起始性别为女
    
    
    
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    if(iOS8){
        //创建CLLocationManager对象
        self.locationManager = [[CLLocationManager alloc] init];
        //设置代理为自己
        self.locationManager.delegate = self;
        
        //    请求使用期间定位
        //    [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        
        //    定位请求状态
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        //    如果使用期间可以定位则定位
        
        if (status == kCLAuthorizationStatusDenied)
        {
            NSString *alertStr = @"您关闭了应用的定位请求，请选择您的所在区域";
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [alertView show];
            
            NSLog(@"用户需要选择区域");
        }
        else
        {
            
            [self.locationManager startUpdatingLocation];
            NSLog(@"定位");
        }
    }else{
        //创建CLLocationManager对象
        self.locationManager = [[CLLocationManager alloc] init];
        //设置代理为自己
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        NSLog(@"定位");
    }
    
    
    
    
    
    //    功能修改，已注释下面代码
    /*
     //    如果用户未关闭定位功能
     if (status == kCLAuthorizationStatusRestricted)
     {
     if (status == kCLAuthorizationStatusDenied)
     {
     //            NSString *alertStr = @"请开启您的定位功能帮助程序更好的为您推荐健康减脂方法";
     //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:nil, nil];
     //            [alertView show];
     }
     //         开始定位
     else
     {
     //            [self.locationManager startUpdatingLocation];
     
     }
     
     }
     else
     {
     //        NSString *alertStr = @"请开启您的定位功能帮助程序更好的为您推荐健康减脂方法";
     //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:nil, nil];
     //        [alertView show];
     }
     */
    
}




-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上传用户数据
//此处上传注册的信息，KS新增地理定位信息
- (IBAction)success:(id)sender {
    
    
    //    必须定位
    if([_nickName.text isKindOfClass:[NSString class]] && _nickName.text.length>0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击定位您的区域"] && [_birthdayField.text length]>0 && self.sexField.text.length >0)
    {
        //必须输入昵称
        if(![WWTolls isNameValidate:self.nickName.text]){
            [self showAlertMsg:@"昵称中必须包含汉字、字母或者数字，请修改您的昵称" yOffset:0];
            return;
        }else if([WWTolls isHasSensitiveWord:self.nickName.text]){
            [self showAlertMsg:@"注意哦！昵称中含有敏感词！" yOffset:0];
            return;
        }
        [self writeUserInformatinForPlist];
        [self operationManagerRequest:nil parameter:nil];
    }
    else
    {
        [self showAlertMsg:@"请完善信息" andFrame:CGRectMake(70,100,200,60)];
    }
}


//上传用户数据
-(void)operationManagerRequest:(NSString*)string parameter:(NSMutableDictionary*)para{
    [self showWaitView];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_URLREQUEST_ATGV_POSTUSERDICTIONARY]);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:self.phoneNumber forKey:@"userid"];
    NSString * keyString = [self.phoneNumber stringByAppendingString:ZDS_M_PI];
    NSString * keyStringMD5 = [WWTolls md5:keyString];
    NSString *clientString = [[NSUserDefaults standardUserDefaults] objectForKey:ZDS_CLIENTID];
    [dic setObject:keyStringMD5 forKey:@"key"];
    [dic setObject:@"0" forKey:@"registerstatus"];
    [dic setObject:@"appstore" forKey:@"channel"];
    [dic setObject:self.phoneNumber forKey:@"phonenumber"];
    [dic setObject:self.codeEnter forKey:@"vcode"];
    self.deviceID = [NSUSER_Defaults objectForKey:ZDS_DEVICETOKEN];
    [dic setObject: [NSString stringWithFormat:@"%@",self.deviceID] forKey:@"deviceid"];
    if (self.deviceID == nil||self.deviceID.length<1) {
        [dic setObject: [NSString stringWithFormat:@"0"] forKey:@"deviceid"];
    }
    [dic setObject:[NSString stringWithFormat:@"%@",clientString] forKey:@"clientid"];
    [dic setObject:self.nickName.text forKey:@"username"];
    [dic setObject:@"0" forKey:@"logintype"];//ios 0 android 1
    
    NSLog(@"dict1 %@",dic);
    
    //    此处写入用户地理位置信息上传服务器
    if (![self.areaButton.titleLabel.text isEqualToString:@"点击定位您的区域"])
    {
        [dic setObject:self.country forKey:@"country"];
        [dic setObject:self.province forKey:@"province"];
        if(self.city!=nil) [dic setObject:self.city forKey:@"city"];
        if ([self.longitudeStr length] >0 )
        {
            [dic setObject:self.longitudeStr forKey:@"longitude"];
        }
        if ([self.latitudeStr length] >0)
        {
            [dic setObject:self.latitudeStr forKey:@"latitude"];
        }
        
        
    }
    
    NSLog(@"dict2 %@",dic);
    
    
    if (_birthdayField.left!=0) {
        [dic setObject:[NSString stringWithFormat:@"%@",_birthdayField.text] forKey:@"birthday"];
    }
    if (_sexField.text.length!=0) {
        [dic setObject:[NSString stringWithFormat:@"%d",sexInt] forKey:@"usersex"];
    }else{
        [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"usersex"];
    }
    if(self.openid.length!=0){
        [dic setObject:self.openid forKey:@"openid"];
    }
    if (self.Photohash.length>0) {
        [dic setObject:[NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig] forKey:@"imageurl"];
    }else{
        [dic setObject:@"imgs/default/head.jpg?FrmRhCmNQrWYNgUlI6JSCQJzTJ2Q" forKey:@"imageurl"];
    }
    
    NSLog(@"dicdic %@",dic);
    
    [WWRequestOperationEngine operationManagerRequest_NoUserIdPost:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_SAVEINFODO] parameters:dic requestOperationBlock:^(NSDictionary *dictionary) {        
        NSLog(@"dictionary %@",dictionary);
        
        NSLog(@"错误码%@",[dictionary objectForKey:@"errinfo"]);
        
        NSString *loginstatus = [dictionary objectForKey:@"loginstatus"];
        //..把接收到的手机号存储起来..//
        NSString *userID = [dictionary objectForKey:@"userid"];
        UserModel *user=[[UserModel alloc]init];
        user.userID = userID;
        [NSUSER_Defaults setObject:user.userID forKey:ZDS_USERID];
        [NSUSER_Defaults synchronize];
        if ([loginstatus intValue]==0) {
            MainViewController *mainController = [[MainViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
            [self.navigationController pushViewController:mainController animated:YES];
            //初始化通讯录并调取
            ContactViewController * contanct = [[ContactViewController alloc]init];
            [contanct readContacts];
            [contanct uploadPhoneNumber];
            [contanct writePhoneNumber];
        }
        [self removeWaitView];
        
    }];
    
}

//保存用户注册信息
-(void)writeUserInformatinForPlist
{
    UserModel *user = [[UserModel alloc]init];
    [user setNickName:_nickName.text];
    [user setSex:sexInt];
    
    if (self.birthdayField.text.length!=0)
    {
        [user setBirthDay:self.birthdayField.text];
    }
    //    用户区域信息
    if (![self.areaButton.titleLabel.text isEqualToString:@"点击定位您的区域"])
    {
        //        [user setUserArea:self.areaButton.titleLabel.text];
        [user setUserLongitudeStr:self.longitudeStr];
        [user setUserLatitudeStr:self.latitudeStr];
        [user setUserCountry:self.country];
        [user setUserProvince:self.province];
        [user setUserCity:self.city];
        
    }
    
    [NSUSER_Defaults setObject:[user savePropertiesToDictionary] forKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
    [NSUSER_Defaults synchronize];
}

- (IBAction)sexButton:(id)sender
{
    [self hiddenPickerView];
    [self.sexField becomeFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    [actionSheet showInView:self.view];
}

- (IBAction)dateButton:(id)sender {
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         self.selectButn.frame = rr;
                         self.concelButn.frame = r2;
                         self.cityPicker.frame = rect;
                     } completion:^(BOOL finished) {
                     }];
    [self.view endEditing:YES];
    if (dateString.length < 1) {
        dateString = @"1990-01-01";
        self.birthdayField.text = dateString;
    }
    [self.birthdayField becomeFirstResponder];
    if(self.picker.frame.origin.y != self.view.frame.size.height - 200)
        [UIView animateWithDuration:0.2f animations:^{
            [self.picker setFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        }];
}

- (IBAction)nickName:(id)sender
{
    [self hiddenPickerView];
    [self.nickName becomeFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        [self.picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    }];
}

#pragma mark -  pickViewDelegate 必须实现的两个方法
-(void)cancelBtn{
    [self hiddenPickerView];
    self.birthdayField.text = dateString;
    
    if (_nickName.text.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
    {
        self.complete.enabled = YES;
    }
    
}
-(void)selectBtn:(PickerView_*)pick{
    [self hiddenPickerView];
    self.birthdayField.text = dateString;
    
    if (_nickName.text.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
    {
        self.complete.enabled = YES;
    }
}


-(void)pickerValue:(NSString*)str
{
    
}

-(void)datePickerValue:(NSDate*)date
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:date];
    dateString = currentDateStr1;
}

-(void)hiddenPickerView
{
    //[self.nickName resignFirstResponder];
    CGRect rect = self.cityPicker.frame;
    rect.origin.y = SCREEN_HEIGHT;
    CGRect rr = self.selectButn.frame;
    CGRect r2 = self.concelButn.frame;
    rr.origin.y = SCREEN_HEIGHT;
    r2.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [self.picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
                         self.selectButn.frame = rr;
                         self.concelButn.frame = r2;
                         self.cityPicker.frame = rect;
                     } completion:^(BOOL finished) {
                         //                             cancelBtn.hidden = YES;
                         //                             confirmBtn.hidden = YES;
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
    }else{
        switch (buttonIndex) {
            case 0:
                self.sexField.text = @"男";
                sexInt = 1;
                break;
            case 1:
                self.sexField.text = @"女";
                sexInt = 2;
                break;
            default:
                break;
        }
        if (self.nickName.text.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
        {
            self.complete.enabled = YES;
        }
    }
}

#pragma mark textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField == _nickName)
    {
        if ([toBeString isEqualToString:@" "]) {
            [self showAlertMsg:@"昵称不允许输入空格" andFrame:CGRectMake(70,100,200,60)];
            return NO;
        }
    }
    //    判定完成按钮可选状态
    if (_nickName.text.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
    {
        self.complete.enabled = YES;
    }
    else self.complete.enabled = NO;
    
    if(_nickName.text.length==1&&[string isEqualToString:@""]) self.complete.enabled = NO;
    
    if (string.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
    {
        self.complete.enabled = YES;
    }
    return YES;
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
#pragma mark 点击地区按钮选择所在区域
- (IBAction)areaButtonClick:(id)sender
{
    //    ChooseAreaViewController *chooseAreaVC = [[ChooseAreaViewController alloc] init];
    //    [self.navigationController pushViewController:chooseAreaVC animated:YES];
    
    
    //    self.cityPicker.backgroundColor = [UIColor grayColor];
    
    [self.view endEditing:YES];
    
    if (self.cityPicker.frame.origin.y == SCREEN_HEIGHT||self.cityPicker.frame.origin.y == HEIGHT)
    {
        //        CGRect rect = self.cityPicker.frame;
        //        rect.origin.y = HEIGHT - 180;
        //        [UIView animateWithDuration:1.0f
        //                         animations:^{
        //                             self.cityPicker.frame = rect;
        //                         } completion:^(BOOL finished) {
        ////                             cancelBtn.hidden = NO;
        ////                             confirmBtn.hidden = NO;
        //                         }];
        [UIView animateWithDuration:1.0f
                         animations:^{
                             [self.picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
                         } completion:^(BOOL finished){
                         }];
        CGRect rect = self.cityPicker.frame;
        rect.origin.y = SCREEN_HEIGHT-250;
        CGRect rr = self.selectButn.frame;
        CGRect r2 = self.concelButn.frame;
        rr.origin.y = SCREEN_HEIGHT-243;
        r2.origin.y = SCREEN_HEIGHT-243;
        [UIView animateWithDuration:1.0f
                         animations:^{
                             self.selectButn.frame = rr;
                             self.concelButn.frame = r2;
                             self.cityPicker.frame = rect;
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
                             self.selectButn.frame = rr;
                             self.concelButn.frame = r2;
                             self.cityPicker.frame = rect;
                         } completion:^(BOOL finished) {
                             //                             cancelBtn.hidden = YES;
                             //                             confirmBtn.hidden = YES;
                         }];
    }
    
    
    
    
    
    
    ////    定位请求被拒绝
    //    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    //    
    ////    如果用户未关闭定位功能
    //    if (status != kCLAuthorizationStatusRestricted)
    //    {
    //        if (status == kCLAuthorizationStatusDenied)
    //        {
    //            NSString *alertStr = @"请开启您的定位功能帮助程序更好的为您推荐健康减脂方法";
    //            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:nil, nil];
    //            [alertView show];
    //        }
    ////         开始定位
    //        else
    //        {
    //            [self.locationManager startUpdatingLocation];
    //
    //        }
    //        
    //    }
    //    else
    //    {
    //        NSString *alertStr = @"请开启您的定位功能帮助程序更好的为您推荐健康减脂方法";
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:alertStr delegate:self cancelButtonTitle:@"前往设置" otherButtonTitles:nil, nil];
    //        [alertView show];
    //    }
    
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    CGRect rect = self.picker.frame;
//    rect.origin.y = HEIGHT;
//    [UIView animateWithDuration:1.0f
//                     animations:^{
//                         self.picker.frame = rect;
//                     } completion:^(BOOL finished) {
//                         nil;
//                     }];
//
//}


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
    
    //    self.cityLabel.text = str;
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


//前往设置页面
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    [[UIApplication sharedApplication] openURL:settingsURL];
//}

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
             if ([SubLocality rangeOfString:@"市"].length>0) {
                 SubLocality = [SubLocality substringToIndex:SubLocality.length-1];
             }
             if ([stateStr rangeOfString:@"市"].length>0) {
                 stateStr = [stateStr substringToIndex:SubLocality.length-1];
             }
             if ([stateStr rangeOfString:@"省"].length>0) {
                 stateStr = [stateStr substringToIndex:SubLocality.length-1];
             }
             
             NSLog(@"%@",SubLocality);
             
             if ([countryStr length]>0 &&[stateStr length]>0 &&[SubLocality length]>0)
             {
                 [self.areaButton setTitleColor:ContentColor forState:UIControlStateNormal];
                 //国内显示省市
                 if ([countryStr isEqualToString:@"中国"]||[countryStr isEqualToString:@"China"])
                 {
                     [self.areaButton setTitle:[NSString stringWithFormat:@"%@%@",stateStr,SubLocality] forState:UIControlStateNormal];
                 }
                 //             否则显示国家
                 else
                 {
                     [self.areaButton setTitle:[NSString stringWithFormat:@"%@",countryStr] forState:UIControlStateNormal];
                 }
                 self.country = [NSString stringWithString:countryStr];
                 self.province = [NSString stringWithString:stateStr];
                 self.city = [NSString stringWithString:SubLocality];
                 
                 if ([self.country length]>0 && [self.province length]>0 && [self.city length]>0 )
                 {
                     NSString *title = [NSString stringWithFormat:@"%@ %@ %@",self.country,self.province,self.city];
                     [self.areaButton setTitle:title forState:UIControlStateNormal];
                     [self.areaButton setTitle:title forState:UIControlStateDisabled];
                     //        [self.areaButton setTitle:title forState:UIControlStateApplication];
                 }
                 [self.areaButton setTitleColor:ContentColor forState:UIControlStateNormal];
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
    
    if (_nickName.text.length>0 && [_birthdayField.text length] >0 && ![self.areaButton.titleLabel.text isEqualToString:@"点击选择您的区域"] && [_sexField.text length]>0)
    {
        self.complete.enabled = YES;
    }
    
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}


@end
