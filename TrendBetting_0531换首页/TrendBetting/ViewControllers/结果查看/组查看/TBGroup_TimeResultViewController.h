//
//  TBGroup_TimeResultViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/25.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroup_TimeResultViewController : TBBaseViewController
@property(strong,nonatomic)NSArray*dataArray;
@property(strong,nonatomic)NSString*dateStr;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
