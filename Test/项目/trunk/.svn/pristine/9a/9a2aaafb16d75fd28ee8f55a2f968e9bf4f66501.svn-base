//
//  GameDetail_ViewController.m
//  zhidoushi
//
//  Created by xinglei on 14/12/15.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageCropperDelegate;

@interface ImageCropper : BaseViewController <UIScrollViewDelegate> {
	UIScrollView *cropperScrollView;
	UIImageView *imageView;
	__weak id <ImageCropperDelegate> cropperImageDelegate;
}
@property(nonatomic,strong)NSString * imageString;//图片的地址

@property (nonatomic, retain) UIScrollView *cropperScrollView;
@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, weak) id <ImageCropperDelegate> cropperImageDelegate;

- (id)initWithImage:(UIImage *)image imageString:(NSString*)imageString;

@end

@protocol ImageCropperDelegate <NSObject>
//- (void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)image;
- (void)imageCropperDidCancel:(ImageCropper *)cropper;
@end