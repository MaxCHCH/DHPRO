//
//  InitShareGameView.m
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "InitShareGameView.h"

#import "WWTolls.h"

@implementation InitShareGameView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)createView{

    //    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self addGestureRecognizer:singleTap];
    
    _shareView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-200)];
    _shareView.backgroundColor = [WWTolls colorWithHexString:@"eeeeee"];
    GameShareView *weightView = [GameShareView initView];
    weightView.gameShareDelegate = self;
    weightView.parterid_1 = self.parterid_1;
    weightView.parterid_2 = self.parterid_2;
    weightView.gameName_1 = self.gameName_1;
    weightView.gameName_2 = self.gameName_2;
    [weightView configureView];
     NSLog(@"self.parterid_1__%@,%@",self.parterid_1,self.parterid_2);
    [_shareView addSubview:weightView];
    [self addSubview:_shareView];

    if ([self.parterid_1 isEqualToString:self.parterid_2]) {
        _shareView.top =SCREEN_HEIGHT-117;
    }else{
        [UIView animateWithDuration:0.33 animations:^{
        _shareView.top =SCREEN_HEIGHT-200;
    }];
    }

}

-(void)cancelButtonSender{
    [self cancelAction];
}

-(void)cancelAction{
    [UIView animateWithDuration:0.33 animations:^{
        _shareView.top = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        for (UIView *view in _shareView.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}

@end
