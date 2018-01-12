//
//  addArbitrageViewController.m
//  TrendBetting
//
//  Created by 于秀玉 on 2017/12/18.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "addArbitrageViewController.h"

@interface addArbitrageViewController ()
{
    BOOL ispostNotification;
    NSString * isselect;
}
@end

@implementation addArbitrageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加套利规则";
    if (_selectedDic)
    {
        _ruleTextF.text=[self replaceToChina:_selectedDic[@"name"]];
        isselect = _selectedDic[@"select"];
        self.title=@"修改套利规则";
        
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_RULE_TXT}];
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





- (void)saveBtnAction{
    if (_ruleTextF.text.length<=0)
    {
        [self.view makeToast:@"请添加套利规则" duration:0.5f position:CSToastPositionCenter];
        return;
    }
   
    
    NSString*ruleStr=[self replaceToEnglish:_ruleTextF.text];

    NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].arbitrageRuleArray];
    if (_selectedDic)
    {
        [tempArr replaceObjectAtIndex:[_selectedIndex intValue] withObject:@{@"name":ruleStr,@"select":isselect}];
        
    }
    else
    {
        [tempArr addObject:@{@"name":ruleStr,@"select":@""}];
    }
    BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_arbitrageRule];
    if (issuccess)
    {
        _ruleTextF.text=@"";
      
        [Utils sharedInstance].arbitrageRuleArray = tempArr;
//        if (![_selectedDic[ruleStr] isEqualToString:@""])
//        {
//            ispostNotification=YES;
//        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
    }
    
}

#pragma --KeyBoardView
- (IBAction)BBtnAction:(id)sender {
  
        _ruleTextF.text=[NSString stringWithFormat:@"%@闲",_ruleTextF.text];

}

- (IBAction)RBtnAction:(id)sender
{
        _ruleTextF.text=[NSString stringWithFormat:@"%@庄",_ruleTextF.text];
}

- (IBAction)deleteBtnAction:(id)sender {
   
        if (_ruleTextF.text.length>0)
        {
            _ruleTextF.text=[_ruleTextF.text substringToIndex:_ruleTextF.text.length-1];
        }
}



-(NSString*)replaceToEnglish:(NSString*)str
{
    str=[str stringByReplacingOccurrencesOfString:@"庄" withString:@"R"];
    str=[str stringByReplacingOccurrencesOfString:@"闲" withString:@"B"];
    return  str;
}
-(NSString*)replaceToChina:(NSString*)str
{
    str=[str stringByReplacingOccurrencesOfString:@"R" withString:@"庄"];
    str=[str stringByReplacingOccurrencesOfString:@"B" withString:@"闲"];
    return  str;
}
@end
