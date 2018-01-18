//
//  XTabBar.m
//  zhidoushi
//
//  Created by xiang on 15-2-4.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "XTabBar.h"
#import "WWTolls.h"
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
#import "MobClick.h"

@interface XTabBar()
@end
@implementation XTabBar

+(XTabBar*)shareXTabBar
{
    static XTabBar *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XTabBar alloc]init];
    });
    return instance;
}

/**
 * init方法内部会调用这个方法
 * 只有通过代码创建控件,才会执行这个方法
 */
- (instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [WWTolls colorWithHexString:@"#ffffff"];
//        self.selec
//        self.selectedImageTintColor = RGBCOLOR(72, 83, 214);
//        self.selectedImageTintColor = [UIColor clearColor];
//        self sel
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsNotification) name:@"newinformation" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsNotification) name:@"newNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(apnsNotification) name:@"newmessage" object:nil];
        [self setup];
    }
    return self;
}

/**
 * 通过xib\storyboard创建控件时,才会执行这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 * 初始化
 */
- (void)setup
{
    //**添加红点**//
    [self changeButtonStage];
    //**添加判断信息**//
    [self getNewMessage];
    [self imageState];
    [self addNewFriends];
}
#pragma mark - 添加新朋友红点
-(void)addNewFriends{
    _frienddian = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 32, 5, 10, 10)];
    _frienddian.backgroundColor = OrangeColor;
    _frienddian.layer.cornerRadius = 5;
    _frienddian.clipsToBounds = YES;
    _frienddian.hidden = YES;
    [self addSubview:_frienddian];
    //如果有电话号码的话
    NSString *myString = [NSUSER_Defaults objectForKey:@"newFriendPhones"];
    if(myString.length!=0 && [myString isKindOfClass:[NSString class]])
    {
        self.frienddian.hidden = NO;
    }
    NSString *myString2 = [NSUSER_Defaults objectForKey:@"newFriendSina"];
    if(myString2.length!=0 && [myString2 isKindOfClass:[NSString class]])
    {
        self.frienddian.hidden = NO;
    }
}
-(void)friendDian{
    //如果有电话号码的话
    self.frienddian.hidden = YES;
    NSString *myString = [NSUSER_Defaults objectForKey:@"newFriendPhones"];
    if(myString.length!=0 && [myString isKindOfClass:[NSString class]])
    {
        self.frienddian.hidden = NO;
    }
    NSString *myString2 = [NSUSER_Defaults objectForKey:@"newFriendSina"];
    if(myString2.length!=0 && [myString2 isKindOfClass:[NSString class]])
    {
        self.frienddian.hidden = NO;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    UITabBar *tabBar = self;
    
    UITabBarItem *aTabBarItem = [tabBar.items objectAtIndex:0];
    aTabBarItem.image = [UIImage imageNamed:@"jianzhi"];
    aTabBarItem.selectedImage = [UIImage imageNamed:@"jianzhi_select"];
    aTabBarItem.title = @"减脂";    
     NSLog(@" [aTabBarItem superclass]%@", [aTabBarItem superclass]);
    [aTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 21)];
    [aTabBarItem setTitleTextAttributes:[NSDictionary
                                          dictionaryWithObjectsAndKeys:TimeColor,
                                          UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [aTabBarItem setTitleTextAttributes:[NSDictionary
                                          dictionaryWithObjectsAndKeys:OrangeColor,
                                          UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    UITabBarItem *bTabBarItem =  [tabBar.items objectAtIndex:1];
    bTabBarItem.image = [UIImage imageNamed:@"faxian"];
    bTabBarItem.selectedImage = [UIImage imageNamed:@"faxian_select"];
    bTabBarItem.title = @"撒欢";
    [bTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 21)];
    [bTabBarItem setTitleTextAttributes:[NSDictionary
                                          dictionaryWithObjectsAndKeys:TimeColor,
                                          UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [bTabBarItem setTitleTextAttributes:[NSDictionary
                                          dictionaryWithObjectsAndKeys:OrangeColor,
                                          UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    UITabBarItem *dTabBarItem = [tabBar.items objectAtIndex:2];
    dTabBarItem.image = [UIImage imageNamed:@"dongjing"];
    dTabBarItem.selectedImage = [UIImage imageNamed:@"dongjing_select"];
    dTabBarItem.title = @"动静";
    [dTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 21)];
    [dTabBarItem setTitleTextAttributes:[NSDictionary
                                         dictionaryWithObjectsAndKeys:TimeColor,
                                         UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [dTabBarItem setTitleTextAttributes:[NSDictionary
                                         dictionaryWithObjectsAndKeys:OrangeColor,
                                         UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    
    _eTabBarItem = [tabBar.items objectAtIndex:3];
    _eTabBarItem.image = [UIImage imageNamed:@"wo"];
    _eTabBarItem.selectedImage = [UIImage imageNamed:@"wo_select"];
    _eTabBarItem.title = @"自我";
//    ［UITabBarItem
//    appearance] setTitleTextAttributes: forState:UIControlStateNormal];
    [_eTabBarItem setTitleTextAttributes:[NSDictionary
                                         dictionaryWithObjectsAndKeys:TimeColor,
                                          UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    [_eTabBarItem setTitleTextAttributes:[NSDictionary
                                          dictionaryWithObjectsAndKeys:OrangeColor,
                                          UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    [_eTabBarItem setTitlePositionAdjustment:UIOffsetMake(0, 21)];
    /** 设置所有UITabBarButton的位置和尺寸 */
    // UITabBarButton的尺寸
    CGFloat buttonW = self.width / 4;
    CGFloat buttonH = self.height - 18;
    
    // 按钮索引
    int buttonIndex = 0;
    // 设置所有UITabBarButton的frame
    for (UIView *child in self.subviews) {
        // 找到UITabBarButton
        if ([child isKindOfClass:[UIControl class]] && ![child isKindOfClass:[UIButton class]]) {
            CGFloat buttonX = buttonW * buttonIndex;
            child.frame = CGRectMake(buttonX, 23, buttonW, 4);
            // 增加索引
            buttonIndex++;
        }
    }
}


- (void)getNewMessage
{
        NSString *newString = [NSUSER_Defaults objectForKey:@"everyNotification"];
        if ([newString isEqualToString:@"justdoit"]) {
            [self imageState];
        }
}

-(void)apnsNotification
{
    if(((UITabBarController*)self.viewController).selectedIndex != 2){
        [self imageState];
        [NSUSER_Defaults setObject:@"YES" forKey:@"isothercome"];
    }
}

-(void)changeButtonStage
{
    NSLog(@"xtabbar*****收到了透传消息*****");
    if (!_dianImage) {
        _dianImage = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4 - 30, 4, 10, 10)];
        _dianImage.backgroundColor = OrangeColor;
        _dianImage.layer.cornerRadius = 5;
        _dianImage.clipsToBounds = YES;
        _dianImage.textColor = [UIColor whiteColor];
        _dianImage.font = MyFont(9);
        _dianImage.textAlignment = NSTextAlignmentCenter;
        _dianImage.text = [NSString stringWithFormat:@" %@ ",[NSUSER_Defaults objectForKey:@"messageTotalSum"]];
        _dianImage.hidden = YES;
        [_dianImage sizeToFit];
        [self addSubview:_dianImage];
        NSLog(@"**xtabbar****收到了透传消息*****");
    }
    _dianImage.text = [NSString stringWithFormat:@" %@ ",[NSUSER_Defaults objectForKey:@"messageTotalSum"]];
    [_dianImage sizeToFit];
}

-(void)imageState
{
    if (!_dianImage) {
        _dianImage = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3/4 - 30, 4, 10, 10)];
        _dianImage.backgroundColor = [WWTolls colorWithHexString:@"#ff3e2a"];
        _dianImage.layer.cornerRadius = 5;
        _dianImage.clipsToBounds = YES;
        _dianImage.textColor = [UIColor whiteColor];
        _dianImage.font = MyFont(9);
        _dianImage.textAlignment = NSTextAlignmentCenter;
//        _dianImage.image = [UIImage imageNamed:@"dian_20_20.png"];
        [self addSubview:_dianImage];
        NSLog(@"**xtabbar****收到了透传消息*****");
    }
    _dianImage.width = 10;
    _dianImage.height = 10;
    if(![[NSUSER_Defaults objectForKey:@"flwsum"] isKindOfClass:[NSDictionary class]]){
        [NSUSER_Defaults setObject:[NSDictionary dictionary] forKey:@"flwsum"];
    }
    _dianImage.text = [NSString stringWithFormat:@"%lu  ",((NSDictionary*)[NSUSER_Defaults objectForKey:@"newMessage"]).count + [((NSDictionary*)[NSUSER_Defaults objectForKey:@"flwsum"]) allKeys].count+[[NSUSER_Defaults objectForKey:@"inform"] intValue]+[[NSUSER_Defaults objectForKey:@"newmsgid"] intValue] + ([[NSUSER_Defaults objectForKey:@"groupinform"] isEqualToString:@"YES"]?1:0) ];
    _dianImage.hidden = NO;
    if([_dianImage.text isEqualToString:@"0  "])
       [self removeRedSpotImage];
    else _dianImage.text = @"";
    if (![[NSUSER_Defaults objectForKey:@"tabbarreddian"] isEqualToString:@"YES"]) {
        [self removeRedSpotImage];
    }
}

-(void)removeRedSpotImage
{
    _dianImage.hidden = YES;
    [NSUSER_Defaults removeObjectForKey:@"everyNotification"];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
