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
-(NSArray*)getAllFileName:(NSString*)str;
/////////对读取到的数据进行处理

-(NSDictionary*)getDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr ;
-(NSDictionary*)getGroupDayData:(NSString*)monthStr dayStr:(NSString*)dayNameStr isContinue:(BOOL)isContinue;
@end
