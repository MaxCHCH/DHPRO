//
//  CreateGroupDoneViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/18.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "CreateGroupDoneViewController.h"
#import "UITextView+LimitLength.h"
#import "GroupViewController.h"

@interface CreateGroupDoneViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *content;//文本框
@property(nonatomic,strong)UILabel *textPlacehoader;//占位
@end

@implementation CreateGroupDoneViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    UIView *titleViews = [[UIView alloc] init];
    [titleViews addSubview:self.leftButton];
    [titleViews addSubview:self.rightButton];
    self.navigationItem.titleView = titleViews;
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(14);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 16;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(Next) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.rightButton.width = 44;
    self.rightButton.left += 124;
    self.rightButton.titleLabel.font = MyFont(16);
    
    //导航栏标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"创建减脂团";
    title.textColor = ZDS_DHL_TITLE_COLOR;
    title.font = MyFont(18);
    title.textAlignment = NSTextAlignmentCenter;
    title.frame = CGRectMake(0, 0, 320, 44);
    title.center = titleViews.center;
    [titleViews addSubview:title];
    [self setUpGUI];
}

-(void)setUpGUI{
    self.view.backgroundColor = ZDS_BACK_COLOR;
    //点点
    UIPageControl *page = [[UIPageControl alloc] init];
    page.numberOfPages = 4;
    page.layer.affineTransform = CGAffineTransformMakeScale(0.7, 0.7);
    page.currentPage = 3;
    page.currentPageIndicatorTintColor = ZDS_DHL_TITLE_COLOR;
    page.pageIndicatorTintColor = [WWTolls colorWithHexString:@"#959595"];
    page.frame = CGRectMake(0, 9, 320, 10);//指定位置大小
    [self.view addSubview:page];
    //招募
    UILabel *lbl1 = [[UILabel alloc] init];
    lbl1.frame = CGRectMake(-1, 25, 322, 35);
    lbl1.font = MyFont(14);
    lbl1.backgroundColor = [UIColor whiteColor];
    lbl1.textColor = [WWTolls colorWithHexString:@"#535353"];
    lbl1.text = @"   招募宣言";
    lbl1.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    lbl1.layer.borderWidth = 0.5;
    [self.view addSubview:lbl1];
    
    UITextView *text = [[UITextView alloc] init];
    text.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    text.layer.borderWidth = 0.5;
    self.content = text;
    text.frame = CGRectMake(11, lbl1.bottom+14, 298, 83);
    text.delegate = self;
    text.font = MyFont(15);
    text.textColor = [WWTolls colorWithHexString:@"#999999"];
    text.contentInset = UIEdgeInsetsMake(5, 3, -5, -3);
    [text limitTextLength:50];
    [self.view addSubview:text];
    
    UILabel *textlbl = [[UILabel alloc] initWithFrame:CGRectMake(21, text.top+10, 200, 20)];
    textlbl.numberOfLines = 0;
    self.textPlacehoader = textlbl;
    textlbl.text = @"打开脑洞，吸引更多人加入吧";
    textlbl.textColor = [WWTolls colorWithHexString:@"#a0a0a0"];
    textlbl.font = MyFont(15);
    [self.view addSubview:textlbl];
    
    //字数提醒
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = @"最多可以输入50个字";
    lbl.font = MyFont(11);
    lbl.textColor = [WWTolls colorWithHexString:@"#80cafb"];
    lbl.frame = CGRectMake(22, text.bottom+7, 200, 12);
    [self.view addSubview:lbl];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"创建减脂团页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"创建减脂团页面"];
}
#pragma mark - 完成
-(void)Next{
    if(self.content.text.length<1){
        [self showAlertMsg:@"请输入团组宣言" yOffset:-40];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认创建吗?" message:@"创建后，团组不能取消哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.rightButton.userInteractionEnabled = NO;
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithCapacity:10];
        if(self.imageurl.length>0){
            [dictionary setObject:self.imageurl forKey:@"imageurl"];
        }else{
            [dictionary setObject:ZDS_DEFAULTIMAGEURL forKey:@"imageurl"];
        }
        [dictionary setObject:self.groupname forKey:@"gamename"];
        [dictionary setObject:self.begindate forKey:@"gmbegintime"];//开始时间
        NSString * gmsloganString = [NSString takeoutString:self.content.text];
        [dictionary setObject:gmsloganString forKey:@"gmslogan"];//宣言
        [dictionary setObject:self.shenfen forKey:@"crtortype"];//参与者类型
        [dictionary setObject:@"0" forKey:@"gamests"];
        [dictionary setObject:@"1" forKey:@"gamemode"];
        
        if(self.Wheretag.length>0)
            [dictionary setObject:self.Wheretag forKey:@"gametags"];
        __weak typeof(self)weakSelf = self;
        [WWRequestOperationEngine operationManagerRequest_Post:ZDS_CREATEDO parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
            if ([dic[@"createflg"] isEqualToString:@"0"]) {
                [weakSelf showAlertMsg:@"创建成功" andFrame:CGRectMake(70,100,200,60)];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"createGroupSucess" object:nil];
                NSLog(@"*********%@", [dic objectForKey:@"errinfo"]);
                NSString *gameid = [dic objectForKey:@"gameid"];
                GroupViewController *detail = [[GroupViewController alloc]init];
                detail.clickevent = 0;
                detail.joinClickevent = 0;
                detail.groupId = gameid;//20150206020000000078
                detail.gameDetailStatus = @"10086";
                [weakSelf.navigationController pushViewController:detail animated:YES];
                weakSelf.rightButton.userInteractionEnabled = NO;
            }else{
                weakSelf.rightButton.userInteractionEnabled = YES;
            }
        }];
    }
}
#pragma mark - UItextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length==0&&text.length==0) {
        self.textPlacehoader.hidden = NO;
    }else{
        self.textPlacehoader.hidden = YES;    }
    if (textView.text.length==1&&text.length==0) {
        self.textPlacehoader.hidden = NO;    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    [textView textFieldTextLengthLimit:nil];
    if(textView.text.length>0){
        self.textPlacehoader.hidden = YES;
    }
}
#pragma mark - 返回
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
