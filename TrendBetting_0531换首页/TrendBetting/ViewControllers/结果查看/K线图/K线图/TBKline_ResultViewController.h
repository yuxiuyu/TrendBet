//
//  TBKline_ResultViewController.h
//  TrendBetting
//
//  Created by 于秀玉 on 2018/3/23.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBKline_ResultViewController : TBBaseViewController
@property(strong, nonatomic)NSArray*dataArr;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
