//
//  AddView.h
//  zhidoushi
//
//  Created by xiang on 15-1-23.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddModel.h"

@interface AddView : UIView
#define KADViewheight 150
-(instancetype)initWithAds:(NSArray *)ads;

@property(nonatomic,copy) void (^adDidClick)(AddModel *ad);

- (void)setAds:(NSArray *)ads;
@end
