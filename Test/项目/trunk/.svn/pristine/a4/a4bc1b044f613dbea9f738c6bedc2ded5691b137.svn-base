//
//  UpdateAlert.m
//  zhidoushi
//
//  Created by licy on 15/7/1.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "UpdateAlert.h"

@interface UpdateAlert () <UIAlertViewDelegate>

@property (nonatomic,strong) UIAlertView *alert;

@end

@implementation UpdateAlert

+ (UpdateAlert *)sharedUpdateAlert {
    
    static UpdateAlert *alert = nil;
    @synchronized(self) {
        if (alert == nil) {
            alert = [[UpdateAlert alloc] init];
        }   
    }
    
    return alert;
}

- (void)show {
    
    if (!self.alert) {
        
        self.alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
                                                message:@"您的脂斗士版本过低，请更新后使用。"
                                               delegate:self
                                      cancelButtonTitle:@"退出"
                                      otherButtonTitles:@"马上更新",nil];
        [self.alert show];
    }
}   

#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        exit(-1);
    } else {
        
        NSURL *url = [NSURL URLWithString:ZDS_APP_DOWNLOAD];
        [[UIApplication sharedApplication] openURL:url];
        exit(-1);
    }
}

@end
