//
//  customMyImageButton.m
//  zhidoushi
//
//  Created by xinglei on 14/12/2.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "customMyImageButton.h"
#import "UIViewExt.h"
#import "WWTolls.h"

@implementation customMyImageButton

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void)configureButton:(NSString*)tittle image1:(UIImage*)image_1 image2:(UIImage*)image_2{
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    
    _imageView_1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
    _imageView_1.image = image_1;
    [self addSubview:_imageView_1];
    
    UILabel *coachLabel = [[UILabel alloc]initWithFrame:CGRectMake(_imageView_1.right, 9, 70, 20)];
    coachLabel.text = tittle;
    coachLabel.font = MyFont(14);
    coachLabel.textColor = [WWTolls colorWithHexString:@"#535353"];
    [self addSubview:coachLabel];
    
    UIImageView *imageView_2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width-30, 10, 15, 15)];
    imageView_2.image = image_2;
    [self addSubview:imageView_2];
    
}

@end
