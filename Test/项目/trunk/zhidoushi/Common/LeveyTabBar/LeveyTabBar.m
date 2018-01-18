//
//  LeveyTabBar.m
//  LeveyTabBarController
//
//  Created by Levey Zhu on 12/15/10.
//  Copyright 2010 VanillaTech. All rights reserved.
//

#import "LeveyTabBar.h"
//..customView..//
#import "InitShareView.h"
#import "InitShareButton.h"
#import "InitShareGameView.h"
#import "InitShareWeightView.h"
//..gateGory..//
#import "UIView+ViewController.h"
#import "NSString+NARSafeString.h"
//..netWork..//
#import "NSDictionary+NARSafeDictionary.h"
#import "WWRequestOperationEngine.h"
#import "JSONKit.h"
#import "WWTolls.h"

@interface LeveyTabBar ()
{
    UIImageView *dianImage;//红点视图
    UIButton *mybtn;
    InitShareView * shareView;
    InitShareButton * button;
    InitShareGameView *shareGameView;
    InitShareWeightView *shareWeightView;
}
@end

@implementation LeveyTabBar
@synthesize backgroundView = _backgroundView;
@synthesize delegate = _delegate;
@synthesize buttons = _buttons;

- (id)initWithFrame:(CGRect)frame buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];

    if (self)
	{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsNotification) name:@"newNotification" object:nil];

        self.layer.borderColor = [WWTolls colorWithHexString:@"#aeaeae"].CGColor;
        self.layer.borderWidth = 0.5f;
		self.backgroundColor = [UIColor clearColor];
        
		_backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
		[self addSubview:_backgroundView];
		
		self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];

		CGFloat width =  SCREEN_WIDTH/ [imageArray count];
		for (int i = 0; i < [imageArray count]; i++)
		{
            mybtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            mybtn.showsTouchWhenHighlighted = YES;
            mybtn.tag = i;
            mybtn.frame = CGRectMake(width * i+12, 7, 37, 37);
             NSLog(@"%f%f",mybtn.frame.size.height,mybtn.frame.size.width);
            [mybtn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
            [mybtn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
            [mybtn setBackgroundImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
            [mybtn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttons addObject:mybtn];
            [self addSubview:mybtn];
		}
        button = [[InitShareButton alloc]initWithFrame:CGRectMake(width * 2+12, 0, width-20, frame.size.height)];
         NSLog(@"加号按钮尺寸%f%f",button.width,button.height);
        [button setBackgroundImage:[UIImage imageNamed:@"icon_plus_88_98_"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"icon_plus_88_98_"] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(selector) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];

        //**添加判断信息**//
        [self getNewMessage];
    }
    return self;
}

-(void)selector{

    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_BOBO_DEFAULT_HTTP_SERVER_HOST,ZDS_UPLWEISTS];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    NSString *userID =  [NSUSER_Defaults objectForKey:ZDS_USERID];
    NSString *userid = [NSString stringWithFormat:@"%@",userID];
    NSString *key = [NSString getMyKey:userID];
    [dic setObject:userid forKey:@"userid"];
    [dic setObject:key forKey:@"key"];
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dic requestOperationBlock:^(NSString *object) {
        NSDictionary *dic = [object objectFromJSONString];
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {

            [self.viewController showAlertMsg:@"获取信息失败" andFrame:CGRectMake(70,100,200,60)];

        }else{

        NSLog(@"dic-----------%@",dic);
        NSString * uplwegsts = [dic objectForKey:@"uplwegsts"];
        if ([uplwegsts isEqualToString:@"1"]) {//选择游戏界面
        shareGameView = [[InitShareGameView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
        NSArray *nameArray = [dic objectForKey:@"parterlist"];
            if (nameArray.count!=0) {
                NSDictionary *name1Array = [nameArray firstObject];
                NSDictionary *name2Array = [nameArray lastObject];
                shareGameView.parterid_1 = [name1Array objectForKey:@"parterid"];
                shareGameView.parterid_2 = [name2Array objectForKey:@"parterid"];
                shareGameView.gameName_1 = [name1Array objectForKey:@"gamename"];
                shareGameView.gameName_2 = [name2Array objectForKey:@"gamename"];
                 NSLog(@"%@",[name1Array objectForKey:@"gamename"]);
            }
        [shareGameView createView];
        [self.viewController.view addSubview:shareGameView];
        }
        else if ([uplwegsts isEqualToString:@"2"]){//弹出仅上传体重页面
            NSString * parterid = [dic objectForKey:@"parterid"];
            shareWeightView = [[InitShareWeightView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
            shareWeightView.parterid = parterid;
            [shareWeightView createView];
            [self.viewController.view addSubview:shareWeightView];
        }
        else if ([uplwegsts isEqualToString:@"3"]){//上传体重和照片页面
            if ([dic objectForKeySafe:@"phgoalweg"]) {
                [self.viewController showAlertMsg:@"当前上传体重大于目标体重无法上传" andFrame:CGRectMake(70,100,200,60)];
            }
            else{
                NSString * parterid = [dic objectForKey:@"parterid"];
                shareView = [[InitShareView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
                shareView.parterid = parterid;
                [shareView createView:shareViewType_loadPhotoView];
                [self.viewController.view addSubview:shareView];
            }
        }
        else if([uplwegsts isEqualToString:@"0"]){
            [self.viewController showAlertMsg:@"你目前没有需要上传体重及照片的团组哦" andFrame:CGRectMake(70,100,200,60)];
            }
        else if([uplwegsts isEqualToString:@"4"]){
            [self.viewController showAlertMsg:@"团组任务开始前2天才能上传照片哦，请耐心等待" andFrame:CGRectMake(70,100,200,60)];
            }
        else if ([dic objectForKeySafe:@"islastupload"]){
            NSString * islastuploadString = [dic objectForKey:@"islastupload"];
            if ([islastuploadString isEqualToString:@"0"]) {
                [self.viewController showAlertMsg:@"仅剩一次上传机会" andFrame:CGRectMake(70,100,200,60)];
            }
        }
        else if (dic.count==0){
             [self.viewController showAlertMsg:@"你目前没有需要上传体重及照片的团组哦" andFrame:CGRectMake(70,100,200,60)];
            }
        }
    }];
 NSLog(@"点击了加号************");
}

- (void)setBackgroundImage:(UIImage *)img
{
	[_backgroundView setImage:img];
}

- (void)tabBarButtonClicked:(id)sender
{
	UIButton *btn = sender;
	[self selectTabAtIndex:btn.tag];
    if(btn.tag==4){
        [dianImage removeFromSuperview];
        [NSUSER_Defaults removeObjectForKey:@"everyNotification"];
    }
}

- (void)selectTabAtIndex:(NSInteger)index
{
	for (int i = 0; i < [self.buttons count]; i++)
	{
		UIButton *b = [self.buttons objectAtIndex:i];
		b.selected = NO;
	}
    if (index<5) {

            UIButton *btn = [self.buttons objectAtIndex:index];
            btn.selected = YES;
            if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
            {
                [_delegate tabBar:self didSelectIndex:btn.tag];
            }
               }else{
                   
        if ([_delegate respondsToSelector:@selector(tabBar:didSelectIndex:)])
        {
            [_delegate tabBar:self didSelectIndex:5];
        }
    }
}

- (void)removeTabAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
   
    // Re-index the buttons
     CGFloat width = 320.0f / [self.buttons count];
    for (UIButton *btn in self.buttons) 
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}

- (void)insertTabWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    // Re-index the buttons
    CGFloat width = 320.0f / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons) 
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (void)getNewMessage
{
    NSString *newString = [NSUSER_Defaults objectForKey:@"everyNotification"];
    if ([newString isEqualToString:@"justdoit"]) {
        [self changeButtonStage];
    }
}

-(void)apnsNotification
{
    [self changeButtonStage];
}

-(void)changeButtonStage
{
        if (!dianImage) {
            dianImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 32, 5, 10, 10)];
            dianImage.image = [UIImage imageNamed:@"dian_20_20.png"];
            [self addSubview:dianImage];
            NSLog(@"*****收到了透传消息*****");
        }

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newNotification" object:nil];
    [_backgroundView release];
    [_buttons release];
    [super dealloc];
}

@end
