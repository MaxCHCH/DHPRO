//
//  XLNavigationController.m
//  zhidoushi
//
//  Created by xinglei on 14-10-28.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "XLNavigationController.h"

@interface XLNavigationController (){
    
    UIView *baseView;
    UIView *currentView;
}

@end

@implementation XLNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    baseView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20)];

    [self setNavigationBarHidden:true];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice]systemVersion]compare:@"7.0"]!=NSOrderedAscending){

    }
    
#endif
}

@end
