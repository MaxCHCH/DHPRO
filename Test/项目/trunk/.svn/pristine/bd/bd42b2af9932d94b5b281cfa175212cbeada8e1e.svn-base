//
//  ZSDPaymentForm.m
//  demo
//
//  Created by shaw on 15/4/11.
//  Copyright (c) 2015年 shaw. All rights reserved.
//

#import "ZSDPaymentForm.h"
#import "ZSDSetPasswordView.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ZSDPaymentForm ()<ZSDSetPasswordViewDelegate>





@end

@implementation ZSDPaymentForm

-(void)awakeFromNib
{
    [super awakeFromNib];
    _inputView.layer.borderWidth = 0.5f;
    _inputView.layer.borderColor = UIColorFromRGB(0xC8C8C8).CGColor;
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.delegate = self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        _inputView.layer.borderWidth = 0.5f;
        _inputView.layer.borderColor = [UIColor blackColor].CGColor;
        _inputView.delegate = self;
    }
    return self;
}
#pragma mark -
#pragma mark -ZSDSetPasswordViewDelegate
-(void)passwordView:(ZSDSetPasswordView *)passwordView inputPassword:(NSString *)password
{
//    //密码检测，必须是6位数字
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0-9]{6}$"];
//    if(![predicate evaluateWithObject:password])
//    {
//        self.inputPassword = nil;
//    }
//    else
//    {
        self.inputPassword = password;
    
    if(_completeHandle)
    {
        _completeHandle(_inputPassword);
    }
//    }
}

-(CGSize)viewSize
{
    CGSize size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size;
}

-(void)fieldBecomeFirstResponder
{
    [_inputView fieldBecomeFirstResponder];
}

@end
