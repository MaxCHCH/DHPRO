//
//  InitShareWeightView.m
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "InitShareWeightView.h"

#import "WWTolls.h"
#import "postWeightView.h"
#import "WWRequestOperationEngine.h"
#import "JSONKit.h"

@interface InitShareWeightView ()
{
    NSString *weightString;
//    int weightHeight;
}



@end
@implementation InitShareWeightView

-(void)createView{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
//    [[UIApplication sharedApplication].keyWindow addSubview:self];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self addGestureRecognizer:singleTap];

    postWeightView *weightView = [postWeightView initView];
    self.weightView = weightView;
    
    if (self.initShareType==myWeightType) {
        
        self.weightHeight = 350 - self.scroY;
        weightView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.weightHeight);
        
    }else{
        
        self.weightHeight = 280 - self.scroY;
        weightView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.weightHeight);
    }
    weightView.parterid = self.parterid;
    weightView.gameModel = self.gameModel;
    weightView.postWeightDelegate = self;
    [weightView configureView];
    
    [self addSubview:weightView];
    
    [UIView animateWithDuration:0.4 animations:^{
        weightView.top =SCREEN_HEIGHT-self.weightHeight;
    }];
}

#pragma mark - Delegate
#pragma mark postWeightViewDelegate
-(void)cancelButtonSender{
    [self cancelAction];
}

-(void)weightTextFieldValue:(NSString *)value{
    weightString = value;
}

-(void)confirmButtonSender{

    if ([self.initShareDelegate respondsToSelector:@selector(confirmShare)]) {
        [self.initShareDelegate confirmShare];
    }
}

#pragma mark - Publci Methods
-(void)cancelAction{
    
    [UIView animateWithDuration:0.4 animations:^{
        _shareView.top = SCREEN_HEIGHT;
        
    } completion:^(BOOL finished) {
        for (UIView *view in _shareView.subviews) {
            [view removeFromSuperview];
        }
        [self removeFromSuperview];
    }];
}




@end
