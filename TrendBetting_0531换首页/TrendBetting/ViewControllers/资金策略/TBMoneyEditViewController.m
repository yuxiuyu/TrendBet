//
//  TBMoneyEditViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/2/23.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBMoneyEditViewController.h"

@interface TBMoneyEditViewController ()

{
     BOOL ispostNotification;
     BOOL ismoneyDirection;
}
@end

@implementation TBMoneyEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加资金策略";
    if (_selectedDic)
    {
        _nameTextF.text=_selectedDic[@"name"];
        NSArray*array=_selectedDic[@"moneyRule"];
        NSString*str=array[0];
        for (int i=1; i<array.count; i++)
        {
            str=[NSString stringWithFormat:@"%@、%@",str,array[i]];
        }
        [_directionBtn setTitle:_selectedDic[@"direction"] forState:UIControlStateNormal];
        _moneyTextF.text=str;
        self.title=@"修改资金策略";
        
        
    }
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    // Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (ispostNotification)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_MONEY_TXT}];
    }
    
}
-(void)saveBtnAction
{
    if (_nameTextF.text.length<=0)
    {
        [self.view makeToast:@"资金名称不能为空" duration:0.5f position:CSToastPositionCenter];
        return;
    }
    else if (_moneyTextF.text.length<=0)
    {
        [self.view makeToast:@"资金数列不能为空" duration:0.5f position:CSToastPositionCenter];
        return;
    }
    NSArray*array = [_moneyTextF.text componentsSeparatedByString:@"、"];
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:@{
    @"number":[NSString stringWithFormat:@"%ld",[Utils sharedInstance].moneyRuleArray.count+1],
    @"name":_nameTextF.text,
    @"moneyRule":array,
    @"direction":_directionBtn.titleLabel.text,
    @"isselected":@"NO"}];
    NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].moneyRuleArray];
    if (_selectedDic)
    {
         [dic setObject:_selectedDic[@"isselected"] forKey:@"isselected"];
        [tempArr replaceObjectAtIndex:[_selectedIndex intValue] withObject:dic];
    }
    else
    {
        [tempArr addObject:dic];
    }
    BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_MONEY_TXT];
    if (issuccess)
    {
        _nameTextF.text=@"";
        _moneyTextF.text=@"";
        [Utils sharedInstance].moneyRuleArray = tempArr;
        [[Utils sharedInstance] getSelectedMoneyArr];
        if ([dic[@"isselected"] isEqualToString:@"YES"])
        {
            ispostNotification=YES;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
         [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
    }
 
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

- (IBAction)moneyDirectionBtnActin:(id)sender {
    NSString *str = [_directionBtn.titleLabel.text isEqualToString:@"正追"]?@"反追":@"正追";
    [_directionBtn setTitle:str forState:UIControlStateNormal];
}
@end
