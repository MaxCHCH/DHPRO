//
//  TalkAboutViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/17.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "TalkAboutViewController.h"

#import "JSONKit.h"
#import "ImageButton.h"
#import "WWRequestOperationEngine.h"
#import "NSString+NARSafeString.h"
#import "WWTolls.h"
#import "MBProgressHUD+MJ.h"
#import "UITextView+LimitLength.h"
#import "MobClick.h"
#import "QiniuSDK.h"
#import "UIImage+fixOrientation.h"
#import "IQKeyboardManager.h"
#import "FacialView.h"
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "MLSelectPhotoAssets.h"

@interface TalkAboutViewController ()<UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TuSDKFilterManagerDelegate>
{
    UIActionSheet *photoActionSheet;
    MBProgressHUD *HUD;
    
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
    TuSDKCPAlbumComponent *_albumComponent;

}

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;


@property (nonatomic,assign) BOOL isSelect;


@property(nonatomic,strong)NSString *imageNameString;
@property(nonatomic,strong)UIButton * imageButton;
@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小

@property (nonatomic,strong) UILabel *textViewPlaceLabel;

@property(nonatomic,strong)UIScrollView *scrollView;//表情键盘
@property(nonatomic,strong)UIPageControl *pageControl;//表情
@property(nonatomic,strong)UIView *myToolBar;//键盘工具栏
@property(nonatomic,strong)UIButton *facialBtn;//表情按钮
@property (weak, nonatomic) IBOutlet UIView *photoBack;

@end

@implementation TalkAboutViewController

#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发送团聊消息页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [MobClick beginLogPageView:@"发送团聊消息页面"];
    //广场标题
    self.titleLabel.text = @"乐活吧";
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
    //导航栏返回
//    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
//    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;

    //    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    //    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    self.leftButton.titleLabel.font = MyFont(13);
    //    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    //    CGRect labelRect = self.leftButton.frame;
    //    labelRect.size.width = 16;
    //    labelRect.size.height = 16;
    //    self.leftButton.frame = labelRect;
    ////    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(createGame)];
    ////    item.tintColor = [UIColor whiteColor];
    ////    self.navigationItem.rightBarButtonItem = item;
    //
    //    [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
    //    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    //    self.rightButton.titleLabel.font = MyFont(16);
    //    [self.rightButton addTarget:self action:@selector(createGame) forControlEvents:UIControlEventTouchUpInside];
    //    CGRect labelRectRight = self.rightButton.frame;
    //    labelRectRight.size.width = 51;
    //    labelRectRight.size.height = 18;
    //    self.rightButton.frame = labelRectRight;
    //
    //    self.titleLabel.text = @"说点啥吧";
    //    self.titleLabel.font = MyFont(18);
    //    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = ZDS_BACK_COLOR;
//    self.view.backgroundColor = [WWTolls colorWithHexString:@"#efefef"];
    //TUSDK
//    [[TuSDKTKLocation shared] requireAuthorWithController:self];
//    [TuSDK checkManagerWithDelegate:self];
    //初始化 单选按钮
    self.isSelect = YES;
    [self.selectImageView setImage:[UIImage imageNamed:@"xz-34"]];
    
    self.backTextView = [[QEDTextView alloc] init];
    [self.backGround_View addSubview:self.backTextView];
    self.backGround_View.width = SCREEN_WIDTH;
    self.backTextView.frame = CGRectMake(15, 5, self.backGround_View.width - 30, self.backGround_View.height - 40 - 11);
//    self.backTextView.layoutManager.allowsNonContiguousLayout = NO;
//    self.backTextView.textColor = [UIColor grayColor];
//    self.backTextView.font = MyFont(16.0);
//    [self.backTextView limitTextLength:301];
    [self.backTextView setValue:@300 forKey:@"limit"];
    self.backTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backTextView.layoutManager.allowsNonContiguousLayout = NO;
    self.backTextView.delegate = self;
    self.backTextView.font = MyFont(16);
    self.backTextView.textColor = ContentColor;
    self.backTextView.scrollEnabled = YES;
//    self.limitLabel.left = SCREEN_WIDTH - 146;
    
    self.textViewPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, self.backTextView.width, 16)];
    [self.backTextView addSubview:self.textViewPlaceLabel];
    self.textViewPlaceLabel.textColor = [ContentColor colorWithAlphaComponent:0.6];
    self.textViewPlaceLabel.font = MyFont(16.0);
    self.textViewPlaceLabel.text = @"说点什么...";
    
    NSLog(@"self.backTextView.maxY:%f",self.backTextView.maxY);
    _imageButton = [[UIButton alloc]init];
    _imageButton.frame = CGRectMake(5,5, 87, 87);
    [_imageButton setBackgroundImage:[UIImage imageNamed:@"tjtp-174"] forState:UIControlStateNormal];
    _imageButton.contentMode = UIViewContentModeScaleAspectFill;
    _imageButton.clipsToBounds = YES;
//    [_imageButton setBackgroundImage:[UIImage imageNamed:@"xj-80"] forState:UIControlStateHighlighted];
    [_imageButton addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
    _picker = [[UIImagePickerController alloc] init];
    [_picker setDelegate:self];
    
    [self.photoBack addSubview:_imageButton];
    
    self.selectButton.hidden = NO;
    self.selectImageView.hidden = NO;
    self.textLabel.hidden = NO;
//    self.textLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    self.isSelect = YES;
    [self.selectImageView setImage:[UIImage imageNamed:@"xz-34"]];
    if (self.gmpassword.length > 0) {
        self.isSelect = NO;
        [self.selectImageView setImage:[UIImage imageNamed:@"wxz-34"]];
    }
    
    /*********表情工具条********/
    //创建工具条
    UIView *myToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 48)];
    myToolBar.backgroundColor = [UIColor whiteColor];
    myToolBar.layer.borderWidth = 0.5;
    myToolBar.layer.borderColor = [WWTolls colorWithHexString:@"#989898"].CGColor;
    self.myToolBar = myToolBar;
    [self.view addSubview:myToolBar];
    //完成按钮
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-47, 0, 34, 48)];
    cancelBtn.titleLabel.font = MyFont(17);
    [cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar addSubview:cancelBtn];
    //表情按钮
    UIButton *facialBtn = [[UIButton alloc] initWithFrame:CGRectMake(13, 13, 25, 25)];
    self.facialBtn = facialBtn;
    //    [facialBtn setTitle:@"表情" forState:UIControlStateNormal];
    //    [facialBtn setTitle:@"键盘" forState:UIControlStateSelected];
    //    [facialBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [facialBtn setBackgroundImage:[UIImage imageNamed:@"chat_facial"] forState:UIControlStateNormal];
    [facialBtn setBackgroundImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
    [facialBtn addTarget:self action:@selector(facial:) forControlEvents:UIControlEventTouchUpInside];
    [myToolBar addSubview:facialBtn];
    //创建表情键盘
    if (_scrollView==nil) {
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 212 - 66, SCREEN_WIDTH, 212)];
        [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<9; i++) {
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, SCREEN_WIDTH-20, 170)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(33*SCREEN_WIDTH/320, 43)];
            fview.delegate=self;
            [_scrollView addSubview:fview];
            //                [fview release];
        }
    }
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, 212);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    //        [scrollView release];
    self.pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-150)/2,SCREEN_HEIGHT -30-64, 150, 30)];
    [self.pageControl setCurrentPage:0];
    self.pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    self.pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    self.pageControl.numberOfPages = 9;//指定页面个数
    [self.pageControl setBackgroundColor:[UIColor clearColor]];
    self.pageControl.hidden=YES;
    [self.pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.pageControl];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.backTextView becomeFirstResponder];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - UI

/*************************头像上传******************************/
-(void)photoFileSelector{
    [self.view endEditing:YES];
    
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    [NSUSER_Defaults setObject:@"精华帖的评论最多只能添加1张图片" forKey:@"zdsselectphotoTip"];
    //    pickerVc.selectPickers = self.assets;
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
        [self openEditMultipleWithController:self result:[MLSelectPhotoPickerViewController getImageWithImageObj:image]];

        
    };
    
//    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
//    [photoActionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
        //弹出的菜单按钮点击后的响应
        if (buttonIndex == photoActionSheet.cancelButtonIndex)
        {
            
        }
        switch (buttonIndex)
        {
            case 0:  //打开照相机拍照
                
                [self takePhoto:NO];
                break;
                
            case 1:  //打开本地相册
                
                [self LocalPhoto:NO];
                break;
        }
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
        _picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        _picker.allowsEditing = NO;
        
        _picker.sourceType = sourceType;
        
//        [self presentViewController:_picker animated:YES completion:nil];
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
    
    _picker.allowsEditing = Editing;
    
    [self presentViewController:_picker animated:YES completion:nil];
    
}
- (void)onTuSDKFilterManagerInited:(TuSDKFilterManager *)manager;
{
//    [self showAlertMsg:@"初始化完成" andFrame:CGRectZero];
}



//获取图片后的行为
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
        
    {
//        [self showWaitView];
        UIImage* editeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage* originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage *image;//原图
        
        if (editeImage!=nil) {
            image = editeImage;
        }else{
            image = originalImage;
        }
        image = [image fixOrientation];
        [self openEditMultipleWithController:self result:image];

        __weak typeof(self) weakSelf = self;
        [_picker dismissViewControllerAnimated:YES completion:^{
            [weakSelf showWaitView];
        }];
  
        
//        float f = 0.5;
//        data = UIImageJPEGRepresentation(image,1);
//        if(data.length>1024*1024*10){
//            [self removeWaitView];
//            [self showAlertMsg:@"您选择的图片太大,请重新上传" andFrame:CGRectZero];
//        }else{
//            if (data.length>1024*1024*2) {
//                data = UIImageJPEGRepresentation(image,0.3);
//            }else{
//                while (data.length>300*1024) {
//                    data=nil;
//                    data = UIImageJPEGRepresentation(image,f);
//                    f*=0.8;
//                }
//            }
        
//        }

    }
         
}


- (void)openEditMultipleWithController:(UIViewController *)controller     result:(UIImage *)result
{

    self.controller = controller;

    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleComponent.html
    WEAKSELF_SS
    _photoEditMultipleComponent =
    [TuSDKGeeV1 photoEditMultipleWithController:controller
                                  callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         //         _albumComponent = nil;
         
         // 如果在RootViewController presentViewController,autoDismissWhenCompelted参数将无效
         // 请使用以下方法关闭
         //         if (_photoEditMultipleComponent.autoDismissWhenCompelted && controller) {
         //             [controller popViewControllerAnimated:YES];
         //         }
         if (controller) {
             [controller popViewControllerAnimated:YES];
         }
         WEAKSELF_SS
         NSDictionary *dict = [NSMutableDictionary dictionary];
         [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
         [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
             
             if (dic[ERRCODE]) {
                 [weakSelf removeWaitView];
             }else{
#pragma mark - 七牛上传图片
                 NSString *token = dic[@"uptoken"];
                 if(token.length>0){
                     UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfFile:result.imagePath]];
                     NSData *data = [SSLImageTool compressImage:img withMaxKb:300];
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
                                           weakSelf.PhotoSize = result.image.size;
                                           weakSelf.imageNameString = [NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig];
                                           //直接把该图片读出来显示在按钮上
                                           dispatch_async(dispatch_get_main_queue(), ^{
//                                                                                              [weakSelf.imageBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
                                               UIImage *img=[UIImage imageWithData:data];
                                               [weakSelf.imageButton setBackgroundImage:img forState:UIControlStateNormal];
                                           });
                                           //                                           weakSelf.imageBtn.width = 80;
                                           //                                           weakSelf.imageBtn.height = 80;
                                           //                                           weakSelf.imageBack.height = 91;
                                           //                                           weakSelf.bottomView.top = weakSelf.imageBack.maxY + 10;
                                           //                                           weakSelf.contentNumLbl.top = weakSelf.imageBtn.bottom - 10;
//                                           weakSelf.imageButton.width = 80;
//                                           weakSelf.imageButton.height = 80;
////                                           weakSelf.imageButton.top = 118;
//                                           weakSelf.backGround_View.height = 108 + 80 + 10;
//                                           weakSelf.selectImageView.top = 181 + 40;
//                                           weakSelf.selectButton.top = 181 + 40;
//                                           weakSelf.textLabel.top = 181 + 40;
//                                           weakSelf.limitLabel.top = 64 + 40 + 80;
                                           [weakSelf.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
                                           
                                           //                                           NSLog(@"weakSelf.imageBtn.frame:%@",[NSValue valueWithCGRect:weakSelf.imageBtn.frame]);
                                           //                                           NSLog(@"weakSelf.textView.frame:%@",[NSValue valueWithCGRect:weakSelf.textView.frame]);
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
         
         
         
         ///*
         //         __weak typeof(self) weakSelf = self;
         //         dispatch_async(dispatch_get_main_queue(), ^{
         //             [_picker dismissViewControllerAnimated:YES completion:^{
         //                 //获取七牛上传凭证
         //                 NSDictionary *dict = [NSMutableDictionary dictionary];
         //                 [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
         //                 [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
         //
         //                     if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
         //                         [weakSelf removeWaitView];
         //                         [MBProgressHUD showError:@"上传失败请重试"];
         //                     }else{
         //#pragma mark - 七牛上传图片
         //                         NSString *token = dic[@"uptoken"];
         //                         if(token.length>0){
         //                             UIImage *img =  [UIImage imageWithData:[NSData dataWithContentsOfFile:result.imagePath]];
         //                             NSData *data = [SSLImageTool compressImage:img withMaxKb:300];
         //                             //                            HUD = [[MBProgressHUD alloc] initWithView:self.view];
         //                             //                            [self.view addSubview:HUD];
         //                             //                            HUD.labelText = @"正在上传";
         //                             //                            //进度条
         //                             //                            __block float progress = 0.0f;
         //                             //                            HUD.mode = MBProgressHUDModeAnnularDeterminate;
         //                             //                            [HUD showAnimated:YES whileExecutingBlock:^{
         //                             //                                while (progress<1.0) {
         //                             //                                    HUD.progress = progress;
         //                             //                                }
         //                             //
         //                             //                            } completionBlock:^{
         //                             //                                [HUD removeFromSuperview];
         //                             //                            }];
         //
         //                             //七牛上传管理器
         //                             QNUploadManager *upManager = [[QNUploadManager alloc] init];
         //                             //初始化上传选项
         //                             //                            QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
         //                             //                                progress = percent;
         //                             //                            } params:nil checkCrc:NO cancellationSignal:^BOOL{
         //                             //                                NSLog(@"xxxxxxxxxxxxxxxxxxxxx");
         //                             //                                return NO;
         //                             //                            }];
         //                             //开始上传
         //                             CFUUIDRef uuidRef =CFUUIDCreate(NULL);
         //
         //                             CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
         //
         //                             CFRelease(uuidRef);
         //
         //                             NSString *UUIDStr = (__bridge NSString *)uuidStringRef;
         //                             NSString *QNkey = [NSString stringWithFormat:@"images/0/%@.jpg",UUIDStr];
         //                             [upManager putData:data key:QNkey token:token
         //                                       complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {//resp hash key
         //
         //                                           weakSelf.isNew = NO;
         //                                           if (info.isOK) {
         //                                               //                                              [self showAlertMsg:@"上传成功" yOffset:-100];
         //                                               if(resp){
         //                                                   weakSelf.Photohash = resp[@"hash"];
         //                                                   weakSelf.Photokey = resp[@"key"];
         //                                                   weakSelf.PhotoSize = result.image.size;
         //                                                   weakSelf.PhotoBig = data.length;
         //                                                   weakSelf.imageNameString = [NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",self.Photokey,self.Photohash,self.PhotoSize.width,self.PhotoSize.height,self.PhotoBig];
         //                                                   //直接把该图片读出来显示在按钮上
         //                                                   UIImage *img=[UIImage imageWithData:data];
         //                                                   [weakSelf.imageButton setBackgroundImage:img forState:UIControlStateNormal];
         //                                                   weakSelf.imageButton.width = 80;
         //                                                   weakSelf.imageButton.height = 80;
         //                                                   //                                                      weakSelf.imageButton.top = 148;
         //                                                   weakSelf.backGround_View.height = 108 + 80 + 10;
         //                                                   weakSelf.selectImageView.top = 181 + 40;
         //                                                   weakSelf.selectButton.top = 181 + 40;
         //                                                   weakSelf.textLabel.top = 181 + 40;
         //                                                   weakSelf.limitLabel.top = 177 + 40;
         //                                                   [weakSelf.rightButton setTitleColor:ZDS_DHL_TITLE_COLOR forState:UIControlStateNormal];
         //                                                   //                                                      @property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
         //                                                   //                                                      @property (weak, nonatomic) IBOutlet UIButton *selectButton;
         //                                                   //                                                      @property (weak, nonatomic) IBOutlet UILabel *textLabel;
         //                                                   //                                                      @property (weak, nonatomic) IBOutlet UILabel *limitLabel;
         //                                                   [weakSelf removeWaitView];
         //                                               }
         //                                           }else{
         //                                               [weakSelf removeWaitView];
         //                                               if (info.isConnectionBroken) {
         //                                                   [MBProgressHUD showError:@"网速太不给力了"];
         //                                               }
         //                                               else if(info.statusCode == 401){//授权失败
         //                                                   weakSelf.isNew = YES;
         //                                                   [MBProgressHUD showError:@"上传失败，请重试"];
         //                                               }else [MBProgressHUD showError:@"上传失败，请重试"];
         //                                           }
         //                                           NSLog(@"%@", info);
         //                                           NSLog(@"%@", resp);
         //                                       } option:nil];
         //                         }else{
         //                             [weakSelf removeWaitView];
         //                             [MBProgressHUD showError:@"上传失败请重试"];
         //                         }
         //                     }
         //                 }];
         //                 //                //__strong __typeof(weakSelf)strongSelf = weakSelf;
         //                 //#pragma mark - 监测图片上传的指示器
         //                 //                [weakSelf showWaitView:@"图片上传中"];
         //                 //
         //                 //
         //                 //
         //                 //                //****获取userid****//
         //                 //                NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
         //                 //                NSString *userid = [NSString stringWithFormat:@"%@",userID];
         //                 //                NSString *key = [NSString getMyKey:userID];
         //                 //
         //                 //                [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@userid=%@&key=%@&method=upload&filetyp=0&imgsize=0,%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOAD,userid,key,@"98"] jsonMutableDictionary:nil parameters:nil imageData:data imageName:@"talkImageImageimage.png" requestOperationBlock:^(NSString *object) {
         //                 //                    NSLog(@"打印的图片链接############%@",[NSString stringWithFormat:@"%@%@userid=%@&key=%@&method=upload&filetyp=0&imgsize=0,%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOAD,userid,key,@"98"]);
         //                 //
         //                 //                    NSDictionary *dic = [object objectFromJSONString];
         //                 //                    if (![dic isKindOfClass:[NSDictionary class]] && dic==nil) {
         //                 //                        [weakSelf showAlertMsg:@"上传图片失败" andFrame:CGRectMake(70,100,200,60)];
         //                 //                        [weakSelf removeWaitView];
         //                 //                    }else{
         //                 //                        NSString *headFile = [dic objectForKey:@"fileURL"];
         //                 //                        //直接把该图片读出来显示在按钮上
         //                 //                        UIImage *img=[UIImage imageWithData:data];
         //                 //                        [weakSelf.imageButton setBackgroundImage:nil forState:UIControlStateNormal];
         //                 //                        weakSelf.imageButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
         //                 //                        [weakSelf.imageButton setBackgroundColor:[UIColor whiteColor]];
         //                 //                        [weakSelf.imageButton setImage:img forState:UIControlStateNormal];
         //                 //                        //[weakSelf setBackgroundImage:img forState:UIControlStateNormal];
         //                 //
         //                 //                        self.imageNameString  = headFile;
         //                 //                        [self removeWaitView];
         //                 //                    }
         //                 //                }];
         //             }];
         //         });
         //
         //       */
         
         // 获取图片失败
         if (error) {
             lsqLError(@"editMultiple error: %@", error.userInfo);
             return;
         }
         [result logInfo];
     }];
    // 设置图片
    _photoEditMultipleComponent.inputImage = result;
    //    _photoEditMultipleComponent.inputTempFilePath = result.imagePath;
    //    _photoEditMultipleComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
    [_photoEditMultipleComponent showComponent];
    
    
    
}

- (void)pop{
    if (self.backTextView.text.length > 0 || self.Photohash.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃当前编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else [self popButton];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self popButton];
    }
}

-(void)popButton{
    [self.backTextView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 输出评论请求
-(void)createGame{
    self.rightButton.userInteractionEnabled = NO;
     NSLog(@"********上传的图片地址%@",self.imageNameString);
    if([WWTolls isHasSensitiveWord:self.backTextView.text]){
        self.rightButton.userInteractionEnabled = YES;
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }else if ((self.backTextView.text.length!=0 && (self.backTextView.text.length<=300)) || self.imageNameString.length!=0) {

        [self talkRequestReload:self.gameid talkContent:self.backTextView.text imageURL:self.imageNameString];
    }else{
        if (self.backTextView.text.length > 300) {

            [self showAlertMsg:@"输入内容不能大于300字" andFrame:CGRectMake(70,100,200,60)];
        }else{
            [self showAlertMsg:@"请输入内容" andFrame:CGRectMake(70,100,200,60)];
        }
        self.rightButton.userInteractionEnabled = YES;
    }
}   



#pragma mark - UITextViewDelegate
#pragma mark - 此处进行了textView的输入内容的判断
-(void)textViewDidChange:(UITextView *)textView{
    
    [self reloadNum];
//    [textView textFieldTextLengthLimit:nil];
}

- (void)reloadNum{
    self.textViewPlaceLabel.hidden = self.backTextView.text.length;
    self.limitLabel.text = [NSString stringWithFormat:@"(%ld/300)",_backTextView.text.length>300?300:_backTextView.text.length];
//    if (_backTextView.text.length > 0 || self.Photokey.length > 0) {
//        [self.rightButton setTitleColor:OrangeColor forState:UIControlStateNormal];
//    }else{
//        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
//    }

}
//键入Done时，插入换行符，然后执行addBookmark
//- (BOOL)textView:(UITextView *)textView
//shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)text
//{
//
//    if ([text isEqualToString:@"\n"])
//    {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    NSString * str = [textView.text stringByReplacingCharactersInRange:range withString:text]; //得到输入框的内容
//    NSUInteger charLen = [self lenghtWithString:str];
//    //判断加上输入的字符，是否超过界限
//    //    NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
//    if (charLen > 400)
//    {
//        textView.text = [str substringToIndex:200];
//        //        textView.text = [textView.text substringToIndex:200];
//        //        [self showAlertMsg:@"不能超过200字" andFrame:CGRectMake(60, 100, 200, 50)];
//        return NO;
//    }
//
////    if (str.length>0) {
////        if(self.nameTextField.text.length>0){
////            [self confirmButtonStage];
////        }
////    }else{
////        [self cancelButtonStage];
////    }
//    return YES;
//}

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

#pragma mark ..发起讨论..
-(void)talkRequestReload:(NSString*)gameid talkContent:(NSString*)content imageURL:(NSString*)imgUrl {
    
    [self showWaitView:@"发送中"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dictionary setObject:self.gameid forKey:@"gameid"];
    if (content == nil || content.length == 0) {
        [dictionary setObject:@"" forKey:@"talkcontent"];
    }
    else [dictionary setObject:[content stringByReplacingOccurrencesOfString:@"＃" withString:@"#" options:NSCaseInsensitiveSearch range:NSMakeRange(0, content.length)] forKey:@"talkcontent"];
    if(imgUrl.length!=0){
        [dictionary setObject:imgUrl forKey:@"imageurl"];
    }
    /**
         0 是
         1 否
     */
    
    NSString *synshow = nil;
    
    if (self.isSelect) {
        synshow = @"0";
    } else {
        synshow = @"1";
    }
    
    [dictionary setObject:synshow forKey:@"synshow"];
    
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PUBLISHTALK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        weakSelf.rightButton.userInteractionEnabled = YES;
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {
            [weakSelf.delegate sendSuccess];
            [weakSelf.backTextView resignFirstResponder];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectClick:(UIButton *)sender {
    
    self.isSelect = !self.isSelect;
    
    if (self.isSelect) {
        [self.selectImageView setImage:[UIImage imageNamed:@"xz-34"]];
    } else {
        [self.selectImageView setImage:[UIImage imageNamed:@"wxz-34"]];
    }
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length + textView.text.length - range.length >= 301) {
//        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        textView.text = [newText substringToIndex:300];
//        [self reloadNum];
//        return NO;
//    }
//    return YES;
//}

#pragma mark -  表情键盘 Delegate
//工具栏完成
-(void)cancel{
    [self.view endEditing:YES];
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    self.myToolBar.top = SCREEN_HEIGHT;
    self.facialBtn.selected = NO;
}
-(void)facial:(UIButton*)btn{
    if (self.scrollView.hidden) {
        [self.backTextView endEditing:YES];
        self.scrollView.hidden = NO;
        self.pageControl.hidden = NO;
        btn.selected = YES;
        self.myToolBar.frame = CGRectMake(0, self.scrollView.top-48, SCREEN_WIDTH, 48);
    }else{
        btn.selected = NO;
        [self.backTextView becomeFirstResponder];
    }
}
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    self.facialBtn.selected = NO;
    self.myToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-ty-48-64, SCREEN_WIDTH, 48);
}
- (void)keyBoardWillHide:(NSNotification *)note{
    if (self.scrollView.hidden) {
        self.myToolBar.top = SCREEN_HEIGHT;
        self.facialBtn.selected = NO;
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = _scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    _pageControl.currentPage = page;//pagecontroll响应值的变化
}

//pagecontroll的委托方法
- (void)changePage:(id)sender
{
    NSInteger page = _pageControl.currentPage;//获取当前pagecontroll的值
    [_scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

#pragma mark 点击表情按钮
-(void)sendFace:(UIButton*)button
{
    NSLog(@"点击的表情按钮1==%ld",(long)button.tag);
    
    if (10000 == button.tag) {//如果是删除按钮
        NSString *newStr = nil;
        
        if (self.backTextView.text.length > 0) {
            
            if ([@"]" isEqualToString:[self.backTextView.text substringFromIndex:self.backTextView.text.length-1]]) {
                if ([self.backTextView.text rangeOfString:@"["].location == NSNotFound) {
                    newStr = [self.backTextView.text substringToIndex:self.backTextView.text.length - 1];
                }
                else{
                    newStr = [self.backTextView.text substringToIndex:[self.backTextView.text rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            }
            else{
                newStr = [self.backTextView.text substringToIndex:self.backTextView.text.length - 1];
            }
            self.backTextView.text = newStr;
        }
    }
    
    else{//如果点击表情按钮的时候
        NSString* str;
        if (button.tag > 20) {
            //            str = [SHAREDAPPDELE.faceArray objectAtIndex:button.tag-1];
            //        }else{
            //            str = [SHAREDAPPDELE.faceArray objectAtIndex:button.tag];
        }
        NSLog(@"点击的表情按钮222===%ld====%@",(long)button.tag,str);
        
        NSString *newStr = [NSString stringWithFormat:@"%@%@",self.backTextView.text,str];
        if(newStr.length <= 300) [self.backTextView setText:newStr];
    }
    [self reloadNum];
}
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.backTextView.text.length > 1) {
            if ([[Emoji allEmoji] containsObject:[self.backTextView.text substringFromIndex:self.backTextView.text.length-2]]) {
                //                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr = [self.backTextView.text substringToIndex:self.backTextView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[self.backTextView.text substringFromIndex:self.backTextView.text.length-1]);
                newStr = [self.backTextView.text substringToIndex:self.backTextView.text.length-1];
            }
            self.backTextView.text = newStr;
        }else if(self.backTextView.text.length > 0){
            newStr = [self.backTextView.text substringToIndex:self.backTextView.text.length-1];
            self.backTextView.text = newStr;
        }
    }else{
        NSString *newStr = [NSString stringWithFormat:@"%@%@",self.backTextView.text,str];
        if(newStr.length <= 300) [self.backTextView setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,self.backTextView.text);
    }
    [self reloadNum];
}
@end
