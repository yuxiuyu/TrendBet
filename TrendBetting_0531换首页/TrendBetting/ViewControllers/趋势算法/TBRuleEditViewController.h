//
//  TBRuleEditViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/2.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBRuleEditViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *nameTextF;
@property (weak, nonatomic) IBOutlet UITextField *beforTrendTextF;
@property (weak, nonatomic) IBOutlet UITextField *afterTrendTextF;
@property (weak, nonatomic) IBOutlet UISwitch *isCycleSwitch;
@property(strong,nonatomic)NSDictionary*selectedDic;
@property(strong,nonatomic)NSString * selectedIndex;
@property(strong,nonatomic)NSString*tag;
- (IBAction)beforeTrendBtnAction:(id)sender;
- (IBAction)afterTrendBtnAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
- (IBAction)BBtnAction:(id)sender;
- (IBAction)RBtnAction:(id)sender;
- (IBAction)deleteBtnAction:(id)sender;
- (IBAction)isSwitchChanged:(id)sender;
@end
