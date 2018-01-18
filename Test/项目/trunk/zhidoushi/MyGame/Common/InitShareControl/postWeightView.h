//
//  postWeightView.h
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol postWeightViewDelegate <NSObject>
@optional
-(void)cancelButtonSender;
-(void)confirmButtonSender;
-(void)weightTextFieldValue:(NSString*)value;
@end

@interface postWeightView : UIView

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *weightTextField;
@property (weak, nonatomic) IBOutlet UIButton *affirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic,strong) UIViewController *viewController;

@property(nonatomic,strong)NSString * parterid;
@property(nonatomic,strong)NSString * gameModel;

@property(nonatomic,weak) id <postWeightViewDelegate> postWeightDelegate;

+(postWeightView*)initView;

-(void)configureView;

@end
