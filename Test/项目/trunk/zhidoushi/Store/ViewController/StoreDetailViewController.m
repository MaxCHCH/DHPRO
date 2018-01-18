//
//  StoreDetailViewController.m
//  zhidoushi
//
//  Created by xinglei on 15/1/10.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "StoreDetailViewController.h"

//..netWork../
#import "JSONKit.h"
#import "Define.h"
#import "WWRequestOperationEngine.h"
#import "WWTolls.h"
#import "NSString+NARSafeString.h"
#import "UIImageView+AFNetworking.h"
#import "NSURL+MyImageURL.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+MJ.h"
#import "ExchangeRecordViewController.h"
#import "XimageView.h"
#import "MobClick.h"

@interface StoreDetailViewController ()

@end

@implementation StoreDetailViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"商品详情页面"];
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"商品详情页面"];
    self.titleLabel.text = [NSString stringWithFormat:@"商品详情"];
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);

    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(11);
    [self.leftButton addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    labelRect.origin.x = 0;
    self.leftButton.frame = labelRect;
    //积分是够足够
    if (!self.isEnoughScore) {
        [self.changeButton setTitle:@"斗币不够了" forState:UIControlStateNormal];
        [self.changeButton setBackgroundImage:[UIImage imageNamed:@"button_366_76"] forState:UIControlStateNormal];
        self.changeButton.userInteractionEnabled = NO;
    }else {
        [self.changeButton setBackgroundImage:[UIImage imageNamed:@"button_366_76-"] forState:UIControlStateNormal];
        [self.changeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
        self.changeButton.userInteractionEnabled = YES;
    }
    //是否从记录跳转
    if (self.isJiLu) {
        self.changeButton.hidden = YES;
    }
}

-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.backGroundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.headImageView.image = [UIImage imageNamed:@"广告图-640^300.jpg"];
    self.storeName.alpha = 0.6;
    self.goalLabel.textColor = [WWTolls colorWithHexString:@"#ea5b57"];
    [self uploadData:self.goodsid];

}




#pragma mark - 立即兑换按钮
- (IBAction)changeButton:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"是否确认兑换%@\n所需积分：%@",self.storeName.text,self.goalLabel.text] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认兑换", nil];
    [alert show];
}
#pragma mark - 提示框代理
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self uploadAwardData:self.goodsid];
    }
}


#pragma mark - 获取商品数据
-(void)uploadData:(NSString*)goodsid{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:goodsid forKey:@"goodsid"];

    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ZDS_GETGOODSINFO];

    NSLog(@" 获取商品数据%@,%@",urlString,dictionary);

    __weak typeof(self)weakSelf = self;

    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        if (!dic[ERRCODE]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *imageUrl = [NSURL URLWithImageString:[dic objectForKey:@"imageurl2"] Size:300];
            weakSelf.headImageView.bigImageURL = imageUrl;
            [weakSelf.headImageView sd_setImageWithURL:imageUrl];
            NSString *gsstatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"gsstatus"]];
            NSString *scoreEnough = [NSString stringWithFormat:@"%@",[dic objectForKey:@"scoreEnough"]];
            NSString *inventory = [NSString stringWithFormat:@"%@",[dic objectForKey:@"inventory"]];
            if ([gsstatus isEqualToString:@"2"]) {
                [weakSelf.changeButton setTitle:@"兑换已结束" forState:UIControlStateNormal];
                [weakSelf.changeButton setBackgroundImage:[UIImage imageNamed:@"button_366_76"] forState:UIControlStateNormal];
                weakSelf.changeButton.userInteractionEnabled = NO;
            }else if(inventory.intValue < 1){
                [weakSelf.changeButton setTitle:@"兑换已结束" forState:UIControlStateNormal];
                [weakSelf.changeButton setBackgroundImage:[UIImage imageNamed:@"button_366_76"] forState:UIControlStateNormal];
                weakSelf.changeButton.userInteractionEnabled = NO;
            }else{
                [weakSelf.changeButton setBackgroundImage:[UIImage imageNamed:@"button_366_76-"] forState:UIControlStateNormal];
                [weakSelf.changeButton setTitle:@"立即兑换" forState:UIControlStateNormal];
                weakSelf.changeButton.userInteractionEnabled = YES;
                if ([scoreEnough isEqualToString:@"0"]) {
                    [weakSelf.changeButton setTitle:@"斗币不够了" forState:UIControlStateNormal];
                    [weakSelf.changeButton setBackgroundImage:[UIImage imageNamed:@"button_366_76"] forState:UIControlStateNormal];
                    weakSelf.changeButton.userInteractionEnabled = NO;
                }
            }
            
            weakSelf.storeName.text =[NSString stringWithFormat:@"    %@",[dic objectForKey:@"gsname"]];
            
            weakSelf.goalLabel.text  = [dic objectForKey:@"imageurl"];
            
            NSString *goodInfo = [dic objectForKey:@"gsintro"];
            if (iPhone4) {
                goodInfo = [NSString stringWithFormat:@"%@%@",goodInfo,@"<br/><br/><br/>"];
            }
            [weakSelf.introView loadHTMLString:[NSString stringWithFormat:@"%@",goodInfo] baseURL:nil];
            weakSelf.introView.scrollView.showsVerticalScrollIndicator = YES;
            weakSelf.introView.scrollView.bounces = NO;
            weakSelf.introView.backgroundColor = weakSelf.backGroundScrollView.backgroundColor;
            weakSelf.goalLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"exchscore"]];
        });
         

        }
    }];
    
}

#pragma mark - 积分兑换奖品
-(void)uploadAwardData:(NSString*)goodsid{

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dictionary setObject:goodsid forKey:@"goodsid"];
    WEAKSELF_SS
    [WWRequestOperationEngine operationManagerRequest_Post:ZDS_EXCHANGE parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
            if ([dic[@"exchangeStatus"] isEqualToString:@"1"]) {
                [weakSelf showAlertMsg:@"兑换成功" andFrame:CGRectZero];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.changeButton setTitle:@"兑换成功" forState:UIControlStateNormal];
                    weakSelf.changeButton.enabled = NO;
                    ExchangeRecordViewController * introduce = [[ExchangeRecordViewController alloc]initWithNibName:@"ExchangeRecordViewController" bundle:nil];
                    [weakSelf.navigationController pushViewController:introduce animated:YES];
                });
            }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
