//
//  BMIAlertSView.h
//  zhidoushi
//
//  Created by glaivelee on 15/11/12.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitShareView.h"
#import "InitShareWeightView.h"

@class BMIAlertSView;

@protocol BMIAlertSViewDelegate <NSObject>
- (void)setWEG:(NSString *)parterid;
@end


@interface BMIAlertSView : UIView<InitShareDelegate,InitShareViewDelegate>{
    InitShareWeightView * shareWeightView;
    InitShareView * shareView;
}
- (instancetype)initWithFrame:(CGRect)frame delegate:(id <BMIAlertSViewDelegate>)delegate;
@property (nonatomic,weak) id <BMIAlertSViewDelegate> delegate;
@property (nonatomic,strong) UIButton *button_setHeight;
- (void)createView;
@end
