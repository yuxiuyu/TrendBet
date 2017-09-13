//
//  Utils.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(instancetype)sharedInstance
{
    static Utils * _sharedInstance=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance=[[Utils alloc]init];
    });
    return _sharedInstance;
    
}
////去掉浮点数后面多余的0
-(NSString*)removeFloatAllZero:(NSString*)string
{
    if (string)
    {
        float tempF=[string floatValue];
        
        NSString * testNumber = string;
        NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
        if (tempF>0)
        {
            outNumber = [NSString stringWithFormat:@"+%@",outNumber];
        }
        return outNumber;
    }
    return @"";
   
}
//排序
-(NSArray*)orderArr:(NSArray*)arr{
    NSArray*xArray=[arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        obj1=[(NSString*)obj1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        obj2=[(NSString*)obj2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([obj1 intValue]>[obj2 intValue])
        {
            return NSOrderedDescending;
        }
        else if ([obj1 intValue]>[obj2 intValue])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedSame;
        }
    }];
    return xArray;
}
-(void)getSelectedMoneyArr
{
    for (int i=0; i<_moneyRuleArray.count; i++)
    {
        NSDictionary*dic=_moneyRuleArray[i];
        if ([dic[@"isselected"] isEqualToString:@"YES"])
        {
            _moneySelectedArray=dic[@"moneyRule"];
        }
        
        
    }

}
///获取选中的趋势规则
-(void)getSelectedRuleArr:(NSString*)tag
{
    _ruleSelectedKeyArr=[[NSMutableArray alloc]init];
    _ruleSelectedValueArr=[[NSMutableArray alloc]init];
    _ruleSelectedCycleArr=[[NSMutableArray alloc]init];
    for (int i=0; i<_ruleArray.count; i++)
    {
        NSDictionary*dic=_ruleArray[i];
        if ([dic[@"selected"] containsString:tag])
        {
            NSDictionary*tepDic=dic[@"rule"];
            NSArray*keyArr=[tepDic allKeys];
            NSArray*valueArr=[tepDic allValues];
            [_ruleSelectedKeyArr addObject:keyArr[0]];
            [_ruleSelectedValueArr addObject:valueArr[0]];
            [_ruleSelectedCycleArr addObject:dic[@"isCycle"]];
            
        }
    }
    
}
///获取选中的总的组的数组
-(void)getSelectedGroupArr
{
    _groupSelectedArr=[[NSMutableArray alloc]init];
    for (int i=0; i<_groupArray.count; i++)
    {
        NSDictionary*dic=_groupArray[i];
        if ([dic[@"selected"] isEqualToString:@"YES"])
        {
            [_groupSelectedArr addObject:dic];
        }
    }

}
@end
