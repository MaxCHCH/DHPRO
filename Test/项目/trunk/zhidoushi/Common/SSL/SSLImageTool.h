//
//  SSLImageTool.h
//  zhidoushi
//
//  Created by licy on 15/6/11.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSLImageTool : NSObject

/**
 *  压缩图片尺寸
 *
 *  @param size 要压缩到的尺寸
 *  @param img  原图片
 *
 *  @return UIImage 压缩后的图片
 */
+ (UIImage *)scaleToSize:(CGSize)size withImage:(UIImage *)img;

//压缩图片质量
+ (NSData *)compressImage:(UIImage *)image withMaxKb:(CGFloat)maxKb;

//剪裁图片
+ (void)clipImage:(UIImage *)image withRect:(CGRect)rect;

@end
