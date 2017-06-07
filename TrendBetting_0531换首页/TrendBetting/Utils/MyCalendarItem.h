//
//  ViewController.m
//  LPHCalendar
//
//  Created by 钱趣多 on 16/9/26.
//  Copyright © 2016年 LPH. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MyCalendarItem : UIView

- (void)createCalendarViewWith:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDictionary *fileDateDic;

@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);

@end
