//
//  UIViewController+ShowAlert.m
//  zhidoushi
//
//  Created by xinglei on 14-9-23.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+ShowAlert.h"
#import "WWTolls.h"

static const NSUInteger UnLoginAlertViewTag = 1000;
static UIActivityIndicatorView* activityView = nil;
static UILabel* bgLabel = nil;
static UIActivityIndicatorView *activityIndica = nil;
static UIView *backView = nil;
static UILabel * textLabel = nil;
@implementation UIViewController (ShowAlert)


- (void)showAlertMsg:(NSString *)messae yOffset:(float)yOffset {
    UILabel *mylabel = (UILabel*)[self.view viewWithTag:11111];
    if (nil == mylabel) {
        mylabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
    mylabel.tag = 11111;
    mylabel.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7f];
    mylabel.textAlignment = NSTextAlignmentCenter;
    mylabel.textColor = [UIColor whiteColor];
    mylabel.text = messae;
    mylabel.opaque = NO;
    mylabel.numberOfLines = 0;
    mylabel.font = [UIFont boldSystemFontOfSize:16];
    CGSize size = [messae sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if (size.width>240) {
        size.width = 240;
        size.height*=2;
    }
    mylabel.frame =CGRectMake(SCREEN_MIDDLE(size.width)-10, 160+yOffset, size.width+20, size.height+20);
    mylabel.layer.cornerRadius = 10;
    mylabel.layer.masksToBounds = YES;
    if (nil == mylabel.superview) {
        [self.view addSubview:mylabel];
        [self.view bringSubviewToFront:mylabel];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(disappear:) userInfo:mylabel repeats:NO];
    }
}

-(void)showAlertMsg:(NSString *)messae verticalSpace:(CGFloat)verticalSpace timeInterval:(NSTimeInterval)time {
    
    UILabel *mylabel = (UILabel*)[self.view viewWithTag:11111];
    if (nil == mylabel) {
        mylabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
    mylabel.tag = 11111;
    mylabel.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7f];
    mylabel.textAlignment = NSTextAlignmentCenter;
    mylabel.textColor = [UIColor whiteColor];
    mylabel.text = messae;
    mylabel.opaque = NO;
    mylabel.numberOfLines = 0;
    mylabel.font = [UIFont boldSystemFontOfSize:16];
    //    CGSize constraint = CGSizeMake(frame.size.width, 20000.0f);
    //    CGSize size = [messae sizeWithFont:label.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    //    float height = MAX(frame.size.height, size.height);
    //    frame.size.height = height;
    //    label.frame = frame;
    CGSize size = [messae sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if (size.width>240) {
        size.width = 240;
        size.height*=2;
    }
    
    if (verticalSpace > 0) {
        size.height += verticalSpace * 2;
    }
    
    mylabel.frame =CGRectMake(SCREEN_MIDDLE(size.width)-10, SCREEN_HEIGHT_MIDDLE(size.height + 20) - 40, size.width+20, size.height+20);
    mylabel.layer.cornerRadius = 10;
    mylabel.layer.masksToBounds = YES;
    
    if (nil == mylabel.superview) {
        [self.view addSubview:mylabel];
        [self.view bringSubviewToFront:mylabel];
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(disappear:) userInfo:mylabel repeats:NO];
    }
}

-(void)showAlertMsg:(NSString *)messae andFrame:(CGRect)frame timeInterval:(NSTimeInterval)time {
    
    UILabel *mylabel = (UILabel*)[self.view viewWithTag:11111];
    if (nil == mylabel) {
        mylabel = [[UILabel alloc] initWithFrame:frame];
        
    }
    mylabel.tag = 11111;
    mylabel.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7f];
    mylabel.textAlignment = NSTextAlignmentCenter;
    mylabel.textColor = [UIColor whiteColor];
    mylabel.text = messae;
    mylabel.opaque = NO;
    mylabel.numberOfLines = 0;
    mylabel.font = [UIFont boldSystemFontOfSize:16];
    //    CGSize constraint = CGSizeMake(frame.size.width, 20000.0f);
    //    CGSize size = [messae sizeWithFont:label.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    //    float height = MAX(frame.size.height, size.height);
    //    frame.size.height = height;
    //    label.frame = frame;
    CGSize size = [messae sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if (size.width>240) {
        size.width = 240;
        size.height*=2;
    }
    mylabel.frame =CGRectMake(SCREEN_MIDDLE(size.width)-10, 160, size.width+20, size.height+20);
    mylabel.layer.cornerRadius = 10;
    mylabel.layer.masksToBounds = YES;
    if (nil == mylabel.superview) {
        [self.view addSubview:mylabel];
        [self.view bringSubviewToFront:mylabel];
        [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(disappear:) userInfo:mylabel repeats:NO];
    }
}   

-(void)showAlertMsg:(NSString *)messae andFrame:(CGRect)frame{
    
    UILabel *mylabel = (UILabel*)[self.view viewWithTag:11111];
    if (nil == mylabel) {
        mylabel = [[UILabel alloc] initWithFrame:frame];
        
    }
    mylabel.tag = 11111;
    mylabel.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7f];
    mylabel.textAlignment = NSTextAlignmentCenter;
    mylabel.textColor = [UIColor whiteColor];
    mylabel.text = messae;
    mylabel.opaque = NO;
    mylabel.numberOfLines = 0;
    mylabel.font = [UIFont boldSystemFontOfSize:16];
//    CGSize constraint = CGSizeMake(frame.size.width, 20000.0f);
//    CGSize size = [messae sizeWithFont:label.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//    float height = MAX(frame.size.height, size.height);
//    frame.size.height = height;
//    label.frame = frame;
    CGSize size = [messae sizeWithFont:[UIFont boldSystemFontOfSize:16]];
    if (size.width>240) {
        size.width = 240;
        size.height*=2;
    }
    mylabel.frame =CGRectMake(SCREEN_MIDDLE(size.width)-10, 160, size.width+20, size.height+20);
    mylabel.layer.cornerRadius = 10;
    mylabel.layer.masksToBounds = YES;
    if (nil == mylabel.superview) {
        [self.view addSubview:mylabel];
        [self.view bringSubviewToFront:mylabel];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(disappear:) userInfo:mylabel repeats:NO];
    }
}

- (void)showUnLoginAlertViewMsg:(NSString *)message titleOne:(NSString*)titleOne titleTwo:(NSString*)titleTwo title:(NSString*)title
{
    UIAlertView *noLogin = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:titleOne, titleTwo, nil];
    noLogin.tag = UnLoginAlertViewTag;
    [noLogin show];
}

- (void)showUnLoginAlertViewMsg:(NSString *)title message:(NSString*)message cacelTitle:(NSString*)cacelTitle
{
    UIAlertView *noLogin = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cacelTitle otherButtonTitles:nil, nil];
    noLogin.tag = 10010;
    [noLogin show];
}

-(void)disappear:(NSTimer*)timer{
    UILabel *label = [timer userInfo];
    if (label && [label isKindOfClass:[UILabel class]]) {
        [UIView animateWithDuration:1 animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished){
            [label removeFromSuperview];
        }];
    }
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

-(void)showErrorCode:(NSError *)error
{
    if (-1001 == [error code]) {
        [self showAlertMsg:@"网络请求超时" andFrame:CGRectMake(60, 100, 200, 60)];
    }
    else if (-1004 == [error code])
    {
        [self showAlertMsg:@"未能连接网络" andFrame:CGRectMake(60, 100, 200, 60)];
    }
    else if (-1009 == [error code])
    {
        [self showAlertMsg:@"没有网络" andFrame:CGRectMake(60, 100, 200, 60)];
    }
    else
    {
        [self showAlertMsg:@"网络异常" andFrame:CGRectMake(60, 100, 200, 60)];
    }
    
}


-(void)showActivityView:(NSString*)msg{
    if (nil == activityView) {
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.frame = CGRectMake(30, 30, 40, 40);
        activityView.hidesWhenStopped = NO;
    }
    if (nil == bgLabel) {
        bgLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 100, 100)];
        bgLabel.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.7f];
        bgLabel.textAlignment = NSTextAlignmentCenter;
        bgLabel.textColor = [UIColor whiteColor];
        bgLabel.numberOfLines = 0;
        bgLabel.opaque = NO;
        bgLabel.layer.cornerRadius = 5;
        [bgLabel addSubview:activityView];
    }
    bgLabel.text = [NSString stringWithFormat:@"\n\n%@",msg];
    [activityView startAnimating];
    
    if (bgLabel.subviews) {
        [bgLabel removeFromSuperview];
    }
    [self.view addSubview:bgLabel];
}

-(void)removeActivityView{
    if (activityView) {
        [activityView stopAnimating];
    }
    if (bgLabel) {
        [bgLabel removeFromSuperview];
    }
}

-(void)changeShowMsg:(NSString *)msg{
    if (msg.length > 0) {
        activityView.frame = CGRectMake(30, 15, 40, 40);
    }
    if (activityView) {
        [activityView stopAnimating];
    }
    if (bgLabel) {
        bgLabel.text = [NSString stringWithFormat:@"\n\n%@",msg];
        [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:.5];
    }
}


-(NSInteger)transformTime:(NSString*)time
{
    NSInteger year=0, month=0, date = 0;
    if (time.length > 4) {
        year = [[time substringToIndex:4] integerValue];
    }
    if (time.length > 6) {
        month = [[time substringWithRange:NSMakeRange(5, 2)] integerValue];
    }
    if (time.length > 10) {
        date = [[time substringWithRange:NSMakeRange(8, 2)] integerValue];
    }
    return year*365 + month*30 + date;
}

-(NSString*)transformNewTime:(NSString*)publishTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* time =  [dateFormatter stringFromDate:[NSDate date]];
    NSInteger currentTime  =  [self transformTime:time];
    
    NSInteger oldTime = [self transformTime:publishTime];
    switch (currentTime - oldTime) {
        case 0:
        {
            publishTime = [NSString stringWithFormat:@"今天%@",[publishTime substringWithRange:NSMakeRange(11, 5)] ];
        }
            break;
        case 1:
        {
            publishTime = [NSString stringWithFormat:@"昨天%@",[publishTime substringWithRange:NSMakeRange(11, 5)] ];
        }
            break;
        case 2:
        {
            publishTime = [NSString stringWithFormat:@"前天%@",[publishTime substringWithRange:NSMakeRange(11, 5)] ];
        }
            break;
        default:
        {
            publishTime = [publishTime substringWithRange:NSMakeRange(5, 11)];
        }
            break;
    }
    return publishTime;
}

#pragma mark - UIAlertViewDelegate -

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView.tag == UnLoginAlertViewTag) {
//        if (buttonIndex == 0) {
//            LoginViewController *login = [[LoginViewController alloc] init];
//            [self.navigationController pushViewController:login animated:YES];
//        }else if (buttonIndex == 1) {
//            
//        }
//    }
}

-(void)showWaitView
{
    backView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-90);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.layer.cornerRadius = 5;
    [self.view addSubview:backView];
    activityIndica = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndica.center = CGPointMake(backView.width/2, backView.height/2);
    [activityIndica startAnimating];
    [backView addSubview:activityIndica];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeWaitView];
        });
    });
}

-(void)showWaitView:(NSString*)text
{   
    backView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-90);
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    backView.layer.cornerRadius = 5;
    [self.view addSubview:backView];
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 60, 20)];
    textLabel.text = text;
    textLabel.font = MyFont(11);
    textLabel.textColor = [UIColor whiteColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:textLabel];
    activityIndica = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndica.center = CGPointMake(backView.width/2, backView.height/2);
    [activityIndica startAnimating];
    [backView addSubview:activityIndica];
}

-(void)removeWaitView
{
    [activityIndica stopAnimating];
    [activityIndica removeFromSuperview];
    [textLabel removeFromSuperview];
    [backView removeFromSuperview];
}

@end
