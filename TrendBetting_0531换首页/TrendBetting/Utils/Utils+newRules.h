//
//  Utils+newRules.h
//  TrendBetting
//
//  Created by 于秀玉 on 17/5/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (newRules)
#pragma mark------搜索（一 三 四 五）区域  个数 区域的趋势
-(NSArray*)seacherNewsRule:(NSArray*)partArray arrGuessPartArray:(NSArray*)arrGuessPartArray;
#pragma mark------将得到的（一 三 四 五）区域 一个个长的数组  塞到对应的坐标上
-(NSMutableArray*)newPartData:(NSMutableArray*)dataArray specArray:(NSArray*)specArray;
-(NSString*)getGuessValue:(NSArray*)tempResultArr partArray:(NSArray*)partArray fristPartArray:(NSArray*)fristPartArray myTag:(int)myTag;
@end
