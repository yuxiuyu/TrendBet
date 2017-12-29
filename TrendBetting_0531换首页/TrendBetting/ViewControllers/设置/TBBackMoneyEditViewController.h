//
//  TBBackMoneyEditViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBBackMoneyEditViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab1;
@property (weak, nonatomic) IBOutlet UILabel *nameLab2;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField1;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField2;
@property(strong,nonatomic)NSString*tagStr;
- (IBAction)saveBtnAction:(id)sender;

@end
