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
-(void)downLoadServerFile:(NSString*)roomStr timeStr:(NSString*)timeStr{
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
    [[TBWebService sharedInstance] getServerData:dic success:^(NSDictionary *responseObject) {
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
@end
