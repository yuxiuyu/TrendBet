//
//  TBResultRoomDetail_MonthViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBRoomDetail_MonthViewController : TBBaseViewController
@property(copy,nonatomic)NSString * roomStr;
@property(copy,nonatomic)NSString * selectedTitle;
@property(strong,nonatomic)NSArray * winCountArray;
@property (weak, nonatomic) IBOutlet UILabel *resultCountLab;
@property (weak, nonatomic) IBOutlet UILabel *winCountLab;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@end
