//
//  Utils+downServerFile.m
//  TrendBetting
//
//  Created by 于秀玉 on 17/10/18.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils+downServerFile.h"
#import "Utils+encryption.h"
#import "TBWebService+Login&Register.h"
@implementation Utils (downServerFile)
-(void)downLoadServerFile:(NSString*)roomStr timeStr:(NSString*)timeStr isanimated:(BOOL)isanimated{
    //    NSString*roomStr=@"4";
    //    NSString*timeStr=@"2017-10-13";
    //    BOOL issuccess = YES;
    NSDateFormatter*formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSTimeInterval a=[[formater dateFromString:timeStr] timeIntervalSince1970];
    NSString*endtimeStr=[NSString stringWithFormat:@"%.0f",a];
    NSString*seekStr=[NSString stringWithFormat:@"%.8d",arc4random()%100000000];
    NSDictionary*dic=@{@"roomid":roomStr,
                       @"endtime":endtimeStr,
                       @"seek":seekStr,
                       @"md5str":[[Utils sharedInstance] stringFromMD5:[NSString stringWithFormat:@"%@%@%@",roomStr,endtimeStr,seekStr]]};
    NSDictionary *notiDic = [[NSDictionary alloc]initWithObjectsAndKeys:roomStr,@"roomStr",timeStr,@"timeStr", nil];
    NSNotification *errnotification =[NSNotification notificationWithName:@"DownErrNotification" object:nil userInfo:notiDic];
    NSNotification *sucnotification =[NSNotification notificationWithName:@"InfoNotification" object:nil userInfo:notiDic];
    NSNotification *noFilenotification =[NSNotification notificationWithName:@"noFileInfoNotification" object:nil userInfo:notiDic];
    //    __weak typeof(self) weakself =self;
    [[TBWebService sharedInstance] getServerData:dic isanimated:isanimated success:^(NSDictionary *responseObject) {
        NSLog(@"res is %@",responseObject);
        if ([[responseObject objectForKey:@"code"] integerValue] == 200) {
            // 下载完成
            
            NSArray*array=[timeStr componentsSeparatedByString:@"-"];
            [[Utils sharedInstance] saveServerData:responseObject[@"orgstr"] houseStr:roomStr monthStr:[NSString stringWithFormat:@"%@-%@",array[0],array[1]] dayStr:array[2]];
            [[NSNotificationCenter defaultCenter] postNotification:sucnotification];
        }else if ([[responseObject objectForKey:@"code"] integerValue] == 501)
        {
            [[NSNotificationCenter defaultCenter] postNotification:noFilenotification];
        }
        
    } failure:^(NSString *error) {
        NSLog(@"error is %@",error);
        if ([error isEqualToString:@"The request timed out."]) {
        
            [[NSNotificationCenter defaultCenter] postNotification:errnotification];
        }
        
    }];
    //    return issuccess;
}
-(NSArray*)getCurrentYearMonthDay{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    int year =(int) [dateComponent year];
    int month = (int) [dateComponent month];
    int day = (int) [dateComponent day];
    NSArray *monthArr = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    
    NSDate *nowDate = [NSDate date];
    NSString *str = [NSString stringWithFormat:@"%d-%02d-%02d 11:15:00 +0800",year,month,day];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
    NSDate *lastDate = [formatter dateFromString:str];
    
    
    NSString *monthStr = [NSString stringWithFormat:@"%d",month];
    if ([nowDate timeIntervalSince1970]>[lastDate timeIntervalSince1970]) {
        if ([monthArr containsObject:monthStr]) {
            if (day == 31) {
                if (month == 12) {
                    year = year + 1;
                    month = 1;
                    day = 1;
                }else{
                    day = 1;
                    month = month + 1;
                }
            }else{
                day = day + 1;
            }
        }else if(month == 2)
        {
            if (year % 4 == 0) {
                if (day == 29) {
                    day = 1;
                    month = month + 1;
                }else{
                    day = day + 1;
                }
            }else{
                if (day == 28) {
                    day = 1;
                    month = month + 1;
                }else{
                    day = day + 1;
                }
            }
        }else
        {
            if (day == 30) {
                day = 1;
                month = month + 1;
            }else{
                day = day + 1;
            }
        }
    }
    return @[[NSString stringWithFormat:@"%d",year],[NSString stringWithFormat:@"%d",month],[NSString stringWithFormat:@"%d",day]];
}
-(NSInteger)getAllDayFromDate:(NSDate*)date{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSGregorianCalendar - ios 8
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                                   inUnit: NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                                  forDate:date];
    return range.length;
}
@end
