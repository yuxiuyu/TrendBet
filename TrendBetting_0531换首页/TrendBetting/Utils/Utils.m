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
-(NSArray*)orderArr:(NSArray*)arr isArc:(BOOL)isArc{
    NSArray*xArray=[arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        obj1=[(NSString*)obj1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        obj2=[(NSString*)obj2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([obj1 intValue]>[obj2 intValue])
        {
            return isArc?NSOrderedDescending:NSOrderedAscending;
        }
        else if ([obj1 intValue]>[obj2 intValue])
        {
            return isArc?NSOrderedAscending:NSOrderedDescending;
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
            _moneyDirection = @"正追";
            if ([dic[@"direction"] isEqualToString:@"反追"]) {
                _moneyDirection = @"反追";
            }
           
            
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
//获取选中的套利规则
-(void)getSelectarbitrageRuleArray{
    _selectArbitrageRuleName = @"";
    for (int i=0; i<[_arbitrageRuleArray count]; i++) {
        NSDictionary * dic = _arbitrageRuleArray[i];
        if (dic[@"select"]&&[dic[@"select"] isEqualToString:@"YES"]) {
            _selectArbitrageRuleName = dic[@"name"];
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
///获取当前选中的十个规则组
-(void)initSetTenModel{
    NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
    NSData*data=[defaults objectForKey:SAVE_TenListBlodRule];
    if (!data) {
        data=[defaults objectForKey:SAVE_TenBlodRule];
    }
    tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    _tenModel=tenM;
}
//获取数组中的最大最小值
-(NSArray*)getMinAndMaxFromArr:(NSArray*)array{
    CGFloat maxValue1 = [[array valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minValue1 = [[array valueForKeyPath:@"@min.floatValue"] floatValue];
    int showMaxV1;
    int showMinV1;

    if (fabs(maxValue1)>fabs(minValue1)) {
        showMaxV1 = fabs(maxValue1) + 1;
        showMinV1 = -showMaxV1;
    }else{
        showMaxV1 = fabs(minValue1) + 1;
        showMinV1 = -showMaxV1;
    }
    return @[@(showMaxV1),@(showMinV1)];
}
@end
