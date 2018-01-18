//
//  UIViewController+Photo.m
//  zhidoushi
//
//  Created by xinglei on 14-9-16.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "UIViewController+Photo.h"

@implementation UIViewController (Photo)

//调用相机
-(void)takePhoto

{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        
        //设置拍照后的图片可被编辑
        
        picker.allowsEditing = YES;
        
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
    }else
        
    {
        
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        
    }
    
}
//调用相册
-(void)LocalPhoto

{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    //设置选择后的图片可被编辑

    picker.allowsEditing = YES;
    
    //    [self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:^{
        
         NSLog(@"------------->>>%@",picker);
    }];
    
}
//编辑图片
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
        
    {
        //先把图片转成NSData
        
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        NSData *data;
        
        if (UIImagePNGRepresentation(image) == nil)
            
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        
        //这里将图片放在沙盒的documents文件夹中
        
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
         NSLog(@"DocumentsPath------->>>>>>>>%@",DocumentsPath);
        //文件管理器
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        
        //获得系统时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"HHmmss"];
        NSString *  locationString=[dateformatter stringFromDate:senddate];
        //[dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
        //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
        
        //获得系统日期
        NSCalendar  * cal=[NSCalendar  currentCalendar];
        NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
        NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
        NSInteger year=[conponent year];
        NSInteger month=[conponent month];
        NSInteger day=[conponent day];
        NSString *nsDateString= [NSString  stringWithFormat:@"%ld%ld%ld",(long)year,(long)month,(long)day];
        
        NSString *sum = [NSString stringWithFormat:@"%@%@",nsDateString,locationString];
        
        NSString *str = [NSString stringWithFormat:@"%@image.png",sum];
         NSLog(@"%@",str);
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:str] contents:data attributes:nil];
        
        [picker dismissViewControllerAnimated:YES completion:^{
//            NSData *data=[NSData dataWithContentsOfFile:str];
//            //直接把该 图片读出来
//            UIImage *img=[UIImage imageWithData:data];
        }];
        
        //        [_headImageButton setImage:image forState:UIControlStateNormal];
        //        NSDictionary *parmaters = @{};
        //        [Request RequestWithPOST:[Api uploadImageUrl] parameters:parmaters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //            NSData * data = UIImagePNGRepresentation(image);
        //            [formData appendPartWithFileData:data name:@"file" fileName:@"111.png" mimeType:@"image/png"];
        //        } success:^(id responseObject) {
        //            NSLog(@"%@",responseObject);
        //        } failure:^(NSError *error) {
        //            NSLog(@"%@",error);
        //        }];
        
    }
}

@end
