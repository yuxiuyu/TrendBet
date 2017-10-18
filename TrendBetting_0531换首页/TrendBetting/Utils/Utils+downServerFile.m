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
//    __weak typeof(self) weakself =self;
    [[TBWebService sharedInstance] getServerData:dic success:^(NSDictionary *responseObject) {
        NSLog(@"res is %@",responseObject);
        NSArray*array=[timeStr componentsSeparatedByString:@"-"];
       [[Utils sharedInstance] saveServerData:responseObject[@"orgstr"] houseStr:roomStr monthStr:[NSString stringWithFormat:@"%@-%@",array[0],array[1]] dayStr:array[2]];
    } failure:^(NSString *error) {
        NSLog(@"error is %@",error);
    }];
//    return issuccess;
}
@end
