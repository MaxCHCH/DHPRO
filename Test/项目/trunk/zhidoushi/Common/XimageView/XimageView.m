//
//  XimageView.m
//
//  Created by xiang on 15-1-30.
//  Copyright (c) 2015年 任云翔, LLC. All rights reserved.
//

#import "XimageView.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "UIImageView+WebCache.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "WWRequestOperationEngine.h"
#import "NSString+NARSafeString.h"
#import "JSONKit.h"
@interface XimageView()
@end
@implementation XimageView
-(instancetype)init{
    if(self = [super init]){
        [self setUp];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - 初始化
- (void)setUp{
    //添加点击事件
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] init];
    [tapRecognizer addTarget:self action:@selector(big)];
    [self addGestureRecognizer:tapRecognizer];
    //高亮蒙层
    UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0.25;
    bg.hidden = YES;
    self.highliView = bg;
    [self addSubview:bg];
}

-(void)setImage:(UIImage *)image{
    [super setImage:image];
    self.highliView.hidden = YES;
}

- (void)big{
#pragma mark - 点击大图
    self.highliView.hidden = YES;
    for (UIView *view = self; view != nil ; view = view.superview) {
        [view endEditing:YES];
    }
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url =self.sd_imageURL; // 图片路径
    photo.srcImageView = self; // 来源于哪个UIImageView
    NSArray *photos = [NSArray arrayWithObject:photo];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
    
    
}

- (void)bigButtonTapped {
    
    // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.image = self.image;
    NSString *str = [NSString stringWithFormat:@"%@",self.bigImageURL];
    if (self.bigImageURL!=nil&&str.length!=0) {
        UIImageView *temp = [[UIImageView alloc] init];
        [temp sd_setImageWithURL:self.bigImageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            imageInfo.image = image;
        }];
    }
    imageInfo.referenceRect = self.frame;
    imageInfo.referenceView = self.superview;
    imageInfo.referenceContentMode = self.contentMode;
    imageInfo.referenceCornerRadius = self.layer.cornerRadius;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    // Present the view controller.
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [imageViewer showFromViewController:(UIViewController*)nextResponder transition:JTSImageViewControllerTransition_FromOriginalPosition];
            return;
        }
    }
    
}

#pragma mark - 点击高亮
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highliView.hidden = NO;
    self.highliView.frame = self.bounds;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highliView.hidden = YES;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highliView.hidden = YES;
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    self.highliView.hidden = YES;
}

@end
