//
//  TBNewFirstViewController.h
//  TrendBetting
//
//  Created by 于秀玉 on 17/5/20.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBaseViewController.h"

@interface TBNewFirstViewController : TBBaseViewController
@property (weak, nonatomic) IBOutlet UIView *fristCollection;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *fourthView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;

@property (weak, nonatomic) IBOutlet UILabel *memoLab;
@property (weak, nonatomic) IBOutlet UILabel *winOrLoseLab;
@property (weak, nonatomic) IBOutlet UILabel *totalWinLab;
//@property (weak, nonatomic) IBOutlet UILabel *nextTrendLab;

@property (weak, nonatomic) IBOutlet UILabel *areaTrendLab1;
@property (weak, nonatomic) IBOutlet UILabel *areaTrendLab2;
@property (weak, nonatomic) IBOutlet UILabel *areaTrendLab3;

- (IBAction)BPTBtnAction:(id)sender;
- (IBAction)reduceBtnAction:(id)sender;

- (IBAction)clearBtnAction:(id)sender;
- (IBAction)closeProjectBtnAction:(id)sender;
- (IBAction)saveBtnAction:(id)sender;
- (IBAction)resultLookBtnAction:(id)sender;
- (IBAction)dataShowBtnAction:(id)sender;



@property (weak, nonatomic) IBOutlet UIView *bgMemoView;
@property (weak, nonatomic) IBOutlet UITextView *myKeyTextView;
@property (weak, nonatomic) IBOutlet UITextView *answerKeyTextView;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
- (IBAction)checkBtnAction:(id)sender;
@end
