//
//  ImageExtensionMethod.h
//  zhidoushi
//
//  Created by xinglei on 14/11/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageExtensionMethod : NSObject

+ (UIImage *)imageAtRect:(CGRect)rect image:(UIImage*)image;
+ (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize image:(UIImage*)image;
+ (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize image:(UIImage*)image;
+ (UIImage *)imageByScalingToSize:(CGSize)targetSize image:(UIImage*)image;
+ (UIImage *)imageRotatedByRadians:(CGFloat)radians image:(UIImage*)image;
+ (UIImage *)imageRotatedByDegrees:(CGFloat)degrees image:(UIImage*)image;

@end
