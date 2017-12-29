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
    switch ([_tagStr intValue]) {
        case 0:
             _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_BackMoney];
            _nameLab.text=@"请输入洗码基数:千分之";
            _sumTextField.placeholder=@"1";
            break;
        case 1:
            _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GotwoCount];
            _sumTextField.placeholder=@"不可小于3";
            _nameLab.text=@"长跳个数";
            break;
        case 2:
            _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GoCount];
            _nameLab.text=@"长连个数";
            _sumTextField.placeholder=@"不可小于3";
            break;
        case 3:
            _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_GoXiaoCount];
            _nameLab.text=@"小二路个数";
            _sumTextField.placeholder=@"不可小于2";
            break;
        case 4:
            _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_wordGoCount];
            _nameLab.text=@"文字长连个数";
            _sumTextField.placeholder=@"不可小于3";
            break;
        case 5:
            _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_wordGotwoCount];
            _nameLab.text=@"文字长跳个数";
            _sumTextField.placeholder=@"不可小于3";
            break;
        case 6:
            _sumTextField.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_dateSqrCount];
            _sumTextField1.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_dateDaySqrCount];
            _sumTextField2.text=[[NSUserDefaults standardUserDefaults] objectForKey:SAVE_dateTimeSqrCount];
            _nameLab.text=@"连月均线天数设置";
            _sumTextField.placeholder=@"不可小于1";
            _nameLab1.hidden = NO;
            _nameLab2.hidden = NO;
            _sumTextField1.hidden = NO;
            _sumTextField2.hidden = NO;
            break;
            
        default:
            break;
    }

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
    BOOL ispostNotification=NO;
    NSUserDefaults *udefault=[NSUserDefaults standardUserDefaults];
    switch ([_tagStr intValue]) {
        case 0:
            [udefault setObject:_sumTextField.text forKey:SAVE_BackMoney];
            [udefault synchronize];
            break;
        case 1:
            if([_sumTextField.text intValue]<3)
            {
                 [self.view makeToast:@"最小个数必须大于等于3" duration:0.5f position:CSToastPositionCenter];
                 return;
               
            }
            else
            {
                ispostNotification=YES;
                [udefault setObject:_sumTextField.text forKey:SAVE_GotwoCount];
                [udefault synchronize];
            }
            break;
        case 2:
            if([_sumTextField.text intValue]<3)
            {
                [self.view makeToast:@"最小个数必须大于等于3" duration:0.5f position:CSToastPositionCenter];
                 return;
            }
            else
            {
                ispostNotification=YES;
                [udefault setObject:_sumTextField.text forKey:SAVE_GoCount];
                [udefault synchronize];
            }
            break;
        case 3:
            if([_sumTextField.text intValue]<2)
            {
                [self.view makeToast:@"最小个数必须大于等于2" duration:0.5f position:CSToastPositionCenter];
                 return;
                
            }
            else
            {
                ispostNotification=YES;
                [udefault setObject:_sumTextField.text forKey:SAVE_GoXiaoCount];
                [udefault synchronize];
            }
            break;
        case 4://文字长连
            if([_sumTextField.text intValue]<3)
            {
                [self.view makeToast:@"最小个数必须大于等于3" duration:0.5f position:CSToastPositionCenter];
                return;
                
            }
            else
            {
                ispostNotification=YES;
                [udefault setObject:_sumTextField.text forKey:SAVE_wordGoCount];
                [udefault synchronize];
            }
            break;
        case 5: //文字长跳
            if([_sumTextField.text intValue]<3)
            {
                [self.view makeToast:@"最小个数必须大于等于3" duration:0.5f position:CSToastPositionCenter];
                return;
                
            }
            else
            {
                ispostNotification=YES;
                [udefault setObject:_sumTextField.text forKey:SAVE_wordGotwoCount];
                [udefault synchronize];
            }
            break;
        case 6: //均线
            if([_sumTextField.text intValue]<=0)
            {
                [self.view makeToast:@"连月最小均线必须大于1" duration:0.5f position:CSToastPositionCenter];
                return;
            }
            else if ([_sumTextField1.text intValue]<=0)
            {
                [self.view makeToast:@"连日最小均线必须大于1" duration:0.5f position:CSToastPositionCenter];
                return;
            }
            else if ([_sumTextField2.text intValue]<=0)
            {
                [self.view makeToast:@"连句最小均线必须大于1" duration:0.5f position:CSToastPositionCenter];
                return;
            }
            
            [udefault setObject:_sumTextField.text forKey:SAVE_dateSqrCount];
            [udefault setObject:_sumTextField1.text forKey:SAVE_dateDaySqrCount];
            [udefault setObject:_sumTextField2.text forKey:SAVE_dateTimeSqrCount];
            [udefault synchronize];
            break;
            
        default:
            break;
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (ispostNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":xiasanroad_notifation}];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
