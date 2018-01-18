//
//  PickerView+.h
//  zhidoushi
//
//  Created by xinglei on 14-9-19.
//  Copyright (c) 2014年 game.zhidoushi.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerView_;
typedef enum {
    wightType,
    yearType,
    heightType,
    timeType
} pickerViewType;


@protocol PickerViewDelegate<NSObject>
@optional
-(void)cancelBtn;
-(void)pickerValue:(NSString*)str;
-(void)datePickerValue:(NSDate*)str;
-(void)timeDatePickerValue:(NSString *)str;
-(void)selectBtn:(PickerView_*)pick;
@end

@interface PickerView_ : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIDatePicker * dataPicker;
@property(nonatomic,strong)UIPickerView   *pickerView;
@property(nonatomic,strong)NSMutableArray *weightfirArr;
@property(nonatomic,strong)NSMutableArray *timeArray;
@property(nonatomic,strong)NSMutableArray *time2Array;
@property(nonatomic,strong)NSMutableArray * heightArr;
@property(nonatomic,strong)NSMutableArray * weightfir2Arr;
@property(nonatomic,strong)NSMutableArray * yearArray;
@property(nonatomic,strong)id<PickerViewDelegate> pickDelegate;
@property(nonatomic,strong)NSDate *selectDate;
@property (unsafe_unretained, nonatomic) pickerViewType pickerType;

- (id)initWithFrame:(CGRect)frame withType:(pickerViewType)type;
- (id)initWithFrame:(CGRect)frame withType:(pickerViewType)type withDate:(NSDate *)currentDate;

//根据日期限制最小时间
- (void)limitTimeWithSelectDate:(NSDate *)date timeString:(NSString *)timeString;

@end






