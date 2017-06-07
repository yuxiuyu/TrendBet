//
//  TBRuleSelectViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/1.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBRuleSelectViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(strong,nonatomic)NSString*tag;
@property(strong,nonatomic)NSArray*groupSelecedArray;
@end
