//
//  WWCodeButton.h
//  zhidoushi
//
//  Created by xinglei on 14/11/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWCodeButton : UIButton

- (void)startTimerNmu;
@property(nonatomic,assign) int time_out; //倒计时时间
@property(nonatomic,assign) int clickDownNum;//点击次数
-(void)stopTimer;

@end
