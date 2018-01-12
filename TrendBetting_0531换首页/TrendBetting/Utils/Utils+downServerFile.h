//
//  Utils+downServerFile.h
//  TrendBetting
//
//  Created by 于秀玉 on 17/10/18.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (downServerFile)
//下载文件
-(void)downLoadServerFile:(NSString*)roomStr timeStr:(NSString*)timeStr isanimated:(BOOL)isanimated;
-(NSArray*)getCurrentYearMonthDay;
-(NSInteger)getAllDayFromDate:(NSDate*)date;
//比较两个日期大小
-(BOOL)compareDate:(NSDate*)beginDate endDate:(NSDate*)endDate;
//加上一个月的日期
-(NSDate*)monthAddOneMonth:(NSDate*)currentDate;

@end
 
