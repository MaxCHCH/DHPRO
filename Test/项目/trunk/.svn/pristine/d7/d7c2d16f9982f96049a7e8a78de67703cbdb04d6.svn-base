//
//  PickerView+.m
//  zhidoushi
//
//  Created by xinglei on 14-9-19.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import "PickerView+.h"
#import "WWTolls.h"
#import "NSObject+Date.h"

static NSString * weight1String = nil;
static NSString * weight2String = nil;

@implementation PickerView_

- (id)initWithFrame:(CGRect)frame withType:(pickerViewType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        if (type==heightType) {
            
            self.heightArr = [[NSMutableArray alloc] init];
            
            for (int i = 100; i < 230; i++)
            {
                [self.heightArr addObject:[NSString stringWithFormat:@"%dcm",i]];
            }   

            self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 180)];
            self.pickerView.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            self.pickerView.showsSelectionIndicator = YES;
            [self addSubview:self.pickerView];
            
        }
        
        if (type==wightType) {
        
            self.weightfirArr = [[NSMutableArray alloc] init];

            self.weightfir2Arr = [[NSMutableArray alloc]initWithCapacity:10];

            for (int i = 25; i < 200; i++)
            {
                [self.weightfirArr addObject:[NSString stringWithFormat:@"%d",i]];
            }

            for (int i=0; i<10; i++) {
                [self.weightfir2Arr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            
            self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 180)];
            self.pickerView.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
            [self.pickerView selectRow:20 inComponent:0 animated:YES];
            if ([NSUSER_Defaults objectForKey:ZDS_LAST_WEIGHT]!=nil) {
                int kg = [[NSUSER_Defaults objectForKey:ZDS_LAST_WEIGHT] intValue];
                float g =[[NSUSER_Defaults objectForKey:ZDS_LAST_WEIGHT] floatValue];
                for (; g>1; ) {
                    g--;
                }
                int gg = g*10;
                if (gg/10.0+0.09<g) {//精度损失
                    gg++;
                }   
                if(gg>=10) gg-=10;
                [self.pickerView selectRow:kg-25 inComponent:0 animated:YES];
                [self.pickerView selectRow:gg inComponent:1 animated:YES];
            }
            
            self.pickerView.showsSelectionIndicator = YES;
            [self addSubview:self.pickerView];

            UILabel* kgLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pickerView.width/2, self.pickerView.height/2-10, 20, 20)];
            kgLabel.font = [UIFont systemFontOfSize:16];
            kgLabel.textColor = [UIColor blackColor];
            kgLabel.backgroundColor = [UIColor clearColor];
            kgLabel.text = @".";
            [self.pickerView addSubview:kgLabel];
            UILabel* gLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.pickerView.width-40, self.pickerView.height/2-10, 50, 20)];
            gLabel.font = [UIFont systemFontOfSize:16];
            gLabel.textColor = [UIColor blackColor];
            gLabel.backgroundColor = [UIColor clearColor];
            gLabel.text = @"KG";
            [self.pickerView addSubview:gLabel];
        }
        
        if (type == timeType) {
            
//            self.dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 180)];
//            self.dataPicker.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
//            [self.dataPicker setDatePickerMode:UIDatePickerModeTime];
//            [self.dataPicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
//            [self.dataPicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
//            self.dataPicker.tag = 1;
//
//            [self limitTimeWithSelectDate:self.selectDate];
//            
//            [self addSubview:self.dataPicker];
            
            self.timeArray = [[NSMutableArray alloc] init];
            self.time2Array = [[NSMutableArray alloc] init];
            
            for (int i = 0; i <= 23; i++)
            {
                [self.timeArray addObject:[NSString stringWithFormat:@"%02d",i]];
            }
            
            for (int i = 0; i <= 59; i++) {
                [self.time2Array addObject:[NSString stringWithFormat:@"%02d",i]];
            }
            
            self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 180)];
            self.pickerView.backgroundColor = [WWTolls colorWithHexString:@"#eeeeee"];
            self.pickerView.delegate = self;
            self.pickerView.dataSource = self;
            
            [self limitTimeWithSelectDate:self.selectDate timeString:nil];
            
//            NSDate *tempDate = [self.selectDate dateByAddingTimeInterval:60 * 10];
//            
//            NSString *selectDateStr = [NSObject dateStringWithDate:self.selectDate withDateType:SSL_Date];
//            NSString *currentDateStr = [NSObject dateStringWithDate:[NSDate date] withDateType:SSL_Date];
//            
//            NSString *hour = [NSObject dateStringWithDate:tempDate withDateType:SSL_HourDate];
//            NSString *minute = [NSObject dateStringWithDate:tempDate withDateType:SSL_MinuteDate];
//            
//            if ([selectDateStr isEqualToString:currentDateStr]) {
//                [self.pickerView selectRow:hour.integerValue inComponent:0 animated:YES];
//                [self.pickerView selectRow:minute.integerValue inComponent:1 animated:YES];
//            }
            
//            [self.pickerView selectRow:hour.integerValue inComponent:0 animated:NO];
//            [self.pickerView selectRow:minute.integerValue inComponent:1 animated:NO];
            
            [self addSubview:self.pickerView];
            self.pickerView.showsSelectionIndicator = YES;
            
//            [self.pickerView selectRow:9 inComponent:1 animated:NO];
        }
        
      if (type==yearType) {
          
          _dataPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 180)];
          //日期模式
          [_dataPicker setDatePickerMode:UIDatePickerModeDate];
          //定义最小日期
          NSDateFormatter *formatter_minDate = [[NSDateFormatter alloc] init];
          [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
          NSDate *minDate = [formatter_minDate dateFromString:@"1900-01-01"];
          formatter_minDate = nil;
          //最大日期是今天
          NSDate *maxDate = [NSDate date];
          
          [_dataPicker setMinimumDate:minDate];
          [_dataPicker setMaximumDate:maxDate];
          [_dataPicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
          [self addSubview:_dataPicker];
          
        }
        [self layoutSub];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withType:(pickerViewType)type withDate:(NSDate *)currentDate {
    
    self.selectDate = currentDate;
    self = [self initWithFrame:frame withType:type];
    if (self) {
//        [self.pickerView selectRow:10 inComponent:0 animated:YES];
    }
    return self;
}

-(void)layoutSub{

    [self setBackgroundColor:[WWTolls colorWithHexString:@"#eeeeee"]];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    [_cancelBtn setFrame:CGRectMake(0, 10, 50, 20)];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelBtnSender) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_cancelBtn];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.backgroundColor = [UIColor clearColor];
    [_selectBtn setFrame:CGRectMake(self.frame.size.width - 50, 10, 50, 20)];
    [_selectBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_selectBtn addTarget:self action:@selector(selectBtnSender) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_selectBtn];

//    if(self.pickerType==yearType){
//
//
//    }else{
//      }
}

-(void)dataValueChanged:(UIDatePicker*)sender{
    
    if (sender.tag == 1) {
        if ([self.pickDelegate respondsToSelector:@selector(timeDatePickerValue:)]) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *temp = [dateFormatter stringFromDate:sender.date];
            [self.pickDelegate timeDatePickerValue:temp];
        }
        
    } else {
        if ([self.pickDelegate respondsToSelector:@selector(datePickerValue:)]) {
            [self.pickDelegate datePickerValue:sender.date];
        }
    }
    
}   

-(void)cancelBtnSender{
    if ([self.pickDelegate respondsToSelector:@selector(cancelBtn)]) {
        [self.pickDelegate cancelBtn];
    }
}

-(void)selectBtnSender{

    if ([self.pickDelegate respondsToSelector:@selector(selectBtn:)]) {
        [self.pickDelegate selectBtn:self];
//        [self.pickDelegate datePickerValue:_dataPicker.date];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([self.weightfirArr count]) {
        
        return 2;
    } else if ([self.timeArray count]) {
        
        return 2;
    } else {
        return 1;
    }
}   

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    unsigned long count = 0;
    
    if ([self.weightfirArr count]) {
        if (component==0) {
            count  = [self.weightfirArr count];
        }
        if (component==1) {
            count  = [self.weightfir2Arr count];
        }
    }
    else if([self.yearArray count]){
        count  = [self.yearArray count];
    }
    else if ([self.timeArray count]) {
        if (component == 0) {
            return self.timeArray.count;
        } else {
            return self.time2Array.count;
        }
    }
    else{
        count = [self.heightArr count];
    }
    return count;
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    if ([self.weightfirArr count]) {

        if (component == 0)
        {
            weight1String = [NSString stringWithFormat:@"%@",[self.weightfirArr objectAtIndex:row]];
            [self getWeightString];
            return [self.weightfirArr objectAtIndex:row];
        }
        else{
             weight2String = [NSString stringWithFormat:@"%@",[self.weightfir2Arr objectAtIndex:row]];
            [self getWeightString];
            return [self.weightfir2Arr objectAtIndex:row];
        }
    }
    else if ([self.heightArr count]){
        [self.pickDelegate pickerValue:[self.heightArr objectAtIndex:row]];
        return [self.heightArr objectAtIndex:row];
    }
    else if ([self.timeArray count]){
        if (component == 0) {
            NSInteger minute = [pickerView selectedRowInComponent:1];
            [self.pickDelegate pickerValue:[NSString stringWithFormat:@"%@:%@",self.timeArray[(NSUInteger)row],self.time2Array[minute]]];
            return [NSString stringWithFormat:@"%@时",[self.timeArray objectAtIndex:row]];
        } else {
            NSInteger second = [pickerView selectedRowInComponent:0];
            [self.pickDelegate pickerValue:[NSString stringWithFormat:@"%@:%@",self.timeArray[second],self.time2Array[row]]];
            return [NSString stringWithFormat:@"%@分",[self.time2Array objectAtIndex:row]];
        }
    }
    else{
        [self.pickDelegate pickerValue:[self.yearArray objectAtIndex:row]];
        return [self.yearArray objectAtIndex:row];
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.weightfirArr count]) {
        
        if (component == 0)
        {
            weight1String = [NSString stringWithFormat:@"%@",[self.weightfirArr objectAtIndex:row]];
            [self getWeightString];
        }
        else{
            weight2String = [NSString stringWithFormat:@"%@",[self.weightfir2Arr objectAtIndex:row]];
            [self getWeightString];
        }
    }
    else if ([self.heightArr count]){
        [self.pickDelegate pickerValue:[self.heightArr objectAtIndex:row]];
    }   
    else if ([self.timeArray count]){
        
        NSDate *tempDate = [self.selectDate dateByAddingTimeInterval:60 * 10];
        
        NSString *selectDateStr = [NSObject dateStringWithDate:self.selectDate withDateType:SSL_Date];
        NSString *currentDateStr = [NSObject dateStringWithDate:[NSDate date] withDateType:SSL_Date];
        
        NSString *hour = [NSObject dateStringWithDate:tempDate withDateType:SSL_HourDate];
        NSString *minute = [NSObject dateStringWithDate:tempDate withDateType:SSL_MinuteDate];
        
//        if ([selectDateStr isEqualToString:currentDateStr]) {
//            [self.pickerView selectRow:hour.integerValue inComponent:0 animated:YES];
//            [self.pickerView selectRow:minute.integerValue inComponent:1 animated:YES];
//        }
        
        if ([selectDateStr isEqualToString:currentDateStr]) {
            if (component == 0) {
                if (row < hour.integerValue) {
                    [self.pickerView selectRow:hour.integerValue inComponent:0 animated:YES];
                    return;
                }
            }
            if (component == 1) {
                
                if ([self.pickerView selectedRowInComponent:0] == hour.integerValue) {
                    if (row < minute.integerValue) {
                        [self.pickerView selectRow:minute.integerValue inComponent:1 animated:YES];
                        return;
                    }
                }
            }
        }
        
        if (component == 0) {
            NSInteger minute = [pickerView selectedRowInComponent:1];
            [self.pickDelegate pickerValue:[NSString stringWithFormat:@"%@:%@",self.timeArray[(NSUInteger)row],self.time2Array[minute]]];
        } else {
            NSInteger second = [pickerView selectedRowInComponent:0];
            [self.pickDelegate pickerValue:[NSString stringWithFormat:@"%@:%@",self.timeArray[second],self.time2Array[row]]];
        }
    }
    else{
        [self.pickDelegate pickerValue:[self.yearArray objectAtIndex:row]];
    }
}

- (void)limitTimeWithSelectDate:(NSDate *)date timeString:(NSString *)timeString{
    
    if (self.selectDate != date) {
        self.selectDate = date;
    }
    
    if (timeString) {
        NSArray *array = [timeString componentsSeparatedByString:@":"];
        NSString *hour = array[0];
        NSString *minute = array[1];
        
        [self.pickerView selectRow:hour.integerValue inComponent:0 animated:NO];
        [self.pickerView selectRow:minute.integerValue inComponent:1 animated:NO];
    } else {
        NSDate *tempDate = [date dateByAddingTimeInterval:60 * 10];
        
        NSString *selectDateStr = [NSObject dateStringWithDate:date withDateType:SSL_Date];
        NSString *currentDateStr = [NSObject dateStringWithDate:[NSDate date] withDateType:SSL_Date];
        
        NSString *hour = [NSObject dateStringWithDate:tempDate withDateType:SSL_HourDate];
        NSString *minute = [NSObject dateStringWithDate:tempDate withDateType:SSL_MinuteDate];
        
        if ([selectDateStr isEqualToString:currentDateStr]) {
            [self.pickerView selectRow:hour.integerValue inComponent:0 animated:YES];
            [self.pickerView selectRow:minute.integerValue inComponent:1 animated:YES];
        }
    }   
    
    NSString *selectDateStr = [NSObject dateStringWithDate:date withDateType:SSL_Date];
    NSString *currentDateStr = [NSObject dateStringWithDate:[NSDate date] withDateType:SSL_Date];
    
    if ([selectDateStr isEqualToString:currentDateStr]) {
        //起始时间加10分钟
        self.dataPicker.minimumDate = [[NSDate new] dateByAddingTimeInterval:10 * 60];
    } else {
        self.dataPicker.minimumDate = nil;
    }
}

-(void)getWeightString
{
    NSInteger myNumber = weight2String.integerValue;
//     NSLog(@"**********%ld,%ld",myNumber,myNumber/100);
    [self.pickDelegate pickerValue:[NSString stringWithFormat:@"%@.%ld",weight1String,myNumber]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
