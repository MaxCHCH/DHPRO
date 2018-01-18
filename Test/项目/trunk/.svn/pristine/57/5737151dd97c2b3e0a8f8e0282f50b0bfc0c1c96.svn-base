//
//  PublicTaskViewController.m
//  zhidoushi
//
//  Created by licy on 15/6/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "PublicTaskViewController.h"
#import "PublishTaskModel.h"
#import "IQKeyboardManager.h"
#import "QEDTextView.h"
#import "UITextView+LimitLength.h"
#import "UITextField+LimitLength.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FacialView.h"
#import "MJExtension.h"
#import "IQKeyboardManager.h"
#import "taskDetailViewController.h"
#import "MJPhotoBrowser.h"

@interface PublicTaskViewController () <UITextViewDelegate>
@property(nonatomic,strong)UITextField *titleText;//标题
@property(nonatomic,strong)UITextView *textView;//内容
@property(nonatomic,strong)UILabel *textPlacehoader;//占位
@property(nonatomic,strong)TPKeyboardAvoidingScrollView *back;//背景
@property(nonatomic,strong)UIView *whiteBack;//白色背景
@property(nonatomic,strong)UIView *photosView;//相册视图
@property(nonatomic,strong)UIButton *tongbuBtn;//同步按钮
@property(nonatomic,strong)UILabel *tongbuLbl;//同步话术
@property(nonatomic,assign)BOOL isNew;//上传凭证
@property (nonatomic , strong) NSMutableArray *assets;//图片集合
@property(nonatomic,copy)NSString *PhotosUrl;
@property(nonatomic,strong)UILabel *contentNumLbl;//<#强引用#>

@property(nonatomic,strong)UIScrollView *scrollView;//表情键盘
@property(nonatomic,strong)UIPageControl *pageControl;//表情
@property(nonatomic,strong)UIView *myToolBar;//键盘工具栏
@property(nonatomic,strong)UIButton *facialBtn;//表情按钮
@property(nonatomic,assign)CGFloat ty;//键盘高度

@end

@implementation PublicTaskViewController

#pragma mark - Life Cycle
#define photoWidth (SCREEN_WIDTH - 25)/4
#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发布任务页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"发布任务页面"];
    //广场标题
    self.titleLabel.text = @"发布任务";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = [WWTolls colorWithHexString:@"#475564"];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

    //导航栏返回
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#ff5304"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(17);
    [self.leftButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 40;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [self reloadPhotos];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //导航栏返回
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#ff5304"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(17);
    [self.leftButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 40;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
//    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
//    self.rightButton.titleLabel.font = MyFont(16);
//    [self.rightButton addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
//    self.rightButton.width = 40;
//    self.rightButton.height = 16;
//    [self reloadNum];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(17);
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#ff5304"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(createArticle) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
    
    
    self.assets = [NSMutableArray array];
    self.PhotosUrl = @"";
    [self setUpGUI];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpGUI{
    self.view.backgroundColor = ZDS_BACK_COLOR;
    TPKeyboardAvoidingScrollView *back = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:back];
    self.back = back;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 320)];
    self.whiteBack = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:backView];
//    backView.layer.borderWidth = 0.5;
//    backView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    
    //标题
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 50)];
    title.textAlignment = NSTextAlignmentLeft;
    title.text = [NSString stringWithFormat:@"%@月 任务%@",self.taskMonth,self.taskNum];
    title.font = MyFont(17);
    title.textColor = [WWTolls colorWithHexString:@"#4E777F"];
    [backView addSubview:title];
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, title.maxY, SCREEN_WIDTH, 15)];
    line.backgroundColor = ZDS_BACK_COLOR;
    [backView addSubview:line];
    //内容
    UITextView *text = [[UITextView alloc] initWithFrame:CGRectMake(15, line.bottom+15, SCREEN_WIDTH-30, 140)];
    [text setValue:@200 forKey:@"limit"];
//    [text limitTextLength:2001];
    self.textView = text;
    [text scrollsToTop];
    text.delegate = self;
    text.layoutManager.allowsNonContiguousLayout = NO;
    text.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    text.font = MyFont(17);
    text.contentInset = UIEdgeInsetsMake(-7, -5, 0, 0);
    text.textColor = [WWTolls colorWithHexString:@"#94ADB2"];
    [backView addSubview:text];
    //内容占位文字
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom + 15, 200, 18)];
    self.textPlacehoader = lbl;
    lbl.font = MyFont(15);
    lbl.textColor = [WWTolls colorWithHexString:@"#94ADB2" AndAlpha:0.6];
    lbl.text = @"请填写任务内容";
    [backView addSubview:lbl];
    
    //分割线
    line = [[UIView alloc] initWithFrame:CGRectMake(0, text.bottom+13, SCREEN_WIDTH, 15)];
    line.backgroundColor = ZDS_BACK_COLOR;
    [backView addSubview:line];
    
    //相片视图
    UIView *photosView = [[UIView alloc] initWithFrame:CGRectMake(5, line.bottom + 10, SCREEN_WIDTH, 60)];
    [backView addSubview:photosView];
    self.photosView = photosView;
    //同步分享到广场
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(12, 12, 16, 16)];
    [btn setBackgroundImage:[UIImage imageNamed:@"xz-34"] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:@"wxz-34"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(tongbu:) forControlEvents:UIControlEventTouchUpInside];
    btn.selected = YES;
    if(self.password && self.password.length>0) [self.back addSubview:btn];
    self.tongbuBtn = btn;
    
    UILabel *tongbuLbl = [[UILabel alloc] initWithFrame:CGRectMake(32, 12, 200, 14)];
    tongbuLbl.font = MyFont(13);
    tongbuLbl.textColor = [WWTolls colorWithHexString:@"#535353"];
    tongbuLbl.text = @"任务结束后是否将结果同步到撒欢";
    self.tongbuLbl = tongbuLbl;
    if(self.password && self.password.length>0) [self.back addSubview:tongbuLbl];
    [self reloadPhotos];
    
    //字数提示
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 100, text.bottom - 2, 88, 12);
    contentNumLbl.text = @"(0/300)";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = [WWTolls colorWithHexString:@"#94ADB2" AndAlpha:0.6];
    [backView addSubview:contentNumLbl];
    
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

- (void)reloadPhotos{
    for (UIView *subView in self.photosView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i = 0;i < self.assets.count;i++) {
        MLSelectPhotoAssets *asset = self.assets[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i%4*(photoWidth+5), i/4*(photoWidth+5), photoWidth, photoWidth)];
        [self.photosView addSubview:btn];
        btn.tag = i;
        btn.titleLabel.textColor = [UIColor clearColor];
        btn.titleLabel.text = @"";
        [btn addTarget:self action:@selector(lookPhotos:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[MLSelectPhotoPickerViewController getImageWithImageObj:asset] forState:UIControlStateNormal];
    }
    long i = self.assets.count;
    if (self.assets.count < 9) {
        UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(i%4*(photoWidth+5), i/4*(photoWidth+5), photoWidth, photoWidth)];
        [addBtn setBackgroundImage:[UIImage imageNamed:@"tjtp-174"] forState:UIControlStateNormal];
        addBtn.tag = 999;
        [addBtn addTarget:self action:@selector(selectPhotos) forControlEvents:UIControlEventTouchUpInside];
        [self.photosView addSubview:addBtn];
        i++;
    }
    self.photosView.height = (photoWidth + 5) * ((i+3)/4);
    self.whiteBack.height = (photoWidth + 5) * ((i+3)/4) + 263;
    self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.whiteBack.bottom + 80);
    self.textView.height = 140;
    self.tongbuBtn.top = self.whiteBack.bottom + 12;
    self.tongbuLbl.top = self.whiteBack.bottom + 13;
}

- (void)createArticle{
    if ([WWTolls getCharLength:self.textView.text ] < 60) {
        [MBProgressHUD showError:@"任务内容不能少于20个汉字"];
        return;
    }
    if([WWTolls isHasSensitiveWord:self.textView.text]){
        [self showAlertMsg:ZDS_HASSENSITIVE yOffset:0];
        return;
    }
    [self showWaitView];
    self.rightButton.userInteractionEnabled = NO;
    self.PhotosUrl = @"";
    if (self.assets.count == 0) {
        [self createDone];
    }else{
        //上传图片
        NSDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
        WEAKSELF_SS
        [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
            
            if (dic[ERRCODE]) {
                [weakSelf removeWaitView];
                weakSelf.rightButton.userInteractionEnabled = YES;
            }else{
#pragma mark - 七牛上传图片
                NSString *token = dic[@"uptoken"];
                if(token.length>0){
                    //                    [weakSelf putImage:token andIndex:0];
                    UIImage *image;
                    for (int i = 0; i<self.assets.count; i++) {
                        if ([self.assets[i] isKindOfClass:[MLSelectPhotoAssets class]]) {
                            image = ((MLSelectPhotoAssets*)self.assets[i]).originImage;
                        }else image = self.assets[i];
                        
                        NSData *data = [SSLImageTool compressImage:image withMaxKb:300];
                        //七牛上传管理器
                        QNUploadManager *upManager = [[QNUploadManager alloc] init];
                        //开始上传
                        CFUUIDRef uuidRef =CFUUIDCreate(NULL);
                        
                        CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
                        
                        CFRelease(uuidRef);
                        
                        NSString *UUIDStr = (__bridge NSString *)uuidStringRef;
                        NSString *QNkey = [NSString stringWithFormat:@"images/0/%@.jpg",UUIDStr];
                        WEAKSELF_SS
                        [upManager putData:data key:QNkey token:token
                                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {//resp hash key
                                      weakSelf.isNew = NO;
                                      if (info.isOK) {
                                          
                                          if(resp){
                                              NSString *Photohash = resp[@"hash"];
                                              NSString *Photokey = resp[@"key"];
                                              NSString *url = [NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lu",Photokey,Photohash,image.size.width,image.size.height,(unsigned long)data.length];
                                              BOOL uploadPhotosDone = YES;
                                              for (UIButton *btn in self.photosView.subviews) {
                                                  if (btn.tag == i) {
                                                      btn.titleLabel.text = url;
                                                  }
                                                  if ((!btn.titleLabel.text || btn.titleLabel.text.length < 1) && btn.tag != 999) {
                                                      uploadPhotosDone = NO;
                                                  }
                                              }
                                              if (uploadPhotosDone) {
                                                  [weakSelf createDone];
                                              }
                                          }
                                      }else{
                                          weakSelf.rightButton.userInteractionEnabled = YES;
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
                    }
                    
                }else{
                    [weakSelf removeWaitView];
                    weakSelf.rightButton.userInteractionEnabled = YES;
                    [MBProgressHUD showError:@"上传失败请重试"];
                }
            }
        }];
    }
}

- (void)createDone{
    //创建
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:self.tongbuBtn.selected?@"0":@"1" forKey:@"synshow"];
    BOOL uploadPhotosDone = YES;
    self.PhotosUrl = @"";
    for (UIButton *btn in self.photosView.subviews) {
        if (!btn.titleLabel.text || btn.titleLabel.text.length < 1) {
            uploadPhotosDone = NO;
            if (btn.tag == 999) {
                uploadPhotosDone = YES;
            }
        }else{
            self.PhotosUrl = [self.PhotosUrl stringByAppendingString:btn.titleLabel.text];
            self.PhotosUrl = [self.PhotosUrl stringByAppendingString:@"|"];
        }
    }
    if (self.PhotosUrl.length > 0) {
        self.PhotosUrl = [self.PhotosUrl substringToIndex:self.PhotosUrl.length - 2];
    }
    if (!uploadPhotosDone) {
        [self removeWaitView];
        [self showAlertMsg:@"上传失败，请重试" yOffset:0];
        return;
    }
    if(self.PhotosUrl.length > 0) [dict setValue:self.PhotosUrl forKey:@"imageurl"];
    [dict setObject:[NSString stringWithFormat:@"%@",self.gameId] forKey:@"gameid"];
    [dict setObject:[NSString stringWithFormat:@"%@",self.textView.text] forKey:@"content"];
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PUBLISHTASK parameters:dict requestOperationBlock:^(NSDictionary *dic) {
        weakSelf.rightButton.userInteractionEnabled = YES;
        PublishTaskModel *model = [PublishTaskModel objectWithKeyValues:dic];
        //成功
        if ([model.result isEqualToString:@"0"]) {
            if ([weakSelf.delegate respondsToSelector:@selector(pubTaskSuccess:)]) {
                [weakSelf.delegate pubTaskSuccess:model.taskid];
            }
            [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"发布成功！" andFrame:CGRectZero];
            if(self.isFromGroup){
                taskDetailViewController *task = [[taskDetailViewController alloc] init];
                task.gameAngle = @"1";
                task.taskId = model.taskid;
                task.hidesBottomBarWhenPushed = YES;
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
                [temp removeLastObject];
                [temp addObject:task];
                weakSelf.navigationController.viewControllers = temp;
            }else{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }

        }
    }];
//    WEAKSELF_SS
//    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEARTICLE parameters:dict requestOperationBlock:^(NSDictionary *dic) {
//        
//        if (dic[ERRCODE]) {
//            [weakSelf removeWaitView];
//            weakSelf.rightButton.userInteractionEnabled = YES;
//            if([dic[ERRCODE] isEqualToString:@"IEA088"]){
//                [weakSelf popButton];
//            }
//        }else{
//            if ([dic[@"result"] isEqualToString:@"0"]) {
//                [MBProgressHUD showError:@"发布成功"];
//            }else{
//                weakSelf.rightButton.userInteractionEnabled = YES;
//            }
//        }
//    }];
}

- (void)selectPhotos{
    if (!self.rightButton.userInteractionEnabled) {
        return;
    }
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    //    pickerVc.selectPickers = self.assets;
    [NSUSER_Defaults setObject:@"任务中最多只能添加9张图片" forKey:@"zdsselectphotoTip"];

    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.minCount = 9 - self.assets.count;
    [pickerVc showPickerVc:self];
    __weak typeof(self) weakSelf = self;
    pickerVc.callBack = ^(NSArray *assets){
        [weakSelf.assets addObjectsFromArray:assets];
        [weakSelf reloadPhotos];
    };
}

- (void)lookPhotos:(UIButton*)btn{
    if (!self.rightButton.userInteractionEnabled) {
        return;
    }
    MLSelectPhotoBrowserViewController *browserVc = [[MLSelectPhotoBrowserViewController alloc] init];
    browserVc.currentPage = btn.tag;
    browserVc.photos = self.assets;
    [self.navigationController pushViewController:browserVc animated:YES];
//
//    
//    // 2.显示相册
//    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//    browser.currentPhotoIndex = btn.tag; // 弹出相册时显示的第一张图片是？
//    browser.photos = self.assets; // 设置所有的图片
//    [browser show];
    
    
}

- (void)tongbu:(UIButton*)btn{
    btn.selected = !btn.selected;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
//    [textView textFieldTextLengthLimit:nil];
    [self reloadNum];
}
- (void)reloadNum{
    self.textPlacehoader.hidden = self.textView.text.length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"(%ld/300)",_textView.text.length > 300 ? 300 :_textView.text.length];
    if ([WWTolls getCharLength:_textView.text] >= 60) {
        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#FF723E"] forState:UIControlStateNormal];
    } else {
        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#FF723E"] forState:UIControlStateNormal];
    }
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length + textView.text.length - range.length >= 2001) {
//        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        textView.text = [newText substringToIndex:2000];
//        [self reloadNum];
//        return NO;
//    }
//    return YES;
//}

- (void)pop{
    if (self.textView.text.length > 0 || self.assets.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否放弃当前编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
    }else [self popButton];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self popButton];
    }
}


- (void)popButton{
    [WWTolls zdsClick:TJ_PUSHTASK_QX];
    [self.navigationController popViewControllerAnimated:YES];
}

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
        [self.textView endEditing:YES];
        self.scrollView.hidden = NO;
        self.pageControl.hidden = NO;
        btn.selected = YES;
        self.myToolBar.frame = CGRectMake(0, self.scrollView.top-48, SCREEN_WIDTH, 48);
    }else{
        btn.selected = NO;
        [self.textView becomeFirstResponder];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    self.facialBtn.selected = NO;
    self.myToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-self.ty-48-64, SCREEN_WIDTH, 48);
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.myToolBar.top = SCREEN_HEIGHT;
    self.facialBtn.selected = NO;
}
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = rect.size.height;
    self.ty = ty;
    if ([self.textView isFirstResponder]) {
        
        self.scrollView.hidden = YES;
        self.pageControl.hidden = YES;
        self.facialBtn.selected = NO;
        self.myToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-ty-48-64, SCREEN_WIDTH, 48);
    }else{
        self.scrollView.hidden = YES;
        self.pageControl.hidden = YES;
        self.myToolBar.top = SCREEN_HEIGHT;
        self.facialBtn.selected = NO;
    }
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
        
        if (self.textView.text.length > 0) {
            
            if ([@"]" isEqualToString:[self.textView.text substringFromIndex:self.textView.text.length-1]]) {
                if ([self.textView.text rangeOfString:@"["].location == NSNotFound) {
                    newStr = [self.textView.text substringToIndex:self.textView.text.length - 1];
                }
                else{
                    newStr = [self.textView.text substringToIndex:[self.textView.text rangeOfString:@"[" options:NSBackwardsSearch].location];
                }
            }
            else{
                newStr = [self.textView.text substringToIndex:self.textView.text.length - 1];
            }
            self.textView.text = newStr;
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
        
        NSString *newStr = [NSString stringWithFormat:@"%@%@",self.textView.text,str];
        if(newStr.length <= 300) [self.textView setText:newStr];
    }
    [self reloadNum];
}
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.textView.text.length > 1) {
            if ([[Emoji allEmoji] containsObject:[self.textView.text substringFromIndex:self.textView.text.length-2]]) {
                //                NSLog(@"删除emoji %@",[textView.text substringFromIndex:textView.text.length-2]);
                newStr = [self.textView.text substringToIndex:self.textView.text.length-2];
            }else{
                NSLog(@"删除文字%@",[self.textView.text substringFromIndex:self.textView.text.length-1]);
                newStr = [self.textView.text substringToIndex:self.textView.text.length-1];
            }
            self.textView.text = newStr;
        }else if(self.textView.text.length > 0){
            newStr = [self.textView.text substringToIndex:self.textView.text.length-1];
            self.textView.text = newStr;
        }
    }else{
        NSString *newStr = [NSString stringWithFormat:@"%@%@",self.textView.text,str];
        if(newStr.length <= 300) [self.textView setText:newStr];
    }
    [self reloadNum];
}


#pragma mark 发布任务
//- (void)menu {
//    
//    NSString *content = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    if ([WWTolls getCharLength:content] < 60 ) {
//        [self showAlertMsg:@"任务内容不能少于60字节" yOffset:-100];
//        return;
//    }else if([WWTolls isHasSensitiveWord:content]){
//        [self.view endEditing:YES];
//        [self showAlertMsg:@"注意哦！任务中含有敏感词！" yOffset:-100];
//        return;
//    }
//
//    
//    self.rightButton.userInteractionEnabled = NO;
//    
//    [self requestWithUrgetask];
//}

#pragma mark - Private Methods

//#pragma mark - Request
//#pragma mark 团长发任务请求
//- (void)requestWithUrgetask {
//    //构造请求参数
//    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
//    [dictionary setObject:[NSString stringWithFormat:@"%@",self.gameId] forKey:@"gameid"];
//    [dictionary setObject:[NSString stringWithFormat:@"%@",self.textView.text] forKey:@"content"];
//    __weak typeof(self)weakSelf = self;
//    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PUBLISHTASK parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
//        weakSelf.rightButton.userInteractionEnabled = YES;
//        PublishTaskModel *model = [PublishTaskModel objectWithKeyValues:dic];
//            //成功
//            if ([model.result isEqualToString:@"0"]) {
//                if ([weakSelf.delegate respondsToSelector:@selector(pubTaskSuccess:)]) {
//                    [weakSelf.delegate pubTaskSuccess:model.msgid];
//                }
//                [[UIApplication sharedApplication].keyWindow.rootViewController showAlertMsg:@"发布成功！" andFrame:CGRectZero];
//                            }
//    }];
//}

#pragma mark - Public Methods
#pragma mark - UIResponder
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - Public Methods

@end









