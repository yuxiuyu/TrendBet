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
