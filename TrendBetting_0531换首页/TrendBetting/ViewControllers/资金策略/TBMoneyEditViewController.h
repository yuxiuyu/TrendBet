//
//  TBMoneyEditViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/23.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBMoneyEditViewController : TBBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTextF;
@property (weak, nonatomic) IBOutlet UIButton *directionBtn;
@property(strong,nonatomic)NSDictionary*selectedDic;
@property(strong,nonatomic)NSString * selectedIndex;
- (IBAction)moneyDirectionBtnActin:(id)sender;
@end
