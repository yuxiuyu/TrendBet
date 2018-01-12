//
//  TBNewRuleRoomDetailViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/6/20.
//  Copyright © 2017年 yxy. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TBBaseViewController.h"


@interface TBNewRule_RMDetailViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(copy,nonatomic)NSString * selectedTitle;
@end
