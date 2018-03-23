//
//  Utils+klineRule.h
//  TrendBetting
//
//  Created by 于秀玉 on 2018/3/17.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "Utils.h"

@interface Utils (klineRule)
-(NSArray*)getKlineArray:(NSArray*)listArray;
-(NSArray*)getStopBKlineArray:(NSArray*)listArray needValue:(int)needValue;
@end
