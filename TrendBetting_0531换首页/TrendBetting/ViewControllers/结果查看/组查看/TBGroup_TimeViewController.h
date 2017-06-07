//
//  TBGroup_TimeViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBGroup_TimeViewController : TBBaseViewController

@property(copy,nonatomic)NSString * selectedTitle;
@property(strong,nonatomic)NSArray*dataArray;



@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;



@end
