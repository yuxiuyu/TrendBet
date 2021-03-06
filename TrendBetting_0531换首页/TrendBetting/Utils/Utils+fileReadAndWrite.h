//
//  Utils+fileReadAndWrite.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/16.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"
#import "Utils+rule.h"
@interface Utils (fileReadAndWrite)

-(NSDictionary*)readData:(NSString*)str;
/////读取数据类数据 如资金策略
-(NSArray*)readMoneyData:(NSString*)str;
/////保存我的数据
-(BOOL)saveData:(NSDictionary*)dic  saveArray:(NSArray*)saveArray filePathStr:(NSString*)filePathStr;
-(BOOL)saveServerData:(NSString*)dataStr houseStr:(NSString*)houseStr monthStr:(NSString*)monthStr dayStr:(NSString*)dayStr;
/////保存我的ten数据
-(BOOL)saveTenData:(NSArray*)arr name:(NSString*)name;
////读取我的Ten数据
-(NSArray*)readTenData:(NSString*)str;
-(NSArray*)getAllFileName:(NSString*)str;
/////////对读取到的数据进行处理

-(NSDictionary*)getDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr ;
-(NSDictionary*)getGroupDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr isContinue:(BOOL)isContinue;
/////////对读取到的新的规则数据进行处理
-(NSDictionary*)getNewRuleDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr;

/////////按照房间、月份和日期获取文件
-(NSArray*)readDataWithRoom:(NSString *)roomId andMonth:(NSString *)month andDay:(NSString *)day;
////K线获取数据
// K线里获取数据
-(NSDictionary*)getKlineData:(NSString*)monthStr dayStr:(NSString*)dayNameStr isNeedTotal:(BOOL)isNeedTotal;
// 需要的B 的个数
-(int)getStopKlineData:(NSString*)dayNameStr needValue:(int)needValue indexp:(int)indexp;

@end
