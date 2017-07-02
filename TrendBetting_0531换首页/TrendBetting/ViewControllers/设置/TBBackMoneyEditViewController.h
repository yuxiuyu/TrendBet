//
//  TBBackMoneyEditViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBBackMoneyEditViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *sumTextField;
@property(strong,nonatomic)NSString*tagStr;
- (IBAction)saveBtnAction:(id)sender;

@end
