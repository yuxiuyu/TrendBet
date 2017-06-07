//
//  TBGroup_RoomDetailViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroup_RoomDetailViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(copy,nonatomic)NSString * selectedTitle;
@end
