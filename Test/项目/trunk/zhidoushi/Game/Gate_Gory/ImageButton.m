//
//  ImageButton.m
//  zhidoushi
//
//  Created by xinglei on 14-11-4.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "ImageButton.h"

#import "JSONKit.h"
#import "WWSaveImages.h"
#import "AFNetworking.h"
#import "UIView+ViewController.h"
#import "WWRequestOperationEngine.h"
#import "NSString+NARSafeString.h"
#import "WWTolls.h"
#import "Define.h"
#import "QiniuSDK.h"
#import "UIViewController+ShowAlert.h"
#import "MBProgressHUD+MJ.h"

@interface ImageButton ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIActionSheet *photoActionSheet;
    MBProgressHUD *HUD;
}

@property(nonatomic,strong)UIImagePickerController *picker;
@property(nonatomic,assign)BOOL isNew;//是否请求生产新凭证
@property(nonatomic,copy)NSString *Photohash;//上传图片hash值
@property(nonatomic,copy)NSString *Photokey;//上传图片key值
@property(nonatomic,assign)CGSize PhotoSize;//尺寸
@property(nonatomic,assign)long long PhotoBig;//大小
@end

@implementation ImageButton

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self addTarget:self action:@selector(photoFileSelector) forControlEvents:UIControlEventTouchUpInside];
        _picker = [[UIImagePickerController alloc] init];
        [_picker setDelegate:self];
    }
    return self;
}

-(void)photoFileSelector{

    photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开相机",@"从手机相册获取", nil];
    [photoActionSheet showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == photoActionSheet.cancelButtonIndex)
    {
        
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            
            [self takePhoto:_allowEditing];
            break;
            
        case 1:  //打开本地相册
            
            [self LocalPhoto:_allowEditing];
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
        
        _picker.allowsEditing = Editing;
        
        _picker.sourceType = sourceType;

        [self.window.rootViewController presentViewController:_picker animated:YES completion:nil];

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

    [self.window.rootViewController presentViewController:_picker animated:YES completion:nil];

}

//获取图片后的行为
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
        
    {
        //先把图片转成NSData
        [self.viewController showWaitView];
        UIImage* editeImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        UIImage* originalImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *image;//原图

        if (editeImage!=nil) {
            image = editeImage;
        }else{
            image = originalImage;
        }

        //*****此处可以更改判断来适应更多尺寸图片*****//
//        if (_picStatus==peoplePicture) {
//            CGFloat width = 320;
//            CGFloat height = width/image.size.width * image.size.height;
//            imageSmall = [WWTolls imageWithImageSimple:image scaledToSize:CGSizeMake(width, height)];//改变图片尺寸
//
//        }
//        else{
//
//            imageSmall = [WWTolls imageWithImageSimple:image scaledToSize:CGSizeMake(180, 180)];//改变图片尺寸
//
//        }

//        if (UIImagePNGRepresentation(imageSmall) == nil)
//        {
//            data = UIImageJPEGRepresentation(imageSmall, 1.0);
//        }
//        else
//        {
//            data = UIImagePNGRepresentation(imageSmall);
//        }
//        float f = 0.5;
//        data = UIImageJPEGRepresentation(image,1);
//        if(data.length>1024*1024*10){
//            [self.viewController removeWaitView];
//            [self.viewController showAlertMsg:@"您选择的图片太大,请重新上传" andFrame:CGRectZero];
//        }else if (data.length>1024*1024*2) {
//            data = UIImageJPEGRepresentation(image,0.3);
//        }else{
//            while (data.length>300*1024) {
//                data=nil;
//                data = UIImageJPEGRepresentation(image,f);
//                f*=0.8;
//            }
//        }
//        //图片保存的路径
//        
//        //这里将图片放在沙盒的documents文件夹中
//        
//        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        NSLog(@"DocumentsPath------->>>>>>>>%@",DocumentsPath);
//        //文件管理器
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
//        
//        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//
//        NSString *imagesName = [NSString stringWithFormat:@"/%@image.png",self.imageTitle];
//        NSLog(@"imagesName-------%@",imagesName);
//
//        //..获取图片路径..//
//        NSString *image_path = [DocumentsPath stringByAppendingString:imagesName];
//
//        [fileManager createFileAtPath:image_path contents:data attributes:nil];

        __weak __typeof(self) weakSelf = self;

        [_picker dismissViewControllerAnimated:YES completion:^{
                //获取七牛上传凭证
                NSDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:self.isNew?@"0":@"1" forKey:@"isnew"];
            [WWRequestOperationEngine operationManagerRequest_Post:[NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLOADTOKEN] parameters:dict requestOperationBlock:^(NSDictionary *dic) {
                
                    if (dic[ERRCODE]) {
                        [self.viewController removeWaitView];
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
                                          [self.viewController removeWaitView];
                                          weakSelf.isNew = NO;
                                          if (info.isOK) {
                                              
                                              [MBProgressHUD showSuccess:@"上传成功"];
                                              if(resp){
                                                  weakSelf.Photohash = resp[@"hash"];
                                                  weakSelf.Photokey = resp[@"key"];
                                                  weakSelf.PhotoBig = data.length;
                                                  weakSelf.PhotoSize = image.size;
                                                  NSString *imgurl = [NSString stringWithFormat:@"%@?%@?%.0f?%.0f?%lld",weakSelf.Photokey,weakSelf.Photohash,weakSelf.PhotoSize.width,weakSelf.PhotoSize.height,weakSelf.PhotoBig];
                                                  if ([weakSelf.typeString isEqualToString:@"1000"]) {
                                                      _imageBlock_1(imgurl);
                                                  }else{
                                                      _imageBlock_2(imgurl);
                                                  }
                                                  //直接把该图片读出来显示在按钮上
                                                  UIImage *img=[UIImage imageWithData:data];
                                                  [weakSelf setBackgroundImage:img forState:UIControlStateNormal];
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
                            [self.viewController removeWaitView];
                            [MBProgressHUD showError:@"上传失败请重试"];
                        }
                    }
                }];
        }];

    }
}


//        //获得系统时间
//        NSDate *  senddate=[NSDate date];
//        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"HHmmss"];
//        NSString *  locationString=[dateformatter stringFromDate:senddate];
//        //[dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
//        //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
//
//        //获得系统日期
//        NSCalendar  * cal=[NSCalendar  currentCalendar];
//        NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
//        NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
//        NSInteger year=[conponent year];
//        NSInteger month=[conponent month];
//        NSInteger day=[conponent day];
//        NSString *nsDateString= [NSString  stringWithFormat:@"%ld%ld%ld",(long)year,(long)month,(long)day];
//此处传入userid来标识图片名称
//        NSString *sum = [NSString stringWithFormat:@"%@%@",nsDateString,locationString];
@end
