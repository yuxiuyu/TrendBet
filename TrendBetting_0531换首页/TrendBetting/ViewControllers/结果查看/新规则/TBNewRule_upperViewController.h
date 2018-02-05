//
//  TBNewRule_upperViewController.h
//  TrendBetting
//
//  Created by 王昕 on 2018/1/7.
//  Copyright © 2018年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBNewRule_upperViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSArray * dataArray;
@property(strong,nonatomic)NSArray * backdataArray;
@end
