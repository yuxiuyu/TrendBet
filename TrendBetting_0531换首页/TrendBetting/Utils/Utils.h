//
//  Utils.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,TBTrendCode)
{
    TBAreaTrend=0,
    TBCoundTrend=1,
    TBLengthTrend=2
};
@interface Utils : NSObject
+(instancetype)sharedInstance;
@property(strong,nonatomic)NSDictionary*housesDic;
//
@property(assign,nonatomic)TBTrendCode selectedTrendCode;//选中的区域 个数 长度
//
@property(strong,nonatomic)NSMutableArray*moneyRuleArray;//总的资金策略数组
@property(strong,nonatomic)NSArray*moneySelectedArray;///选中的资金策略数组
//
@property(strong,nonatomic)NSMutableArray*ruleArray;//总的规则数组
@property(strong,nonatomic)NSMutableArray*ruleSelectedKeyArr;//选中的规则数组key
@property(strong,nonatomic)NSMutableArray*ruleSelectedValueArr;//选中的规则数组Value
@property(strong,nonatomic)NSMutableArray*ruleSelectedCycleArr;//选中的规则数组isCycle
//
@property(strong,nonatomic)NSMutableArray*groupArray;//总的组的数组
@property(strong,nonatomic)NSMutableArray*groupSelectedArr;//选中的总的组的数组


////去掉浮点数后面多余的0
-(NSString*)removeFloatAllZero:(NSString*)string;
//排序
-(NSArray*)orderArr:(NSArray*)arr;
///获取选中的收益规则
-(void)getSelectedMoneyArr;
///获取选中的趋势规则
-(void)getSelectedRuleArr:(NSString*)tag;
///获取选中的总的组的数组
-(void)getSelectedGroupArr;
@end
