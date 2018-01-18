//
//  WWViewController.h
//  zhidoushi
//
//  Created by xinglei on 14-11-5.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "UserProtocolViewController.h"
#import "WWTolls.h"

@interface UserProtocolViewController ()

@end

@implementation UserProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.scorll.contentSize = CGSizeMake(self.view.size.width, self.image.size.height+68);
    if (iPhone4) {
        self.scorll.contentSize = CGSizeMake(self.view.size.width, self.image.size.height+188);
    }
    self.scorll.bounces = NO;
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"BarBtn_goBack_32_32"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 20;
    labelRect.size.height = 20;
    self.leftButton.frame = labelRect;

    self.titleLabel.text = @"脂斗士用户协议";
    self.titleLabel.font = MyFont(17);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
}

-(void)popButton{
    
   [self.navigationController popViewControllerAnimated:YES];
}

-(void)createGame{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.scorll.contentSize = CGSizeMake(SCREEN_WIDTH, self.image.height+64);
    if (iPhone4) {
        self.scorll.height = [UIScreen mainScreen].bounds.size.height;
        //        self.backGroundScrollView.contentSize = CGSizeMake(320,self.backImageView.size.height+44);
    }
    self.scorll.backgroundColor = [WWTolls colorWithHexString:@"#fafafa"];
    self.view.backgroundColor = [WWTolls colorWithHexString:@"#fafafa"];

    
    /// 屏幕适配
    self.scorll.height = SCREEN_HEIGHT;
    self.scorll.width = SCREEN_WIDTH;

    self.image.width = SCREEN_WIDTH;
    self.image.height = self.image.image.size.height * SCREEN_WIDTH / self.image.image.size.width;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
