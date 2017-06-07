//
//  TBBackMoneyEditViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/4/14.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBBackMoneyEditViewController.h"

@interface TBBackMoneyEditViewController ()

@end

@implementation TBBackMoneyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveBtnAction:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:_sumTextField.text forKey:SAVE_BackMoney];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
