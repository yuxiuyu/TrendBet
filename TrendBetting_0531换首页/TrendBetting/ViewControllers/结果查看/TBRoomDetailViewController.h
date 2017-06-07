//
//  TBResultRoomDetailViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBRoomDetailViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(copy,nonatomic)NSString * selectedTitle;
@end
