//
//  ZSDPaymentForm.h
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSDSetPasswordView.h"

@interface ZSDPaymentForm : UIView
@property (weak, nonatomic) IBOutlet UILabel *centerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@property (nonatomic,assign) CGFloat amount;
@property (weak, nonatomic) IBOutlet ZSDSetPasswordView *inputView;

@property (nonatomic,copy) NSString *inputPassword;
@property (nonatomic,copy) void (^completeHandle)(NSString *inputPwd);

-(void)fieldBecomeFirstResponder;
-(CGSize)viewSize;

@end
