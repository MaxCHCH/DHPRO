//
//  ZDSPublishActivityViewController.m
//  zhidoushi
//
//  Created by licy on 15/5/21.
//  Copyright (c) 2015年 game.zhidoushi.com. All rights reserved.
//

#import "ZDSPublishActivityViewController.h"
#import "ZDSActDetailViewController.h"
#import "UITextView+LimitLength.h"
#import "PickerView+.h"
#import "NSObject+Date.h"

//接口
//发起活动
static NSString *ActPubAct = ZDS_Group_Pubact;

static NSString *PageTitle = @"约活动";
static NSString *PageName = @"约活动页面";
static NSString *CancelText = @"取消";
static NSString *PublishText = @"发布";


static NSString *ActivityTime = @"活动时间";
static NSString *ActivityPlace = @"活动地点";
static NSString *ActivityContent = @"活动内容";

//线颜色
static NSString *LineColor = @"#dcdcdc";
//label字体颜色 （活动时间、活动地点、活动内容）
static NSString *LabelColor = @"#535353";
//内容颜色
//static NSString *TextColor = @"#999999";
static NSString *TextColor = @"#c1c1c1";

static NSString *PlacePlaceHolder = @"自家垫子上  公园  任意地方 ……最多20字";
static NSString *ContentPlaceHolder = @"今晚不吃饭  慢跑5KM  深夜发吃 ……最多50字";

@interface ZDSPublishActivityViewController () <UITextViewDelegate,PickerViewDelegate>

@property (nonatomic,strong) NSDate *selectedDate;//选中年
@property (nonatomic,copy) NSString *selectTime;//选中时间
@property (nonatomic) BOOL haveClickPublish;//是否已经点击发布按钮

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *timeButton;
@property (nonatomic,strong) UIButton *timeDetailButton;
@property (nonatomic,strong) UIView *firstLine;
@property (nonatomic,strong) UILabel *placeLabel;
@property (nonatomic,strong) UITextView *placeTextView;
@property (nonatomic,strong) UILabel *placePlaceHolderLabel;
@property (nonatomic,strong) UIView *secondLine;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,strong) UILabel *contentPlaceHolderLabel;

@property (nonatomic,strong) UIView *thirdLine;

@property (nonatomic,strong) PickerView_ *yearPicker;
@property (nonatomic,strong) PickerView_ *timePicker;

@end

@implementation ZDSPublishActivityViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self p_addSubViews];
    [self p_setFrame];
    //键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}   

//添加子view
-(void)p_addSubViews {
    
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.timeButton];
    [self.view addSubview:self.timeDetailButton];
    [self.view addSubview:self.firstLine];
    [self.view addSubview:self.placeLabel];
    [self.view addSubview:self.placeTextView];
    [self.placeTextView addSubview:self.placePlaceHolderLabel];
    [self.view addSubview:self.secondLine];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.contentTextView];
    [self.contentTextView addSubview:self.contentPlaceHolderLabel];
    [self.view addSubview:self.thirdLine];
    
    [self.view addSubview:self.yearPicker];
    [self.view addSubview:self.timePicker];
}

//改变frame
- (void)p_setFrame {
    
    self.timeLabel.frame = CGRectMake(15, 20, 70, 20);
    self.timeButton.frame = CGRectMake(self.timeLabel.maxX + 5, self.timeLabel.midY - 20, 100, 40);
//    self.timeButton.backgroundColor = [UIColor redColor];
    self.timeDetailButton.frame = CGRectMake(self.timeButton.maxX + 10, self.timeButton.y, 70, self.timeButton.height);
    self.firstLine.frame = CGRectMake(10, self.timeButton.maxY + 10, SCREEN_WIDTH - 30, 0.5);
    
    self.placeLabel.frame = CGRectMake(self.timeLabel.x, self.firstLine.maxY + 10, self.timeLabel.width, self.timeLabel.height);
    self.placeTextView.frame = CGRectMake(self.timeButton.x, self.placeLabel.y, SCREEN_WIDTH - self.timeButton.x - 15, 50);
    self.placePlaceHolderLabel.frame = CGRectMake(5, 3, self.placeTextView.width - 10, 35);
    CGFloat secondLineHeight = 0.3;
    if (iPhone4) {
        secondLineHeight = 0.5;
    }
    self.secondLine.frame = CGRectMake(10, self.placeTextView.maxY + 10, SCREEN_WIDTH - 30, secondLineHeight);
    
    self.contentLabel.frame = CGRectMake(self.placeLabel.x, self.secondLine.maxY + 10, self.placeLabel.width, self.placeLabel.height);
    self.contentTextView.frame = CGRectMake(self.placeTextView.x, self.contentLabel.y, self.placeTextView.width,80);
    self.contentPlaceHolderLabel.frame = self.placePlaceHolderLabel.frame;
    self.thirdLine.frame = CGRectMake(10, self.contentTextView.maxY + 10, SCREEN_WIDTH - 30, 0.5);
    
    [self p_hiddenYearPickerWithYes:YES];
    [self p_hiddenTimePickerWithYes:YES];
}   

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:PageName];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //友盟打点
    [MobClick beginLogPageView:PageName];
    
    //广场标题
    self.titleLabel.text = PageTitle;
    self.titleLabel.font = MyFont(18);
    self.titleLabel.textColor = ZDS_DHL_TITLE_COLOR;
    
    //导航栏返回
    [self.leftButton setTitle:CancelText forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = MyFont(16);
    [self.leftButton addTarget:self action:@selector(popButton) forControlEvents:UIControlEventTouchUpInside];
    CGRect labelRect = self.leftButton.frame;
    labelRect.size.width = 40;
    labelRect.size.height = 16;
    self.leftButton.frame = labelRect;
    //导航栏发布
    [self.rightButton setTitle:PublishText forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = MyFont(16);
    [self.rightButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(activityPublishClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.width = 40;
    self.rightButton.height = 16;
    self.rightButton.enabled = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Delegate
#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView == self.contentTextView) {
        self.contentPlaceHolderLabel.hidden = textView.text.length > 0;
    } else if (textView == self.placeTextView) {
        self.placePlaceHolderLabel.hidden = textView.text.length > 0;
    }   
    
    [textView textFieldTextLengthLimit:nil];
}

#pragma mark PickerViewDelegate
//点击取消按钮
-(void)cancelBtn {
    [self p_hiddenYearPickerWithYes:YES];
    [self p_hiddenTimePickerWithYes:YES];
}

//时间 值的回调
-(void)pickerValue:(NSString*)str {
    NSLog(@"str:%@",str);
    self.selectTime = str;
}   

//年 值的回调
-(void)datePickerValue:(NSDate*)str {
    self.selectedDate = str;
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:self.selectedDate];
    NSLog(@"currentDateStr1:%@",currentDateStr1);
}   

//- (void)timeDatePickerValue:(NSString *)str {
//    self.selectTime = str;
//    NSLog(@"self.selectTime:%@",self.selectTime);
//}

//点击确认按钮
-(void)selectBtn:(PickerView_*)pick {
    
    //year
    if (pick.tag == 0) {
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        NSString *currentDateStr1 = [dateFormatter1 stringFromDate:self.selectedDate];
        
        [self.timeButton setTitle:currentDateStr1 forState:UIControlStateNormal];
        
        //是否为今天
        if ([NSObject compareOneDay:self.selectedDate withAnotherDay:[NSDate date]] == 0) {
            
            if (self.timeDetailButton.titleLabel.text.length > 4) {
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"HH:mm"];
                
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                
                //1:前边的大
                if ([dateString compare:self.selectTime] == 1) {
                    
                    NSDate *tempDate = [formatter dateFromString:dateString];
                    
                    //加十分钟
                    tempDate = [tempDate dateByAddingTimeInterval:10 * 60];
                    
                    self.selectTime = [formatter stringFromDate:tempDate];
                    [self.timeDetailButton setTitle:[formatter stringFromDate:tempDate] forState:UIControlStateNormal];
                }
            }
        }
        
        [self p_hiddenYearPickerWithYes:YES];
        
    } else {
        
        if (!(self.selectTime.length > 0)) {
            self.selectTime = [NSObject dateStringWithDate:[NSDate date] withDateType:SSL_HourAndMinute];
        }
        
        [self.timeDetailButton setTitle:self.selectTime forState:UIControlStateNormal];
        [self p_hiddenTimePickerWithYes:YES];
    }
}

#pragma mark - Event Responses
#pragma mark - 返回
-(void)popButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发布
- (void)activityPublishClick:(UIButton *)button {
    
    self.rightButton.userInteractionEnabled = NO;
    
//    if (!(self.timeButton.titleLabel
//          .text.length > 4)) {
//        [self showAlertMsg:@"请选择日期" andFrame:CGRectZero];
//        return;
//    }
    
//    NSString *place = [self.placeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    if (!(place.length > 0)) {
//        [self showAlertMsg:@"请选择活动地点" andFrame:CGRectZero];
//        return;
//    }
//    
    NSString *content = [self.contentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!(content.length > 0)) {
        [self showAlertMsg:@"请添加活动内容" andFrame:CGRectZero];
        return;
    }
    
    [self requestWithPubAct];
}

#pragma mark - 选择时间
- (void)timeButtonClick:(UIButton *)button {
    [self.view endEditing:YES];
    [self p_hiddenTimePickerWithYes:YES];
    [self p_hiddenYearPickerWithYes:NO];
}

#pragma mark - 选择详细时间
- (void)timeDetailButtonClick:(UIButton *)button {
    [self.view endEditing:YES];
    [self p_hiddenYearPickerWithYes:YES];
    [self p_hiddenTimePickerWithYes:NO];
}

#pragma mark - Private Methods

#pragma mark - Request
//发起活动
- (void)requestWithPubAct {
    
    [self showWaitView];
    
    //构造请求参数
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:self.groupId forKey:@"gameid"];
    
    //日期
    if (self.timeButton.titleLabel.text.length > 4) {
        NSString *actdate = self.timeButton.titleLabel.text;
        [dictionary setObject:actdate forKey:@"actdate"];
    }
    
    if (self.timeDetailButton.titleLabel.text.length > 4) {
        NSString *acttiming = [NSString stringWithFormat:@" %@:00",self.selectTime];
        [dictionary setObject:acttiming forKey:@"acttiming"];
    }
    
    NSString *place = [self.placeTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (place.length > 0) {
        [dictionary setObject:self.placeTextView.text forKey:@"place"];
    }
    
    [dictionary setObject:self.contentTextView.text forKey:@"content"];
    
    //发送请求即将开团
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ZDS_DEFAULT_HTTP_SERVER_HOST,ActPubAct];
    __weak typeof(self)weakSelf = self;
    
    [WWRequestOperationEngine operationManagerRequest_Post:urlString parameters:dictionary requestOperationBlock:^(NSDictionary *dic) {
        
        weakSelf.rightButton.userInteractionEnabled = YES;
        [weakSelf removeWaitView];
        if (![dic isKindOfClass:[NSDictionary class]] || dic==nil) {
            [weakSelf showAlertMsg:ZDS_NONET_HUASHU andFrame:CGRectZero];
        }else{
            
            if ([dic[@"result"] isEqualToString:@"0"]) {
                [weakSelf showAlertMsg:@"发布成功" andFrame:CGRectZero];
                if ([weakSelf.delegate respondsToSelector:@selector(sendSuccess)]) {
                    [weakSelf.delegate sendSuccess];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

//是否隐藏yearPicker
- (void)p_hiddenYearPickerWithYes:(BOOL)hidden {
    if (hidden) {
        [UIView animateWithDuration:0.2f animations:^{
            [self.yearPicker setFrame:CGRectMake(0, SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 200)];
        }];
    } else {
        [UIView animateWithDuration:0.2f animations:^{
            [self.yearPicker setFrame:CGRectMake(0, SCREEN_HEIGHT - 200 - self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 200)];
        }];
    }
}

//是否隐藏timePicker
- (void)p_hiddenTimePickerWithYes:(BOOL)hidden {
    if (hidden) {
        //隐藏
        [UIView animateWithDuration:0.2f animations:^{      
            [self.timePicker setFrame:CGRectMake(0, SCREEN_HEIGHT - self.navigationController.navigationBar.frame.size.height, self.view.   frame.size.width, 200)];
        }];
    } else {
        //显示
        NSString *temp = nil;
        if (self.timeDetailButton.titleLabel.text.length > 4) {
            temp = self.selectTime;
        }
        [self.timePicker limitTimeWithSelectDate:self.selectedDate timeString:temp];
        [UIView animateWithDuration:0.2f animations:^{
            [self.timePicker setFrame:CGRectMake(0, SCREEN_HEIGHT - 200 - self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 200)];
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self p_hiddenTimePickerWithYes:YES];
    [self p_hiddenYearPickerWithYes:YES];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}   

#pragma mark - NSNotification
- (void)keyBoardWillShow:(NSNotification *)note {
    [self p_hiddenYearPickerWithYes:YES];
    [self p_hiddenTimePickerWithYes:YES];
}

- (void)keyBoardWillHide:(NSNotification *)note {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - Getters And Setters
- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = MyFont(14.0);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.text = ActivityTime;
        _timeLabel.textColor = [WWTolls colorWithHexString:LabelColor];
    }
    return _timeLabel;
}   

- (UIButton *)timeButton {
    if (_timeButton == nil) {
        _timeButton = [[UIButton alloc] init];
        [_timeButton setTitle:@"选择日期" forState:UIControlStateNormal];
        [_timeButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
        _timeButton.titleLabel.font = MyFont(14.0);
        [_timeButton addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _timeButton.backgroundColor = [UIColor clearColor];
    }
    return _timeButton;
}

- (UIButton *)timeDetailButton {
    if (_timeDetailButton == nil) {
        _timeDetailButton = [[UIButton alloc] init];
        [_timeDetailButton setTitle:@"选择时间" forState:UIControlStateNormal];
        [_timeDetailButton setTitleColor:[WWTolls colorWithHexString:@"#959595"] forState:UIControlStateNormal];
        _timeDetailButton.titleLabel.font = MyFont(14.0);
        _timeDetailButton.backgroundColor = [UIColor clearColor];
        [_timeDetailButton addTarget:self action:@selector(timeDetailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }   
    return _timeDetailButton;
}

- (UIView *)firstLine {
    if (_firstLine == nil) {
        _firstLine = [[UIView alloc] init];
        _firstLine.backgroundColor = [WWTolls colorWithHexString:LineColor];
    }
    return _firstLine;
}

- (UILabel *)placeLabel {
    if (_placeLabel == nil) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.text = ActivityPlace;
        _placeLabel.textAlignment = NSTextAlignmentLeft;
        _placeLabel.font = MyFont(14.0);
        _placeLabel.textColor = [WWTolls colorWithHexString:LabelColor];
    }
    return _placeLabel;
}

- (UITextView *)placeTextView {
    if (_placeTextView == nil) {
        _placeTextView = [[UITextView alloc] init];
        _placeTextView.backgroundColor = [UIColor clearColor];
        _placeTextView.delegate = self;
        _placeTextView.font = MyFont(14.0);
        [_placeTextView limitTextLength:20];
        _placeTextView.textColor = [WWTolls colorWithHexString:@"#959595"];
    }
    
    return _placeTextView;
}

- (UILabel *)placePlaceHolderLabel {
    if (_placePlaceHolderLabel == nil) {
        _placePlaceHolderLabel = [[UILabel alloc] init];
        _placePlaceHolderLabel.text = PlacePlaceHolder;
        _placePlaceHolderLabel.numberOfLines = 0;
        _placePlaceHolderLabel.font = MyFont(14);
        _placePlaceHolderLabel.textColor = [WWTolls colorWithHexString:TextColor];
    }
    return _placePlaceHolderLabel;
}

- (UIView *)secondLine {
    if (_secondLine == nil) {
        _secondLine = [[UIView alloc] init];
        _secondLine.backgroundColor = [WWTolls colorWithHexString:LineColor];
    }
    return _secondLine;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = ActivityContent;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = MyFont(14.0);
        _contentLabel.textColor = [WWTolls colorWithHexString:LabelColor];
    }
    return _contentLabel;
}

- (UITextView *)contentTextView {
    if (_contentTextView == nil) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.delegate = self;
        _contentTextView.font = MyFont(14.0);
        _contentTextView.textColor = [WWTolls colorWithHexString:@"#959595"];
        [_contentTextView limitTextLength:50];
    }
    return _contentTextView;
}

- (UILabel *)contentPlaceHolderLabel {
    if (_contentPlaceHolderLabel == nil) {
        _contentPlaceHolderLabel = [[UILabel alloc] init];
        _contentPlaceHolderLabel.text = ContentPlaceHolder;
        _contentPlaceHolderLabel.numberOfLines = 0;
        _contentPlaceHolderLabel.font = MyFont(14);
        _contentPlaceHolderLabel.textColor = [WWTolls colorWithHexString:TextColor];
    }
    return _contentPlaceHolderLabel;
}

- (UIView *)thirdLine {
    if (_thirdLine == nil) {
        _thirdLine = [[UIView alloc] init];
        _thirdLine.backgroundColor = [WWTolls colorWithHexString:LineColor];
    }
    
    return _thirdLine;
}

- (PickerView_ *)yearPicker {
    if (_yearPicker == nil) {
        _yearPicker = [[PickerView_ alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NavHeight - 200, SCREEN_WIDTH, 200) withType:yearType];
        _yearPicker.pickDelegate = self;
        _yearPicker.tag = 0;
        NSDate *date = [NSDate date];
        [_yearPicker.dataPicker setMinimumDate:date];
        [_yearPicker.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        
        self.selectedDate = date;
        self.yearPicker.dataPicker.maximumDate = [date dateByAddingTimeInterval:60*60*24*7];
        
    }
    return _yearPicker;
}

- (PickerView_ *)timePicker {
    
    if (_timePicker == nil) {
        _timePicker = [[PickerView_ alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - NavHeight, SCREEN_WIDTH, 200) withType:timeType withDate:self.selectedDate];
        _timePicker.pickDelegate = self;
        _timePicker.tag = 1;
    }
    return _timePicker;
}   



@end











