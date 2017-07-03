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

    
    switch ([_tagStr intValue]) {
        case 0:
            [[NSUserDefaults standardUserDefaults] setObject:_sumTextField.text forKey:SAVE_BackMoney];
            break;
        case 1:
            if([_sumTextField.text intValue]<4)
            {
                [[NSUserDefaults standardUserDefaults] setObject:_sumTextField.text forKey:SAVE_GotwoCount];
            }
            else
            {
                [self.view makeToast:@"最小个数必须大于等于4" duration:0.5f position:CSToastPositionCenter];
            }
            break;
        case 2:
            if([_sumTextField.text intValue]<3)
            {
                [[NSUserDefaults standardUserDefaults] setObject:_sumTextField.text forKey:SAVE_GoCount];
            }
            else
            {
                [self.view makeToast:@"最小个数必须大于等于3" duration:0.5f position:CSToastPositionCenter];
            }
            break;
        case 3:
            if([_sumTextField.text intValue]<2)
            {
                [[NSUserDefaults standardUserDefaults] setObject:_sumTextField.text forKey:SAVE_GoXiaoCount];
            }
            else
            {
                 [self.view makeToast:@"最小个数必须大于等于2" duration:0.5f position:CSToastPositionCenter];
            }
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
