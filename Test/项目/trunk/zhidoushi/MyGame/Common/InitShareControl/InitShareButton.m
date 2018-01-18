//
//  InitShareButton.m
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "InitShareButton.h"

#import "InitShareView.h"
#import "UIView+ViewController.h"

@interface InitShareButton()

@property(nonatomic,strong)InitShareView * shareView;

@end

@implementation InitShareButton

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

-(void)initShareView{
    _shareView = [[InitShareView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    [_shareView createView:self.viewType];
    [self.viewController.view addSubview:_shareView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
