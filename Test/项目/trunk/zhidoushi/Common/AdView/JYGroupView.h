//
//  JYGroupView.h
//  zhidoushi
//
//  Created by nick on 15/6/15.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYGroupView : UIView
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,copy)void (^adDidClick)(NSInteger index);
@end
