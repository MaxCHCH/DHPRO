//
//  SSLImageTool.m
//  zhidoushi
//
//  Created by licy on 15/6/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "SSLImageTool.h"

@implementation SSLImageTool

+ (UIImage *)scaleToSize:(CGSize)size withImage:(UIImage *)img {
    
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    //返回新的改变大小后的图片
    
    return scaledImage;
    
}   

+ (NSData *)compressImage:(UIImage *)image withMaxKb:(CGFloat)maxKb {
    
    if (!image) {
        return nil;
    }
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    //压缩质量
    while ([imageData length]/1024 > maxKb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    //压缩尺寸
    CGFloat imageScale = 0.8;
    while (imageData.length/1024>maxKb) {
        image = [self scaleToSize:CGSizeMake(image.size.width*imageScale, image.size.height*imageScale) withImage:image];
        imageData = UIImageJPEGRepresentation(image, compression);
    }
//    CGFloat tempReduce = 0.5;
//    NSData *data = UIImageJPEGRepresentation(image,tempReduce);
//    
//    
//    if (data.length/1024>maxKb*2) {
//        data = UIImageJPEGRepresentation(image, 0.3);
//    }
//    //如果大小有限制进行不停压缩
//    if (maxKb > 0) {
//        CGFloat sizeScale = 1;
//        while (data.length/1024 > maxKb) {
//            sizeScale *= 0.8;
//            data = [self scale:sizeScale withImageData:data];
//        }
//    }
    
    return imageData;
}

+ (NSData *)scale:(CGFloat)dou withImageData:(NSData *)imgData {
    
    UIImage *img = [UIImage imageWithData:imgData];
    
    // 创建一个bitmap的context
    
    // 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width*dou, img.size.height*dou));
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0,0, img.size.width*dou, img.size.height*dou)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    //返回新的改变大小后的图片
    return UIImageJPEGRepresentation(scaledImage,1);
    
}

+ (void)clipImage:(UIImage *)image withRect:(CGRect)rect {
    [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], rect)];
}

@end







