//
//  uploadWeightView.h
//  zhidoushi
//
//  Created by xinglei on 14/11/29.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol uploadWeightViewDelegate <NSObject>
@optional
-(void)cancelButtonSender;
-(void)confirmButtonSender;
@end

@interface uploadWeightView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *line2View;

@property (weak, nonatomic) IBOutlet UIImageView *line1View;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;//确认按钮

@property(nonatomic,strong)NSString * phgoalweg;
@property(nonatomic,strong)NSString * parterid;

@property(nonatomic,weak)id<uploadWeightViewDelegate> uploadViewDelegate;

+(uploadWeightView*)initView;

-(void)configureView;

@end
