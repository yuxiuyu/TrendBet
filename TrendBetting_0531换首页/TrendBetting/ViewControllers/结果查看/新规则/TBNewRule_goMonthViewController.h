//
//  TBNewRule_goMonthViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/6.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBNewRule_goMonthViewController : TBBaseViewController
@property(strong,nonatomic)NSArray*klineArr;
@property(strong,nonatomic)NSArray*totalDayKeyArr;
@property(strong,nonatomic)NSArray*totalDayValueArr;
@property(strong,nonatomic)NSArray*totalDayBackMoneyArr;
//@property(strong,nonatomic)NSArray*dayValueArr;
@property(strong,nonatomic)NSString*titleStr;
@property(copy,nonatomic)NSDictionary * allmonthDic;
@property(copy,nonatomic)NSString * selectP; //选中第几个月


@end
