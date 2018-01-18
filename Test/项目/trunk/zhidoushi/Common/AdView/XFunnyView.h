//
//  XFunnyView.h
//  zhidoushi
//
//  Created by nick on 15/4/21.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFunnyView : UIView
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,copy)void (^adDidClick)(NSInteger index);
@end
