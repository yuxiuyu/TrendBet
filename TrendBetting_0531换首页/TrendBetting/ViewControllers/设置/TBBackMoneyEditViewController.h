//
//  TBBackMoneyEditViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBBackMoneyEditViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLab1;
@property (weak, nonatomic) IBOutlet UILabel *nameLab2;
@property (weak, nonatomic) IBOutlet UILabel *nameLab3;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField1;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField11;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField12;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField2;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField21;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField22;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField3;
@property(strong,nonatomic)NSString*tagStr;
- (IBAction)saveBtnAction:(id)sender;

@end
