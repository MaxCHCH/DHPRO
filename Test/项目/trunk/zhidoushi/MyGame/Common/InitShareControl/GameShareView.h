//
//  GameShareView.h
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GameShareViewDelegate <NSObject>
@optional
-(void)cancelButtonSender;
@end
@interface GameShareView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *game_1_button;
@property (weak, nonatomic) IBOutlet UIButton *game_2_button;
@property(nonatomic,strong)NSString * gameName_1;
@property(nonatomic,strong)NSString * gameName_2;
@property(nonatomic,strong)NSString * parterid_1;
@property(nonatomic,strong)NSString * parterid_2;
@property(nonatomic,weak)id<GameShareViewDelegate> gameShareDelegate;
+(GameShareView*)initView;
-(void)configureView;

@end
