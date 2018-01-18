//
//  UIView+SSLShowAlert.m
//  zhidoushi
//
//  Created by licy on 15/6/30.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UIView+SSLShowAlert.h"

@implementation UIView (SSLShowAlert)

-(void)showAlertMsg:(NSString *)messae andFrame:(CGRect)frame timeInterval:(NSTimeInterval)time {
    
    UILabel *mylabel = (UILabel*)[self viewWithTag:11111];
    if (nil == mylabel) {
        mylabel = [[UILabel alloc] initWithFrame:frame];
        
    }
    mylabel.tag = 11111;
    mylabel.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7f];
    mylabel.textAlignment = NSTextAlignmentCenter;
    mylabel.textColor = [UIColor whiteColor];
    mylabel.text = messae;
    mylabel.opaque = NO;
    mylabel.numberOfLines = 0;
    mylabel.font = [UIFont boldSystemFontOfSize:16];
    //    CGSize constraint = CGSizeMake(frame.size.width, 20000.0f);
    //    CGSize size = [messae sizeWithFont:label.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    //    float height = MAX(frame.size.height, size.height);
    //    frame.size.height = height;
    //    label.frame = frame;
    CGSize size = [messae sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if (size.width>240) {
        size.width = 240;
        size.height*=2;
    }
    mylabel.frame =CGRectMake(SCREEN_MIDDLE(size.width)-10, 160, size.width+20, size.height+20);
    mylabel.layer.cornerRadius = 10;
    mylabel.layer.masksToBounds = YES;
    if (nil == mylabel.superview) {
        [self addSubview:mylabel];
        [self bringSubviewToFront:mylabel];
        NSLog(@"")
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(disappear:) userInfo:mylabel repeats:NO];
    }
}

-(void)disappear:(NSTimer*)timer{
    UILabel *label = [timer userInfo];
    if (label && [label isKindOfClass:[UILabel class]]) {
        [UIView animateWithDuration:1 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished){
            [label removeFromSuperview];
        }];
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
