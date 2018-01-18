//  MyLibraryViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/30.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "MyLibraryViewController.h"

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

@interface MyLibraryViewController ()<PickerViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UIPickerViewDelegate ,UIPickerViewDataSource>
{
    int sexInt;//性别数字码(1男,2女,0未填)
    UIActionSheet *myActionSheetView;
    NSString * name_String;
    NSString * sex_String;
    NSString * date_String;
    NSString * height_String;
    NSString * content_String;
    UIActionSheet *photoActionSheet;
    MBProgressHUD *HUD;
}
@property(nonatomic,strong)UIButton * imageButton;
@property(nonatomic,strong)PickerView_ * date_picker;
@property(nonatomic,strong)PickerView_ * weight_picker;
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小

- (IBAction)areaButtonClick:(id)sender;//选择地区按钮点击
@property (weak, nonatomic) IBOutlet UIButton *areaButton;
@property(nonatomic,strong)UIButton *selectButn;//确定
@property(nonatomic,strong)UIButton *concelButn;//取消
@property (strong, nonatomic) CLLocationManager *locationManager;//定位
@property (strong,nonatomic)NSString *longitudeStr;//经度
@property (strong,nonatomic) NSString *latitudeStr;//纬度
@property (strong,nonatomic) NSString *country;//国家
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *tpback;
@property (strong,nonatomic) NSString *province;//省市
@property (strong,nonatomic) NSString *city;//市区
@end

@implementation MyLibraryViewController
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
}

-(void)awakeFromNib{
    [super awakeFromNib];
    for (UIView *view in self.view.subviews) {
        if (view.height == 1) {
            view.height = 0.5;
        }
    }
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
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width =16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton addTarget:self action:@selector(success:) forControlEvents:UIControlEventTouchUpInside];

    self.titleLabel.text = @"编辑资料";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;

    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}
-(void)concel{
    [self.view endEditing:YES];
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
    selectBtn.titleLabel.font = MyFont(15);
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(sel) forControlEvents:UIControlEventAllEvents];
    [self.view addSubview:selectBtn];

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
    
    [self checkUserInformation];
    NSLog(@"%@ %@ %@",self.country,self.province,self.city);
    
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
- (void)viewDidLoad {

    [super viewDidLoad];
    for (UIView *view in self.view.subviews) {
        if (view.height == 1) {
            view.height = 0.5;
        }
    }
    if (iPhone5||iPhone4) {
        
    }else{
        self.line1.height = 0.2;
        self.line2.height = 0.2;
    }
    
    self.isNew = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(concel)];
    [self.view addGestureRecognizer:tap];
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    self.nameTextField.delegate = self;
//    [self.nameTextField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventValueChanged];
    [self.nameTextField limitTextLength:10];
    [self.contentTextView limitTextLength:30];
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#fafafa"];
    self.contentTextView.backgroundColor = [UIColor clearColor];
//    self.contentTextView.layer.cornerRadius = 5;
//    self.contentTextView.layer.borderColor = [WWTolls colorWithHexString:@"#bfbfbf"].CGColor;
//    self.contentTextView.layer.borderWidth = 1.f;
    // Do any additional setup after loading the view from its nib.
    _imageButton = [[UIButton alloc]init];
    _imageButton.clipsToBounds = YES;
    _imageButton.layer.cornerRadius = 5;
    [_imageButton addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
    _picker = [[UIImagePickerController alloc] init];
    [_picker setDelegate:self];
    _imageButton.frame = CGRectMake(10,9, 40, 40);
    //[_imageButton setTitle:@"上传头像" forState:UIControlStateNormal];
    _imageButton.titleLabel.font = MyFont(12);
    _imageButton.layer.cornerRadius = 20;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"upLoadPhoto_180_180"] forState:UIControlStateNormal];
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"upLoadPhoto_180_180"] forState:UIControlStateHighlighted];
    [self.tpback addSubview:_imageButton];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 9, 300, 50)];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
//    self.nickName.frame = CGRectMake(15,_imageButton.bottom+24, 290, 41);
//    self.sexField.frame = CGRectMake(15, self.nickName.bottom+8, 290, 41);
//    self.birthdayField.frame = CGRectMake(15, self.sexField.bottom+8, 290, 41);
//    self.complete.frame = CGRectMake(15, self.birthdayField.bottom+8, 290, 41);

    //生日
    self.date_picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:yearType];
    self.date_picker.pickDelegate = self;
    [self.view addSubview:self.date_picker];

//    self.weight_picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:heightType];
//    self.weight_picker.pickDelegate = self;
//    [self.view addSubview:self.weight_picker];

    //    地址选择
    self.cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 180)];
    [self operationManagerRequest];
}

-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上传用户数据
- (IBAction)success:(id)sender {
    
    if(_nameTextField.text!=nil && _nameTextField.text.length!=0){//必须输入昵称
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
    if (self.nameTextField.text.length > 10) {
        [self removeWaitView];
        [MBProgressHUD showError:@"昵称不能超过10个字符"];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.nameTextField becomeFirstResponder];
        });

        return;
    }else if(![WWTolls isNameValidate:self.nameTextField.text]){
        [self removeWaitView];
        [self showAlertMsg:@"昵称中必须包含汉字、字母或者数字，请修改您的昵称" yOffset:0];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.nameTextField becomeFirstResponder];
        });
        return;
    }else if([WWTolls isHasSensitiveWord:self.nameTextField.text]){
        [self removeWaitView];
        [self showAlertMsg:@"注意哦！昵称中含有敏感词！" yOffset:0];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.nameTextField becomeFirstResponder];
        });
        return;
    }

    if (self.contentTextView.text.length > 30) {
        [self removeWaitView];
        [MBProgressHUD showError:@"个人签名不能超过30个字符"];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.contentTextView becomeFirstResponder];
        });

        return;
    }else if([WWTolls isHasSensitiveWord:self.contentTextView.text]){
        [self removeWaitView];
        [self showAlertMsg:@"注意哦！个人签名中含有敏感词！" yOffset:0];
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.contentTextView becomeFirstResponder];
        });
        return;
    }

    
    if (self.nameTextField.text.length!=0) {
        [dic setObject:self.nameTextField.text forKey:@"username"];
    }
    if (self.sexTextField.text.length!=0) {
        [dic setObject:[NSString stringWithFormat:@"%d",sexInt] forKey:@"usersex"];
    }
    if (self.heightTextField.text.length!=0) {
      NSString * height = [self.heightTextField.text stringByReplacingOccurrencesOfString:@"cm" withString:@""];
    [dic setObject:height forKey:@"height"];
    }
    if (self.birthDayTextField.text.length!=0) {
        [dic setObject:[NSString stringWithFormat:@"%@",self.birthDayTextField.text] forKey:@"birthday"];
    }
    if (self.contentTextView.text.length!=0) {
        [dic setObject:self.contentTextView.text forKey:@"usersign"];
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

#pragma mark - 获取我的个人信息
-(void)operationManagerRequest
{

    [self showWaitView];

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    __weak typeof(self)weakSelf = self;

    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GETMYINFO parameters:dic requestOperationBlock:^(NSDictionary *baseUserDtoDictionary) {
        
        if (!baseUserDtoDictionary[ERRCODE]) {

            if (baseUserDtoDictionary) {

                if ([baseUserDtoDictionary objectForKeySafe:@"username"]) {
                    weakSelf.nameTextField.text = [baseUserDtoDictionary objectForKey:@"username"];
                    name_String = [baseUserDtoDictionary objectForKey:@"username"];
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"imageurl"]) {
                    [_imageButton setBackgroundImage:self.headImage forState:UIControlStateNormal];
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"usersex"]) {

                    if ([[baseUserDtoDictionary objectForKeySafe:@"usersex"]isEqualToString:@"2"]) {
                        weakSelf.sexTextField.text = @"女";
                        sexInt = 2;
                    }
                    else if ([[baseUserDtoDictionary objectForKeySafe:@"usersex"]isEqualToString:@"1"])
                    {
                        weakSelf.sexTextField.text = @"男";
                        sexInt = 1;
                    }
                    else{
                        weakSelf.sexTextField.text = @"";
                        sexInt = 0;
                    }

                    sex_String = weakSelf.sexTextField.text;
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"birthday"]&& ![[baseUserDtoDictionary objectForKeySafe:@"birthday"] isEqualToString:@"null"]) {

                    weakSelf.birthDayTextField.text = [NSString stringWithFormat:@"%@",[baseUserDtoDictionary objectForKey:@"birthday"]];

                    date_String = weakSelf.birthDayTextField.text;
                }
                if (((NSString*)baseUserDtoDictionary[@"height"]).length>0 && ![[baseUserDtoDictionary objectForKeySafe:@"height"] isEqualToString:@"null"]) {

                    weakSelf.heightTextField.text = [NSString stringWithFormat:@"%@cm",[baseUserDtoDictionary objectForKey:@"height"]];
                    height_String =  weakSelf.heightTextField.text;
                }
                if ([baseUserDtoDictionary objectForKeySafe:@"usersign"]&& ![[baseUserDtoDictionary objectForKeySafe:@"usersign"] isEqualToString:@"null"]) {
                    weakSelf.contentTextView.text = [NSString stringWithFormat:@"%@",[baseUserDtoDictionary objectForKey:@"usersign"]];
                    weakSelf.titleMyLabel.hidden = YES;
                    content_String =   weakSelf.contentTextView.text;
                }
                
                weakSelf.country = [baseUserDtoDictionary[@"country"] isEqualToString:@"null"]?@"":baseUserDtoDictionary[@"country"];
                weakSelf.province = [baseUserDtoDictionary[@"province"] isEqualToString:@"null"]?@"":baseUserDtoDictionary[@"province"];
                weakSelf.city = [baseUserDtoDictionary[@"city"] isEqualToString:@"null"]?@"":baseUserDtoDictionary[@"city"];
                if (weakSelf.country.length>0&&weakSelf.province.length>0) {
                    weakSelf.areaButton.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@",weakSelf.country,weakSelf.province,weakSelf.city];
                    [weakSelf.areaButton setTitle:[NSString stringWithFormat:@"%@ %@ %@",weakSelf.country,weakSelf.province,weakSelf.city] forState:UIControlStateNormal];
                }else if(weakSelf.country.length>0){
                    weakSelf.areaButton.titleLabel.text = [NSString stringWithFormat:@"%@",weakSelf.country];
                    [weakSelf.areaButton setTitle:[NSString stringWithFormat:@"%@",weakSelf.country] forState:UIControlStateNormal];
                }
            }

            [weakSelf removeWaitView];
        }
    }];
    
}

-(void)writeUserInformatinForPlist{

    UserModel *user = [[UserModel alloc]init];
    [user setNickName:self.nameTextField.text];
    [user setSex:sexInt];
    if (self.birthDayTextField.text.length!=0) {
        [user setBirthDay:self.birthDayTextField.text];
    }
    [NSUSER_Defaults setObject:[user savePropertiesToDictionary] forKey:ZDS_USERDEFAULT_SYSTEM_SETTING_KEY_USER_MODEL_INFO];
    [NSUSER_Defaults synchronize];
}

- (IBAction)sexButton:(id)sender {
    [self checkUserInformation];
    [self.nameTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    [self hiddenPickerView];
    myActionSheetView = [[UIActionSheet alloc] initWithTitle:@"选择性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    [myActionSheetView showInView:self.view];
}

- (IBAction)dateButton:(id)sender {
    [self hiddenPickerView];
    [self.nameTextField resignFirstResponder];
    [self checkUserInformation];
    [self.date_picker.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.date_picker.dataPicker.minimumDate = [formatter dateFromString:@"1900-01-01"];
    self.date_picker.dataPicker.maximumDate = [NSDate date];
    [self.contentTextView resignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        [self.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
    NSString *dateStr = @"1990-01-01";
    if (![self.birthDayTextField.text isEqualToString:@""]) {
        dateStr = self.birthDayTextField.text;
    }else{
        date_String = @"1990-01-01";
    }
    
    NSDate *date=[formatter dateFromString:dateStr];
    [self.date_picker.dataPicker setDate:date animated:YES];
    
}

- (IBAction)nickName:(id)sender {
    [self hiddenPickerView];
    BOOL b= [self.nameTextField canBecomeFirstResponder];
    if (b) {
        [self.nameTextField becomeFirstResponder];
    }
}

- (IBAction)heightButton:(id)sender {
    [self hiddenPickerView];
    [self.nameTextField resignFirstResponder];
    [self checkUserInformation];
    [self.contentTextView resignFirstResponder];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.2f animations:^{
        [weakself.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height- 200, self.view.frame.size.width, 200)];
        [weakself.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
    if ([self.heightTextField.text isEqualToString:@""]) {
        [self.weight_picker.pickerView selectRow:65 inComponent:0 animated:YES];
        height_String = @"165cm";
    }else [self.weight_picker.pickerView selectRow:([self.heightTextField.text substringToIndex:3].intValue-100) inComponent:0 animated:YES];
}


#pragma mark -  pickViewDelegate 必须实现的两个方法
-(void)cancelBtn;{
    [self hiddenPickerView];
    
}
-(void)selectBtn:(PickerView_*)pick{
    [self hiddenPickerView];
    if (pick == self.date_picker) {
        self.birthDayTextField.text = date_String;
    }else if(pick == self.weight_picker){
        self.heightTextField.text = height_String;
    }
    
}
-(void)datePickerValue:(NSDate*)date{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:date];
    
    date_String = currentDateStr1;
}

-(void)pickerValue:(NSString*)str
{
    height_String = str;
}

-(void)hiddenPickerView{
    
    [self.heightTextField resignFirstResponder];
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
    }else {
        switch (buttonIndex) {
            case 0:
                self.sexTextField.text = @"男";
                sexInt = 1;
                break;
            case 1:
                self.sexTextField.text = @"女";
                sexInt = 2;
                break;
            default:
                break;
        }
    }
}

#pragma mark textFieldDelegate
-(void)textFieldDidChange{
    [self checkUserInformation];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    [self checkUserInformation];
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }

    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (textField == self.nameTextField) {
        if ([toBeString isEqualToString:@" "]) {
            [self showAlertMsg:@"昵称不允许输入空格" andFrame:CGRectMake(70,100,200,60)];
            return NO;
        }
    }
    
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
//    return YES;
//}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [self checkUserInformation];
//    return YES;
//}
////-(void)textFieldDidBeginEditing:(UITextField *)textField{
////    [self checkUserInformation];
////}
//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [self checkUserInformation];
//}

#pragma mark - textViewDelegate
#pragma mark - 此处进行了textView的输入内容的判断



//键入Done时，插入换行符，然后执行addBookmark
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSInteger res = 15-[new length];
//    if (new.length==0) {
//        self.titleMyLabel.hidden = NO;
//    }else{
//        self.titleMyLabel.hidden = YES;
//    }
//    if(res >= 0){
//        return YES;
//    }
//    else{
//        NSRange rg = {0,[text length]+res};
//        if (rg.length>0) {
//            NSString *s = [text substringWithRange:rg];
//            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
//        }
//        return NO;
//    }
//}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if (textView.text.length==0&&text.length==0) {
        self.titleMyLabel.hidden = NO;
    }else{
        self.titleMyLabel.hidden = YES;
    }
    if (textView.text.length==1&&text.length==0) {
        self.titleMyLabel.hidden = NO;
    }
    return YES;
}


- (NSUInteger)lenghtWithString:(NSString *)string
{
    NSUInteger len = string.length;
    // 汉字字符集
    NSString * pattern  = @"[\u4e00-\u9fa5]";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    
    return len + numMatch;
}
-(void)textViewDidChange:(UITextView *)textView{
    [textView textFieldTextLengthLimit:nil]; 
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
  [self checkUserInformation];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self hiddenPickerView];
    [UIView animateWithDuration:0.2f animations:^{
        [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
        [self.weight_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
    [myActionSheetView removeFromSuperview];
    return YES;
}

-(void)checkUserInformation
{
    
}



#pragma mark 点击地区按钮选择所在区域
- (IBAction)areaButtonClick:(id)sender
{
    [self.nameTextField resignFirstResponder];
    [self hiddenPickerView];
    [self.contentTextView endEditing:YES];
    [self.view endEditing:YES];
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


@end
