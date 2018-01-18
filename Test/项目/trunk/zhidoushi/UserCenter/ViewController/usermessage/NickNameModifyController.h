//
//  NickNameModifyController.h
//  zhidoushi
//
//  Created by ji on 15/11/13.
//  Copyright © 2015年 game.zhidoushi.com. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^returnBlock)(NSString *showText);

@interface NickNameModifyController : BaseViewController

@property (nonatomic,strong) NSString *strtext;

@property(strong,nonatomic) UILabel* textPlacehoader;
@property(strong,nonatomic) UITextView* nameText;

@property (nonatomic, copy) returnBlock nameblock;
@end
