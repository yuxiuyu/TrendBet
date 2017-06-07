//
//  TBGroup_MonthViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroup_MonthViewController : TBBaseViewController
@property(copy,nonatomic)NSString * roomStr;
@property(copy,nonatomic)NSString * selectedTitle;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@end
