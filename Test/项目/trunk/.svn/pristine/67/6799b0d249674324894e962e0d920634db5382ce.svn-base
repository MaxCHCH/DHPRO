//
//  SnapViewController.h
//  zhidoushi
//
//  Created by glaivelee on 15/11/11.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"
#import "BMIAlertSView.h"
@interface SnapViewController : BaseViewController<UIGestureRecognizerDelegate,BMIAlertSViewDelegate,UIGestureRecognizerDelegate>
/**
 * 体重
 */
@property (weak, nonatomic) IBOutlet UILabel *labelNum;

/**
 * 日期
 */
@property (weak, nonatomic) IBOutlet UILabel *labelDate;

/**
 * 当前BMI提示
 */
@property (weak, nonatomic) IBOutlet UILabel *labelS;
/**
 * 背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageviewBackground;
/**
 * 当前BMI
 */
@property (weak, nonatomic) IBOutlet UILabel *labelBMINum;
/**
 * 锁
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageLock;

@property (weak, nonatomic) IBOutlet UIView *viewBMIQuxian;
@property (strong, nonatomic) InitShareWeightView *shareWeightView;
@property(nonatomic,copy)NSString *parterid;//上传体重id

/**
 * 记录体重
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonRecordBMI;

@end
