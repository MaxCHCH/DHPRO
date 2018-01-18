//
//  NARScrollView.m
//  zhidoushi
//
//  Created by xinglei on 14/11/24.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "NARScrollView.h"

@implementation NARScrollView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        [self configureView];
    }
    return self;
}

-(void)configureView{

    UIImageView *imageViewOne = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imageViewOne.image = [UIImage imageNamed:@""];
    
    UIImageView *imageViewTwo = [[UIImageView alloc]initWithFrame:CGRectMake(self.width, 0, self.width, self.height)];
    imageViewTwo.image = [UIImage imageNamed:@""];
    
    UIImageView *imageViewThree = [[UIImageView alloc]initWithFrame:CGRectMake(self.width*2, 0, self.width, self.height)];
    imageViewThree.image = [UIImage imageNamed:@""];
    
    UIImageView *imageViewFour = [[UIImageView alloc]initWithFrame:CGRectMake(self.width*3, 0, self.width, self.height)];
    imageViewFour.image = [UIImage imageNamed:@""];
    
    [self addSubview:imageViewOne];
    [self addSubview:imageViewTwo];
    [self addSubview:imageViewThree];
    [self addSubview:imageViewFour];
    
}


@end
