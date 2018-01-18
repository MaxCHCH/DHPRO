//
//  WWSaveImages.m
//  zhidoushi
//
//  Created by xinglei on 14/11/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWSaveImages.h"

#import "ImageExtensionMethod.h"

@interface WWSaveImages ()

//@property (copy, nonatomic) NSString *cacheImageFolder; // 缓存图片目录
//@property (unsafe_unretained, nonatomic) int cacheImageIndex; // 缓存图片的索引
//@property (strong, nonatomic) NSMutableArray *cacheImagePaths; // 保存缓存图片路径

@end

static NSMutableArray *cacheImagePaths;

@implementation WWSaveImages

+(BOOL)writeImageToFile:(UIImage *)image
{
    BOOL ret = NO;
    // 创建缓存目录
    NSArray *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cache objectAtIndex:0];
    NSFileManager *defualtManager = [NSFileManager defaultManager];
    NSString *cacheImageFolder = [cachePath stringByAppendingPathComponent:@"pictureCache"];
    if (![defualtManager fileExistsAtPath:cacheImageFolder]) {
        NSLog(@"缓存目录不存在");
        if (![defualtManager createDirectoryAtPath:cacheImageFolder withIntermediateDirectories:YES attributes:nil error:nil]) {
            return ret;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(180, 180));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,180,180)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);

    int cacheImageIndex = 0;
    
    NSString *cacheCompletePath = [cacheImageFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"PublishDynammicImage%d.png", cacheImageIndex]];
    
    NSLog(@"cacheCompletePath: %@", cacheCompletePath);
    
    ret = [imageData writeToFile:cacheCompletePath atomically:NO];
    if (ret) {
        cacheImageIndex++;
        if (cacheImagePaths==nil && ![cacheImagePaths isKindOfClass:[NSMutableArray class]]) {
            cacheImagePaths = [[NSMutableArray alloc]initWithCapacity:1];
        }
        [cacheImagePaths addObject:cacheCompletePath];
        NSLog(@"%@8490238409238403284302948920348320948204",cacheImagePaths);
    }
    return ret;
    
}

@end
