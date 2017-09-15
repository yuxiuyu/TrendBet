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
    NSMutableArray*answerArray;
    NSMutableDictionary*resultDic;
}
@end

@implementation TBFixGroupAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"添加组";
    
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBtnAction)];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    dataArray=@[@"长跳",@"长连",@"小二路",@"一带不规则",@"不规则带一",@"一带规则",@"规则带一",@"平头规则",@"文字区域的规则",@"和暂停"];
    answerArray =[[NSMutableArray alloc]init];
    resultDic=[[NSMutableDictionary alloc]init];
//    if (_selectedIndex)
//    {
//        self.title=@"编辑组";
//        resultDic=[[NSMutableDictionary alloc]initWithDictionary:[Utils sharedInstance].groupArray[[_selectedIndex intValue]]];
//        _nameTextField.text=resultDic[@"name"];
//        
//        NSArray*rarr=resultDic[@"rule"];
//        NSString*str=[resultDic[@"rbSelect"] stringByReplacingOccurrencesOfString:@"R" withString:@"庄"];
//        str=[str stringByReplacingOccurrencesOfString:@"B" withString:@"闲"];
//        [answerArray addObject:[NSString stringWithFormat:@"%ld个",rarr.count]];
//        [answerArray addObject:str];
//        [answerArray addObject:[resultDic[@"reverseSelect"] isEqualToString:@"NO"]?@"正向":@"反向"];
//    }
//    else
//    {
//        [answerArray addObject:@""];
//        [answerArray addObject:@"庄闲"];
//        [answerArray addObject:@"正向"];
//        [resultDic setObject:@[] forKey:@"rule"];
//        [resultDic setObject:@"RB" forKey:@"rbSelect"];
//        [resultDic setObject:@"NO" forKey:@"reverseSelect"];
//    }
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
    for (int i=0; i<answerArray.count; i++)
    {
        if ([answerArray[i] length]<=0)
        {
            [self.view makeToast:[NSString stringWithFormat:@"请选择%@",dataArray[i]] duration:0.5f position:CSToastPositionCenter];
            return;
        }
    }
    [resultDic setObject:_nameTextField.text forKey:@"name"];
    NSMutableArray*tempArr=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].groupArray];
    if (!_selectedIndex)
    {
        [resultDic setObject:[NSString stringWithFormat:@"%ld",[Utils sharedInstance].groupArray.count+1] forKey:@"number"];
        [resultDic setObject:@"NO" forKey:@"selected"];
        [tempArr addObject:resultDic];
    }
    else
    {
        [tempArr replaceObjectAtIndex:[_selectedIndex intValue] withObject:resultDic];
    }
    BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:tempArr filePathStr:SAVE_Group_TXT];
    if (issuccess)
    {
        [Utils sharedInstance].groupArray = tempArr;
        [[Utils sharedInstance] getSelectedGroupArr];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.view makeToast:@"保存失败" duration:0.5f position:CSToastPositionCenter];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSwitchTableViewCell*cell=[TBSwitchTableViewCell loadSwitchTableViewCell:tableView];
    cell.delegate=self;
    cell.mySwitch.hidden=NO;
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.titleLab.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row)
    {
        case 0:
            [self performSegueWithIdentifier:@"show_group_ruleVC" sender:@{@"tag":@"-1",@"groupSelecedArray":resultDic[@"rule"]}];
            break;
        case 1:
            [self performSegueWithIdentifier:@"show_group_rbSelectVC" sender:@{@"isback":@"YES",@"resultStr":resultDic[@"rbSelect"]}];
            break;
        case 2:
            [self performSegueWithIdentifier:@"show_group_reverseVC" sender:@{@"isback":@"YES",@"resultStr":resultDic[@"reverseSelect"]}];
            break;
        default:
            break;
    }
    
    
}
#pragma mark--值回传
-(void)rulePassBack:(NSNotification*)user
{
    NSDictionary*dic=(NSDictionary*)user.userInfo;
    if ([dic[@"indexp"] intValue]==0)
    {
        NSArray*rarr=dic[@"rule"];
        [resultDic setObject:rarr forKey:@"rule"];
        [answerArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld个",rarr.count]];
    }
    else  if ([dic[@"indexp"] intValue]==1)
    {
        [resultDic setObject:dic[@"rbSelect"] forKey:@"rbSelect"];
        NSString*str=[resultDic[@"rbSelect"] stringByReplacingOccurrencesOfString:@"R" withString:@"庄"];
        str=[str stringByReplacingOccurrencesOfString:@"B" withString:@"闲"];
        [answerArray replaceObjectAtIndex:1 withObject:str];
    }
    else
    {
        [resultDic setObject:dic[@"reverseSelect"] forKey:@"reverseSelect"];
        [answerArray replaceObjectAtIndex:2 withObject:[resultDic[@"reverseSelect"] isEqualToString:@"NO"]?@"正向":@"反向"];
    }
    
    [_tableview reloadData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UIViewController*vc=[segue destinationViewController];
    [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
