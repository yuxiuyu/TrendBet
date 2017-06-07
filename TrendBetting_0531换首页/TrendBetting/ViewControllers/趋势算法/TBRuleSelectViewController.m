//
//  TBRuleSelectViewController.m
//  TrendBetting
//
//  Created by jiazhen-mac-01 on 17/3/1.
//  Copyright © 2017年 yxy. All rights reserved.
//

#import "TBRuleSelectViewController.h"
#import "TBSelectTableViewCell.h"
@interface TBRuleSelectViewController ()<TBSelectTableViewCellDelegate>
{
    NSMutableArray*dataArray;
}
@end

@implementation TBRuleSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"趋势";
    dataArray=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].ruleArray];
    self.navigationController.navigationBarHidden=NO;
    UIBarButtonItem*item;
    if ([_tag intValue]==-1)//组选择规则
    {
        item=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveGroupRuleBtnAction)];
        for (int i=0; i<dataArray.count; i++)
        {
            NSMutableDictionary*dic1=[[NSMutableDictionary alloc]initWithDictionary: dataArray[i]];
            NSString*kstr1=[dic1[@"rule"] allKeys][0];
            NSString*vstr1=[dic1[@"rule"] allValues][0];
            for (int j=0; j<_groupSelecedArray.count; j++)
            {
                NSDictionary*dic2=_groupSelecedArray[j];
                if ([dic2[kstr1] isEqualToString:vstr1])
                {
                    [dic1 setObject:_tag forKey:@"selected"];
                    [dataArray replaceObjectAtIndex:i withObject:dic1];
                }
            }
        }
    }
    else
    {
        item=[[UIBarButtonItem alloc]initWithTitle:@"添加趋势" style:UIBarButtonItemStylePlain target:self action:@selector(addRuleBtnAction)];
    }
    self.navigationItem.rightBarButtonItem=item;
    [_tableview reloadData];
    _tableview.tableFooterView=[[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     dataArray=[[NSMutableArray alloc]initWithArray:[Utils sharedInstance].ruleArray];
    if ([_tag intValue]==-1)//组选择规则
    {
       
        for (int i=0; i<dataArray.count; i++)
        {
            NSMutableDictionary*dic1=[[NSMutableDictionary alloc]initWithDictionary: dataArray[i]];
            NSString*kstr1=[dic1[@"rule"] allKeys][0];
            NSString*vstr1=[dic1[@"rule"] allValues][0];
            for (int j=0; j<_groupSelecedArray.count; j++)
            {
                NSDictionary*dic2=_groupSelecedArray[j];
                if ([dic2[kstr1] isEqualToString:vstr1])
                {
                    [dic1 setObject:_tag forKey:@"selected"];
                    [dataArray replaceObjectAtIndex:i withObject:dic1];
                }
            }
        }
    }

    [_tableview reloadData];
}
-(void)saveGroupRuleBtnAction
{
    NSMutableArray*tepA=[[NSMutableArray alloc]init];
    for (int i=0; i<dataArray.count; i++)
    {
        
        NSDictionary*dic1=dataArray[i];
        NSString*str=dic1[@"selected"];
        if ([str containsString:_tag])
        {
             NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary: dic1[@"rule"]];
            [dic setObject:dic1[@"isCycle"] forKey:@"isCycle"];
            [tepA addObject:dic];
        }

    }
    if (tepA.count>0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"selectedGroupRule" object:self userInfo:@{@"rule":tepA,@"indexp":@"0"}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.view makeToast:@"请选择趋势" duration:0.5f position:CSToastPositionCenter];
    }
   
    
}
-(void)addRuleBtnAction
{
    [self performSegueWithIdentifier:@"showRuleEditVC" sender:@{@"tag":_tag}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TBSelectTableViewCell*cell=[TBSelectTableViewCell loadSelectTableViewCell:tableView];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary*dic=dataArray[indexPath.row];
    cell.nameLab.text=dic[@"name"];
    if ([dic[@"selected"] containsString:_tag])
    {
        cell.selectBtn.selected=YES;
    }
    else
    {
        cell.selectBtn.selected=NO;
    }
    
    cell.delegate=self;
    cell.selectedInp=indexPath.row;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_tag intValue]>=0)//排除组选择规则
    {
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:dataArray[indexPath.row]];
        [self performSegueWithIdentifier:@"showRuleEditVC" sender:@{@"selectedDic":dic,@"selectedIndex":[NSString stringWithFormat:@"%ld",indexPath.row],@"tag":_tag}];
    }
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([_tag intValue]==-1)//组选择规则
    {
        return NO;
    }
    return dataArray.count>1?YES:NO;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete)
    {
        [dataArray removeObjectAtIndex:indexPath.row];
        BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:dataArray filePathStr:SAVE_RULE_TXT];
        if (issuccess)
        {
            [[Utils sharedInstance].ruleArray removeObjectAtIndex:indexPath.row];
            [_tableview reloadData];
        }
        else
        {
            dataArray=[Utils sharedInstance].ruleArray;
            [self.view makeToast:@"删除失败" duration:0.5f position:CSToastPositionCenter];
        }
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--TBSelectTableViewCellDelegate
-(void)backSelected:(NSInteger)selectedIndex
{
    NSMutableDictionary*dic=[[NSMutableDictionary alloc]initWithDictionary:dataArray[selectedIndex]];

    NSString*str=dic[@"selected"];
    if ([str containsString:_tag])
    {
         [dic setObject:[str stringByReplacingOccurrencesOfString:_tag withString:@""] forKey:@"selected"];
    }
    else
    {
         [dic setObject:[NSString stringWithFormat:@"%@%@",str,_tag] forKey:@"selected"];
    }
   
    [dataArray replaceObjectAtIndex:selectedIndex withObject:dic];
    [_tableview reloadData];
    if ([_tag intValue]>-1)
    {
        BOOL issuccess= [[Utils sharedInstance] saveData:nil saveArray:dataArray filePathStr:SAVE_RULE_TXT];
        if (issuccess)
        {
            [Utils sharedInstance].ruleArray=dataArray;
            [_tableview reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeArea" object:self userInfo:@{@"title":SAVE_RULE_TXT}];
        }
        else
        {
             dataArray=[Utils sharedInstance].ruleArray;
             [self.view makeToast:@"修改失败" duration:0.5f position:CSToastPositionCenter];
        }
    }
    
  
    
   
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRuleEditVC"])
    {
        UIViewController*vc=[segue destinationViewController];
        [vc setValuesForKeysWithDictionary:(NSDictionary*)sender];
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
