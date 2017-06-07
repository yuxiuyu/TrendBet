//
//  TBGroupAddViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/19.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroupAddViewController : TBBaseViewController
@property(strong,nonatomic)NSString*selectedIndex;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
