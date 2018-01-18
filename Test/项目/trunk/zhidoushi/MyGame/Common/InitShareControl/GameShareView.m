//
//  GameShareView.m
//  zhidoushi
//
//  Created by xinglei on 14/12/9.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "GameShareView.h"

//..netWork..//
#import "JSONKit.h"
#import "WWRequestOperationEngine.h"
//..private..//
#import "InitShareView.h"
#import "InitShareWeightView.h"
//..gateGory..//
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"
#import "NSDictionary+NARSafeDictionary.h"

@interface GameShareView()<InitShareDelegate,InitShareViewDelegate>
{
    InitShareWeightView * shareWeightView;
    InitShareView * shareView;
}
@end

@implementation GameShareView

+(GameShareView*)initView{
    NSArray *nibArray = [[NSBundle mainBundle]loadNibNamed:@"GameShareView" owner:nil options:nil];
    return [nibArray objectAtIndex:0];
}

- (IBAction)cancel:(id)sender {
    [self cancelMyView];
}

- (IBAction)button_1:(id)sender {
     NSLog(@"self.parterid_1******%@",self.parterid_1);
    [self clickButton:self.parterid_1];
}

- (IBAction)button_2:(id)sender {
    NSLog(@"self.parterid_2******%@",self.parterid_2);
    [self clickButton:self.parterid_2];
}

-(void)clickButton:(NSString*)parterid{
    NSLog(@"self.parterid_1__%@,%@",self.parterid_1,self.parterid_2);

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:parterid forKey:@"parterid"];
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_GAMESELGAME parameters:dic requestOperationBlock:^(NSDictionary *dic) {

            NSString * selgamests = [dic objectForKey:@"selgamests"];
            NSString * islastupload = [dic objectForKey:@"islastupload"];

            if ([selgamests isEqualToString:@"0"]){//弹出仅上传体重页面

                shareWeightView = [[InitShareWeightView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
                shareWeightView.initShareDelegate = self;
                shareWeightView.initShareType = myWeightType;
                shareWeightView.parterid = parterid;
                [shareWeightView createView];
                [self.viewController.view addSubview:shareWeightView];
            }

            else if([selgamests isEqualToString:@"1"]) {//上传体重和照片页面

                shareView = [[InitShareView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];

                if([islastupload isEqualToString:@"0"]){

                    [self.viewController showAlertMsg:@"仅剩一次上传机会" andFrame:CGRectMake(70,100,200,60)];
                }

                if ([dic objectForKeySafe:@"phgoalweg"]) {
                    shareView.phgoalweg = [NSString stringWithFormat:@"%@",[dic objectForKeySafe:@"phgoalweg"]];
                }

                [self postPicture:parterid];
            }

//        NSLog(@"%@",dic);
//        NSString * selgamests = [dic objectForKey:@"selgamests"];
//        NSString * parterid = [dic objectForKey:@"parterid"];
//        if ([selgamests isEqualToString:@"0"]) {//0仅上传体重页面
//            [self cancelMyView];
//            shareWeightView = [[InitShareWeightView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//            shareWeightView.parterid = parterid;
//            [shareWeightView createView];
//            [self.viewController.view addSubview:shareWeightView];
//        }
//        else if ([selgamests isEqualToString:@"1"]){//1上传体重和照片页面
//            [self cancelMyView];
//            shareView = [[InitShareView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//            shareView.parterid = parterid;
//            [shareView createView:shareViewType_loadPhotoView];
//            [self.viewController.view addSubview:shareView];
//        }
//        else{
//            [self.viewController showAlertMsg:@"游戏已结束" andFrame:CGRectMake(70,100,200,60)];
//            }
    }];

}

-(void)postPicture:(NSString*)myparterid
{
    shareView.shareMyType = shareInType;
    shareView.initShareView = self;
    shareView.parterid = [NSString stringWithFormat:@"%@",myparterid];
    [shareView createView:shareViewType_loadPhotoView];
    [self.viewController.view addSubview:shareView];
}

-(void)cancelMyView{
    if ([self.gameShareDelegate respondsToSelector:@selector(cancelButtonSender)]) {
        [self.gameShareDelegate cancelButtonSender];
    }
}

-(void)configureView{

    [self.game_2_button setTitle:self.gameName_2 forState:UIControlStateNormal];
    [self.game_1_button setTitle:self.gameName_1 forState:UIControlStateNormal];
}

@end
