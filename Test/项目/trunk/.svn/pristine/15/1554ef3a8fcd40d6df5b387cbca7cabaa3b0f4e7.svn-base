//
//  CalendarDayButton.m
//  sampleCalendar
//
//  Created by nick on 15/10/19.
//  Copyright © 2015年 Attinad. All rights reserved.
//

#import "CalendarDayButton.h"
#import "UIImageView+WebCache.h"

@interface CalendarDayButton()

@property(nonatomic,strong)UILabel *dayView;//时间背景
@property(nonatomic,strong)UILabel *dayLbl;//日期
@property(nonatomic,strong)UILabel *weekLbl;//周几

@end

@implementation CalendarDayButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.layer.borderColor = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
//        self.layer.borderWidth = 0.5;
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *mengceng = [[UIImageView alloc] init];
        self.backImage = mengceng;
        mengceng.contentMode = UIViewContentModeScaleAspectFill;
        mengceng.clipsToBounds = YES;
        //        mengceng.alpha = 0.6;
        [self addSubview:mengceng];
        
        UILabel *dayView = [[UILabel alloc] init];
        self.dayView = dayView;
        [self addSubview:dayView];
        dayView.frame = CGRectMake(frame.size.width / 3 * 2, 0, frame.size.width / 3, frame.size.width / 3);
        //        dayView.layer.cornerRadius = 11;
        //        dayView.layer.cornerRadius = dayView.bounds.size.height/2;
        //        dayView.clipsToBounds = YES;
        dayView.backgroundColor = OrangeColor;
        //        UILabel *day = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 21, 11)];
        self.dayLbl = dayView;
        //        [dayView addSubview:day];
        dayView.font = [UIFont italicSystemFontOfSize:12];
        dayView.textAlignment = NSTextAlignmentCenter;
        dayView.textColor = [UIColor whiteColor];
        //        UILabel *week = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 21, 8)];
        //        self.weekLbl = week;
        //        [dayView addSubview:week];
        //        week.font = [UIFont systemFontOfSize:6];
        //        week.textColor = [UIColor whiteColor];
        //        week.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.dayView.frame = CGRectMake(frame.size.width / 3 * 2, 0, frame.size.width / 3, frame.size.width / 3);
    self.backImage.frame = self.bounds;
}

- (void)setModel:(singinModel *)model{
    _model = model;
    if(model.punchdate.length == 8) self.dayLbl.text = [NSString stringWithFormat:@"%d",[model.punchdate substringFromIndex:6].intValue];
    
    if (model.imageurl && model.imageurl.length>0) {
        [self setBackgroundColor:[WWTolls colorWithHexString:@"#dfdfdf"]];
        [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.backgroundColor = [UIColor clearColor];
        } ];
    }else{
        self.dayView.backgroundColor= [UIColor clearColor];
        self.dayView.textColor = TitleColor;
        self.backImage.backgroundColor = self.dayLbl.text.intValue%2 == 0 ? [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0] : [UIColor colorWithRed:246 / 255.0 green:247 / 255.0 blue:250 / 255.0 alpha:1.0];
    }
    
    //    NSString *weekStr;
    //    switch (model.weekday.intValue) {
    //        case 7:
    //            weekStr = @"SUN";
    //            break;
    //        case 1:
    //            weekStr = @"MON";
    //            break;
    //        case 2:
    //            weekStr = @"TUE";
    //            break;
    //        case 3:
    //            weekStr = @"WED";
    //            break;
    //        case 4:
    //            weekStr = @"THU";
    //            break;
    //        case 5:
    //            weekStr = @"FRI";
    //            break;
    //        case 6:
    //            weekStr = @"SAT";
    //            break;
    //        default:
    //            break;
    //    }
    //    self.weekLbl.text = weekStr;
    //    if([weekStr isEqualToString:@"SAT"] || [weekStr isEqualToString:@"SUN"]){
    //        self.dayLbl.textColor = [WWTolls colorWithHexString:@"#eb5b9f"];
    //        self.weekLbl.textColor = [WWTolls colorWithHexString:@"#eb5b9f"];
    //    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:[self getDateFromString:model.punchdate]];
    NSDateComponents *compsNow = [[NSDateComponents alloc] init];
    compsNow = [calendar components:unitFlags fromDate:[self getDateFromString:self.today]];
    if (comps.year == compsNow.year && comps.month == compsNow.month && comps.day == compsNow.day) {
        self.dayLbl.textColor = [UIColor whiteColor];
        self.weekLbl.textColor = [UIColor whiteColor];
        self.dayView.backgroundColor = [WWTolls colorWithHexString:@"#fb6061"];
        UIImageView *photo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xjicon-62-54"]];
        photo.frame = CGRectMake(8, self.height - 5 - 27, 31, 27);
        if(![model.ispunch isEqualToString:@"0"]) [self addSubview:photo];
        self.layer.borderColor = [WWTolls colorWithHexString:@"#ff3e2a"].CGColor;
        self.layer.borderWidth = 1;
        [self setBackgroundColor:[WWTolls colorWithHexString:@"#f4bab4"]];
    }else if(comps.year == compsNow.year && comps.month == compsNow.month && comps.day > compsNow.day){
//        self.dayView.backgroundColor = [UIColor clearColor];
        self.dayView.textColor = TitleColor;
    }
}

- (NSDate*)getDateFromString:(NSString*)dateStr{
    NSDate *date = [NSDate date];
    if (dateStr.length == 8) {
        NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
        
        [inputFormatter setDateFormat:@"yyyyMMdd"];
        
        date = [inputFormatter dateFromString:dateStr];
    }
    return date;
}

@end
