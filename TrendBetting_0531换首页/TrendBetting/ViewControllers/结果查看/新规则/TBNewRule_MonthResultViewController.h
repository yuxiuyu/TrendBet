//
//  TBNewRule_MonthResultViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/8/24.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBNewRule_MonthResultViewController : TBBaseViewController
@property(strong,nonatomic)NSArray*winArray;
@property(strong,nonatomic)NSArray*failArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
