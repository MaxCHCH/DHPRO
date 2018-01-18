//
//  ArticleCommentViewController.m
//  zhidoushi
//
//  Created by nick on 15/9/16.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ArticleCommentViewController.h"
#import "IQKeyboardManager.h"
#import "QEDTextView.h"
#import "UITextView+LimitLength.h"
#import "MLSelectPhotoAssets.h"
#import "MLSelectPhotoPickerAssetsViewController.h"
#import "MLSelectPhotoBrowserViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "FacialView.h"
#import "IQKeyboardManager.h"

@interface ArticleCommentViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;//内容
@property(nonatomic,strong)UILabel *textPlacehoader;//占位
@property(nonatomic,strong)TPKeyboardAvoidingScrollView *back;//背景
@property(nonatomic,strong)UIView *whiteBack;//白色背景
@property(nonatomic,strong)UIView *photosView;//相册视图
@property(nonatomic,assign)BOOL isNew;//上传凭证
@property(nonatomic,strong) NSMutableArray *assets;//图片集合
@property(nonatomic,copy)NSString *PhotosUrl;
@property(nonatomic,strong)UILabel *contentNumLbl;//字数提示

@property(nonatomic,strong)UIScrollView *scrollView;//表情键盘
@property(nonatomic,strong)UIPageControl *pageControl;//表情
@property(nonatomic,strong)UIView *myToolBar;//键盘工具栏
@property(nonatomic,strong)UIButton *facialBtn;//表情按钮
@property(nonatomic,assign)CGFloat ty;//键盘高度
@end

@implementation ArticleCommentViewController

#define photoWidth (SCREEN_WIDTH - 25)/4
#pragma mark - Life Cycle
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"标题帖评论页面"];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [MobClick beginLogPageView:@"标题贴评论页面"];
    //广场标题
    self.titleLabel.text = @"回复评论";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = TitleColor;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //导航栏返回
//    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
//    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#ff5304"] forState:UIControlStateNormal];
//    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 18;
    labelRect.size.height = 18;
    self.leftButton.frame = labelRect;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [self reloadPhotos];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏发布
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#475564"] forState:UIControlStateNormal];
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
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 340)];
    self.whiteBack = backView;
    backView.backgroundColor = [UIColor whiteColor];
    [self.back addSubview:backView];
//    backView.layer.borderWidth = 0.5;
//    backView.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    
    //分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 15)];
    line.backgroundColor = ZDS_BACK_COLOR;
    [backView addSubview:line];
    //内容
    QEDTextView *text = [[QEDTextView alloc] initWithFrame:CGRectMake(15, line.bottom+15, SCREEN_WIDTH-30, 140)];
    self.textView = text;
    [text setValue:@1000 forKey:@"limit"];
    [text scrollsToTop];
    text.delegate = self;
    text.layoutManager.allowsNonContiguousLayout = NO;
    text.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    text.font = MyFont(17);
    text.contentInset = UIEdgeInsetsMake(-7, -5, 0, 0);
    text.textColor = [WWTolls colorWithHexString:@"#94ADB2"];
    [backView addSubview:text];
    //内容占位文字
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, line.bottom + 15, 300, 18)];
    self.textPlacehoader = lbl;
    lbl.font = MyFont(15);
    lbl.textColor = [WWTolls colorWithHexString:@"#94ADB2" AndAlpha:0.6];
    lbl.text = @"写评论";
    if(![self.talkId isEqualToString:self.byComendId]){
        lbl.text = [NSString stringWithFormat:@"回复%@",self.byComendName];
    }
    [backView addSubview:lbl];
    //字数提示
    UILabel *contentNumLbl = [[UILabel alloc] init];
    self.contentNumLbl = contentNumLbl;
    contentNumLbl.frame = CGRectMake(SCREEN_WIDTH - 88 - 15, text.bottom, 88, 12);
    contentNumLbl.text = @"(0/1000)";
    contentNumLbl.textAlignment = NSTextAlignmentRight;
    contentNumLbl.font = MyFont(11);
    contentNumLbl.textColor = [WWTolls colorWithHexString:@"#94ADB2" AndAlpha:0.6];
    [backView addSubview:contentNumLbl];
    
    //分割线
    line = [[UIView alloc] initWithFrame:CGRectMake(0, text.bottom+15, SCREEN_WIDTH, 15)];
    line.backgroundColor = ZDS_BACK_COLOR;
    [backView addSubview:line];
    
    //相片视图
    UIView *photosView = [[UIView alloc] initWithFrame:CGRectMake(5, line.bottom + 5, SCREEN_WIDTH - 10, 84)];
    [backView addSubview:photosView];
    self.photosView = photosView;
    
    [self reloadPhotos];
    
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
    self.whiteBack.height = (photoWidth + 5) * ((i+3)/4) + 205;
    self.back.contentSize = CGSizeMake(SCREEN_WIDTH, self.whiteBack.bottom + 80);
    self.textView.height = 140;
}

- (void)createArticle{

    if ([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length < 1) {
        [MBProgressHUD showError:@"评论内容不能为空"];
        [self.textView becomeFirstResponder];
        return;
    }
    if (self.textView.text.length > 1000) {
        [MBProgressHUD showError:@"评论内容不能超过1000字"];
        [self.textView becomeFirstResponder];
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
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:6];
    [dictionary setObject:self.talkId forKey:@"talkid"];
    if(self.PhotosUrl.length > 0) [dictionary setValue:self.PhotosUrl forKey:@"imageurl"];
    [dictionary setObject:_textView.text forKey:@"rpycontent"];//回复内容
    [dictionary setObject:[self.talkId isEqualToString:self.byComendId]?@"1":@"2" forKey:@"replylevel"];//回复级别
    [dictionary setObject:self.byComendId forKey:@"byreplyid"];
    
    //发送请求即将开团
    __weak typeof(self)weakSelf = self;
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_PUBLISHRPY parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        [weakSelf removeWaitView];
        if ([dic[@"result"] isEqualToString:@"0"]) {//成功
            
            [weakSelf.view endEditing:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"grouptitletoggle" object:@{@"talkid":weakSelf.talkId}];
            // 2、刷新表格
            [weakSelf showAlertMsg:@"评论成功" andFrame:CGRectZero];
            [weakSelf popButton];
        }else self.rightButton.userInteractionEnabled = YES;
    }];
}
/***
 - (void)putImage:(NSString*)token andIndex:(int)index{
 if (index>=self.assets.count) {
 [self createDone];
 return;
 }else{
 
 UIImage *image;
 if ([self.assets[index] isKindOfClass:[MLSelectPhotoAssets class]]) {
 image = ((MLSelectPhotoAssets*)self.assets[index]).originImage;
 }else image = self.assets[index];
 
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
 __block int i = index+1;
 [upManager putData:data key:QNkey token:token
 complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {//resp hash key
 weakSelf.isNew = NO;
 if (info.isOK) {
 
 if(resp){
 NSString *Photohash = resp[@"hash"];
 NSString *Photokey = resp[@"key"];
 NSString *url = [NSString stringWithFormat:@"%@?%@|",Photokey,Photohash];
 weakSelf.PhotosUrl = [weakSelf.PhotosUrl stringByAppendingString:url];
 [weakSelf putImage:token andIndex:i];
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
 
 }
 **/
- (void)selectPhotos{
    if (!self.rightButton.userInteractionEnabled) {
        return;
    }
    // 创建控制器
    MLSelectPhotoPickerViewController *pickerVc = [[MLSelectPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    pickerVc.topShowPhotoPicker = YES;
    [NSUSER_Defaults setObject:@"精华帖的评论最多只能添加9张图片" forKey:@"zdsselectphotoTip"];
    //    pickerVc.selectPickers = self.assets;
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
    self.textPlacehoader.hidden = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0;
    self.contentNumLbl.text = [NSString stringWithFormat:@"(%ld/1000)",_textView.text.length>1000?1000:_textView.text.length];
    if ([WWTolls getCharLength:_textView.text ] >= 1) {
        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"FF723E"] forState:UIControlStateNormal];
    } else {
        [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#475564"] forState:UIControlStateNormal];
    }
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (text.length + textView.text.length - range.length >= 1001) {
//        NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
//        textView.text = [newText substringToIndex:1000];
//        [self reloadNum];
//        return NO;
//    }
//    return YES;
//}

- (void)popButton{
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
        if(newStr.length <= 1000)
            [self.textView setText:newStr];
    }

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
        if(newStr.length <= 1000)
            [self.textView setText:newStr];
        NSLog(@"点击其他后更新%lu,%@",(unsigned long)str.length,self.textView.text);
    }
    [self reloadNum];
}

@end
