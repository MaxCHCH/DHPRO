//
//  CreatQuanButton.h
//  zhidoushi
//
//  Created by glaivelee on 15/11/18.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatQuanButton : UIButton
/**
 * 按钮上得标题
 */
@property (nonatomic, strong) UIView *back;

-(void)setIsPressdWithTitle:(NSString *)titleStr backgroundImage:(UIImage *)btnImage forState:(UIControlState)state;
@end
