//
//  CreateGroupOneViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/15.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreateGroupOneViewController.h"
#import "PickerView+.h"
#import "QiniuSDK.h"
#import "MLImageCrop.h"
#import "UITextField+LimitLength.h"
#import "UITextView+LimitLength.h"
#import "GroupViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "IQKeyboardManager.h"
#import "CreateGroupSetPasswordViewController.h"

@interface CreateGroupOneViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,PickerViewDelegate,UITextFieldDelegate,UITextViewDelegate,MLImageCropDelegate>
{
    NSString * date_String;//时间
    NSDateFormatter *dateformatter1;//一个标准的时间
    NSString *  locationStringDays1;//向服务器输出一个时间
    UIActionSheet *photoActionSheet;
    NSString *name;
    NSDate * selectedDate;//选中时间
}
@property (strong, nonatomic) UIButton *timebtn;
@property (strong, nonatomic) UITextField *beginDateTxt;
@property(nonatomic,strong)PickerView_ * date_picker;//时间
@property(nonatomic,strong)UITextView *content;//文本框
@property(nonatomic,strong)UILabel *textPlacehoader;//占位
@property(nonatomic,strong)UIImagePickerController *picker;
@property (strong, nonatomic) UILabel *endtimelbl;
@property(nonatomic,strong)UIButton *imageButton;//选择封面
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property (nonatomic,strong) TPKeyboardAvoidingScrollView *tpBgView;
@end

@implementation CreateGroupOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    if (self.isPassWordGrouper) {
        [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    }else [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [self.rightButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 54;
    self.rightButton.left += 110;
    self.rightButton.titleLabel.font = MyFont(16);
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"创建减脂团";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    [self setUpGUI];
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化UI
-(void)setUpGUI{
    self.tpBgView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:self.tpBgView];
    //选择封面
    _imageButton = [[UIButton alloc]init];
    _imageButton.frame = CGRectMake(SCREEN_MIDDLE(84),15, 84, 84);
    //[_imageButton setTitle:@"上传头像" forState:UIControlStateNormal];
    _imageButton.titleLabel.font = MyFont(12);
    _imageButton.backgroundColor = [UIColor grayColor];
    _imageButton.layer.cornerRadius = 2;
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-h-104-90"] forState:UIControlStateNormal];
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-b-104-90"] forState:UIControlStateHighlighted];
    [_imageButton addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
    _picker = [[UIImagePickerController alloc] init];
    [_picker setDelegate:self];
    [self.tpBgView addSubview:_imageButton];
    NSLog(@"tuxing---------------%@",self.childViewControllers);
    dateformatter1 = [[NSDateFormatter alloc]init];
    [dateformatter1 setDateFormat:@"YYYY-MM-dd 00:00:00"];
    locationStringDays1=[dateformatter1 stringFromDate:[NSDate dateWithTimeIntervalSinceNow:172800]];
    
    //团组名称
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, self.imageButton.bottom+15, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.frame = CGRectMake(13, line.bottom+15, 64,15);
    lbl1.text = @"团组名称";
    lbl1.font = MyFont(14);
    lbl1.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.tpBgView addSubview:lbl1];
    
    //开始时间
    line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, lbl1.bottom+15, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    
    UILabel *lbl2 = [[UILabel alloc] init];
    lbl2.text = @"开始时间";
    lbl2.frame = CGRectMake(13, line.bottom+15, 64,15);
    lbl2.font = MyFont(14);
    lbl2.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.tpBgView addSubview:lbl2];
    
    //结束时间
    line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, lbl2.bottom + 15, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    
    UILabel *lbl3 = [[UILabel alloc] init];
    lbl3.text = @"结束时间";
    lbl3.font = MyFont(14);
    lbl3.frame = CGRectMake(13, line.bottom+15, 64,15);
    lbl3.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.tpBgView addSubview:lbl3];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, lbl3.bottom + 15, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];
    //招募宣言
    UILabel *lbl4 = [[UILabel alloc] init];
    lbl4.text = @"招募宣言";
    lbl4.font = MyFont(14);
    lbl4.frame = CGRectMake(13, line.bottom+15, 64,15);
    lbl4.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.tpBgView addSubview:lbl4];
    
    line = [[UIView alloc] init];
    line.backgroundColor = [WWTolls colorWithHexString:@"#dcdcdc"];
    line.frame = CGRectMake(0, lbl4.bottom + 80, SCREEN_WIDTH, 0.5);
    [self.tpBgView addSubview:line];

    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.font = MyFont(14);
    self.nameTextField.placeholder = @"输入团组名称";
    self.nameTextField.textColor =  [WWTolls colorWithHexString:@"#999999"];
    self.nameTextField.frame = CGRectMake(85, lbl1.top, 150, 15);
    self.nameTextField.textAlignment = NSTextAlignmentCenter;
    self.nameTextField.delegate = self;
    [self.nameTextField limitTextLength:10];
    [self.tpBgView addSubview:self.nameTextField];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, lbl1.top, 320, 20)];
    [self.tpBgView addSubview:btn];
    [btn addTarget:self action:@selector(name) forControlEvents:UIControlEventTouchUpInside];
    
    self.endtimelbl = [[UILabel alloc] init];
    self.endtimelbl.textAlignment = NSTextAlignmentCenter;
    self.endtimelbl.font = MyFont(14);
    self.endtimelbl.frame = CGRectMake(85, lbl3.top, 150, 15);
    self.endtimelbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self.tpBgView addSubview:self.endtimelbl];
    
    self.beginDateTxt = [[UITextField alloc] init];
    self.beginDateTxt.font = MyFont(14);
    self.beginDateTxt.textAlignment = NSTextAlignmentCenter;
    self.beginDateTxt.frame = CGRectMake(85, lbl2.top, 150, 15);
    self.beginDateTxt.placeholder = @"选择开始时间";
    self.beginDateTxt.textColor =  [WWTolls colorWithHexString:@"#999999"];
    [self.tpBgView addSubview:self.beginDateTxt];
    
    UIButton *beginBtn = [[UIButton alloc] init];
    beginBtn.frame = CGRectMake(0, lbl2.top-15, 320,45);
    [beginBtn addTarget:self action:@selector(dateClick) forControlEvents:UIControlEventTouchUpInside];
    [self.tpBgView addSubview:beginBtn];
    
    //招募宣言
    UITextView *text = [[UITextView alloc] init];
//    text.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//    text.layer.borderWidth = 0.5;
    self.content = text;
    text.frame = CGRectMake(6, lbl4.bottom+5, 308, 60);
    text.delegate = self;
    text.font = MyFont(15);
    text.textColor = [WWTolls colorWithHexString:@"#999999"];
    text.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
    [text limitTextLength:50];
    [self.tpBgView addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(16, text.top+6, 200, 20)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"打开脑洞，吸引更多人加入吧";
    textlbl.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
    textlbl.font = MyFont(12);
    [self.tpBgView addSubview:textlbl];
    
    //字数提醒
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"最多可以输入50个字";
    lbl.font = MyFont(11);
    lbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    lbl.frame = CGRectMake(12, text.bottom+2, 200, 12);
    [self.tpBgView addSubview:lbl];
    
    self.date_picker = [[PickerView_ alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200) withType:yearType];
    self.date_picker.pickDelegate = self;
    [self.tpBgView addSubview:self.date_picker];
    self.tpBgView.contentSize = CGSizeMake(SCREEN_WIDTH, lbl.bottom+12);
}
-(void)name{
    [self.nameTextField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"创建闯关减脂团页面"];
    [self.view endEditing:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"创建闯关减脂团页面"];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
#pragma mark - 下一步
-(void)Next{
    if (self.nameTextField.text.length<1) {
        [self showAlertMsg:@"请输入团组名称" yOffset:-40];
    }else if(self.Photohash.length<1){
        [self showAlertMsg:@"请选择封面" yOffset:-40];
    }else if(self.endtimelbl.text.length<1){
        [self showAlertMsg:@"请选择开始时间" yOffset:-40];
    }else if(self.content.text.length<1){
        [self showAlertMsg:@"请输入团组宣言" yOffset:-40];
    }else if(![WWTolls isNameValidate:self.nameTextField.text]){
        [self showAlertMsg:@"团组名称中必须包含汉字、字母或者数字，请修改您的昵称" yOffset:-40];
    }else if([WWTolls isHasSensitiveWord:self.nameTextField.text]){
        [self showAlertMsg:@"注意哦！团组名称中含有敏感词！" yOffset:-40];
    }else if([WWTolls isHasSensitiveWord:self.content.text]){
        [self showAlertMsg:@"注意哦！团组宣言中含有敏感词！" yOffset:-40];
    }else{
        if (self.isPassWordGrouper) {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
            if(self.Photokey.length>0){
                [dictionary setObject:[NSString stringWithFormat:@"%@?%@",self.Photokey,self.Photohash] forKey:@"imageurl"];
            }else{
                [dictionary setObject:ZDS_DEFAULTIMAGEURL forKey:@"imageurl"];
            }
            [dictionary setObject:self.nameTextField.text forKey:@"gamename"];
            [dictionary setObject:[dateformatter1 stringFromDate:selectedDate] forKey:@"gmbegintime"];//开始时间
            NSString * gmsloganString = [NSString takeoutString:self.content.text];
            [dictionary setObject:gmsloganString forKey:@"gmslogan"];//宣言
            [dictionary setObject:@"0" forKey:@"crtortype"];//参与者类型
            [dictionary setObject:@"1" forKey:@"gamemode"];
            if(self.Wheretag.length>0)
                [dictionary setObject:[NSString stringWithFormat:@"%@,",self.Wheretag] forKey:@"gametags"];
            CreateGroupSetPasswordViewController *setPwd = [[CreateGroupSetPasswordViewController alloc] init];
            setPwd.tempDic = dictionary;
            [self.navigationController pushViewController:setPwd animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认创建吗?" message:@"创建后，团组不能取消哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.rightButton.userInteractionEnabled = NO;
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
        if(self.Photokey.length>0){
            [dictionary setObject:[NSString stringWithFormat:@"%@?%@",self.Photokey,self.Photohash] forKey:@"imageurl"];
        }else{
            [dictionary setObject:ZDS_DEFAULTIMAGEURL forKey:@"imageurl"];
        }
        [dictionary setObject:self.nameTextField.text forKey:@"gamename"];
        [dictionary setObject:[dateformatter1 stringFromDate:selectedDate] forKey:@"gmbegintime"];//开始时间
        NSString * gmsloganString = [NSString takeoutString:self.content.text];
        [dictionary setObject:gmsloganString forKey:@"gmslogan"];//宣言
        [dictionary setObject:@"0" forKey:@"crtortype"];//参与者类型
        [dictionary setObject:@"1" forKey:@"gamemode"];
        if(self.Wheretag.length>0)
            [dictionary setObject:[NSString stringWithFormat:@"%@,",self.Wheretag] forKey:@"gametags"];
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            if (dic[ERRCODE]) {
                weakSelf.rightButton.userInteractionEnabled = YES;
            }else{
                [weakSelf showAlertMsg:@"创建成功" andFrame:CGRectMake(70,100,200,60)];
                [NSUSER_Defaults setValue:@"YES" forKey:@"tuanzubianhua"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupSucess" object:nil];
                NSLog(@"*********%@", [dic objectForKey:@"errinfo"]);
                NSString *gameid = [dic objectForKey:@"gameid"];
                GroupViewController *detail = [[GroupViewController alloc]init];
                detail.clickevent = 0;
                detail.joinClickevent = @"0";
                detail.groupId = gameid;//20150206020000000078
                detail.gameDetailStatus = @"10086";
                [weakSelf.navigationController pushViewController:detail animated:YES];
                weakSelf.rightButton.userInteractionEnabled = NO;
            }
        }];
    }
}

#pragma mark - 选择时间
- (void)dateClick{
    
    [self.view endEditing:YES];
    [self.date_picker.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //二天之后
    //    self.date_picker.dataPicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*2];
    
    if (self.theBeginDate == nil) {
        self.theBeginDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*2];
    }
    if (self.days == 0) {
        self.days = 28;
    }
    self.date_picker.dataPicker.minimumDate = self.theBeginDate;
    //三十一天之后
    self.date_picker.dataPicker.maximumDate =[self.theBeginDate dateByAddingTimeInterval:60*60*24*self.days];
    //    [NSDate dateWithTimeIntervalSinceNow:60*60*24*self.days];
    [self.view resignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
    }];
    
    //    NSString *dateStr = @"1990-01-01";
    if ([self.beginDateTxt.text isEqualToString:@""]) {
        [self datePickerValue:self.theBeginDate];
        [self.date_picker.dataPicker setDate:self.theBeginDate animated:YES];
        selectedDate = self.theBeginDate;
    }
}

#pragma mark - datepickViewDelegate
-(void)cancelBtn{
    [UIView animateWithDuration:0.2f animations:^{
        [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
    
}
-(void)selectBtn:(PickerView_*)pick{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:selectedDate];
    
    NSDate *enddate = [selectedDate dateByAddingTimeInterval:60*60*24*self.gamedays];
    NSString *endStr = [dateFormatter1 stringFromDate:enddate];
    
    self.beginDateTxt.text = currentDateStr1;
    self.endtimelbl.text = endStr;
    [UIView animateWithDuration:0.2f animations:^{
        [self.date_picker setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    }];
}
-(void)datePickerValue:(NSDate*)date{
    
    selectedDate = date;
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length==0&&text.length==0) {
        self.textPlacehoader.hidden = NO;
    }else{
        self.textPlacehoader.hidden = YES;    }
    if (textView.text.length==1&&text.length==0) {
        self.textPlacehoader.hidden = NO;    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [textView textFieldTextLengthLimit:nil];
    if(textView.text.length>0){
        self.textPlacehoader.hidden = YES;
    }
}
#pragma mark - 返回
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 相机功能
-(void)photoFileSelector{
    [self.view endEditing:YES];
    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
    photoActionSheet.tag = 999;
    [photoActionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
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
}

//调用相机
-(void)takePhoto:(BOOL)Editing
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        //设置拍照后的图片可被编辑
        _picker.allowsEditing = NO;
        _picker.sourceType = sourceType;
        [self presentViewController:_picker animated:YES completion:nil];
    }else{
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
    
    [self presentViewController:_picker animated:YES completion:nil];
    
}

//获取图片后的行为
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
//    float f = 0.5;
//    NSData *data = UIImageJPEGRepresentation(image,1);
//    if(data.length>1024*1024*10){
//        [self removeWaitView];
//        [self showAlertMsg:@"您选择的图片太大,请重新上传" andFrame:CGRectZero];
//    }else if (data.length>1024*1024*2) {
//        data = UIImageJPEGRepresentation(image,0.3);
//    }else{
//        while (data.length>300*1024) {
//            data=nil;
//            data = UIImageJPEGRepresentation(image,f);
//            f*=0.8;
//        }
//    }
    
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
@end
