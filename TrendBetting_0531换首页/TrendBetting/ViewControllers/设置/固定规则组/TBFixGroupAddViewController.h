//
//  TBFixGroupAddViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBFixGroupAddViewController : TBBaseViewController
@property(strong,nonatomic)NSString*indexStr;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
