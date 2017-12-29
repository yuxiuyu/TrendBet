//
//  addArbitrageViewController.h
//  TrendBetting
//
//  Created by 于秀玉 on 2017/12/18.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface addArbitrageViewController : TBBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *ruleTextF;

@property(strong,nonatomic)NSDictionary*selectedDic;
@property(strong,nonatomic)NSString * selectedIndex;

//@property (weak, nonatomic) IBOutlet UIView *keyBoardView;
- (IBAction)BBtnAction:(id)sender;
- (IBAction)RBtnAction:(id)sender;
- (IBAction)deleteBtnAction:(id)sender;

@end
