//
//  TBNewRule_MonthViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBNewRule_MonthViewController : TBBaseViewController
@property(copy,nonatomic)NSString * roomStr;
@property(copy,nonatomic)NSString * selectP; //选中第几个月
@property(strong,nonatomic)NSArray * winCountArray;
@property(copy,nonatomic)NSDictionary * allmonthDic;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@end
