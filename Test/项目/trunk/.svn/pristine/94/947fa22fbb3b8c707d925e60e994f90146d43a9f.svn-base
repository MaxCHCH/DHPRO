
#import "CalendarView.h"

@interface CalendarView()

// Gregorian calendar
@property (nonatomic, strong) NSCalendar *gregorian;

// Selected day
@property (nonatomic, strong) NSDate * selectedDate;

// Width in point of a day button
@property (nonatomic, assign) NSInteger dayWidth;

// NSCalendarUnit for day, month, year and era.
@property (nonatomic, assign) NSCalendarUnit dayInfoUnits;

// Array of label of weekdays
@property (nonatomic, strong) NSArray * weekDayNames;

// View shake
@property (nonatomic, assign) NSInteger shakes;
@property (nonatomic, assign) NSInteger shakeDirection;

// Gesture recognizers
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeleft;
@property (nonatomic, strong) UISwipeGestureRecognizer * swipeRight;



@end
@implementation CalendarView

#pragma mark - Init methods

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _dayWidth                   = (frame.size.width - 10)/5;
        _originX                    = 5;
        _gregorian                  = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _borderWidth                = 2;
        _originY                    = _dayWidth;
        _calendarDate               = [NSDate date];
        _dayInfoUnits               = NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        
        _monthAndDayTextColor       = [UIColor brownColor];
        _dayBgColorWithoutData      = [UIColor whiteColor];
        _dayBgColorWithData         = [UIColor whiteColor];
        _dayBgColorSelected         = [UIColor brownColor];
        
        _dayTxtColorWithoutData     = [UIColor brownColor];;
        _dayTxtColorWithData        = [UIColor brownColor];
        _dayTxtColorSelected        = [UIColor whiteColor];
        
        _borderColor                = [UIColor brownColor];
        _allowsChangeMonthByDayTap  = NO;
        _allowsChangeMonthByButtons = NO;
        _allowsChangeMonthBySwipe   = YES;
        _hideMonthLabel             = NO;
        _keepSelDayWhenMonthChange  = NO;
        
        _nextMonthAnimation         = UIViewAnimationOptionTransitionCrossDissolve;
        _prevMonthAnimation         = UIViewAnimationOptionTransitionCrossDissolve;
        
        _defaultFont                = [UIFont fontWithName:@"HelveticaNeue" size:15.0f];
        _titleFont                  = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
        
        
        _swipeleft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showNextMonth)];
        _swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:_swipeleft];
        _swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showPreviousMonth)];
        _swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:_swipeRight];
        
        NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:[NSDate date]];
        components.hour         = 0;
        components.minute       = 0;
        components.second       = 0;
        
        _selectedDate = [_gregorian dateFromComponents:components];
        
        NSArray * shortWeekdaySymbols = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
        _weekDayNames  = @[shortWeekdaySymbols[1], shortWeekdaySymbols[2], shortWeekdaySymbols[3], shortWeekdaySymbols[4],
                           shortWeekdaySymbols[5], shortWeekdaySymbols[6], shortWeekdaySymbols[0]];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(id)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 560, 600)];
    if (self)
    {
        
    }
    return self;
}

#pragma mark - Custom setters

-(void)setAllowsChangeMonthByButtons:(BOOL)allows
{
    _allowsChangeMonthByButtons = allows;
    [self setNeedsDisplay];
}

-(void)setAllowsChangeMonthBySwipe:(BOOL)allows
{
    _allowsChangeMonthBySwipe   = allows;
    _swipeleft.enabled          = allows;
    _swipeRight.enabled         = allows;
}

-(void)setHideMonthLabel:(BOOL)hideMonthLabel
{
    _hideMonthLabel = hideMonthLabel;
    [self setNeedsDisplay];
}

-(void)setSelectedDate:(NSDate *)selectedDate
{
    _selectedDate = selectedDate;
    [self setNeedsDisplay];
}

-(void)setData:(NSArray *)data{
    _data = data;
    [self performViewAnimation:_nextMonthAnimation];
//    [self setNeedsDisplay];
}

-(void)setCalendarDate:(NSDate *)calendarDate
{
    _calendarDate = calendarDate;
    [self setNeedsDisplay];
}


#pragma mark - Public methods

-(void)showNextMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *Todate=[formatter dateFromString:self.currentDate];
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:Todate];
    components.day = 1;
    components.month ++;
    NSDate * nextMonthDate =[_gregorian dateFromComponents:components];
    
    if ([self canSwipeToDate:nextMonthDate])
    {
//        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _calendarDate = nextMonthDate;
        components = [_gregorian components:_dayInfoUnits fromDate:nextMonthDate];
        
        if (!_keepSelDayWhenMonthChange)
        {
            _selectedDate = [_gregorian dateFromComponents:components];
        }
//        [self performViewAnimation:_nextMonthAnimation];
    }
    else
    {
//        [self performViewNoSwipeAnimation];
    }
}


-(void)showPreviousMonth
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *Todate=[formatter dateFromString:self.currentDate];
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:Todate];
    components.day = 1;
    components.month --;
    NSDate * prevMonthDate = [_gregorian dateFromComponents:components];
    
    if ([self canSwipeToDate:prevMonthDate])
    {
//        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        _calendarDate = prevMonthDate;
        components = [_gregorian components:_dayInfoUnits fromDate:prevMonthDate];
        
        if (!_keepSelDayWhenMonthChange)
        {
            _selectedDate = [_gregorian dateFromComponents:components];
        }
//        [self performViewAnimation:_prevMonthAnimation];
    }
    else
    {
//        [self performViewNoSwipeAnimation];
    }
}

#pragma mark - Various methods


-(NSInteger)buttonTagForDate:(NSDate *)date
{
    NSDateComponents * componentsDate       = [_gregorian components:_dayInfoUnits fromDate:date];
    NSDateComponents * componentsDateCal    = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    if (componentsDate.month == componentsDateCal.month && componentsDate.year == componentsDateCal.year)
    {
        // Both dates are within the same month : buttonTag = day
        return componentsDate.day;
    }
    else
    {
        //  buttonTag = deltaMonth * 40 + day
        NSInteger offsetMonth =  (componentsDate.year - componentsDateCal.year)*12 + (componentsDate.month - componentsDateCal.month);
        return componentsDate.day + offsetMonth*40;
    }
}

-(BOOL)canSwipeToDate:(NSDate *)date
{
    if (_datasource == nil)
        return YES;
    return [_datasource canSwipeToDate:date];
}

-(void)performViewAnimation:(UIViewAnimationOptions)animation
{
//    NSDateComponents * components = [_gregorian components:_dayInfoUnits fromDate:_selectedDate];
//    
//    NSDate *clickedDate = [_gregorian dateFromComponents:components];
//    [_delegate dayChangedToDate:clickedDate];
    
    [UIView transitionWithView:self
                      duration:0.5f
                       options:animation
                    animations:^ { [self setNeedsDisplay]; }
                    completion:nil];
}

-(void)performViewNoSwipeAnimation
{
    _shakeDirection = 1;
    _shakes = 0;
    [self shakeView:self];
}

// Taken from http://github.com/kosyloa/PinPad
-(void)shakeView:(UIView *)theOneYouWannaShake
{
    [UIView animateWithDuration:0.05 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*_shakeDirection, 0);
         
     } completion:^(BOOL finished)
     {
         if(_shakes >= 4)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         _shakes++;
         _shakeDirection = _shakeDirection * -1;
         [self shakeView:theOneYouWannaShake];
     }];
}

#pragma mark - Button creation and configuration

-(CalendarDayButton *)dayButtonWithFrame:(CGRect)frame
{
    CalendarDayButton *button                = [CalendarDayButton buttonWithType:UIButtonTypeCustom];
    button.today = self.today;
    button.titleLabel.font          = _defaultFont;
    button.frame                    = frame;
    button.layer.borderColor        = [WWTolls colorWithHexString:@"#dcdcdc"].CGColor;
    [button     addTarget:self action:@selector(tappedDate:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)configureDayButton:(CalendarDayButton *)button withDate:(NSDate*)date
{
//    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:date];
//    [button setTitle:[NSString stringWithFormat:@"%ld",(long)components.day] forState:UIControlStateNormal];
    
//    button.tag = [self buttonTagForDate:date];
    singinModel *model = self.data[button.tag - 1];
////    components.day = 1;
//    NSDate *firstDayOfMonth         = [_gregorian dateFromComponents:components];
//    NSDateComponents *comps         = [_gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
//    NSInteger weekdayBeginning      = [comps weekday];
//    model.punchdate = [NSString stringWithFormat:@"%4d%2d%2d",components.year,components.month,components.day];
    
//    model.date = date;
//    model.day = [NSString stringWithFormat:@"%ld",components.day];
//    model.imgUrl = @"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=957872124,3990700180&fm=58";
    button.model = model;
//    if([_selectedDate compare:date] == NSOrderedSame)
//    {
//        
//    }
//    else
//    {
//        
//    }
//
//    NSDateComponents * componentsDateCal = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
//    if (components.month != componentsDateCal.month)
//        button.alpha = 0.6f;
}

#pragma mark - Action methods

-(IBAction)tappedDate:(CalendarDayButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(dayClick:)]) {
        [self.delegate dayClick:sender];
    }
//    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
//    
//    if (sender.tag < 0 || sender.tag >= 40)
//    {
//        // The day tapped is in another month than the one currently displayed
//        
//        if (!_allowsChangeMonthByDayTap)
//            return;
//        
//        NSInteger offsetMonth   = (sender.tag < 0)?-1:1;
//        NSInteger offsetTag     = (sender.tag < 0)?40:-40;
//        
//        // otherMonthDate set to beginning of the next/previous month
//        components.day = 1;
//        components.month += offsetMonth;
//        NSDate * otherMonthDate =[_gregorian dateFromComponents:components];
//        
//        if ([self canSwipeToDate:otherMonthDate])
//        {
//            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            _calendarDate = otherMonthDate;
//            
//            // New selected date set to the day tapped
//            components.day = sender.tag + offsetTag;
//            _selectedDate = [_gregorian dateFromComponents:components];
//
//            UIViewAnimationOptions animation = (offsetMonth >0)?_nextMonthAnimation:_prevMonthAnimation;
//            
//            // Animate the transition
//            [self performViewAnimation:animation];
//        }
//        else
//        {
//            [self performViewNoSwipeAnimation];
//        }
//        return;
//    }
//    
//    // Day taped within the the displayed month
//    NSDateComponents * componentsDateSel = [_gregorian components:_dayInfoUnits fromDate:_selectedDate];
//    if(componentsDateSel.day != sender.tag || componentsDateSel.month != components.month || componentsDateSel.year != components.year)
//    {
//        // Let's keep a backup of the old selectedDay
//        NSDate * oldSelectedDate = [_selectedDate copy];
//        
//        // We redifine the selected day
//        componentsDateSel.day       = sender.tag;
//        componentsDateSel.month     = components.month;
//        componentsDateSel.year      = components.year;
//        _selectedDate               = [_gregorian dateFromComponents:componentsDateSel];
//        
//        // Configure  the new selected day button
//        [self configureDayButton:sender             withDate:_selectedDate];
//        
//        // Configure the previously selected button, if it's visible
//        UIButton *previousSelected =(UIButton *) [self viewWithTag:[self buttonTagForDate:oldSelectedDate]];
//        if (previousSelected)
//            [self configureDayButton:previousSelected   withDate:oldSelectedDate];
//        
//        // Finally, notify the delegate
//        [_delegate dayChangedToDate:_selectedDate];
//    }
}


#pragma mark - Drawing methods

- (void)drawRect:(CGRect)rect
{
    for (UIView *chirldV in self.subviews) {
        [chirldV removeFromSuperview];
    }
    NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:_calendarDate];
    
    components.day = 1;
    NSDate *firstDayOfMonth         = [_gregorian dateFromComponents:components];
    NSDateComponents *comps         = [_gregorian components:NSWeekdayCalendarUnit fromDate:firstDayOfMonth];
    
    NSInteger weekdayBeginning      = [comps weekday];  // Starts at 1 on Sunday
    weekdayBeginning -=2;
    if(weekdayBeginning < 0)
        weekdayBeginning += 7;                          // Starts now at 0 on Monday
    weekdayBeginning = 0;
    
    NSRange days = [_gregorian rangeOfUnit:NSDayCalendarUnit
                                    inUnit:NSMonthCalendarUnit
                                   forDate:_calendarDate];
    
    NSInteger monthLength = days.length;
    NSInteger remainingDays = (monthLength + weekdayBeginning) % 7;
    
    
    // Frame drawing
    NSInteger minY = _originY + _dayWidth;
    NSInteger maxY = _originY + _dayWidth * (NSInteger)(1+(monthLength+weekdayBeginning)/7) + ((remainingDays !=0)? _dayWidth:0);
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setHeightNeeded:)])
        [_delegate setHeightNeeded:maxY];
    
    // Month label
    NSDateFormatter *format         = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM yyyy"];
    NSString *dateString            = [self getMonthString:components.month];
    
    if (!_hideMonthLabel) {
        UIView *monthBack = [[UIView alloc] init];
        monthBack.frame = CGRectMake(0, 0, self.bounds.size.width, 78);
        monthBack.backgroundColor = [UIColor whiteColor];
        [self addSubview:monthBack];
        
        UILabel *titleText              = [[UILabel alloc]initWithFrame:CGRectMake(0,0, self.bounds.size.width, 78)];
        titleText.textAlignment         = NSTextAlignmentCenter;
        titleText.text                  = [NSString stringWithFormat:@"%@ - %@",[self.currentDate substringWithRange:NSMakeRange(0, 4)],[self.currentDate substringWithRange:NSMakeRange(4, 2)]];
        titleText.font                  = [UIFont systemFontOfSize:17];
        titleText.textColor             = ContentColor;
        [monthBack addSubview:titleText];
        
//        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];//设置成中国阳历
//        NSDateComponents *comps = [[NSDateComponents alloc] init];
//        NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//        comps = [calendar components:unitFlags fromDate:];
        
//        if (comps.year<2015 || (comps.year == 2015 && comps.month<10) || [date laterDate:self.calendar.calendarDate] == date) {
//            return NO;
//        }
        
        UIButton *lastMonth = [[UIButton alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *Todate=[formatter dateFromString:self.currentDate];
        NSDateComponents *components = [_gregorian components:_dayInfoUnits fromDate:Todate];
        components.day = 1;
        components.month --;
        if (components.year<2015 || (components.year == 2015 && components.month<10) ) {
            lastMonth.hidden = YES;
        }
        
        lastMonth.frame = CGRectMake(0, 0, (SCREEN_WIDTH-100)/2, 78);
        UILabel *lbl = [[UILabel alloc] init];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.frame = lastMonth.bounds;
        lbl.text = [NSString stringWithFormat:@"%d - %d",([self.currentDate substringWithRange:NSMakeRange(4, 2)].intValue - 1)<1?([self.currentDate substringWithRange:NSMakeRange(0, 4)].intValue-1):[self.currentDate substringWithRange:NSMakeRange(0, 4)].intValue,([self.currentDate substringWithRange:NSMakeRange(4, 2)].intValue - 1)<1?12:([self.currentDate substringWithRange:NSMakeRange(4, 2)].intValue - 1)];
        lbl.textColor = [ContentColor colorWithAlphaComponent:0.6];
        lbl.font = MyFont(15);
        [lastMonth addSubview:lbl];
//        [lastMonth setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
//        [lastMonth setTitle:[self getMonthString:components.month - 1] forState:UIControlStateNormal];
//        lastMonth.titleLabel.textAlignment = NSTextAlignmentLeft;
//        lastMonth.titleLabel.font = [UIFont systemFontOfSize:15];
        [lastMonth addTarget:self action:@selector(showPreviousMonth) forControlEvents:UIControlEventTouchUpInside];
        [monthBack addSubview:lastMonth];
        
        UIButton *nextMonth = [[UIButton alloc] init];
        components.month += 2;
        NSDate * prevMonthDate = [_gregorian dateFromComponents:components];
        Todate=[formatter dateFromString:self.today];
        if ([Todate laterDate:prevMonthDate] == prevMonthDate) {
            nextMonth.hidden = YES;
        }
        nextMonth.frame = CGRectMake((SCREEN_WIDTH - 100)/2 + 100, 0, (SCREEN_WIDTH - 100)/2, 78);
        lbl = [[UILabel alloc] init];
        lbl.frame = nextMonth.bounds;
        lbl.text =  [NSString stringWithFormat:@"%ld - %ld",components.year,(long)components.month];
        lbl.textColor = [ContentColor colorWithAlphaComponent:0.6];
        lbl.font = MyFont(15);
        lbl.textAlignment = NSTextAlignmentCenter;
        [nextMonth addSubview:lbl];
//        [nextMonth setTitleColor:[WWTolls colorWithHexString:@"#535353"] forState:UIControlStateNormal];
//        [nextMonth setTitle:[self getMonthString:components.month + 1] forState:UIControlStateNormal];
//        nextMonth.titleLabel.textAlignment = NSTextAlignmentRight;
//        nextMonth.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextMonth addTarget:self action:@selector(showNextMonth) forControlEvents:UIControlEventTouchUpInside];
        [monthBack addSubview:nextMonth];
        if (_delegate != nil && [_delegate respondsToSelector:@selector(setEnabledForPrevMonthButton:nextMonthButton:)])
            [_delegate setEnabledForPrevMonthButton:lastMonth nextMonthButton:nextMonth];
    }
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(setMonthLabel:)])
        [_delegate setMonthLabel:dateString];

    // Current month
    for (NSInteger i= 0; i<self.data.count; i++)
    {
//        components.day      = i+1;
        NSInteger offsetX   = (_dayWidth*((i+weekdayBeginning)%5));
        NSInteger offsetY   = (_dayWidth *((i+weekdayBeginning)/5));
        CalendarDayButton *button    = [self dayButtonWithFrame:CGRectMake(_originX + offsetX, 78 + offsetY, _dayWidth, _dayWidth)];
        button.tag = i+1;
        button.today = self.today;
        [self configureDayButton:button withDate:[_gregorian dateFromComponents:components]];
        [self addSubview:button];
    }
}

- (NSString*)getMonthString:(long)month {
    if (month > 12) {
        month = month - 12;
    }
    if (month < 1) {
        month = month + 12;
    }
    NSString *dateString = @"";
    switch (month) {
        case 1:
            dateString = @"一月";
            break;
        case 2:
            dateString = @"二月";
            break;
        case 3:
            dateString = @"三月";
            break;
        case 4:
            dateString = @"四月";
            break;
        case 5:
            dateString = @"五月";
            break;
        case 6:
            dateString = @"六月";
            break;
        case 7:
            dateString = @"七月";
            break;
        case 8:
            dateString = @"八月";
            break;
        case 9:
            dateString = @"九月";
            break;
        case 10:
            dateString = @"十月";
            break;
        case 11:
            dateString = @"十一月";
            break;
        case 12:
            dateString = @"十二月";
            break;
        default:
            break;
    }
    return dateString;
}

@end