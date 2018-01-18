//
//  customMyImageButton.h
//  zhidoushi
//
//  Created by xinglei on 14/12/2.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customMyImageButton : UIButton

@property(nonatomic,strong)UIImageView *imageView_1;

-(void)configureButton:(NSString*)tittle image1:(UIImage*)image_1 image2:(UIImage*)image_2;

@end
