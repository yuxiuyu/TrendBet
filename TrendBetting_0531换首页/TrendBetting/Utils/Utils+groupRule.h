//
//  Utils+rule.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (groupRule)
-(NSArray*)getGroupFristArray:(NSArray*)listArray ;
-(NSArray*)judgeGroupGuessRightandWrong:(NSArray*)listArray allGuessArray:(NSArray*)allGuessArray;///判断猜对了还是猜错了
#pragma mark------搜索（一 三 四 五）区域  个数 区域的趋势
-(NSString*)seacherGroupRule:(NSArray*)fristPartArray listStr:(NSString*)listStr myTag:(NSInteger)myTag;
@end
