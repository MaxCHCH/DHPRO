//
//  UIViewController+ShowAlert.h
//  zhidoushi
//
//  Created by xinglei on 14-9-23.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ShowAlert)<UIAlertViewDelegate>
- (void)showAlertMsg:(NSString *)messae yOffset:(float)yOffset;
-(void)showAlertMsg:(NSString*)messae andFrame:(CGRect)frame;
- (void)showUnLoginAlertViewMsg:(NSString *)message titleOne:(NSString*)titleOne titleTwo:(NSString*)titleTwo title:(NSString*)title;
- (void)showUnLoginAlertViewMsg:(NSString *)title message:(NSString*)message cacelTitle:(NSString*)cacelTitle;
-(void)showErrorCode:(NSError*)error;
-(void)showActivityView:(NSString*)msg;
-(void)removeActivityView;
-(void)changeShowMsg:(NSString*)msg;

-(void)showAlertMsg:(NSString *)messae andFrame:(CGRect)frame timeInterval:(NSTimeInterval)time;
-(void)showAlertMsg:(NSString *)messae verticalSpace:(CGFloat)verticalSpace timeInterval:(NSTimeInterval)time;

-(void)showWaitView;
-(void)showWaitView:(NSString*)text;
-(void)removeWaitView;

-(NSInteger)transformTime:(NSString*)time;//把时间转换成整型

-(NSString*)transformNewTime:(NSString*)publishTime;//根据发布的时间转换成新的时间


@end
