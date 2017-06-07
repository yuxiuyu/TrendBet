//
//  TBReverseSelectViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/7.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBReverseSelectViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSString*isback;//有值表示组选择的
@property(strong,nonatomic)NSString*resultStr;
@end
