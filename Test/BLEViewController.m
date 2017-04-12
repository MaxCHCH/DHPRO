//
//  BLEViewController.m
//  Test
//
//  Created by Rillakkuma on 16/6/6.
//  Copyright © 2016年 Rillakkuma. All rights reserved.
//

#import "BLEViewController.h"
#import <Availability.h>
#import "Masonry.h"
//#import "DeviceViewController.h"
#import "TestTableViewController.h"
#import "JSTextView.h"
#import <CoreTelephony/CoreTelephonyDefines.h>
#import "AFNetworking.h"

#define URLMAIN  @"http://zkhb.homesoft.cn/"
#define API_BASE_URL(_URL_)  [NSString stringWithFormat:@"%@WebService/jsonInterface.ashx?json=%@",URLMAIN,_URL_]

#import "InfiniteRollScrollView.h"
#import "ImageModel.h"
extern NSString *CTSettingCopyMyPhoneNumber();

enum {
    // iPhone 1,3,3GS 标准分辨率(320x480px)
    UIDevice_iPhoneStandardRes      = 1,
    // iPhone 4,4S 高清分辨率(640x960px)
    UIDevice_iPhoneHiRes            = 2,
    // iPhone 5 高清分辨率(640x1136px)
    UIDevice_iPhoneTallerHiRes      = 3,
    // iPad 1,2 标准分辨率(1024x768px)
    UIDevice_iPadStandardRes        = 4,
    // iPad 3 High Resolution(2048x1536px)
    UIDevice_iPadHiRes              = 5
}; typedef NSUInteger UIDeviceResolution;




@interface BLEViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,infiniteRollScrollViewDelegate>
{
    NSArray *array,*array2;
    int flag;
    UITextField *textName;
    UIView *viewBackGround;
    UIButton *anbtn;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIButton *Scan;
@property (weak, nonatomic) IBOutlet UIButton *Print;

@end



#define DeviceWidth [UIScreen mainScreen].bounds.size.width
#define DeviceHeight [UIScreen mainScreen].bounds.size.height

@implementation BLEViewController
//@synthesize sensor;
//@synthesize Scan;
+(NSString *)myNumber{
    
    return CTSettingCopyMyPhoneNumber();
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _tableV.hidden = YES;
    
    NSLog(@"%f-%f-%f",self.view.frame.size.height,self.view.bounds.size.height,[UIScreen mainScreen].bounds.size.height);
    
    if (DeviceHeight==480) {
        NSLog(@"%s",__FUNCTION__);
    } if (DeviceHeight == 536){
        NSLog(@"%s",__FUNCTION__);//iPhone5
    }
    if (DeviceHeight == 568){
        NSLog(@"%s",__FUNCTION__);//iPhone5s
    }
    if (DeviceHeight == 667){
        NSLog(@"%s",__FUNCTION__);//iPhone6 6s
    }
     if (DeviceHeight == 736){
        NSLog(@"%s",__FUNCTION__);//6p 6sp
    }
    NSLog(@"%f",[UIScreen mainScreen].bounds.size.height);
    
    
//    __weak typeof (self) weakSelf = self;
//    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
//    }

    NSString *s = [NSString stringWithFormat:@"%@asdf",URLMAIN];
    NSLog(@"%@",s);
    //        NSString *urlll =[NSString stringWithFormat:@"%@&id=%@",API_BASE_URL(@"GetRepairDetail"),_RepairID];

    NSLog(@"手机号码 %@",[BLEViewController myNumber]);
    _leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [_leftSwipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    
    [[self view] addGestureRecognizer:_leftSwipeGestureRecognizer];
    _peripheralViewControllerArray = [[NSMutableArray alloc] init];

    UInt8 bytes[24];
    
    for(int i=0; i<24; i++){
        bytes[i] = i;
    }
    
    UInt8 lockType, activeYear, activeMonth, activeDay;
    UInt16 keyId, activeNumb;
    UInt32 lockId;
    
    lockId = 4000;
    lockType = 0;
    activeYear = 15;
    activeMonth = 7;
    activeDay = 30;
    keyId = 2000;
    activeNumb = 5;
    
    flag = 1;
    
//    UIView *superview = self.view;
//    
//    UIView *view1 = [[UIView alloc] init];
//    view1.translatesAutoresizingMaskIntoConstraints = NO;
//    view1.backgroundColor = [UIColor greenColor];
//    [superview addSubview:view1];
//    
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(superview);
//        make.size.mas_equalTo(CGSizeMake(300, 300));
//    }];
    
    
    JSTextView *textView = [[JSTextView alloc]initWithFrame:CGRectMake(0, 149, DeviceWidth, 120)];
    //1.设置提醒文字
    textView.layer.borderColor = [UIColor redColor].CGColor;
    textView.layer.borderWidth = 0.3;
    textView.myPlaceholder= @"分享新鲜事...";
    
    //2.设置提醒文字颜色
    
    textView.myPlaceholderColor= [UIColor redColor];
    
    [self.view addSubview:textView];

    [self loadData];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(aaaaaaa) forControlEvents:(UIControlEventTouchUpInside)];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(10, 186, 50, 50);
    [self.view addSubview:button];
    array = @[@"时间地方",@"氨基酸的",@"AIDS",@"爱学",
                       @"比屋而封",@"啊防护等级撒",@"阿斯顿",@"卡戴珊覅",
                       @"你骄傲的",@"不雅",@"额外调查",@"卡丁车"];
    
    array2 = @[@"阿萨德地方",@"束带结发的",@"iun",@"爱那就",
              @"比屋觉得女警爱封",@"而无办法级撒",@"我放假饿",@"i32fj",
              @"2哦哦诶积分",@"饿哦妇女",@"爱发呆呢查",@"就i"];
    
    
    
    UIImageView *imageViewM;
    for (int i = 0; i<3; ++i) {
        imageViewM = [[UIImageView alloc]init];
        imageViewM.backgroundColor = [UIColor redColor];
//        imageViewM.frame = CGRectMake(i*((DeviceWidth-20)/3)+13, 80, ((DeviceWidth-20)/3)-10, ((DeviceWidth-20-20)/3)-10);
        imageViewM.frame = CGRectMake(10+i*(40+10), 80, 40, 40);
//        imageViewM.frame = CGRectMake(10, 80, 50, 50);
        [self.view addSubview:imageViewM];

    }
    /**
     *  图片轮播
     *
     *  @return return value description
     */
    InfiniteRollScrollView *scrollView = [[InfiniteRollScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    scrollView.delegate = self;
    scrollView.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    scrollView.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    
    //需要显示的所有图片
//    for (int i = 0 ;i<7;i++){
//        [scrollView.imageArray arrayByAddingObject:[UIImage imageNamed:[NSString stringWithFormat:@"%i",i+1]]];
//    }
    
    scrollView.imageArray = @[
                              [UIImage imageNamed:@"01"],
                              [UIImage imageNamed:@"02"],
                              [UIImage imageNamed:@"03"],
                              [UIImage imageNamed:@"04"],
                              [UIImage imageNamed:@"05"],
                              [UIImage imageNamed:@"06"],
                              [UIImage imageNamed:@"07"],
                              [UIImage imageNamed:@"08"]
                              ];
    //需要显示的所有图片对应的信息，这里我们是手动添加的每张图片的信息，实际环境一般都是由服务器返回，我们再封装到model里面。
    scrollView.imageModelInfoArray = [NSMutableArray array];
    for (int i = 0; i<scrollView.imageArray.count; i++) {
        ImageModel *mode = [[ImageModel alloc]init];
        mode.name = [NSString stringWithFormat:@"picture-%zd",i];
        mode.url = [NSString stringWithFormat:@"http://www.baidu.com-%zd",i];
        [scrollView.imageModelInfoArray addObject:mode];
    }
    
    [self.view addSubview:scrollView];
    
    
    //背景图片
    viewBackGround = [[UIView alloc]init];
    viewBackGround.frame  =CGRectMake(0,DeviceHeight-300 , DeviceWidth, 150);
    viewBackGround.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    [self.view addSubview:viewBackGround];
//[viewBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.bottom.equalTo(self.view).width.offset(-10);
//}];
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = viewBackGround.bounds;
    
    [viewBackGround addSubview:visualEffectView];
    

    //开锁按钮
    anbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [anbtn setFrame:CGRectMake(DeviceWidth/2-32, /*[UIScreen mainScreen].bounds.size.height-350*/ viewBackGround.frame.origin.y-34, 64, 64)];
//    anbtn.frame =CGRectMake(25,[UIScreen mainScreen].bounds.size.height-250,26,26);
    [anbtn addTarget:self action:@selector(SendOpenDoor:) forControlEvents:(UIControlEventTouchUpInside)];
    anbtn.backgroundColor=[UIColor colorWithWhite:1.000 alpha:0.500];
    anbtn.layer.masksToBounds =NO;
    [anbtn setImage:[UIImage imageNamed:@"openDoor"] forState:(UIControlStateNormal)];
//    anbtn.layer.frame = CGRectMake(25,[UIScreen mainScreen].bounds.size.height-250,26,26);
    anbtn.layer.borderColor = [UIColor blackColor].CGColor;
    anbtn.layer.cornerRadius=10;
    anbtn.layer.shadowOffset = CGSizeMake(0, 5); //设置阴影的偏移量
    anbtn.layer.shadowRadius = 10;  //设置阴影的半径
    anbtn.layer.shadowColor = [UIColor blackColor].CGColor; //设置阴影的颜色为黑色
    anbtn.layer.shadowOpacity = 1; //设置阴影的不透明度
    [self.view addSubview:anbtn];
    
    NSLog(@"%f-",anbtn.frame.origin.y);
    
    
    //手机输入框
    textName = [[UITextField alloc] initWithFrame:CGRectMake(viewBackGround.center.x-150, anbtn.frame.origin.y+80, 300, 50)];
    textName.delegate = self;
    textName.placeholder = @"输入授权手机号";
    textName.textAlignment = NSTextAlignmentCenter;
    textName.textColor = [UIColor blackColor];
    textName.font = [UIFont systemFontOfSize:20];
    UIColor *color = [UIColor colorWithWhite:0.224 alpha:1.000];
    textName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:textName.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    textName.backgroundColor = [UIColor clearColor];       //背景颜色
    [self.view addSubview:textName];
    
    //横线
    UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(15, textName.frame.origin.y+60, DeviceWidth-30, 1)];
    labelName.backgroundColor = [UIColor colorWithWhite:0.642 alpha:0.820];       //背景颜色
    [self.view addSubview:labelName];
    
    //提示语
    UILabel *disp = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/2-26, labelName.frame.origin.y+6, 54, 20)];
    disp.backgroundColor = [UIColor clearColor];       //背景颜色
    disp.textColor = [UIColor colorWithWhite:0.532 alpha:1.000];             //字体颜色 默认为RGB 0,0,0
    disp.numberOfLines = 0;                            //行数 0为无限 默认为1
    disp.textAlignment = NSTextAlignmentCenter;        //对齐方式 默认为左对齐
    disp.font = [UIFont systemFontOfSize:12];          //设置字体及字体大小
    disp.text = @"华博-开门";                            //设置显示内容
    [self.view addSubview:disp];
    
    
    
    NSString *number = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
    NSLog(@"%@",number);

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)SendOpenDoor:(UIButton *)sender{
    if ([textName.text isEqualToString:@""]) {
        NSLog(@"空");
        
    }
    else {
        NSLog(@"有");
        [self loadSData];
    }
}
- (void)loadSData{
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        NSString *urlll =[NSString stringWithFormat:@"http://182.48.116.140/CloudHomeCS/houseInterface.ashx?json=VisitorVerify&Code=%@",textName.text];
//        NSURL *zoneUrl = [NSURL URLWithString:urlll];
//        NSError * error;
//        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:&error];
//        if (zoneStr != nil) {
//            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (dic[@"result"]==false) {
////                    [MBProgressHUD showError:dic[@"content"]];
//                }
//                else{
////                    [MBProgressHUD showError:dic[@"content"]];
//                }
//                NSLog(@"数据室1%@",dic);
//            });
//        }else {
//            NSLog(@"error when download:%@", error);
//        }
//    });
        NSString *urlll =[NSString stringWithFormat:@"http://182.48.116.140/CloudHomeCS/houseInterface.ashx?json=VisitorVerify&Code=%@",textName.text];

    
       NSURL *url=[NSURL URLWithString:urlll];
   
   //    2.创建请求对象
    NSURLRequest *request=[NSURLRequest requestWithURL:url];

    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
        if (connectionError == nil) {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            // num = 2
            NSLog(@"%@ %@", str, [NSThread currentThread]);
            
            
            
            NSDictionary* json = [NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:kNilOptions
                                  error:nil];
            
//未授权  0  授权  1
            if ([json[@"result"] isEqual:[NSNumber numberWithUnsignedInt:1]]) {
                NSLog(@"33333%@",json[@"content"]);
                [self openDoor];

            }
            else{
                NSLog(@"44444%@",json[@"content"]);//未收群
                
            }
            NSLog(@"-------------1----------%@",json[@"result"]);
            
            // 更新界面13581920849
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                self.logonResult.text = @"登录完成";
                NSLog(@"success");
            }];
        
        }
    }];
    
    
    
}
- (void)openDoor{
    NSLog(@"一开门");
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textName resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [textName resignFirstResponder];
    [self.view endEditing:YES];
}
//代理方法
-(void)infiniteRollScrollView:(InfiniteRollScrollView *)scrollView tapImageViewInfo:(id)info{
    ImageModel *model = (ImageModel *)info;
    NSLog(@"name:%@---url:%@", model.name, model.url);
}

- (void)loadData{
    NSString *URL =[NSString stringWithFormat:@"%@",API_BASE_URL(@"GetType")];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSLog(@"这里打印请求成功要做的事%@",responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      NSLog(@"%@",error);  //这里打印错误信息

    }];
//    [manager POST:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//    }
//          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//              
//              NSLog(@"这里打印请求成功要做的事");
//          }
//     
//          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
//              
//              NSLog(@"%@",error);  //这里打印错误信息
//              
//          }];

}
- (void)aaaaaaa{
    TestTableViewController *testVC = [[TestTableViewController alloc]init];
    [self presentViewController:testVC animated:YES completion:^{
        
    }];
}
- (IBAction)openDoor:(UIButton *)sender {
    flag = 1;
    _tableV.hidden = NO;
    [_tableV reloadData];
    
    
    [UIView animateWithDuration:0.3f animations:^{
        self.tableV.frame = CGRectMake(0, -self.view.frame.size.height,self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {

        self.tableV.frame = CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height);

        
    }];

    
    
    
}
- (IBAction)OOO:(UIButton *)sender {
    flag = 2;
    _tableV.hidden = NO;
    [_tableV reloadData];
}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return flag == 1 ? array.count:array2.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (flag) {
        case 1:
            
            [_Scan setTitle:[array objectAtIndex:indexPath.row] forState:(UIControlStateNormal)];

            break;
        case 2:
            [_Print setTitle:[array2 objectAtIndex:indexPath.row] forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
    _tableV.hidden = YES;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    switch (flag) {
        case 1:
            cell.textLabel.text = array[indexPath.row];
            break;
        case 2:
            cell.textLabel.text = array2[indexPath.row];
            break;
            
        default:
            break;
    }
   
    return cell;
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
