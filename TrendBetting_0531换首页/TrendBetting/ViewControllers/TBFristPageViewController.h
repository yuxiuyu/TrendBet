//
//  TBFristPageViewController.h
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 16/12/28.
//  Copyright © 2016年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

//typedef NS_ENUM(NSInteger,TBTrendCode)
//{
//    TBAreaTrend=0,
//    TBCoundTrend=1,
//    TBLengthTrend=2
//};
@interface TBFristPageViewController : TBBaseViewController

@property (weak, nonatomic) IBOutlet UIView *fristCollection;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;

@property (weak, nonatomic) IBOutlet UILabel *memoLab;

@property (weak, nonatomic) IBOutlet UIButton *qieRuleBtn;
@property (weak, nonatomic) IBOutlet UILabel *winOrLoseLab;
@property (weak, nonatomic) IBOutlet UILabel *nextTrendLab;
@property (weak, nonatomic) IBOutlet UILabel *totalWinLab;
@property (weak, nonatomic) IBOutlet UILabel *countTrendLab;

- (IBAction)BPTBtnAction:(id)sender;
- (IBAction)reduceBtnAction:(id)sender;
- (IBAction)qieRuleBtnAction:(id)sender;

- (IBAction)clearBtnAction:(id)sender;
- (IBAction)closeProjectBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
- (IBAction)resultLookBtnAction:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *bgMemoView;
@property (weak, nonatomic) IBOutlet UITextView *myKeyTextView;
@property (weak, nonatomic) IBOutlet UITextView *answerKeyTextView;
- (IBAction)checkBtnAction:(id)sender;

@end
