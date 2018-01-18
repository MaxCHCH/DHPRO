//
//  WWCodeButton.m
//  zhidoushi
//
//  Created by xinglei on 14/11/11.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "WWCodeButton.h"

#import "WWTolls.h"
#import "GlobalUse.h"

@interface WWCodeButton ()
{
    dispatch_source_t _timer;
}
@end

@implementation WWCodeButton

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)startTimerNmu
{
    _clickDownNum++;//首先记录点击次数

    if (_clickDownNum>3) {
        _time_out += (60*(_clickDownNum-3));
    }
    else{
        _time_out = 60;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    __weak typeof(self)weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(_time_out==0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               __strong typeof(weakSelf)strongSelf = weakSelf;
                               [strongSelf setBackgroundColor:[WWTolls colorWithHexString:@"f2e8dc"]];
                               [strongSelf setTitle:@"获取验证码" forState:UIControlStateNormal];
                               [strongSelf setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                               [strongSelf setUserInteractionEnabled:YES];
                                NSLog(@"--------------clickDownNum==%d",_clickDownNum);
                           });
        }else{
            NSString *strTime = [NSString stringWithFormat:@"%d秒",_time_out];
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf)strongSelf = weakSelf;
                //设置界面的按钮显示 根据自己需求设置
                [strongSelf setBackgroundColor:[WWTolls colorWithHexString:@"888c91"]];
                [strongSelf setTitle:strTime forState:UIControlStateNormal];
                [strongSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [strongSelf setUserInteractionEnabled:NO];
            });
            _time_out--;
            NSLog(@"--------------clickDownNum==%d,time_out==%d",_clickDownNum,_time_out);
        }
    });
    dispatch_resume(_timer);
}

-(void)stopTimer{
    //结束倒计时并回复数据
        dispatch_source_cancel(_timer);
        _clickDownNum = 0;
        _time_out = 60;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
