//
//  Utils+rule.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (rule)
-(NSArray*)getFristArray:(NSArray*)listArray ;
-(NSArray*)judgeGuessRightandWrong:(NSArray*)listArray allGuessArray:(NSArray*)allGuessArray;///判断猜对了还是猜错了
-(NSString*)changeChina:(NSString*)memoStr isWu:(BOOL)isWu;//B R 转成 庄 闲
-(NSMutableArray*)setNewData:(NSArray*)listArray startCount:(int)startCount dataArray:(NSMutableArray*)dataArray;
-(NSString*)addListPartData:(NSArray*)fristPartArray startCount:(int)startCount listDataStr:(NSString*)listDataStr;
//#pragma mark------搜索（一 三 四 五）区域  区域的趋势
//-(NSString*)seacherRule:(NSArray*)fristPartArray listStr:(NSString*)listStr myTag:(NSInteger)myTag;
#pragma mark------搜索（一 三 四 五）区域  个数的趋势
-(NSString*)seacherRule:(NSArray*)fristPartArray listStr:(NSString*)listStr myTag:(NSInteger)myTag;
#pragma mark--------------根据有规律 猜出来的值 反推猜出来的值
-(NSString*)backRuleSeacher:(NSArray*)fristPartArray ruleStr:(NSString*)ruleStr myTag:(NSInteger)myTag;
#pragma mark------四个区域得出的趋势 相同趋势长度相加 得出最终猜出的结果
-(NSString*)setGuessValue:(NSArray*)resultArray;
-(NSString*)seacherLengthRule:(NSArray*)array;
#pragma mark------将得到的（一 三 四 五）区域 一个个长的数组  塞到对应的坐标上
-(NSMutableArray*)ThirdPartData:(NSMutableArray*)dataArray;

@end
