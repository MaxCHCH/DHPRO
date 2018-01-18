//
//  WWCodeTextField.h
//  zhidoushi
//
//  Created by xinglei on 14/11/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

    codeType = 0,
    phoneType = 1
}WWTextFieldType;

@interface WWCodeTextField : UITextField

@property(nonatomic,assign)WWTextFieldType wwFieldType;//textField的类型

-(instancetype)initWithFrame:(CGRect)frame withType:(WWTextFieldType)type;

@end
