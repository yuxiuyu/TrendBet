//
//  TBFixGroupAddViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 2017/9/15.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBFixGroupAddViewController.h"
#import "TBSwitchTableViewCell.h"
@interface TBFixGroupAddViewController ()<switchOnOrOffProtocol>
{
    NSArray*dataArray;
    NSMutableArray*ansArr;
    NSMutableDictionary*allDic;
}
@end

@implementation TBFixGroupAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加组";
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    dataArray=@[@"长跳",@"长连",@"小二路",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则",@"和暂停"];
    allDic=[[NSMutableDictionary alloc] initWithDictionary: [[Utils sharedInstance] readTenData:[NSString stringWithFormat:@"%@/%@",SAVE_RULE_FILENAME,SAVE_TenGroup_TXT]]];
    

    if (_keyStr)
    {
        self.title=@"编辑组";
        _nameTextField.text=_keyStr;
        ansArr=[[NSMutableArray alloc] initWithArray:allDic[_keyStr][@"listTen"]];

    }
    else
    {
         ansArr=[[NSMutableArray alloc] initWithArray:@[@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES",@"YES"]];
    }
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rulePassBack:) name:@"selectedGroupRule" object:nil];
    _tableview.tableFooterView=[[UIView alloc]init];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnAction)];
    self.navigationItem.rightBarButtonItem=item;
    
    // Do any additional setup after loading the view.
}
-(void)backBtnAction
{
    UIAlertController*alert=[UIAlertController alertControllerWithTitle:@"提示" message:@"确定不保存退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancel];
    [alert addAction:sure];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)saveBtnAction
{
    if (_nameTextField.text.length<=0)
    {
        [self.view makeToast:@"请填写组名称"];
        return;
    }
    

    if (!_keyStr)
    {
        if ([allDic objectForKey:_nameTextField.text])
        {
            [self.view makeToast:@"已存在这个组名称"];
            return;
        }
        else
        {
            NSDictionary*dic=@{@"listTen":ansArr,
                               @"selected":@"NO"};
            [allDic setObject:dic forKey:_nameTextField.text];
        }
    }
    else
    {
        
        if ([allDic objectForKey:_nameTextField.text]&&![_nameTextField.text isEqualToString:_keyStr])
        {
            [self.view makeToast:@"已存在这个组名称"];
            return;
        }
        else
        {
            [allDic removeObjectForKey:_keyStr];
            NSDictionary*dic=@{@"listTen":ansArr,
                               @"selected":@"NO"};
            [allDic setObject:dic forKey:_nameTextField.text];
            
            NSUserDefaults* defaults=[NSUserDefaults standardUserDefaults];
            NSData*data=[defaults objectForKey:SAVE_TenListBlodRule];
            tenRuleModel*tenM=[NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (tenM&&[tenM.nameStr isEqualToString:_nameTextField.text]) {
                 [tenM initWithDic:dic];
                NSData*data=[NSKeyedArchiver archivedDataWithRootObject:tenM];
                [defaults setObject:data forKey:SAVE_TenListBlodRule];
                if ([defaults objectForKey:SAVE_TenDeleteBlodRule]) {
                    [defaults setObject:data forKey:SAVE_TenDeleteBlodRule];
                }
                [defaults synchronize];
            }
        }
    }
    BOOL issuccess= [[Utils sharedInstance] saveTenData:allDic name:SAVE_TenGroup_TXT];
    if (issuccess)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ansArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSwitchTableViewCell*cell=[TBSwitchTableViewCell loadSwitchTableViewCell:tableView];
    cell.delegate=self;
    cell.mySwitch.hidden=NO;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLab.text=dataArray[indexPath.row];
    cell.mySwitch.on=[ansArr[indexPath.row] isEqualToString:@"YES"];
    cell.indexStr=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

#pragma mark--switchOnOrOffProtocol
-(void)switchClick:(NSString*)indexStr{
    
    [ansArr replaceObjectAtIndex:[indexStr intValue] withObject:[ansArr[[indexStr intValue]] isEqualToString:@"YES"]?@"NO":@"YES"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
