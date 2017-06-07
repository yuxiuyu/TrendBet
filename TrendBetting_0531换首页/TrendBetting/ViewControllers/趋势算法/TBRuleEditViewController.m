//
//  TBRuleEditViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/2.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBRuleEditViewController.h"

@interface TBRuleEditViewController ()
{
    NSInteger selectedBtn;
    UITapGestureRecognizer*tapGes;
    BOOL ispostNotification;
}
@end

@implementation TBRuleEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加趋势";
    if (_selectedDic)
    {
        _nameTextF.text=_selectedDic[@"name"];
        NSDictionary*dic=_selectedDic[@"rule"];
        _beforTrendTextF.text=[self replaceToChina:[[dic allKeys] lastObject]];
        _afterTrendTextF.text=[self replaceToChina:[[dic allValues] lastObject]];
        _isCycleSwitch.on=[_selectedDic[@"isCycle"] isEqualToString:@"YES"]?YES:NO;
         self.title=@"修改趋势";
        
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

- (IBAction)beforeTrendBtnAction:(id)sender {
    [self.view endEditing:YES];
     selectedBtn=1;
    _keyBoardView.hidden=NO;
    if (!tapGes)
    {
        tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:tapGes];

    }
    
}

- (IBAction)afterTrendBtnAction:(id)sender {
      [self.view endEditing:YES];
     selectedBtn=2;
    _keyBoardView.hidden=NO;
    if (!tapGes)
    {
        tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [self.view addGestureRecognizer:tapGes];
        
    }
}

- (void)saveBtnAction{
    if (_nameTextF.text.length<=0)
    {
        [self.view makeToast:@"趋势名称不能为空" duration:0.5f position:CSToastPositionCenter];
        return;
    }
    else if (_beforTrendTextF.text.length<=0)
    {
        [self.view makeToast:@"趋势形成前不能为空" duration:0.5f position:CSToastPositionCenter];
        return;
    }
    else if (_afterTrendTextF.text.length<=0)
    {
        [self.view makeToast:@"趋势形成后不能为空" duration:0.5f position:CSToastPositionCenter];
        return;
    }
    
    NSString*beforeStr=[_beforTrendTextF.text stringByReplacingOccurrencesOfString:@"庄" withString:@"R"];
    beforeStr=[beforeStr stringByReplacingOccurrencesOfString:@"庄" withString:@"R"];
    
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:@{@"number":[NSString stringWithFormat:@"%ld",[Utils sharedInstance].ruleArray.count+1],@"name":_nameTextF.text,@"rule":@{[self replaceToEnglish:_beforTrendTextF.text]:[self replaceToEnglish:_afterTrendTextF.text]},@"selected":@"",@"isCycle":_isCycleSwitch.on==YES?@"YES":@"NO"}];
    NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].ruleArray];
    if (_selectedDic)
    {
        [dic setObject:_selectedDic[@"selected"] forKey:@"selected"];
        [tempArr replaceObjectAtIndex:[_selectedIndex intValue] withObject:dic];
      
    }
    else
    {
        [tempArr addObject:dic];
    }
    BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_RULE_TXT];
    if (issuccess)
    {
        _nameTextF.text=@"";
        _beforTrendTextF.text=@"";
        _afterTrendTextF.text=@"";
        _isCycleSwitch.on=YES;
        [Utils sharedInstance].ruleArray = tempArr;
        if (![dic[@"selected"] isEqualToString:@""])
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

#pragma --KeyBoardView
- (IBAction)BBtnAction:(id)sender {
    if (selectedBtn==1)
    {
        _beforTrendTextF.text=[NSString stringWithFormat:@"%@闲",_beforTrendTextF.text];
    }
    else
    {
        _afterTrendTextF.text=[NSString stringWithFormat:@"%@闲",_afterTrendTextF.text];
    }
}

- (IBAction)RBtnAction:(id)sender
{
    if (selectedBtn==1)
    {
        _beforTrendTextF.text=[NSString stringWithFormat:@"%@庄",_beforTrendTextF.text];
    }
    else
    {
        _afterTrendTextF.text=[NSString stringWithFormat:@"%@庄",_afterTrendTextF.text];
    }
}

- (IBAction)deleteBtnAction:(id)sender {
    if (selectedBtn==1)
    {
        if (_beforTrendTextF.text.length>0)
        {
             _beforTrendTextF.text=[_beforTrendTextF.text substringToIndex:_beforTrendTextF.text.length-1];
        }
       
    }
    else
    {
        if (_afterTrendTextF.text.length>0)
        {
            _afterTrendTextF.text=[_afterTrendTextF.text substringToIndex:_afterTrendTextF.text.length-1];
        }
    }
}

- (IBAction)isSwitchChanged:(id)sender {
}
-(void)tapAction
{
    _keyBoardView.hidden=YES;
    [self.view removeGestureRecognizer:tapGes];
    tapGes=nil;
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
