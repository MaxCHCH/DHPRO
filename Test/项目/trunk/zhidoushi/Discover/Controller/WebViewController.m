//
//  WebViewController.m
//  zhidoushi
//
//  Created by nick on 15/5/7.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "WebViewController.h"
#import "NARShareView.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"游览器页面"];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:@"游览器页面"];
    //导航栏标题
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    self.titleLabel.font = MyFont(18);
    //导航栏返回
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fh-36"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.leftButton.frame = CGRectMake(0, 0, 18, 18);
    self.leftButton.titleLabel.font = MyFont(13);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    //导航栏分享
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"fx-c-36"] forState:UIControlStateNormal];
    self.rightButton.width = 18;
    self.rightButton.height = 18;
    [self.rightButton addTarget:self action:@selector(shareWeb) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 分享
- (void)shareWeb{
    NARShareView *myshareView = [[NARShareView alloc]initWithFrame:self.view.bounds];
//    myshareView.narDelegate = self;
    [myshareView createView:NotifyHTMLShareType withModel:nil withGroupModel:nil];
}

#pragma mark - 返回上一级
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.titleLabel.text = @"加载中...";
    UIWebView *webview = [[UIWebView alloc] init];
    webview.backgroundColor = [UIColor clearColor];
    webview.scrollView.scrollEnabled = YES;
    [self.view addSubview:webview];
    webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);;
    webview.delegate = self;
    [webview setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = (UIScrollView *)[[webview subviews] objectAtIndex:0];
    scrollView.bounces = NO;
    self.URL = [self.URL stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSURL *url = [[NSURL alloc]initWithString:self.URL];
    [NSUSER_Defaults setObject:[self.URL stringByReplacingOccurrencesOfString:@"&appflg=0" withString:@"&appflg=1"] forKey:@"htmlshareHtml"];
    [webview loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.titleLabel.text = @"加载中...";
    NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)web{
    NSString *theTitle=[web stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.titleLabel.text = theTitle;
    NSLog(@"webViewDidFinishLoad");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

-(void)webView:(UIWebView*)webView  DidFailLoadWithError:(NSError*)error{
    self.titleLabel.text = @"加载失败";
    [self showAlertMsg:@"加载失败" yOffset:0];
    NSLog(@"DidFailLoadWithError");
}



@end
