//
//  Utils+klineRule.m
//  TrendBetting
//
//  Created by 于秀玉 on 2018/3/17.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "Utils+klineRule.h"
#import "Utils+newRules.h"
#import "Utils+xiasanluRule.h"
@implementation Utils (klineRule)
-(NSArray*)getKlineArray:(NSArray*)listArray{
    int beginPrice = 0;
    int maxPrice = 0;
    int minPrice = 0;
    int total = 0;
    int b_count = 0;
    int r_count = 0;
    for (int i=0; i<listArray.count; i++)
    {
        NSString*resultStr=[NSString stringWithFormat:@"%@",listArray[i]];
        
        if ([resultStr intValue]==10||[resultStr isEqualToString:@"R"])
        {//庄
            resultStr=@"R";
            total+=1;
            r_count++;
        }
        else if ([resultStr intValue]==11||[resultStr isEqualToString:@"B"])
        {//闲
            resultStr=@"B";
            total-=1;
            b_count++;
        }
        
        if (i==0) {
            beginPrice = total;
            maxPrice = total;
            minPrice = total;
        }
        if (maxPrice<total) {
            maxPrice = total;
        }
        if (minPrice>total) {
            minPrice = total;
        }
        
    }
    NSArray*array= @[[NSString stringWithFormat:@"%d",total],//收盘价
                     [NSString stringWithFormat:@"%d",beginPrice],//开盘价
                     [NSString stringWithFormat:@"%d",maxPrice],//最高价
                     [NSString stringWithFormat:@"%d",minPrice],//最低价
                     [NSString stringWithFormat:@"%d",b_count],//闲的个数
                    [NSString stringWithFormat:@"%d",r_count]//闲的个数
                     ];
    
    return array;
}

-(NSArray*)getStopBKlineArray:(NSArray*)listArray needValue:(int)needValue{
    int totalC = 0;
    int b_count = 0;
    for (int i=0; i<listArray.count; i++)
    {
        NSString*resultStr=[NSString stringWithFormat:@"%@",listArray[i]];
        if ([resultStr intValue]==10||[resultStr isEqualToString:@"R"])
        {//庄
            totalC+=1;
        }
        else if ([resultStr intValue]==11||[resultStr isEqualToString:@"B"])
        {//闲
            totalC-=1;
            b_count++;
        }
        if (totalC==needValue) {
            return @[@"YES",@(b_count)];
        }
    }
    return @[@"NO",@(b_count)]; // no 没有结束 yes 结束 b_count 闲的个数
}
@end
