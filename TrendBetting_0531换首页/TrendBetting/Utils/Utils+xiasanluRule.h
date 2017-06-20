//
//  Utils+xiasanluRule.h
//  TrendBetting
//
//  Created by 于秀玉 on 17/6/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (xiasanluRule)
-(NSArray*)getNewFristArray:(NSArray*)listArray;
-(NSArray*)seacherSpecRule:(NSArray*)fristPartArray  resultArray:(NSArray*)resultArray;
//搜索第一区域的规则
-(NSArray*)searchFirstRule:(NSArray*)listArray;
-(NSArray*)xiasanluJudgeGuessRightandWrong:(NSArray*)listArray allGuessArray:(NSArray*)allGuessArray;
@end
