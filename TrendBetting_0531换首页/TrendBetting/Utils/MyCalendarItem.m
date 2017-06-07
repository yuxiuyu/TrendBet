//
//  ViewController.m
//  LPHCalendar
//
//  Created by 钱趣多 on 16/9/26.
//  Copyright © 2016年 LPH. All rights reserved.
//

#import "MyCalendarItem.h"


@implementation MyCalendarItem
{
//    UILabel *headlabel;
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            button.titleLabel.font = [UIFont systemFontOfSize:14.0];
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.layer.cornerRadius = 5.0f;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(logDate:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 100+i;
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}

#pragma mark - date
//几天
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}
//几月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
//哪一年
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
- (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

#pragma mark 上个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma mark  下个月
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
#pragma mark - create View
- (void)setDate:(NSDate *)date{
    _date = date;
    [self createCalendarViewWith:date];
}
-(void)setFileDateDic:(NSDictionary *)fileDateDic
{
    _fileDateDic=fileDateDic;
}
- (void)createCalendarViewWith:(NSDate *)date{
    CGFloat itemW     = self.frame.size.width / 7;
    CGFloat itemH     = self.frame.size.height / 8;

    
    // 2.weekday
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.backgroundColor = [UIColor redColor];
    weekBg.frame = CGRectMake(0, 0, self.frame.size.width, 35);
    [self addSubview:weekBg];
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 35);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor  = [UIColor whiteColor];
        [weekBg addSubview:week];
    }
    
    //  3.days (1-31)
    for (int i = 0; i < 42; i++)
    {
        
        int x = (i % 7) * itemW ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame);
        
        UIButton *dayButton = _daysArray[i];
        dayButton.frame = CGRectMake(x, y, itemW, itemH);
        ////////////////
        UILabel*fileLab=[[UILabel alloc]init];
        fileLab.text     = @"";
        fileLab.font     = [UIFont systemFontOfSize:11];
        fileLab.frame    = CGRectMake(0,itemH-10, itemW, 10);
        fileLab.textAlignment   = NSTextAlignmentCenter;
        fileLab.textColor  = [UIColor redColor];
        [dayButton addSubview:fileLab];

        ////////////////
        //上个月的总天数
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        //这个月的总天数
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        //重要方法 第一周第第一天是周几    1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        if (i < firstWeekday)
        {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        if (_fileDateDic[[NSString stringWithFormat:@"%li", day]])
        {
            NSDictionary*dic=_fileDateDic[[NSString stringWithFormat:@"%li", day]];
            if (dic[@"daycount"])
            {
                NSArray*dataarray=dic[@"daycount"];
                fileLab.text     =[NSString stringWithFormat:@"%@  %@",[[Utils sharedInstance]removeFloatAllZero:dataarray[5]],dataarray[6]];
            }
            else
            {
                fileLab.text   =@"you";
                
            }
           
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        // this month
        if ([self month:date] == [self month:[NSDate date]]) {
            NSInteger todayIndex = [self day:date] + firstWeekday - 1;
            if(i ==  todayIndex){
                [self setStyle_Today:dayButton];
            }
        }
        
    }
}

#pragma mark 月份选择按钮
-(void)btnClick:(UIButton *)btn{
    if (btn.tag == 20) {
        NSLog(@"上");
        _date = [self lastMonth:_date];
//        headlabel.text   = [NSString stringWithFormat:@"%li年%li月",[self year:_date],[self month:_date]];
    }else{
        NSLog(@"下");
        _date = [self nextMonth:_date];
//        headlabel.text   = [NSString stringWithFormat:@"%li年%li月",[self year:_date],[self month:_date]];
    }
    [self refreshViewWithDate:_date];
}
-(void)refreshViewWithDate:(NSDate *)date{
    for (int i = 0; i < 42; i++) {
        UIButton * btn = (UIButton *)[self viewWithTag:100+i];
        if (btn.backgroundColor == [UIColor orangeColor]) {
            btn.backgroundColor = [UIColor whiteColor];
        }
        //上个月的总天数
        NSInteger daysInLastMonth = [self totaldaysInMonth:[self lastMonth:date]];
        //这个月的总天数
        NSInteger daysInThisMonth = [self totaldaysInMonth:date];
        //重要方法 第一周第第一天是周几    1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        NSInteger firstWeekday    = [self firstWeekdayInThisMonth:date];
        
        NSInteger day = 0;
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:btn];
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:btn];
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:btn];
        }
        [btn setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        // this month
        NSInteger todayIndex = [self day:date] + firstWeekday - 1;
        if ([self isThisYearAndMonth]) {
            if(i ==  todayIndex){
                [self setStyle_Today:btn];
            }
        }else{
            if (btn.selected) {
                btn.selected = NO;
            }
            if (i == todayIndex) {
                btn.backgroundColor = [UIColor whiteColor];
                [self setStyle_notToday:btn];
            }
        }
    }
    
}
/**
 
 *  是否为今年的当前月
 
 */

- (BOOL)isThisYearAndMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth;
  // 1.获得当前时间的年月日
  NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
  // 2.获得self的年月日
 NSDateComponents *selfCmps = [calendar components:unit fromDate:self.date];
  return (nowCmps.year == selfCmps.year)&&(nowCmps.month == selfCmps.month);
}
#pragma mark - output date
-(void)logDate:(UIButton *)dayBtn
{
    _selectButton.selected = NO;
    dayBtn.selected = YES;
    _selectButton = dayBtn;
    NSInteger day = [[dayBtn titleForState:UIControlStateNormal] integerValue];
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.date];
    if (self.calendarBlock) {
        self.calendarBlock(day, [comp month], [comp year]);
    }
}


#pragma mark - date button style
//不是这个月的 置灰点击
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.hidden=YES;
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
//今天之前的日期置灰不可点击
- (void)setStyle_BeforeToday:(UIButton *)btn
{
     btn.hidden=NO;
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}
//今天的日期  黄色背景
- (void)setStyle_Today:(UIButton *)btn
{
    
    btn.enabled = YES;
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
   
//    [btn setBackgroundColor:[UIColor orangeColor]];
}
- (void)setStyle_notToday:(UIButton *)btn
{
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
}
//今天之后的日期能点击
- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.hidden=NO;
    btn.enabled = YES;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

//将NSDate按yyyy-MM-dd格式时间输出
-(NSString*)nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}
@end
