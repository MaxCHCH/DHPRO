//
//  CreateGroupSetPasswordNewViewController.h
//  zhidoushi
//
//  Created by glaivelee on 15/11/10.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

@interface CreateGroupSetPasswordNewViewController : BaseViewController<UITextFieldDelegate>
/**
 * 输入新密码
 */
@property (weak, nonatomic) IBOutlet UITextField *inputNewPasswordTextField;
/**
 * 确认密码
 */
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@property(nonatomic,strong)NSMutableDictionary *tempDic;//上级页面创建团组词典

@property (nonatomic, strong)NSMutableArray *titleAllArr;

@property (weak, nonatomic) IBOutlet UIButton *overSettingBtn;

@end
